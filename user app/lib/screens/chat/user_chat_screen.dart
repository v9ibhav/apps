import 'dart:async';
import 'dart:io';

import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/chat_message_model.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/screens/chat/widget/chat_item_widget.dart';
import 'package:booking_system_flutter/services/notification_services.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/cached_image_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../services/chat_services.dart';
import '../../utils/configs.dart';
import '../../utils/getImage.dart';
import '../../utils/images.dart';
import 'send_file_screen.dart';

class UserChatScreen extends StatefulWidget {
  final UserData receiverUser;
  final bool isChattingAllow;

  UserChatScreen({required this.receiverUser, this.isChattingAllow = false});

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> with WidgetsBindingObserver {
  TextEditingController messageCont = TextEditingController();

  FocusNode messageFocus = FocusNode();

  UserData senderUser = UserData();

  StreamSubscription? _streamSubscription;

  int isReceiverOnline = 0;

  bool get isReceiverUserOnline => isReceiverOnline == 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    WidgetsBinding.instance.addObserver(this);

    //OneSignal.shared.disablePush(true);

    if (widget.receiverUser.uid.validate().isEmpty) {
      await userService.getUser(email: widget.receiverUser.email.validate()).then((value) {
        widget.receiverUser.uid = value.uid;
      }).catchError((e) {
        log(e.toString());
      });
    }

    senderUser = await userService.getUser(email: appStore.userEmail.validate());
    appStore.setLoading(false);
    setState(() {});

    if (await userService.isReceiverInContacts(senderUserId: appStore.uid.validate(), receiverUserId: widget.receiverUser.uid.validate())) {
      await chatServices.setUnReadStatusToTrue(senderId: appStore.uid.validate(), receiverId: widget.receiverUser.uid.validate()).catchError((e) {
        toast(e.toString());
      });

      log("receiver ID ${widget.receiverUser.uid}");
      chatServices.setOnlineCount(senderId: widget.receiverUser.uid.validate(), receiverId: appStore.uid.validate(), status: 1);
      //
      _streamSubscription = chatServices.isReceiverOnline(senderId: appStore.uid.validate(), receiverUserId: widget.receiverUser.uid.validate()).listen((event) {
        isReceiverOnline = event.isOnline.validate();
        log("=======*=======*=======*=======*=======* User $isReceiverOnline =======*=======*=======*=======*=======");
      });
    }
  }

