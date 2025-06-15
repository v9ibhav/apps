import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/app_theme.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/custom_image_picker.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/package_response.dart';
import 'package:handyman_provider_flutter/models/attachment_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/packages/components/selected_service_component.dart';
import 'package:handyman_provider_flutter/provider/packages/select_service_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/chat_gpt_loder.dart';
import '../../models/multi_language_request_model.dart';
import '../../models/static_data_model.dart';
import '../../utils/configs.dart';
import '../../utils/model_keys.dart';

class AddPackageScreen extends StatefulWidget {
  final PackageData? data;

  AddPackageScreen({this.data});

  @override
  _AddPackageScreenState createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey uniqueKey = UniqueKey();
  UniqueKey formWidgetKey = UniqueKey();

  TextEditingController packageNameCont = TextEditingController();
  TextEditingController packagePriceCont = TextEditingController();
  TextEditingController packageDescriptionCont = TextEditingController();
  TextEditingController startDateCont = TextEditingController();
  TextEditingController endDateCont = TextEditingController();

  FocusNode packagePriceFocus = FocusNode();
  FocusNode packageDescriptionFocus = FocusNode();
  FocusNode startDateFocus = FocusNode();
  FocusNode endDateFocus = FocusNode();

  List<File> imageFiles = [];
  List<Attachments> tempAttachments = [];
  List<int> selectedService = [];

  List<StaticDataModel> statusListStaticData = [
    StaticDataModel(key: ACTIVE, value: languages.active),
    StaticDataModel(key: INACTIVE, value: languages.inactive),
  ];

  StaticDataModel? packageStatusModel;

  String packageStatus = '';
  int? selectedCategoryId = -1;
  int? selectedSubCategoryId = -1;

  DateTime currentDateTime = DateTime.now();
  DateTime? selectedDate;
  DateTime? finalDate;
  TimeOfDay? pickedTime;

  bool isFeature = false;
  bool isUpdate = false;
  String? isPackageTypeSingleCategory;

  Map<String, MultiLanguageRequest> translations = {};
  MultiLanguageRequest enTranslations = MultiLanguageRequest();

  @override
  void initState() {
    super.initState();
    init();
    appStore.setSelectedLanguage(languageList().first);
  }

  void init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      appStore.selectedServiceList.clear();
      appStore.addAllSelectedPackageService(widget.data!.serviceList.validate());

      tempAttachments = widget.data!.attchments.validate();
      imageFiles = widget.data!.attchments.validate().map((e) => File(e.url.toString())).toList();
      packageNameCont.text = widget.data?.translations?[DEFAULT_LANGUAGE]?.name.validate() ?? "";
      packageDescriptionCont.text = widget.data?.translations?[DEFAULT_LANGUAGE]?.description.validate() ?? "";
      packagePriceCont.text = widget.data!.price.toString().validate();
      startDateCont.text = widget.data!.startDate != null ? formatBookingDate(widget.data!.startDate.validate(), format: DATE_FORMAT_7).toString() : "";
      endDateCont.text = widget.data!.endDate != null ? formatBookingDate(widget.data!.endDate.validate(), format: DATE_FORMAT_7).toString() : "";
      isFeature = widget.data!.isFeatured == 1 ? true : false;
      packageStatus = widget.data!.status.validate() == 1 ? ACTIVE : INACTIVE;
      if (packageStatus == ACTIVE) {
        packageStatusModel = statusListStaticData.first;
      } else {
        packageStatusModel = statusListStaticData[1];
      }
      selectedCategoryId = widget.data!.categoryId != null ? widget.data!.categoryId : selectedCategoryId;
      selectedSubCategoryId = widget.data!.subCategoryId != null ? widget.data!.subCategoryId : selectedSubCategoryId;

      isPackageTypeSingleCategory = widget.data!.packageType.validate() == PACKAGE_TYPE_SINGLE ? PACKAGE_TYPE_SINGLE : PACKAGE_TYPE_MULTIPLE;

