import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/chat_message_model.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class LastMessageChat extends StatelessWidget {
  final stream;

  LastMessageChat({
    required this.stream,
  });

  Widget typeWidget(ChatMessageModel message) {
    String? type = message.messageType;
    switch (type) {
      case TEXT:
        return Text(
          "${message.message.validate()}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: secondaryTextStyle(size: 14),
        );
      case IMAGE:
        return Row(
          children: [
            Icon(Icons.photo_sharp, size: 16),
            6.width,
            Text(languages.lblImage, style: secondaryTextStyle(size: 16)),
          ],
        );
      case VIDEO:
        return Row(
          children: [
            Icon(Icons.videocam_outlined, size: 16),
            6.width,
            Text(languages.lblVideo, style: secondaryTextStyle(size: 16)),
          ],
        );
      case AUDIO:
        return Row(
          children: [
            Icon(Icons.audiotrack, size: 16),
            6.width,
            Text(languages.lblAudio, style: secondaryTextStyle(size: 16)),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data!.docs;

          if (docList.isNotEmpty) {
            ChatMessageModel message = ChatMessageModel.fromJson(docList.last.data() as Map<String, dynamic>);
            String time = '';
            DateTime date = DateTime.fromMicrosecondsSinceEpoch(message.createdAt! * 1000);
            if (date.isToday) {
              time = formatDate(message.createdAt.validate().toString(), format: DATE_FORMAT_3, isFromMicrosecondsSinceEpoch: true, isTime: true);
            } else if (date.isYesterday) {
              time = languages.yesterday;
            } else {
              time = formatDate(
                message.createdAt.validate().toString(),
                format: DATE_FORMAT_1,
                isFromMicrosecondsSinceEpoch: true,
              );
            }
            message.isMe = message.senderId == appStore.uid;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                message.isMe.validate()
                    ? !message.isMessageRead.validate()
                        ? Icon(Icons.done, size: 12, color: textSecondaryColorGlobal)
                        : Icon(Icons.done_all, size: 12, color: textSecondaryColorGlobal)
                    : Offstage(),
                typeWidget(message).expand(),
                16.width,
                Text(time, style: secondaryTextStyle(size: 10)),
              ],
            ).paddingTop(2);
          }
          return Offstage();
        }
        return Offstage();
      },
    );
  }
}
