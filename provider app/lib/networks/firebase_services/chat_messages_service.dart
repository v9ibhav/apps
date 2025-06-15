import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/chat_message_model.dart';
import 'package:handyman_provider_flutter/models/contact_model.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/networks/firebase_services/base_services.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

FirebaseFirestore fireStore = FirebaseFirestore.instance;
CollectionReference? userRef;
FirebaseStorage storage = FirebaseStorage.instance;

class ChatServices extends BaseService {
  ChatServices() {
    ref = fireStore.collection(MESSAGES_COLLECTION);
    userRef = fireStore.collection(USER_COLLECTION);
  }

  Query fetchChatListQuery({String? userId}) {
    try {
      return userRef!.doc(userId).collection(CONTACT_COLLECTION).orderBy("lastMessageTime", descending: true);
    } catch (e) {
      // Return an empty query or any other suitable default value
      return userRef!.doc(userId).collection(CONTACT_COLLECTION).orderBy("lastMessageTime", descending: true).limit(0);
    }
  }

  Future<void> setUnReadStatusToTrue({required String senderId, required String receiverId, String? documentId}) async {
    final WriteBatch batch = fireStore.batch();

    QuerySnapshot unreadMessagesSnapshot;

    if (senderId == appStore.uid) {
      unreadMessagesSnapshot = await ref!.doc(receiverId).collection(senderId).where('isMessageRead', isEqualTo: false).get();
    } else {
      unreadMessagesSnapshot = await ref!.doc(senderId).collection(receiverId).where('isMessageRead', isEqualTo: false).get();
    }

    unreadMessagesSnapshot.docs.forEach((element) {
      batch.update(element.reference, {
        'isMessageRead': true,
      });
    });

    await batch.commit();
  }

  Future<void> deleteSingleMessage({String? senderId, required String receiverId, String? documentId}) async {
    try {
      await ref!.doc(senderId).collection(receiverId).doc(documentId).delete();
      log("====================== Message Deleted ======================");
    } catch (e) {
      throw languages.somethingWentWrong;
    }
  }

  Future<void> deleteSingleMessages({DocumentReference? userRef}) async {
    try {
      if (userRef != null) {
        await userRef.delete();
        toast(languages.clearChatMessage);
        log("====================== Message Deleted ======================");
      }
    } catch (e) {
      throw languages.somethingWentWrong;
    }
  }

  Query chatMessagesWithPagination({required String senderId, required String receiverUserId}) {
    try {
      return ref!.doc(senderId).collection(receiverUserId).orderBy("createdAt", descending: true);
    } catch (e) {
      // Handle the exception or return an empty query
      return ref!.doc(senderId).collection(receiverUserId).limit(0);
    }
  }

  Future<DocumentReference> addMessage(ChatMessageModel data) async {
    final senderCollection = ref!.doc(data.senderId).collection(data.receiverId!);
    final receiverCollection = ref!.doc(data.receiverId).collection(data.senderId!);

    final senderDoc = await senderCollection.add(data.toJson());
    final receiverDoc = await receiverCollection.add(data.toJson());

    await senderDoc.update({'uid': senderDoc.id});
    await receiverDoc.update({'uid': receiverDoc.id});

    return senderDoc;
  }

  Future<void> addToContacts({String? senderId, String? receiverId, String? senderName, String? receiverName, bool isSenderUpdate = false, bool isReceiverUpdate = false}) async {
    final currentTime = Timestamp.now();

    await addToContactsDocument(senderId, receiverId, currentTime, contactName: receiverName);
    await addToContactsDocument(receiverId, senderId, currentTime, contactName: senderName);
  }

  DocumentReference getContactsDocument({required String userId, required String contactId}) {
    return userRef!.doc(userId).collection(CONTACT_COLLECTION).doc(contactId);
  }

  Future<void> addToContactsDocument(String? userId, String? contactId, Timestamp currentTime, {String? contactName}) async {
    final contactSnapshot = await getContactsDocument(userId: userId!, contactId: contactId!).get();

    if (!contactSnapshot.exists) {
      final contactData = ContactModel(uid: contactId, addedOn: currentTime);

      await getContactsDocument(userId: userId, contactId: contactId).set(contactData.toJson());
    }
  }

  Stream<int> getUnReadCount({required String senderId, required String receiverId, String? documentId}) {
    if ((senderId == appStore.uid.validate())) {
      return ref!.doc(receiverId).collection(senderId).where('isMessageRead', isEqualTo: false).where('receiverId', isEqualTo: senderId).snapshots().map((event) => event.docs.length).handleError((e) => 0);
    }
    return ref!.doc(senderId).collection(receiverId).where('isMessageRead', isEqualTo: false).where('receiverId', isEqualTo: senderId).snapshots().map((event) => event.docs.length).handleError((e) => 0);
  }

  Stream<QuerySnapshot> fetchLastMessageBetween({required String senderId, required String receiverId}) {
    return ref!.doc(senderId.toString()).collection(receiverId.toString()).orderBy("createdAt", descending: false).snapshots();
  }

  Future<void> clearAllMessages({String? senderId, required String receiverId}) async {
    final QuerySnapshot messagesSnapshot = await ref!.doc(senderId).collection(receiverId).get();
    final WriteBatch batch = fireStore.batch();

    for (final document in messagesSnapshot.docs) {
      batch.delete(document.reference);
    }

    await batch.commit();
  }

  Future<void> setOnlineCount({required String receiverId, required String senderId, required int status}) async {
    /// if status is 0 = Online and 1 = Offline
    userRef!.doc(senderId).collection(CONTACT_COLLECTION).doc(receiverId).update({"isOnline": status});
    getContactsDocument(userId: senderId, contactId: receiverId).update({"isOnline": status});
  }

  Stream<UserData> isReceiverOnline({required String receiverUserId, required String senderId}) {
    return userRef!.doc(senderId).collection(CONTACT_COLLECTION).doc(receiverUserId).snapshots().map((event) => UserData.fromJson(event.data() as Map<String, dynamic>));
  }

  Future<List<String>> uploadFiles(List<File> files) async {
    appStore.setLoading(true);
    List<String> downloadUrls = [];
    for (File file in files) {
      try {
        Reference storageRef = FirebaseStorage.instance.ref().child('$CHAT_FILES/${file.path.getFileName}');
        await storageRef.putFile(file);
        String downloadURL = await storageRef.getDownloadURL();
        downloadUrls.add(downloadURL);
      } catch (e) {
        toast(e.toString());
        log('Error uploading file $CHAT_FILES/${file.path.getFileName}: $e');
      }
    }
    appStore.setLoading(false);
    return downloadUrls;
  }

  Future<void> deleteFiles(List<String> storagePaths) async {
    for (String path in storagePaths) {
      try {
        log('deleteFile: $CHAT_FILES/${path.getChatFileName}');
        await FirebaseStorage.instance.ref('$CHAT_FILES/${path.getChatFileName}').delete();
      } catch (e) {
        log('Error deleting file $CHAT_FILES/${path.getChatFileName}: $e');
      }
    }
  }
}