      if (widget.data?.translations?.isNotEmpty ?? false) {
      translations = await widget.data!.translations!;
      enTranslations = await translations[DEFAULT_LANGUAGE]!;
      }


    } else {
      appStore.selectedServiceList.clear();
      packageStatus = statusListStaticData.first.key!;
    }

    setState(() {});
  }

  // region Select Start Date and End Date
  void selectDateAndTime(BuildContext context, TextEditingController textEditingController, DateTime? abc) async {
    await showDatePicker(
      context: context,
      initialDate: abc ?? currentDateTime,
      firstDate: abc ?? currentDateTime,
      lastDate: currentDateTime.add(30.days),
      locale: Locale(appStore.selectedLanguageCode),
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme,
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        finalDate = DateTime(date.year, date.month, date.day);

        selectedDate = date;
        textEditingController.text = "${formatBookingDate(selectedDate.toString(), format: DATE_FORMAT_7)}";
        setState(() {});
      }
    });
  }

  // endregion

  // region Remove Attachment

  Future<void> removeAttachment({required int id}) async {
    appStore.setLoading(true);

    Map req = {
      CommonKeys.type: PackageKey.removePackageAttachment,
      CommonKeys.id: id,
    };

    await deleteImage(req).then((value) {
      tempAttachments.validate().removeWhere((element) => element.id == id);

      uniqueKey = UniqueKey();

      setState(() {});

      appStore.setLoading(false);
      toast(value.message.validate(), print: true);
    }).catchError((e) {
      appStore.setLoading(false);
      finish(context);
      toast(e.toString(), print: true);
    });
  }
  // endregion

  // region Form Widget
  Widget buildFormWidget() {
    return Container(
      key: formWidgetKey,
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Column(
        children: [
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                8.height,
                AppTextField(
                  controller: packageNameCont,
                  textFieldType: TextFieldType.NAME,
                  nextFocus: packageDescriptionFocus,
                  errorThisFieldRequired: context.translate.hintRequired,
                  isValidationRequired: checkValidationLanguage(),
                  decoration: inputDecoration(context, hint: languages.packageName, fillColor: context.scaffoldBackgroundColor),
                ),
                24.height,
                Observer(builder: (context) {
                  return Container(
                    width: context.width(),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: context.scaffoldBackgroundColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(languages.selectService, style: secondaryTextStyle()).paddingSymmetric(horizontal: 16, vertical: 12),
                            TextButton(
                              child: Text(appStore.selectedServiceList.isNotEmpty ? context.translate.lblEdit : languages.hintAddService, style: boldTextStyle()),
                              onPressed: () async {
                                Map? res = await SelectServiceScreen(
                                  categoryId: selectedCategoryId,
                                  subCategoryId: selectedSubCategoryId,
                                  isUpdate: widget.data != null ? true : false,
                                  packageData: widget.data,
                                ).launch(context);

                                if (res != null && res["categoryId"] != null) {
                                  selectedCategoryId = res["categoryId"];

                                  if (res["subCategoryId"] != null) {
                                    selectedSubCategoryId = res["subCategoryId"];
                                  }

                                  if (res["packageType"] != null) {
                                    isPackageTypeSingleCategory = res["packageType"];
                                  }
                                }
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        if (appStore.selectedServiceList.isNotEmpty) SelectedServiceComponent()
                      ],
                    ),
                  );
                }),
                24.height,
                AppTextField(
                  controller: packageDescriptionCont,
                  textFieldType: TextFieldType.MULTILINE,
                  focus: packageDescriptionFocus,
                  nextFocus: packagePriceFocus,
                  minLines: 3,
                  maxLines: 5,
                  enableChatGPT: appConfigurationStore.chatGPTStatus,
                  promptFieldInputDecorationChatGPT: inputDecoration(context).copyWith(
                    hintText: languages.writeHere,
                    fillColor: context.scaffoldBackgroundColor,
                    filled: true,
                  ),
                  testWithoutKeyChatGPT: appConfigurationStore.testWithoutKey == 1 ? true : false,
                  loaderWidgetForChatGPT: const ChatGPTLoadingWidget(),
                  errorThisFieldRequired: context.translate.hintRequired,
                  isValidationRequired: checkValidationLanguage(),
                  decoration: inputDecoration(context, hint: languages.packageDescription, fillColor: context.scaffoldBackgroundColor),
                  validator: (value) {
                    if (value!.isEmpty) return context.translate.hintRequired;
                    return null;
                  },
                ),
                24.height,
                Row(
                  children: [
                    AppTextField(
                      controller: packagePriceCont,
                      textFieldType: TextFieldType.NUMBER,
                      focus: packagePriceFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.packagePrice,
                        fillColor: context.scaffoldBackgroundColor,
                        prefix: Text(appConfigurationStore.currencySymbol, style: primaryTextStyle(size: LABEL_TEXT_SIZE), textAlign: TextAlign.center),
                      ),
                      validator: (s) {
                        if (s!.isEmpty) return errorThisFieldRequired;

                        if (s.toDouble() <= 0) return languages.priceAmountValidationMessage;
                        return null;
                      },
                    ).expand(),
                    16.width,

                    ///StaticDataModel logic : changes in active/ inactive status
                    DropdownButtonFormField<StaticDataModel>(
                      dropdownColor: context.scaffoldBackgroundColor,
                      value: packageStatusModel != null ? packageStatusModel : statusListStaticData.first,
                      items: statusListStaticData.map((StaticDataModel data) {
                        return DropdownMenuItem<StaticDataModel>(
                          value: data,
                          child: Text(data.value.validate(), style: primaryTextStyle()),
                        );
                      }).toList(),
                      decoration: inputDecoration(
                        context,
                        fillColor: context.scaffoldBackgroundColor,
                        hint: context.translate.lblStatus,
                      ),
                      onTap: () {
                        hideKeyboard(context);
                      },
                      onChanged: (StaticDataModel? value) async {
                        packageStatus = value!.key.validate();
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null) return errorThisFieldRequired;
                        return null;
                      },
                    ).expand(),
                  ],
                ),
                24.height,
                Row(
                  children: [
                    AppTextField(
                      controller: startDateCont,
                      textFieldType: TextFieldType.OTHER,
                      focus: startDateFocus,
                      decoration: inputDecoration(context, hint: languages.startDate, fillColor: context.scaffoldBackgroundColor),
                      isValidationRequired: false,
                      onTap: () {
                        hideKeyboard(context);
                        selectDateAndTime(context, startDateCont, currentDateTime);
                        endDateCont.text = "";
                        setState(() {});
                      },
                    ).expand(),
                    16.width,
                    AppTextField(
                      controller: endDateCont,
                      textFieldType: TextFieldType.OTHER,
                      focus: endDateFocus,
                      decoration: inputDecoration(context, hint: languages.endDate, fillColor: context.scaffoldBackgroundColor),
                      isValidationRequired: false,
                      onTap: () {
                        hideKeyboard(context);
                        selectDateAndTime(context, endDateCont, selectedDate);
                      },
                    ).expand(),
                  ],
                ),
                24.height,
                Container(
                  decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: radius()),
                  padding: EdgeInsets.only(left: 16, right: 4),
                  child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor: appStore.isDarkMode ? context.dividerColor : context.iconColor,
                      ),
                      child: CheckboxListTile(
                        checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                        autofocus: false,
                        activeColor: context.primaryColor,
                        checkColor: appStore.isDarkMode ? context.iconColor : context.cardColor,
                        value: isFeature,
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
                        title: Text(languages.hintSetAsFeature, style: secondaryTextStyle()),
                        onChanged: (bool? v) {
                          isFeature = v.validate();
                          setState(() {});
                        },
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // endregion

  // region Action
  Future checkValidation({required bool isSave, LanguageDataModel? code}) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      selectedService.clear();

      if (appStore.selectedServiceList.isNotEmpty) {
        appStore.selectedServiceList.forEach((element) {
          selectedService.add(element.id.validate());
        });
      }

      String serviceId = selectedService.join(',');
      if (imageFiles.isEmpty) {
        return toast(languages.pleaseSelectImages);
      } else if (serviceId.isEmpty) {
        return toast(languages.pleaseSelectService);
      }

      if (startDateCont.text.validate().isNotEmpty && endDateCont.text.validate().isEmpty) {
        return toast(languages.pleaseEnterTheEndDate);
      }
      
      updateTranslation();

       if (!isSave) {
        appStore.setSelectedLanguage(code!);
        disposeAllTextFieldsController();
        getTranslation();
        await checkValidationLanguage();
        setState(() => formWidgetKey = UniqueKey());
      } else {
        await removeEnTranslations();
       final req = _buildPackageRequest(serviceId: serviceId);
        await _submitPackage(req);
      }
    }
  }
  // endregion
  
  //region remove en translations
   removeEnTranslations() {
    if (translations.containsKey(DEFAULT_LANGUAGE)) {
      translations.remove(DEFAULT_LANGUAGE);
    }
  }
