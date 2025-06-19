import 'package:chat_app/core/theme/color.dart';
import 'package:chat_app/data/models/chat_room_model.dart';
import 'package:chat_app/data/repositories/chat_repository.dart';
import 'package:chat_app/data/service/service_locator.dart';
import 'package:flutter/material.dart';

class ContectListTile extends StatelessWidget {
  final ChatRoomModel chat;
  final String currentUserId;
  final VoidCallback onTap;

  const ContectListTile({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  });

  String _getOtherUserName() {
    final otherUserId = chat.participants.firstWhere(
      (id) => id != currentUserId,
    );
    return chat.participantsName![otherUserId] ?? 'unknow';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: ColorPalette.primery.withValues(alpha: 0.5),
        child: Text(
          _getOtherUserName()[0].toUpperCase(),
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      title: Text(_getOtherUserName()),
      subtitle: Text(chat.lastMessage ?? ''),
      trailing: StreamBuilder(
        stream: getIt<ChatRepository>().getUnreadCount(chat.id, currentUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == 0) {
            return const SizedBox();
          }
          return Card(
            shape: CircleBorder(),
            color: ColorPalette.primery,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '${snapshot.data}',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
