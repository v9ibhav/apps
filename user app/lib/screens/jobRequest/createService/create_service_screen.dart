import 'dart:convert';
import 'dart:io';

import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/model/package_data_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/network/network_utils.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/chat_gpt_loder.dart';
import '../../../model/multi_language_request_model.dart';
import '../../../utils/configs.dart';

class CreateServiceScreen extends StatefulWidget {
  final ServiceData? data;

  CreateServiceScreen({this.data});

  @override
  _CreateServiceScreenState createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey formWidgetKey = UniqueKey();

  ImagePicker picker = ImagePicker();

  TextEditingController serviceNameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode serviceNameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  List<XFile> imageFiles = [];
  List<Attachments> attachmentsArray = [];
  List<String> typeList = [SERVICE_TYPE_FIXED, SERVICE_TYPE_HOURLY];
  List<CategoryData> categoryList = [];

  CategoryData? selectedCategory;
  String serviceType = '';

  bool isUpdate = false;
  bool isServiceUpdated = false;

  Map<String, MultiLanguageRequest> translations = {};
  MultiLanguageRequest enTranslations = MultiLanguageRequest();

  @override
  void initState() {
    super.initState();
    init();
    appStore.setSelectedLanguage(languageList().first);
  }

  Future<void> init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      if (widget.data?.translations?.isNotEmpty ?? false) {
        translations = await widget.data!.translations!;
        enTranslations = await translations[DEFAULT_LANGUAGE]!;
      }