//endregion

    //region Package Request
   Map<String, dynamic> _buildPackageRequest({required String serviceId}) {
    final req = {
        PackageKey.packageId: widget.data != null
            ? widget.data!.id.validate() != 0
                ? widget.data!.id.validate()
                : null
            : null,
        PackageKey.name: enTranslations.name.validate(),
        PackageKey.description: enTranslations.description.validate(),
        PackageKey.price: packagePriceCont.text.validate(),
        PackageKey.startDate: startDateCont.text.validate(),
        PackageKey.endDate: endDateCont.text.validate(),
        if (selectedCategoryId != -1) PackageKey.categoryId: selectedCategoryId,
        if (selectedSubCategoryId != -1) PackageKey.subCategoryId: selectedSubCategoryId,
        PackageKey.isFeatured: isFeature ? '1' : '0',
        PackageKey.status: packageStatus.validate() == ACTIVE ? '1' : '0',
        PackageKey.serviceId: serviceId,
        PackageKey.packageType: isPackageTypeSingleCategory,
    };

    if (translations.isNotEmpty) {
      req.putIfAbsent(
          AddServiceKey.translations, () => jsonEncode(translations));
    }

    return req;
  }
  // endregion
  

//region submit Package API call
Future<void> _submitPackage(Map<String, dynamic> req) async {
    try {
      await addPackageMultiPart(value: req, imageFile: imageFiles.where((element) => !element.path.contains('http')).toList()).then((value) {
        //
      }).catchError((e) {
        toast(e.toString());
      });
    } catch (e) {
      toast(e.toString());
    }
  }
 // endregion


 
