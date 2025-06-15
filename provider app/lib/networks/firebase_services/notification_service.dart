import 'dart:convert';
import 'dart:io';

import 'package:handyman_provider_flutter/models/firebase_details_model.dart';
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/user_data.dart';

class NotificationService {
  Future<void> sendPushNotifications(String title, String content, {String? image, required UserData receiverUser, required UserData senderUserData}) async {
    await getFirebaseTokenAndId().then((value) async {
      if (value.data != null) {
        Map<String, dynamic> data = {
          "created_at": senderUserData.createdAt,
          "email": senderUserData.email,
          "first_name": senderUserData.firstName,
          "id": senderUserData.id.toString(),
          "last_name": senderUserData.lastName,
          "updated_at": senderUserData.updatedAt,
          "profile_image": senderUserData.profileImage,
          "uid": senderUserData.uid,
        };

        data.putIfAbsent("is_chat", () => '1');
        if (image != null && image.isNotEmpty) data.putIfAbsent("image_url", () => image.validate());

        Map req = {
          "message": {
            "topic": "user_${receiverUser.id.validate()}",
            "notification": {
              "body": content,
              "title": "$title ${languages.sentYouAMessage}",
              "image": image.validate(),
            },
            "data": data,
          }
        };

        log(req);
        var header = {
          HttpHeaders.authorizationHeader: 'Bearer ${value.data!.firebaseToken}',
          HttpHeaders.contentTypeHeader: 'application/json',
        };

        Response res = await post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/${value.data!.projectId}/messages:send'),
          body: jsonEncode(req),
          headers: header,
        );

        log(res.statusCode);
        log(res.body);

        if (res.statusCode.isSuccessful()) {
        } else {
          throw errorSomethingWentWrong;
        }
      }
    });
  }

  Future<FirebaseDetailsModel> getFirebaseTokenAndId({Map? request}) async {
    return FirebaseDetailsModel.fromJson(await handleResponse(await buildHttpResponse('firebase-detail', request: request, method: HttpMethodType.GET)));
  }
}
