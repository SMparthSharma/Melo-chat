import 'dart:async';
import 'dart:developer';

import 'package:chat_app/data/repositories/chat_repository.dart';
import 'package:chat_app/logic/chat_cubit/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final String currentUserId;
  StreamSubscription? _messageSubscription;
  bool isInChatPage = false;
  StreamSubscription? _onlineStatusSubscription;
  StreamSubscription? _typingSubscription;
  StreamSubscription? _blockStatusSubscription;
  StreamSubscription? _amIBlockStatusSubscription;
  Timer? typingTimer;
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
      _subscribeToOnlineStatus(receiverId);
      _subscribeToTypingStatus(chatRoom.id);
      _subscribeToBlockStatus(receiverId);
      await _chatRepository.updateOnlineStatus(currentUserId, true);
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

  void _subscribeToOnlineStatus(String userId) {
    _onlineStatusSubscription?.cancel();
    _onlineStatusSubscription = _chatRepository
        .getUserOnlineStatus(userId)
        .listen(
          (status) {
            final isOnline = status["isOnline"] as bool;
            final lastSeen = status["lastSeen"] as Timestamp?;

            emit(
              state.copyWith(
                isReceiverOnline: isOnline,
                receiverLastSeen: lastSeen,
              ),
            );
          },
          onError: (error) {
            log("error getting online status");
          },
        );
  }

  void _subscribeToTypingStatus(String chatRoomId) {
    _typingSubscription?.cancel();
    _typingSubscription = _chatRepository
        .getTypingStatus(chatRoomId)
        .listen(
          (status) {
            final isTyping = status["isTyping"] as bool;
            final typingUserId = status["typingUserId"] as String?;

            emit(
              state.copyWith(
                isReceiverTyping: isTyping && typingUserId != currentUserId,
              ),
            );
          },
          onError: (error) {
            log("error getting online status");
          },
        );
  }

  void _subscribeToBlockStatus(String otherUserId) {
    _blockStatusSubscription?.cancel();
    _blockStatusSubscription = _chatRepository
        .isUserBlocked(currentUserId, otherUserId)
        .listen(
          (isBlocked) {
            emit(state.copyWith(isUserBlocked: isBlocked));

            _amIBlockStatusSubscription?.cancel();
            _blockStatusSubscription = _chatRepository
                .amIBlocked(currentUserId, otherUserId)
                .listen((isBlocked) {
                  emit(state.copyWith(blocked: isBlocked));
                });
          },
          onError: (error) {
            log("error getting online status");
          },
        );
  }

  void startTyping() {
    if (state.chatRoomId == null) return;
    typingTimer?.cancel();
    _updateTypingStatus(true);
    typingTimer = Timer(const Duration(seconds: 3), () {
      _updateTypingStatus(false);
    });
  }

  Future<void> _updateTypingStatus(bool isTyping) async {
    if (state.chatRoomId == null) return;

    try {
      await _chatRepository.updateTypingStatus(
        state.chatRoomId!,
        currentUserId,
        isTyping,
      );
    } catch (e) {
      log("error updating typing status $e");
    }
  }

  Future<void> blockUser(String userId) async {
    try {
      await _chatRepository.blockUser(currentUserId, userId);
    } catch (e) {
      emit(state.copyWith(error: 'failed to block user $e'));
    }
  }

  Future<void> unBlockUser(String userId) async {
    try {
      await _chatRepository.unBlockUser(currentUserId, userId);
    } catch (e) {
      emit(state.copyWith(error: 'failed to unblock user $e'));
    }
  }
}
