import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_widgets.dart';
import '../../../components/base_scaffold_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../models/booking_detail_response.dart';
import '../../../models/multi_language_request_model.dart';
import '../../../models/service_model.dart';
import '../../../models/static_data_model.dart';
import '../../../networks/rest_apis.dart';
import '../../../utils/common.dart';
import '../../../utils/configs.dart';
import '../../../utils/constant.dart';
import '../../../utils/images.dart';
import '../../../utils/model_keys.dart';
import 'component/select_addon_service_component.dart';

class AddAddonServiceScreen extends StatefulWidget {
  final ServiceAddon? addonServiceData;

  AddAddonServiceScreen({this.addonServiceData});

  @override
  _AddAddonServiceScreenState createState() => _AddAddonServiceScreenState();
}

class _AddAddonServiceScreenState extends State<AddAddonServiceScreen> {
//-------------------------------- Variables -------------------------------//
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey formWidgetKey = UniqueKey();

  /// TextEditing controlle
  TextEditingController addonNameCont = TextEditingController();
  TextEditingController addonPriceCont = TextEditingController();

  /// FocusNodes
  FocusNode addonPriceFocus = FocusNode();

  List<StaticDataModel> statusListStaticData = [
    StaticDataModel(key: ACTIVE, value: languages.active),
    StaticDataModel(key: INACTIVE, value: languages.inactive),
  ];

  StaticDataModel? addonStatusModel;
  File? imageFile;
  XFile? pickedFile;
  String addonStatus = ACTIVE;
  bool isUpdate = false;
  ServiceData? selectedService;
  List<ServiceData> serviceList = [];
  int? serviceId;
  int page = 1;

  Map<String, MultiLanguageRequest> translations = {};
  MultiLanguageRequest enTranslations = MultiLanguageRequest();

  @override
  void initState() {
    super.initState();
    init();
    appStore.setSelectedLanguage(languageList().first);
  }

  @override
  void dispose() {
    super.dispose();
    addonNameCont.dispose();
    addonPriceCont.dispose();
    addonPriceFocus.dispose();
  }

  void init() async {
    isUpdate = widget.addonServiceData != null;

    if (isUpdate) {
      appStore.selectedServiceData = ServiceData();
      addonNameCont.text = widget.addonServiceData?.translations?[DEFAULT_LANGUAGE]?.name.validate().trim() ?? "";
      addonPriceCont.text = widget.addonServiceData!.price.toString().validate();
      addonStatus = widget.addonServiceData!.status.validate() == 1 ? ACTIVE : INACTIVE;
      serviceId = widget.addonServiceData!.serviceId.validate();
      appStore.selectedServiceData.name = widget.addonServiceData!.serviceName.validate();

      if (widget.addonServiceData != null) {
        imageFile = File(widget.addonServiceData!.serviceAddonImage.validate());
      }

      if (addonStatus == ACTIVE) {
        addonStatusModel = statusListStaticData.first;
      } else {
        addonStatusModel = statusListStaticData[1];
      }
      if (widget.addonServiceData?.translations?.isNotEmpty ?? false) {
      translations = await widget.addonServiceData!.translations!;
      enTranslations = await translations[DEFAULT_LANGUAGE]!;
      }
    } else {
      appStore.selectedServiceList.clear();
      appStore.selectedServiceData = ServiceData();
      addonStatus = statusListStaticData.first.key!;
    }
    setState(() {});
  }

