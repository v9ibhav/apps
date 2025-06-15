import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/chat_gpt_loder.dart';
import '../utils/colors.dart';
import '../utils/getImage.dart';

class ServiceProofScreen extends StatefulWidget {
  final BookingDetailResponse? bookingDetail;

  ServiceProofScreen({this.bookingDetail});

  @override
  ServiceProofScreenState createState() => ServiceProofScreenState();
}

class ServiceProofScreenState extends State<ServiceProofScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController serviceNameCont = TextEditingController();
  TextEditingController titleCont = TextEditingController();
  TextEditingController compliantCont = TextEditingController();

  FocusNode compliantFocus = FocusNode();
  FilePickerResult? filePickerResult;

  List<XFile> imageFiles = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    serviceNameCont.text = widget.bookingDetail!.service!.name.validate();
    setState(() {});
  }

  Future<void> submit() async {
    hideKeyboard(context);

    MultipartRequest multiPartRequest = await getMultiPartRequest('save-service-proof');
    multiPartRequest.fields[CommonKeys.serviceId] = widget.bookingDetail!.service!.id.toString().validate();
    multiPartRequest.fields[CommonKeys.bookingId] = widget.bookingDetail!.bookingDetail!.id.toString().validate();
    multiPartRequest.fields[CommonKeys.userId] = getIntAsync(USER_ID).toString();
    multiPartRequest.fields[SaveBookingAttachment.title] = titleCont.text.validate();
    multiPartRequest.fields[SaveBookingAttachment.description] = compliantCont.text.validate();

    if (imageFiles.isNotEmpty) {
      await Future.forEach<XFile>(imageFiles, (element) async {
        int i = imageFiles.indexOf(element);
        log('${SaveBookingAttachment.bookingAttachment + i.toString()}');
        multiPartRequest.files.add(await MultipartFile.fromPath('${SaveBookingAttachment.bookingAttachment + i.toString()}', element.path));
      });
    }
    if (imageFiles.isEmpty) {
      return toast(languages.lblChooseOneImage);
    }

    if (imageFiles.isNotEmpty) multiPartRequest.fields[AddServiceKey.attachmentCount] = imageFiles.length.toString();

    log('multiPartRequest.fields : ${multiPartRequest.fields}');

    multiPartRequest.headers.addAll(buildHeaderTokens());

    appStore.setLoading(true);

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);

        finish(context, true);
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void _showImgPickBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: languages.lblGallery,
              leading: Icon(Icons.image, color: context.iconColor),
              onTap: () async {
                _handleGalleryClick();
              },
            ),
            SettingItemWidget(
              title: languages.camera,
              leading: Icon(Icons.camera, color: context.iconColor),
              onTap: () {
                _handleCameraClick();
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  Future<void> _handleGalleryClick() async {
    finish(context);
    GetMultipleImage(path: (xFiles) async {
      log('Path camera : ${xFiles.length.toString()}');
      final existingNames = imageFiles.map((file) => file.name.trim().toLowerCase()).toSet();
      imageFiles.addAll(xFiles.where((file) => !existingNames.contains(file.name.trim().toLowerCase())));
      setState(() {});
    });
  }

  Future<void> _handleCameraClick() async {
    finish(context);
    GetImage(ImageSource.camera, path: (path, name, xFile) async {
      log('Path camera : ${path.toString()} name $name');
      imageFiles.add(xFile);
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.lblServiceProof,
        color: context.primaryColor,
        textColor: white,
        backWidget: BackWidget(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(languages.hintServiceName, style: boldTextStyle()),
                      2.width,
                      Text('*', style: boldTextStyle(color: pending)),
                    ],
                  ),
                  12.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: serviceNameCont,
                    decoration: inputDecoration(context, showLabel: false),
                    enabled: false,
                  ),
                  16.height,
                  Row(
                    children: [
                      Text(languages.lblTitle, style: boldTextStyle()),
                      2.width,
                      Text('*', style: boldTextStyle(color: pending)),
                    ],
                  ),
                  12.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: titleCont,
                    nextFocus: compliantFocus,
                    isValidationRequired: true,
                    decoration: inputDecoration(context, hint: languages.lblTitle, showLabel: false),
                  ),
                  16.height,
                  Row(
                    children: [
                      Text(languages.hintDescription, style: boldTextStyle()),
                      2.width,
                      Text('*', style: boldTextStyle(color: pending)),
                    ],
                  ),
                  12.height,
                  AppTextField(
                    textFieldType: TextFieldType.MULTILINE,
                    controller: compliantCont,
                    minLines: 5,
                    isValidationRequired: true,
                    enableChatGPT: appConfigurationStore.chatGPTStatus,
                    promptFieldInputDecorationChatGPT: inputDecoration(context).copyWith(
                      hintText: languages.writeHere,
                      fillColor: context.scaffoldBackgroundColor,
                      filled: true,
                    ),
                    testWithoutKeyChatGPT: appConfigurationStore.testWithoutKey,
                    loaderWidgetForChatGPT: const ChatGPTLoadingWidget(),
                    decoration: inputDecoration(context, hint: languages.hintDescription, showLabel: false),
                  ),
                  16.height,
                  SizedBox(
                    width: context.width(),
                    child: Column(
                      children: [
                        DottedBorderWidget(
                          color: primaryColor.withValues(alpha:0.6),
                          strokeWidth: 1,
                          padding: EdgeInsets.all(16),
                          radius: defaultRadius,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_upload_outlined, size: 30, color: context.iconColor),
                              8.height,
                              Text(languages.uploadMedia, style: boldTextStyle()),
                            ],
                          ).center().onTap(() async {
                            _showImgPickBottomSheet(context);
                          }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
                        ),
                        16.height,
                        Text(languages.serviceProofMediaUploadNote, style: secondaryTextStyle()),
                      ],
                    ),
                  ),
                  16.height,
                  HorizontalList(
                      padding: EdgeInsets.zero,
                      itemCount: imageFiles.length,
                      itemBuilder: (context, i) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.file(File(imageFiles[i].path), width: 90, height: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                            Container(
                              decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryColor),
                              margin: EdgeInsets.only(right: 8, top: 8),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close, size: 16, color: white),
                            ).onTap(() {
                              imageFiles.removeAt(i);
                              setState(() {});
                            }),
                          ],
                        );
                      }).paddingBottom(16).visible(imageFiles.isNotEmpty),
                ],
              ),
            ),
          ),
          Observer(
            builder: (context) => LoaderWidget().visible(appStore.isLoading),
          )
        ],
      ),
      bottomNavigationBar: AppButton(
        text: languages.lblSubmit,
        textColor: Colors.white,
        color: primaryColor,
        onTap: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            submit();
          }
        },
      ).paddingAll(16),
    );
  }
}
