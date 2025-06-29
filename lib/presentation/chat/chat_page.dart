import 'package:chat_app/core/theme/color.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/data/service/service_locator.dart';
import 'package:chat_app/logic/chat_cubit/chat_cubit.dart';
import 'package:chat_app/logic/chat_cubit/chat_state.dart';
import 'package:chat_app/presentation/widget/loading_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String reciverName;
  const ChatPage({
    super.key,
    required this.receiverId,
    required this.reciverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  late final ChatCubit _chatCubit;
  bool _isComposing = false;

  @override
  void initState() {
    _chatCubit = getIt<ChatCubit>();
    _chatCubit.enterChat(widget.receiverId);
    _messageController.addListener(_onTextChanged);

    super.initState();
  }

  Future<void> _handelSendMessage() async {
    final messageContent = _messageController.text.trim();
    if (messageContent != "") {
      _messageController.clear();
      await _chatCubit.sendMessage(
        content: messageContent,
        receiverId: widget.receiverId,
      );
    }
  }

  void _onTextChanged() {
    final isComposing = _messageController.text.isNotEmpty;
    if (isComposing != _isComposing) {
      setState(() {
        _isComposing = isComposing;
      });
      if (isComposing) {
        _chatCubit.startTyping();
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatCubit.leaveChat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: ColorPalette.light,
              child: Text(widget.reciverName[0]),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.reciverName),
                const SizedBox(height: 5),
                BlocBuilder<ChatCubit, ChatState>(
                  bloc: _chatCubit,
                  builder: (context, state) {
                    if (state.isReceiverTyping) {
                      return Row(
                        children: [
                          Text(
                            "typing",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: const LoadingDots(),
                          ),
                        ],
                      );
                    }
                    if (state.isReceiverOnline) {
                      return const Text(
                        "Online",
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      );
                    }
                    if (state.receiverLastSeen != null) {
                      final lastSeen = state.receiverLastSeen!.toDate();
                      return Text(
                        "last seen at ${DateFormat('h:mm a').format(lastSeen)}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          BlocBuilder<ChatCubit, ChatState>(
            bloc: _chatCubit,
            builder: (context, state) {
              if (state.isUserBlocked) {
                return TextButton.icon(
                  onPressed: () => _chatCubit.unBlockUser(widget.receiverId),
                  label: const Text(
                    "Unblock",
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                );
              }
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == "block") {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Are you sure you want to block "),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              "Block",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await _chatCubit.blockUser(widget.receiverId);
                    }
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    value: 'block',
                    child: Text("Block User"),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        bloc: _chatCubit,
        builder: (context, state) {
          if (state.status == ChatStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == ChatStatus.error) {
            return Center(child: Text('something went wrong'));
          }
          return Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  reverse: true,

                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isMe = message.senderId == _chatCubit.currentUserId;
                    return MessageBubble(message: message, isMe: isMe);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Message',
                          prefixIcon: Icon(
                            Icons.emoji_emotions_rounded,
                            color: Colors.orange,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _handelSendMessage,
                      icon: Icon(Icons.send_rounded, size: 30),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  //final bool showTime;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    // required this.showTime,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: isMe
              ? ColorPalette.primery
              : Color.fromARGB(255, 193, 211, 233),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(
          left: isMe ? 64 : 10,
          right: isMe ? 10 : 64,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 5,
                children: [
                  Text(
                    DateFormat('hh:mm a').format(message.timestamp.toDate()),
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 10,
                    ),
                  ),
                  isMe
                      ? Icon(
                          Icons.done_all_rounded,
                          color: message.status == MessageStatus.read
                              ? Colors.green
                              : Colors.white,
                          size: 12,
                        )
                      : Text(''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
