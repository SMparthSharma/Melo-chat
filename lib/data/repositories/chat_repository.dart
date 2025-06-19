import 'package:chat_app/data/models/chat_room_model.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/data/service/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository extends BaseReposisory {
  CollectionReference get _chatRooms =>
      firestore.collection('chatRooms'); //create collection of chatroom

  CollectionReference getChatRoomMessage(String chatRoomId) {
    return _chatRooms
        .doc(chatRoomId)
        .collection(
          'message',
        ); //create collection of message in chat room collection
  }

  Future<ChatRoomModel> getOrCreateChatRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    final user = [currentUserId, otherUserId]..sort();
    final roomId = user.join('_');
    final roomDoc = await _chatRooms.doc(roomId).get();
    if (roomDoc.exists) {
      return ChatRoomModel.fromFireStore(roomDoc);
    }
    final currentUserData =
        (await firestore.collection('users').doc(currentUserId).get()).data()
            as Map<String, dynamic>;
    final otherUserData =
        (await firestore.collection('users').doc(otherUserId).get()).data()
            as Map<String, dynamic>;

    final participantsName = {
      currentUserId: currentUserData['userName']?.toString() ?? '',
      otherUserId: otherUserData['userName']?.toString() ?? '',
    };
    final newRoom = ChatRoomModel(
      id: roomId,
      participants: user,
      participantsName: participantsName,
      lastReadTime: {
        currentUserId: Timestamp.now(),
        otherUserId: Timestamp.now(),
      },
    );
    await _chatRooms.doc(roomId).set(newRoom.toMap());
    return newRoom;
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    //bacth for multiple write operation

    final batch = firestore.batch();

    //get message sub collection

    final messageRef = getChatRoomMessage(chatRoomId);
    final messageDoc = messageRef.doc();

    //chat message

    final message = MessageModel(
      id: messageDoc.id,
      chatRoomId: chatRoomId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: Timestamp.now(),
      readBy: [senderId],
    );

    //add message to sub collection

    batch.set(messageDoc, message.toMap());

    //update chatroom

    batch.update(_chatRooms.doc(chatRoomId), {
      'lastMessage': content,
      'lastMessageSenderId': senderId,
      'lastMessageTime': message.timestamp,
    });
    // commite changes
    batch.commit();
  }

  Stream<List<MessageModel>> getMessage(
    String roomId, {
    DocumentSnapshot? lastDocument,
  }) {
    var query = getChatRoomMessage(
      roomId,
    ).orderBy('timestamp', descending: true).limit(20);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList(),
    );
  }

  Future<List<MessageModel>> getMoreMessage(
    String roomId, {
    required DocumentSnapshot lastDocument,
  }) async {
    var query = getChatRoomMessage(roomId)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastDocument)
        .limit(20);

    final snapshot = await query.get();

    return snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
  }

  Stream<List<ChatRoomModel>> getChatRoom(String userId) {
    return _chatRooms
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatRoomModel.fromFireStore(doc))
              .toList(),
        );
  }

  Stream<int> getUnreadCount(String chatRoomId, String userId) {
    return getChatRoomMessage(chatRoomId)
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: MessageStatus.sent.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
