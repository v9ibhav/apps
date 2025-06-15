import 'dart:convert';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthService {
  //region Handle Firebase User Login and Sign Up for Chat module
  Future<UserCredential> getFirebaseUser() async {
    UserCredential? userCredential;
    try {
      /// login with Firebase
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: appStore.userEmail, password: DEFAULT_FIREBASE_PASSWORD);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        /// register user in Firebase
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: appStore.userEmail, password: DEFAULT_FIREBASE_PASSWORD);
      }
    }
    if (userCredential != null && userCredential.user == null) {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: appStore.userEmail, password: DEFAULT_FIREBASE_PASSWORD);
    }

    if (userCredential != null) {
      return userCredential;
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> verifyFirebaseUser() async {
    try {
      UserCredential userCredential = await getFirebaseUser();

      UserData userData = UserData();
      userData.id = appStore.userId;
      userData.email = appStore.userEmail;
      userData.firstName = appStore.userFirstName;
      userData.lastName = appStore.userLastName;
      userData.profileImage = appStore.userProfileImage;
      userData.updatedAt = Timestamp.now().toDate().toString();

      /// Check email exists in Firebase
      /// If not exists, register user in Firebase,
      /// If exists, login with Firebase
      /// Redirect to Dashboard

      /// add user data in Firestore
      userData.uid = userCredential.user!.uid;

      bool isUserExistWithUid = await userService.isUserExistWithUid(userCredential.user!.uid);

      if (!isUserExistWithUid) {
        userData.createdAt = Timestamp.now().toDate().toString();
        await userService.addDocumentWithCustomId(userCredential.user!.uid, userData.toFirebaseJson());
      } else {
        /// Update user details in Firebase
        await userService.updateDocument(userData.toFirebaseJson(), userCredential.user!.uid);
      }

      /// Update UID & Profile Image in Laravel DB
      updateProfile({'uid': userCredential.user!.uid});

      await appStore.setUId(userCredential.user!.uid);
    } catch (e) {
      log('verifyFirebaseUser $e');
    }
  }

  //endregion

  //region Google Login
  Future<User> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);

      final User currentUser = FirebaseAuth.instance.currentUser!;
      assert(user.uid == currentUser.uid);

      try {
        AuthCredential emailAuthCredential = EmailAuthProvider.credential(email: user.email!, password: DEFAULT_FIREBASE_PASSWORD);
        user.linkWithCredential(emailAuthCredential);
      } catch (e) {
        log(e);
      }

      await googleSignIn.signOut();

      return user;
    } else {
      appStore.setLoading(false);
      throw USER_NOT_CREATED;
    }
  }

  //endregion

  //region Apple Sign In
  Future<Map<String, dynamic>> appleSignIn() async {
    if (await TheAppleSignIn.isAvailable()) {
      AuthorizationResult result = await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
          );

          final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
          final user = authResult.user!;

          log('User:- $user');

          /// TODO verify that email is stored or not
          if (result.credential != null && result.credential!.email.validate().isNotEmpty) {
            appStore.setLoading(true);

            await setValue(APPLE_EMAIL, result.credential!.email);
            await setValue(APPLE_GIVE_NAME, result.credential!.fullName!.givenName);
            await setValue(APPLE_FAMILY_NAME, result.credential!.fullName!.familyName);
          } else {
            await setValue(APPLE_EMAIL, user.email.validate());
          }
          await setValue(APPLE_UID, user.uid.validate());

          log('UID: ${getStringAsync(APPLE_UID)}');
          log('Email:- ${getStringAsync(APPLE_EMAIL)}');
          log('appleGivenName:- ${getStringAsync(APPLE_GIVE_NAME)}');
          log('appleFamilyName:- ${getStringAsync(APPLE_FAMILY_NAME)}');

          var req = {
            'email': getStringAsync(APPLE_EMAIL),
            'first_name': getStringAsync(APPLE_GIVE_NAME),
            'last_name': getStringAsync(APPLE_FAMILY_NAME),
            "username": getStringAsync(APPLE_EMAIL),
            "social_image": '',
            'accessToken': '12345678',
            'login_type': LOGIN_TYPE_APPLE,
            "user_type": LOGIN_TYPE_USER,
          };

          log("Apple Login Json" + jsonEncode(req));

          return req;
        case AuthorizationStatus.error:
          throw ("${language.lblSignInFailed}: ${result.error!.localizedDescription}");
        case AuthorizationStatus.cancelled:
          throw ('${language.lblUserCancelled}');
      }
    } else {
      throw language.lblAppleSignInNotAvailable;
    }
  }
//endregion
}