      //Fill Other Fileds
      serviceNameCont.text = widget.data?.translations?[DEFAULT_LANGUAGE]?.name.validate() ?? "";
      descriptionCont.text = widget.data?.translations?[DEFAULT_LANGUAGE]?.description.validate() ?? "";
      imageFiles.addAll(widget.data!.attachments!.map((e) => XFile(e.validate().toString())));
      attachmentsArray.addAll(widget.data!.attachmentsArray.validate());
    }

    await getCategoryData();
  }

  Future<void> getCategoryData() async {
    appStore.setLoading(true);
    await getCategoryList(CATEGORY_LIST_ALL).then((value) {
      if (value.categoryList!.isNotEmpty) {
        categoryList.addAll(value.categoryList.validate());
      }

      if (isUpdate) {
        selectedCategory = value.categoryList!.firstWhere((element) => element.id == widget.data!.categoryId.validate());
      }

      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> getMultipleFile() async {
    await picker.pickMultiImage().then((value) {
      imageFiles.addAll(value);
      setState(() {});
    });
  }

  //region Add Service
  Future<void> checkValidation({required bool isSave, LanguageDataModel? code}) async {
    if (imageFiles.isEmpty) {
      return toast(language.pleaseAddImage);
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      updateTranslation();

      if (!isSave) {
        appStore.setSelectedLanguage(code!);
        disposeAllTextFieldsController();
        getTranslation();
        await checkValidationLanguage();
        setState(() => formWidgetKey = UniqueKey());
      } else {
        showConfirmDialogCustom(
          context,
          title: language.confirmationRequestTxt,
          positiveText: language.lblYes,
          negativeText: language.lblNo,
          primaryColor: primaryColor,
          onAccept: (p0) async {
            await removeEnTranslations();
            final req = await _buildServiceRequest();
            _submitService(req, context);
          },
        );
      }
    }
  }

//endregion

  //region remove en translations
  removeEnTranslations() {
    if (translations.containsKey(DEFAULT_LANGUAGE)) {
      translations.remove(DEFAULT_LANGUAGE);
    }
  }
//endregion

//region Service APi Call
  Future<void> _submitService(req, context) async {
    try {
      appStore.setLoading(true);
      await sendMultiPartRequest(
        req,
        onSuccess: (data) async {
          appStore.setLoading(false);
          toast(jsonDecode(data)['message'], print: true);

          finish(context, true);
        },
        onError: (error) {
          toast(error.toString(), print: true);
          appStore.setLoading(false);
        },
      ).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    } catch (e) {
      toast(e.toString());
    }
  }

//endregion

//region service request
  Future<MultipartRequest> _buildServiceRequest() async {
    MultipartRequest multiPartRequest = await getMultiPartRequest('service-save');
    multiPartRequest.fields[CreateService.name] = enTranslations.name.validate();
    multiPartRequest.fields[CreateService.description] = enTranslations.description.validate();
    multiPartRequest.fields[CreateService.type] = SERVICE_TYPE_FIXED;
    multiPartRequest.fields[CreateService.price] = '0';
    multiPartRequest.fields[CreateService.addedBy] = appStore.userId.toString().validate();
    multiPartRequest.fields[CreateService.providerId] = appStore.userId.toString();
    multiPartRequest.fields[CreateService.categoryId] = selectedCategory!.id.toString();
    multiPartRequest.fields[CreateService.status] = '1';
    multiPartRequest.fields[CreateService.duration] = "0";

    log("multiPart Request: ${multiPartRequest.fields}");

    if (isUpdate) {
      multiPartRequest.fields[CreateService.id] = widget.data!.id.validate().toString();
    }

    if (translations.isNotEmpty) {
      multiPartRequest.fields[CreateService.translations] = jsonEncode(translations);
    }

    if (imageFiles.isNotEmpty) {
      List<XFile> tempImages = imageFiles.where((element) => !element.path.contains("https")).toList();

      multiPartRequest.files.clear();
      await Future.forEach<XFile>(tempImages, (element) async {
        int i = tempImages.indexOf(element);
        multiPartRequest.files.add(await MultipartFile.fromPath('${CreateService.serviceAttachment + i.toString()}', element.path));
      });

      if (tempImages.isNotEmpty) multiPartRequest.fields[CreateService.attachmentCount] = tempImages.length.toString();
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());

    return multiPartRequest;
  }
  //endregion

  //region Update Translation
  void updateTranslation() {
    appStore.setLoading(true);
    final languageCode = appStore.selectedLanguage.languageCode.validate();
    if (serviceNameCont.text.isEmpty && descriptionCont.text.isEmpty) {
      translations.remove(languageCode);
    } else {
      if (languageCode != DEFAULT_LANGUAGE) {
        translations[languageCode] = translations[languageCode]?.copyWith(
              name: serviceNameCont.text.validate(),
              description: descriptionCont.text.validate(),
            ) ??
            MultiLanguageRequest(
              name: serviceNameCont.text.validate(),
              description: descriptionCont.text.validate(),
            );
      } else {
        enTranslations = enTranslations.copyWith(
          name: serviceNameCont.text.validate(),
          description: descriptionCont.text.validate(),
        );
      }
    }
    appStore.setLoading(false);
  }

//endregion

//region Get Translation Details
  void getTranslation() {
    final languageCode = appStore.selectedLanguage.languageCode;
    if (languageCode == DEFAULT_LANGUAGE) {
      serviceNameCont.text = enTranslations.name.validate();
      descriptionCont.text = enTranslations.description.validate();
    } else {
      final translation = translations[languageCode] ?? MultiLanguageRequest();
      serviceNameCont.text = translation.name.validate();
      descriptionCont.text = translation.description.validate();
    }
    setState(() {});
  }

//endregion

//region Dispose All TextControllers
  void disposeAllTextFieldsController() {
    serviceNameCont.clear();
    descriptionCont.clear();
    setState(() {});
  }

//endregion

//region language wise validation
  bool checkValidationLanguage() {
    if (appStore.selectedLanguage.languageCode == DEFAULT_LANGUAGE) {
      return true;
    } else {
      return false;
    }
  }
//endregion

  Future<void> removeAttachment({required int id}) async {
    appStore.setLoading(true);

    Map req = {
      CommonKeys.type: SERVICE_ATTACHMENT,
      CommonKeys.id: id,
    };

    await deleteImage(req).then((value) {
      attachmentsArray.validate().removeWhere((element) => element.id == id);
      isServiceUpdated = true;
      setState(() {});

      // uniqueKey = UniqueKey();

      appStore.setLoading(false);
      toast(value.message.validate(), print: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context, isServiceUpdated);
        return Future.value(false);
      },
      child: AppScaffold(
        appBarTitle: language.createServiceRequest,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            8.height,
            MultiLanguageWidget(onTap: (LanguageDataModel code) async {
              checkValidation(isSave: false, code: code);
            }),
            8.height,
            Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  key: formWidgetKey,
                  children: [
                    SizedBox(
                      width: context.width(),
                      height: 120,
                      child: DottedBorderWidget(
                        color: primaryColor.withValues(alpha: 0.6),
                        strokeWidth: 1,
                        gap: 6,
                        radius: 12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(selectImage, height: 25, width: 25, color: appStore.isDarkMode ? white : gray),
                            8.height,
                            Text(language.chooseImages, style: boldTextStyle()),
                          ],
                        ).center().onTap(borderRadius: radius(), () async {
                          getMultipleFile();
                        }),
                      ),
                    ),
                    HorizontalList(
                      itemCount: imageFiles.length,
                      itemBuilder: (context, i) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            if (imageFiles[i].path.contains("https"))
                              CachedImageWidget(url: imageFiles[i].path, height: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(16)
                            else
                              Image.file(File(imageFiles[i].path), width: 90, height: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(16),
                            Container(
                              decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryColor),
                              margin: EdgeInsets.only(right: 8, top: 4),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close, size: 16, color: white),
                            ).onTap(() {
                              if (imageFiles[i].path.startsWith("https")) {
                                showConfirmDialogCustom(
                                  context,
                                  dialogType: DialogType.DELETE,
                                  positiveText: language.lblDelete,
                                  negativeText: language.lblCancel,
                                  primaryColor: context.primaryColor,
                                  onAccept: (p0) {
                                    if (attachmentsArray.any((element) => element.url == imageFiles[i].path)) {
                                      int id = attachmentsArray.firstWhere((element) => element.url == imageFiles[i].path).id.validate();

                                      imageFiles.removeAt(i);
                                      attachmentsArray.removeAt(i);

                                      removeAttachment(id: id);
                                    }
                                    setState(() {});
                                  },
                                );
                              } else {
                                showConfirmDialogCustom(
                                  context,
                                  dialogType: DialogType.DELETE,
                                  positiveText: language.lblDelete,
                                  negativeText: language.lblCancel,
                                  primaryColor: context.primaryColor,
                                  onAccept: (p0) {
                                    imageFiles.removeWhere((element) => element.path == imageFiles[i].path);
                                    attachmentsArray.removeWhere((element) => element.url == imageFiles[i].path);
                                    //imageFiles.removeAt(i);
                                    setState(() {});
                                  },
                                );
                              }
                            }),
                          ],
                        );
                      },
                    ).paddingBottom(16).visible(imageFiles.isNotEmpty),
                    20.height,
                    DropdownButtonFormField<CategoryData>(
                      decoration: inputDecoration(context, labelText: language.lblCategory),
                      hint: Text(language.selectCategory, style: secondaryTextStyle()),
                      value: selectedCategory,
                      validator: (value) {
                        if (value == null) return errorThisFieldRequired;

                        return null;
                      },
                      dropdownColor: context.scaffoldBackgroundColor,
                      items: categoryList.map((data) {
                        return DropdownMenuItem<CategoryData>(
                          value: data,
                          child: Text(data.name.validate(), style: primaryTextStyle()),
                        );
                      }).toList(),
                      onChanged: isUpdate
                          ? null
                          : (CategoryData? value) async {
                              selectedCategory = value!;
                              setState(() {});
                            },
                    ),
                    16.height,
                    AppTextField(
                      controller: serviceNameCont,
                      textFieldType: TextFieldType.NAME,
                      nextFocus: descriptionFocus,
                      errorThisFieldRequired: language.requiredText,
                      isValidationRequired: checkValidationLanguage(),
                      decoration: inputDecoration(context, labelText: language.serviceName),
                    ),
                    16.height,
                    AppTextField(
                      controller: descriptionCont,
                      textFieldType: TextFieldType.MULTILINE,
                      errorThisFieldRequired: language.requiredText,
                      maxLines: 2,
                      focus: descriptionFocus,
                      enableChatGPT: appConfigurationStore.chatGPTStatus,
                      isValidationRequired: checkValidationLanguage(),
                      promptFieldInputDecorationChatGPT: inputDecoration(context).copyWith(
                        hintText: language.writeHere,
                        fillColor: context.scaffoldBackgroundColor,
                        filled: true,
                      ),
                      testWithoutKeyChatGPT: appConfigurationStore.testWithoutKey,
                      loaderWidgetForChatGPT: const ChatGPTLoadingWidget(),
                      decoration: inputDecoration(context, labelText: language.serviceDescription),
                      validator: (value) {
                        if (value!.isEmpty) return language.requiredText;
                        return null;
                      },
                    ),
                    16.height,
                    AppButton(
                      text: isUpdate ? language.lblUpdate : language.save,
                      color: context.primaryColor,
                      width: context.width(),
                      onTap: () {
                        checkValidation(isSave: true);
                      },
                    )
                  ],
                ),
              ),
            ).paddingAll(16).expand(),
          ],
        ),
      ),
    );
  }
}