//region Update Translation
  void updateTranslation() {
    appStore.setLoading(true);
    final languageCode = appStore.selectedLanguage.languageCode.validate();
    if (packageNameCont.text.isEmpty && packageDescriptionCont.text.isEmpty) {
      translations.remove(languageCode);
    }
    else {
      if (languageCode != DEFAULT_LANGUAGE) {
        translations[languageCode] = translations[languageCode]?.copyWith(
          name: packageNameCont.text.validate(),
          description: packageDescriptionCont.text.validate(),
        ) ??
            MultiLanguageRequest(
              name: packageNameCont.text.validate(),
              description: packageDescriptionCont.text.validate(),
            );
      } else {
        enTranslations = enTranslations.copyWith(
          name: packageNameCont.text.validate(),
          description: packageDescriptionCont.text.validate(),
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
      packageNameCont.text = enTranslations.name.validate();
      packageDescriptionCont.text = enTranslations.description.validate();
    } else {
      final translation = translations[languageCode] ?? MultiLanguageRequest();
      packageNameCont.text = translation.name.validate();
      packageDescriptionCont.text = translation.description.validate();
    }
    setState(() {});
  }

//endregion

//region Dispose All TextControllers
  void disposeAllTextFieldsController() {
    packageNameCont.clear();
    packageDescriptionCont.clear();
    setState(() {});
  }

//endregion

//get region language wise validation
  bool checkValidationLanguage() {
    log("langauge Code ==> ${appStore.selectedLanguage.languageCode}");
    if (appStore.selectedLanguage.languageCode == DEFAULT_LANGUAGE) {
      return true;
    } else {
      return false;
    }
  }

//endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? languages.editPackage : languages.addPackage,
        textColor: white,
        color: context.primaryColor,
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  8.height,
               MultiLanguageWidget(onTap: (LanguageDataModel code) {
                checkValidation(isSave: false, code: code);
             }),
               8.height,
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 16, left: 16.0, right: 16.0, bottom: 25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomImagePicker(
                      key: uniqueKey,
                      onRemoveClick: (value) {
                        if (tempAttachments.validate().isNotEmpty && imageFiles.isNotEmpty) {
                          showConfirmDialogCustom(
                            context,
                            dialogType: DialogType.DELETE,
                            positiveText: languages.lblDelete,
                            negativeText: languages.lblCancel,
                            onAccept: (p0) {
                              imageFiles.removeWhere((element) => element.path == value);
                              if (value.startsWith('http')) {
                                removeAttachment(id: tempAttachments.validate().firstWhere((element) => element.url == value).id.validate());
                              }
                            },
                          );
                        } else {
                          showConfirmDialogCustom(
                            context,
                            dialogType: DialogType.DELETE,
                            positiveText: languages.lblDelete,
                            negativeText: languages.lblCancel,
                            onAccept: (p0) {
                              imageFiles.removeWhere((element) => element.path == value);
                              if (isUpdate) {
                                uniqueKey = UniqueKey();
                              }
                              setState(() {});
                            },
                          );
                        }
                      },
                      selectedImages: widget.data != null ? imageFiles.validate().map((e) => e.path.validate()).toList() : null,
                      onFileSelected: (List<File> files) async {
                        imageFiles = files;
                        setState(() {});
                      },
                    ),
                    8.height,
                    buildFormWidget(),
                    Observer(
                        builder: (context) => AppButton(
                              text: context.translate.btnSave,
                              height: 40,
                              color: context.primaryColor,
                              textStyle: boldTextStyle(color: white),
                              width: context.width() - context.navigationBarHeight,
                              onTap: appStore.isLoading
                                  ? null
                                  : () {
                                      ifNotTester(context, () {
                                        checkValidation(isSave: true);
                                      });
                                    },
                            ))
                  ],
                ),
              ).expand(),
            ],
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
