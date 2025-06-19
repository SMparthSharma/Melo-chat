import 'package:chat_app/core/theme/color.dart';
import 'package:chat_app/data/models/chat_room_model.dart';
import 'package:flutter/material.dart';

class ContectListTile extends StatelessWidget {
  final ChatRoomModel chat;
  final String currentUserId;
  final VoidCallback onTap;
  // final Widget child;
  final bool unRead;
  // final int unReadCount;
  const ContectListTile({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
    this.unRead = false,
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
        child: Text(_getOtherUserName()[0].toUpperCase()),
      ),
      title: Text(_getOtherUserName()),
      subtitle: Text(chat.lastMessage ?? ''),
      trailing: unRead
          ? Card(
              shape: CircleBorder(),
              color: ColorPalette.primery.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('1'),
              ),
            )
          : null,
    );
  }
}
