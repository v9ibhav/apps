import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';
import '../components/base_scaffold_widget.dart';
import '../main.dart';
import '../models/multi_language_request_model.dart';
import '../models/user_type_response.dart';
import '../networks/rest_apis.dart';
import '../utils/configs.dart';
import '../utils/constant.dart';
import '../utils/model_keys.dart';

class AddHandymanCommissionTypeListScreen extends StatefulWidget {
  final UserTypeData? typeData;
  final Function? onUpdate;

  AddHandymanCommissionTypeListScreen({this.typeData, this.onUpdate});

  @override
  AddHandymanCommissionTypeListScreenState createState() => AddHandymanCommissionTypeListScreenState();
}

class AddHandymanCommissionTypeListScreenState extends State<AddHandymanCommissionTypeListScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCont = TextEditingController();
  TextEditingController commissionCont = TextEditingController();
  TextEditingController typeCont = TextEditingController();
  
  UniqueKey formWidgetKey = UniqueKey();

  FocusNode nameFocus = FocusNode();
  FocusNode commissionFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode statusFocus = FocusNode();

  String selectedType = SERVICE_TYPE_FIXED;
  String selectedStatusType = ACTIVE;

  
  Map<String, MultiLanguageRequest> translations = {};
  MultiLanguageRequest enTranslations = MultiLanguageRequest();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.typeData != null) {
      nameCont.text = widget.typeData!.name.validate();
      commissionCont.text = widget.typeData!.commission.validate().toString();
      if (widget.typeData!.type.validate() == COMMISSION_TYPE_PERCENTAGE || widget.typeData!.type.validate() == COMMISSION_TYPE_PERCENT) {
        selectedType = COMMISSION_TYPE_PERCENTAGE;
      } else {
        selectedType = widget.typeData!.type.validate();
      }
      selectedStatusType = widget.typeData!.status.validate() == 1 ? ACTIVE : INACTIVE;
      setState(() {});
      if (widget.typeData!.translations!.isNotEmpty) {
        translations = widget.typeData!.translations!;
      }

      enTranslations.copyWith(
          name: widget.typeData?.name.validate() ?? "",
        );
    }
    appStore.setSelectedLanguage(languageList().first);
  }

  // Add Provider & Handyman Type List
  Future<void> addProviderHandymanTypeList({required bool isSave, LanguageDataModel? code}) async {
    
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      updateTranslation();

     final req = _buildCommissionRequest();

      if (!isSave) {
        appStore.setSelectedLanguage(code!);
        disposeAllTextFieldsController();
        getTranslation();
        await checkValidationLanguage();
        setState(() => formWidgetKey = UniqueKey());
      } else {
        await _submitCommission(req);
      }
     
    }
  }
//endregion


// region submitCommission API Call
 Future<void> _submitCommission(Map<String, dynamic> req) async {
    try {
      await saveProviderHandymanTypeList(request: req).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    } catch (e) {
      toast(e.toString());
    }
  }
//endregion


//region Commission Request 
 Map<String, dynamic> _buildCommissionRequest() {
    final req = {
       CommissionKey.id: widget.typeData != null ? widget.typeData!.id : null,
        CommissionKey.name:enTranslations.name.validate(),
        CommissionKey.commission: commissionCont.text.validate(),
        CommissionKey.type: selectedType,
        CommissionKey.status: selectedStatusType == ACTIVE ? 1 : 0,
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
    if (nameCont.text.isEmpty) {
      translations.remove(languageCode);
    }
    else {
      if (languageCode != DEFAULT_LANGUAGE) {
        translations[languageCode] = translations[languageCode]?.copyWith(
          name: nameCont.text.validate(),
        ) ??
            MultiLanguageRequest(
              name: nameCont.text.validate(),
            );
      } else {
        enTranslations = enTranslations.copyWith(
          name: nameCont.text.validate(),
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
      nameCont.text = enTranslations.name.validate();
    } else {
      final translation = translations[languageCode] ?? MultiLanguageRequest();
      nameCont.text = translation.name.validate();
    }
    setState(() {});
  }
//endregion

//region Dispose All TextControllers
  void disposeAllTextFieldsController() {
    nameCont.clear();
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


  String title() {
      return widget.typeData == null ? languages.addHandymanCommission : languages.editHandymanCommission;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: title(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.height,
          MultiLanguageWidget(onTap: (LanguageDataModel code) {
            addProviderHandymanTypeList(isSave: false, code: code);
          }),
          8.height,
          SingleChildScrollView(
            key: formWidgetKey,
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: nameCont,
                    focus: nameFocus,
                    nextFocus: commissionFocus,
                    errorThisFieldRequired: languages.hintRequired,
                    isValidationRequired: checkValidationLanguage(),
                    decoration:
                        inputDecoration(context, hint: languages.typeName),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    controller: commissionCont,
                    focus: commissionFocus,
                    nextFocus: typeFocus,
                    decoration:
                        inputDecoration(context, hint: languages.commission),
                    keyboardType: TextInputType.number,
                    validator: (s) {
                      if (s!.isEmptyOrNull) {
                        return languages.hintRequired;
                      } else {
                        RegExp reg = RegExp(r'^\d.?\d(,\d*)?$');

                        if (!reg.hasMatch(s)) {
                          return languages.enterValidCommissionValue;
                        }
                      }

                      return null;
                    },
                  ),
                  16.height,
                  DropdownButtonFormField<String>(
                    items: [
                      DropdownMenuItem(
                        child:
                            Text(languages.lblFixed, style: primaryTextStyle()),
                        value: SERVICE_TYPE_FIXED,
                      ),
                      DropdownMenuItem(
                        child: Text(languages.percentage,
                            style: primaryTextStyle()),
                        value: COMMISSION_TYPE_PERCENTAGE,
                      ),
                    ],
                    focusNode: typeFocus,
                    dropdownColor: context.cardColor,
                    decoration:
                        inputDecoration(context, hint: languages.lblType),
                    value: selectedType,
                    validator: (value) {
                      if (value == null) return errorThisFieldRequired;
                      return null;
                    },
                    onChanged: (c) {
                      hideKeyboard(context);
                      selectedType = c.validate();
                    },
                  ),
                  16.height,
                  DropdownButtonFormField<String>(
                    items: [
                      DropdownMenuItem(
                        child:
                            Text(languages.active, style: primaryTextStyle()),
                        value: ACTIVE,
                      ),
                      DropdownMenuItem(
                        child:
                            Text(languages.inactive, style: primaryTextStyle()),
                        value: INACTIVE,
                      ),
                    ],
                    focusNode: statusFocus,
                    dropdownColor: context.cardColor,
                    decoration:
                        inputDecoration(context, hint: languages.selectStatus),
                    value: selectedStatusType,
                    validator: (value) {
                      if (value == null) return errorThisFieldRequired;
                      return null;
                    },
                    onChanged: (c) {
                      hideKeyboard(context);
                      selectedStatusType = c.validate();
                    },
                  ),
                  24.height,
                  AppButton(
                    text: languages.btnSave,
                    color: primaryColor,
                    width: context.width(),
                    onTap: () {
                      if (widget.typeData == null ||
                          widget.typeData!.deletedAt == null) {
                        ifNotTester(context, () {
                          addProviderHandymanTypeList(isSave: true);
                        });
                      } else {
                        toast(languages.youCanTUpdateDeleted);
                      }
                    },
                  ),
                ],
              ),
            ),
          ).expand(),
        ],
      ),
    );
  }
}