  //region Widget
  Widget _buildChatFieldWidget() {
    return Row(
      children: [
        AppTextField(
          textFieldType: TextFieldType.OTHER,
          controller: messageCont,
          textStyle: primaryTextStyle(),
          minLines: 1,
          onFieldSubmitted: (s) {
            sendMessages();
          },
          focus: messageFocus,
          cursorHeight: 20,
          maxLines: 5,
          cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Transform.rotate(angle: -0.75, child: Icon(Icons.attach_file_outlined)),
                onPressed: () {
                  if (!appStore.isLoading) {
                    _handleDocumentClick();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () {
                  if (!appStore.isLoading) {
                    _handleCameraClick();
                  }
                },
              ),
            ],
          ),
          decoration: inputDecoration(context).copyWith(hintText: language.message, hintStyle: secondaryTextStyle()),
        ).expand(),
        8.width,
        Container(
          decoration: boxDecorationDefault(borderRadius: radius(80), color: primaryColor),
          child: IconButton(
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: () {
              sendMessages();
            },
          ),
        )
      ],
    );
  }

  //endregion

  //region Methods
  Future<void> sendMessages({
    bool isFile = false,
    List<String> attachmentFiles = const [],
  }) async {
    if (appStore.isLoading) return;
    // If Message TextField is Empty.
    if (messageCont.text.trim().isEmpty && !isFile) {
      messageFocus.requestFocus();
      return;
    } else if (isFile && attachmentFiles.isEmpty) {
      return;
    }

    // Making Request for sending data to firebase
    ChatMessageModel data = ChatMessageModel();

    data.receiverId = widget.receiverUser.uid;
    data.senderId = appStore.uid;
    data.message = messageCont.text;
    data.isMessageRead = isReceiverOnline == 1;
    data.createdAt = DateTime.now().millisecondsSinceEpoch;
    data.createdAtTime = Timestamp.now();
    data.updatedAtTime = Timestamp.now();
    data.messageType = isFile ? MessageType.Files.name : MessageType.TEXT.name;
    data.attachmentfiles = attachmentFiles;
    log('ChatMessageModel Data : ${data.toJson()}');
    messageCont.clear();

    if (!(await userService.isReceiverInContacts(senderUserId: appStore.uid.validate(), receiverUserId: widget.receiverUser.uid.validate()))) {
      log("========Adding To Contacts=========");
      await chatServices.addToContacts(
        senderId: data.senderId,
        receiverId: data.receiverId,
        receiverName: widget.receiverUser.displayName.validate(),
        senderName: senderUser.displayName.validate(),
      );
      _streamSubscription = chatServices.isReceiverOnline(senderId: appStore.uid.validate(), receiverUserId: widget.receiverUser.uid.validate()).listen((event) {
        isReceiverOnline = event.isOnline.validate();
        log("=======*=======*=======*=======*=======* User $isReceiverOnline =======*=======*=======*=======*=======");
      });
    }
    log('-------addMessage----');
    await chatServices.addMessage(data).then((value) async {
      log("--Message Successfully Added--");
      // todo : remove this
      isReceiverOnline = 0;
      if (isReceiverOnline != 1) {
        /// Send Notification
        NotificationService()
            .sendPushNotifications(
          appStore.userFullName,
          data.message.validate(),
          image: data.attachmentfiles == null || data.attachmentfiles!.isEmpty ? null : data.attachmentfiles!.first,
          receiverUser: widget.receiverUser,
          senderUserData: senderUser,
        )
            .catchError((e) {
          log("Notification Error ${e.toString()}");
        });
      }

      /// Save receiverId to Sender Doc.
      userService.saveToContacts(senderId: appStore.uid, receiverId: widget.receiverUser.uid.validate()).then((value) => log("---ReceiverId to Sender Doc.---")).catchError((e) {
        log(e.toString());
      });

      /// Save senderId to Receiver Doc.
      userService.saveToContacts(senderId: widget.receiverUser.uid.validate(), receiverId: appStore.uid).then((value) => log("---SenderId to Receiver Doc.---")).catchError((e) {
        log(e.toString());
      });

      /// ENd
    }).catchError((e) {
      log(e.toString());
    });
  }

  //endregion

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      chatServices.setOnlineCount(senderId: widget.receiverUser.uid.validate(), receiverId: appStore.uid.validate(), status: 0);
    }

    if (state == AppLifecycleState.paused) {
      chatServices.setOnlineCount(senderId: widget.receiverUser.uid.validate(), receiverId: appStore.uid.validate(), status: 0);
    }
    if (state == AppLifecycleState.resumed) {
      chatServices.setOnlineCount(senderId: widget.receiverUser.uid.validate(), receiverId: appStore.uid.validate(), status: 1);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    chatServices.setOnlineCount(senderId: widget.receiverUser.uid.validate(), receiverId: appStore.uid.validate(), status: 0);

    _streamSubscription?.cancel();

    setStatusBarColor(transparentColor, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.primaryColor,
          leadingWidth: context.width(),
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: context.primaryColor, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light),
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.symmetric(horizontal: 8),
                onPressed: () {
                  finish(context);
                },
                icon: ic_arrow_left.iconImage(color: Colors.white),
              ),
              CachedImageWidget(url: widget.receiverUser.profileImage.validate(), height: 36, circle: true, fit: BoxFit.cover),
              12.width,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.receiverUser.firstName.validate() + " " + widget.receiverUser.lastName.validate()}",
                    style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ).expand(),
              40.width,
            ],
          ),
          actions: [
            PopupMenuButton(
              onSelected: (index) {
                if (index == 0) {
                  showConfirmDialogCustom(
                    context,
                    positiveText: language.lblYes,
                    negativeText: language.lblNo,
                    primaryColor: context.primaryColor,
                    title: language.clearChatMessage,
                    onAccept: (c) async {
                      appStore.setLoading(true);
                      await chatServices.clearAllMessages(senderId: appStore.uid, receiverId: widget.receiverUser.uid.validate()).then((value) {
                        toast(language.chatCleared);
                        hideKeyboard(context);
                      }).catchError((e) {
                        toast(e);
                      });
                      appStore.setLoading(false);
                    },
                  );
                }
              },
              color: context.cardColor,
              icon: Icon(Icons.more_vert_sharp, color: Colors.white),
              itemBuilder: (context) {
                List<PopupMenuItem> list = [];
                list.add(
                  PopupMenuItem(
                    value: 0,
                    child: Text(language.clearChat, style: primaryTextStyle()),
                  ),
                );
                return list;
              },
            )
          ],
        ),
        body: SizedBox(
          height: context.height(),
          width: context.width(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: widget.isChattingAllow ? 0 : 80),
                child: FirestorePagination(
                  reverse: true,
                  isLive: true,
                  padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0),
                  physics: BouncingScrollPhysics(),
                  query: chatServices.chatMessagesWithPagination(senderId: appStore.uid.validate(), receiverUserId: widget.receiverUser.uid.validate()),
                  initialLoader: LoaderWidget(),
                  limit: PER_PAGE_CHAT_LIST_COUNT,
                  onEmpty: NoDataWidget(
                    title: language.noConversation,
                    imageWidget: EmptyStateWidget(),
                  ),
                  shrinkWrap: true,
                  viewType: ViewType.list,
                  itemBuilder: (context, snap, index) {
                    ChatMessageModel data = ChatMessageModel.fromJson(snap[index].data() as Map<String, dynamic>);
                    data.isMe = data.senderId == appStore.uid;
                    data.chatDocumentReference = snap[index].reference;

                    return ChatItemWidget(chatItemData: data);
                  },
                ),
              ),
              if (!widget.isChattingAllow)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildChatFieldWidget(),
                ),
              Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleDocumentClick() async {
    appStore.setLoading(true);
    await pickFiles(
      allowedExtensions: chatFilesAllowedExtensions,
      maxFileSizeMB: max_acceptable_file_size,
      type: FileType.custom,
    ).then((pickedfiles) async {
      await handleUploadAndSendFiles(pickedfiles);
    }).catchError((e) {
      toast(e);
      log('ChatServices().uploadFiles Err: ${e}');
      return;
    }).whenComplete(() => appStore.setLoading(false));
  }

  Future<void> _handleCameraClick() async {
    GetImage(ImageSource.camera, path: (path, name, xFile) async {
      log('Path camera : ${path.toString()} name $name');
      await handleUploadAndSendFiles([File(xFile.path)]);
      setState(() {});
    });
  }

  Future<void> handleUploadAndSendFiles(List<File> pickedfiles) async {
    if (pickedfiles.isEmpty) return;
    await SendFilePreviewScreen(pickedfiles: pickedfiles).launch(context).then((value) async {
      debugPrint('text: ${value}');
      debugPrint('text: ${value[MessageType.TEXT.name]}');
      debugPrint('files: ${value[MessageType.Files.name]}');
      debugPrint('files: ${value[MessageType.Files.name].runtimeType}');

      if (value[MessageType.Files.name] is List<File>) {
        pickedfiles = value[MessageType.Files.name];
      }

      if (value[MessageType.TEXT.name] is String) {
        messageCont.text = value[MessageType.TEXT.name];
      }

      if (messageCont.text.trim().isNotEmpty || pickedfiles.isNotEmpty) {
        appStore.setLoading(true);
        await ChatServices().uploadFiles(pickedfiles).then((attached_files) async {
          if (attached_files.isEmpty) return;
          log('ATTACHEDFILES: ${attached_files}');
          await sendMessages(isFile: true, attachmentFiles: attached_files).whenComplete(() => appStore.setLoading(false));
        }).catchError((e) {
          toast(e);
          log('ChatServices().uploadFiles Err: ${e}');
          return;
        }).whenComplete(() => appStore.setLoading(false));
      }
    });
  }
}