  void _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      setState(() {});
    }
  }

  void _getFromCamera() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      setState(() {});
    }
  }

  //----------------------------------- UI -----------------------------------/
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: isUpdate ? languages.editAddonService : languages.addAddonService,
      body: Stack(
        children: [
           Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.height,
          MultiLanguageWidget(onTap: (LanguageDataModel code) {
            checkValidation(isSave: false,code: code);
          }),
          8.height,
              SingleChildScrollView(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
                child: Column(
                  children: [
                    (imageFile != null && imageFile!.path.isNotEmpty)
                        ? Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: LoaderWidget(),
                                ).visible(imageFile!.path.isNotEmpty),
                                CachedImageWidget(
                                  url: imageFile!.path,
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(defaultRadius),
                                Positioned(
                                  top: 110 * 3 / 4 + 4,
                                  left: 110 * 3 / 4 + 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      hideKeyboard(context);
                                      _showBottomSheet(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: boxDecorationDefault(shape: BoxShape.circle, color: primaryColor),
                                        child: const Icon(Icons.edit, size: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ).paddingBottom(16),
                          )
                        : Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  hideKeyboard(context);
                                  _showBottomSheet(context);
                                },
                                child: DottedBorderWidget(
                                  color: context.primaryColor,
                                  radius: defaultRadius,
                                  child: Container(
                                    padding: EdgeInsets.all(26),
                                    alignment: Alignment.center,
                                    decoration: boxDecorationWithShadow(blurRadius: 0, backgroundColor: context.cardColor, borderRadius: radius()),
                                    child: Column(
                                      children: [
                                        ic_no_photo.iconImage(size: 46),
                                        8.height,
                                        Text(languages.chooseImage, style: secondaryTextStyle()),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              16.height,
                              Text(languages.noteYouCanUpload, style: secondaryTextStyle(size: 10)),
                            ],
                          ),
                    16.height,
                    buildFormWidget(),
                    50.height,
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
                                  if ((imageFile != null && imageFile!.path.isNotEmpty)) {
                                    checkValidation(isSave: true);
                                  } else {
                                    toast(languages.pleaseSelectImages);
                                    hideKeyboard(context);
                                    _showBottomSheet(context);
                                  }
                                });
                              },
                      ),
                    ),
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

  void _showBottomSheet(BuildContext context) {
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
                _getFromGallery();
                finish(context);
              },
            ),
            SettingItemWidget(
              title: languages.camera,
              leading: Icon(Icons.camera, color: context.iconColor),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  // region Form Widget
  Widget buildFormWidget() {
    return Container(
      key: formWidgetKey,
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Wrap(
        runSpacing: 16,
        children: [
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                8.height,
                AppTextField(
                  controller: addonNameCont,
                  textFieldType: TextFieldType.NAME,
                  nextFocus: addonPriceFocus,
                  errorThisFieldRequired: context.translate.hintRequired,
                  isValidationRequired: checkValidationLanguage(),
                  decoration: inputDecoration(context, hint: languages.addonServiceName, fillColor: context.scaffoldBackgroundColor),
                ),
                24.height,
                Observer(builder: (context) {
                  return Container(
                    width: context.width(),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: context.scaffoldBackgroundColor),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Marquee(
                              child: Text(
                                appStore.selectedServiceData.name.validate().isNotEmpty ? appStore.selectedServiceData.name.validate() : languages.selectService,
                                style: appStore.selectedServiceData.name.validate().isNotEmpty ? primaryTextStyle() : secondaryTextStyle(),
                              ).paddingSymmetric(horizontal: 16, vertical: 12),
                            ).expand(),
                            TextButton(
                              child: Text(appStore.selectedServiceData.name != null ? context.translate.lblEdit : languages.hintAddService, style: boldTextStyle()),
                              onPressed: () async {
                                serviceId = await SelectAddonServiceComponent(
                                  serviceAddonData: widget.addonServiceData,
                                  selectedServiceId: appStore.selectedServiceData.id,
                                  isUpdate: widget.addonServiceData != null ? true : false,
                                ).launch(context);
                                if (serviceId == null && isUpdate) {
                                  serviceId = widget.addonServiceData!.serviceId.validate();
                                }
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                24.height,
                AppTextField(
                  controller: addonPriceCont,
                  textFieldType: TextFieldType.NUMBER,
                  focus: addonPriceFocus,
                  decoration: inputDecoration(
                    context,
                    hint: languages.lblPrice,
                    fillColor: context.scaffoldBackgroundColor,
                    prefix: Text(appConfigurationStore.currencySymbol, style: primaryTextStyle(size: LABEL_TEXT_SIZE), textAlign: TextAlign.center),
                  ),
                  validator: (s) {
                    if (s!.isEmpty) return errorThisFieldRequired;

                    if (s.toDouble() <= 0) return languages.priceAmountValidationMessage;
                    return null;
                  },
                ),
                24.height,

                ///StaticDataModel logic : changes in active/ inactive status
                DropdownButtonFormField<StaticDataModel>(
                  dropdownColor: context.scaffoldBackgroundColor,
                  value: addonStatusModel != null ? addonStatusModel : statusListStaticData.first,
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
                    addonStatus = value!.key.validate();
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null) return errorThisFieldRequired;
                    return null;
                  },
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
    if (serviceId != null && serviceId != -1) {
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
         await removeEnTranslations();
       final req = _buildAddOnServiceRequest();
        await _submitAddOnService(req);
      }
        
      }
      } else {
      toast(languages.pleaseSelectAService);
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


  // region AddOn Service API Call
 Future<void> _submitAddOnService(Map<String, dynamic> req) async {
    try {
      await addAddonMultiPart(value: req, imageFile: (!imageFile!.path.contains('http') && imageFile!.path.isNotEmpty) ? imageFile : null).then((value) {
          //
        }).catchError((e) {
          log('Error:  $e');
          toast(e.toString());
        });
    } catch (e) {
      toast(e.toString());
    }
  }
//endregion

//region addon service Request 
 Map<String, dynamic> _buildAddOnServiceRequest() {
    final req = {
       AddonServiceKey.addonId: widget.addonServiceData != null
              ? widget.addonServiceData!.id.validate() != 0
                  ? widget.addonServiceData!.id.validate()
                  : null
              : null,
          AddonServiceKey.name: enTranslations.name.validate(),
          AddonServiceKey.price: addonPriceCont.text.validate(),
          AddonServiceKey.status: addonStatus.validate() == ACTIVE ? '1' : '0',
          if (serviceId != null && serviceId != -1) AddonServiceKey.serviceId: serviceId.validate(),
    };

    if (translations.isNotEmpty) {
      req.putIfAbsent(
          AddServiceKey.translations, () => jsonEncode(translations));
    }
    log("Service Add Request: $req");
    return req;
 }
//endregion


//region Update Translation
  void updateTranslation() {
    appStore.setLoading(true);
    final languageCode = appStore.selectedLanguage.languageCode.validate();
    if (addonNameCont.text.isEmpty) {
      translations.remove(languageCode);
    }
    else {
      if (languageCode != DEFAULT_LANGUAGE) {
        translations[languageCode] = translations[languageCode]?.copyWith(
          name: addonNameCont.text.validate(),
        ) ??
            MultiLanguageRequest(
              name: addonNameCont.text.validate(),
            );
      } else {
        enTranslations = enTranslations.copyWith(
          name: addonNameCont.text.validate(),
        );
      }
    }
    appStore.setLoading(false);
    log("Updated Translations: ${jsonEncode(translations.map((key, value) => MapEntry(key, value.toJson())))}");
  }
//endregion

//region Get Translation Details
  void getTranslation() {
    final languageCode = appStore.selectedLanguage.languageCode;
    if (languageCode == DEFAULT_LANGUAGE) {
      addonNameCont.text = enTranslations.name.validate();
    } else {
      final translation = translations[languageCode] ?? MultiLanguageRequest();
      addonNameCont.text = translation.name.validate();
    }
    setState(() {});
  }
//endregion

//region Dispose All TextControllers
  void disposeAllTextFieldsController() {
    addonNameCont.clear();
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
}
  