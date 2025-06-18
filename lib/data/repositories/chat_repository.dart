import 'package:chat_app/data/models/chat_room_model.dart';
import 'package:chat_app/data/service/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository extends BaseReposisory {
  CollectionReference get _chatRooms => firestore.collection('chatRooms');

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
}
