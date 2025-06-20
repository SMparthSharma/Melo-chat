import 'dart:async';
import 'dart:developer';

import 'package:chat_app/data/repositories/chat_repository.dart';
import 'package:chat_app/logic/chat_cubit/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final String currentUserId;
  StreamSubscription? _messageSubscription;
  bool isInChatPage = false;
  ChatCubit({
    required ChatRepository chatRepository,
    required this.currentUserId,
  }) : _chatRepository = chatRepository,
       super(const ChatState());

  void enterChat(String receiverId) async {
    isInChatPage = true;
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final chatRoom = await _chatRepository.getOrCreateChatRoom(
        currentUserId,
        receiverId,
      );
      emit(
        state.copyWith(
          status: ChatStatus.loaded,
          chatRoomId: chatRoom.id,
          receiverId: receiverId,
        ),
      );
      _subscriptionMessage(chatRoom.id);
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: 'failed to create chat room: $e',
        ),
      );
    }
  }

  Future<void> sendMessage({
    required String content,
    required String receiverId,
  }) async {
    if (state.chatRoomId == null) {
      return;
    }
    try {
      await _chatRepository.sendMessage(
        chatRoomId: state.chatRoomId!,
        senderId: currentUserId,
        receiverId: receiverId,
        content: content,
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: 'failed to send message: $e',
        ),
      );
    }
  }

  void _subscriptionMessage(String chatRoomId) {
    _messageSubscription?.cancel();
    _messageSubscription = _chatRepository
        .getMessage(chatRoomId)
        .listen(
          (messages) {
            if (isInChatPage) {
              _markMessageAsRead(chatRoomId);
            }
            emit(state.copyWith(messages: messages, error: null));
          },
          onError: (error) {
            emit(
              state.copyWith(
                error: 'failed to load message',
                status: ChatStatus.error,
              ),
            );
          },
        );
  }

  Future<void> _markMessageAsRead(String chatRoomId) async {
    try {
      await _chatRepository.markMessagesAsRead(chatRoomId, currentUserId);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> leaveChat() async {
    isInChatPage = false;
  }
}
