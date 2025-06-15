import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/bank_list_response.dart';
import '../../models/base_response.dart';
import '../../models/static_data_model.dart';
import '../../utils/model_keys.dart';

class AddBankScreen extends StatefulWidget {
  final BankHistory? data;

  const AddBankScreen({super.key, this.data});

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController bankNameCont = TextEditingController();
  TextEditingController branchNameCont = TextEditingController();
  TextEditingController accNumberCont = TextEditingController();
  TextEditingController ifscCodeCont = TextEditingController();
  TextEditingController contactNumberCont = TextEditingController();
  TextEditingController aadharCardNumberCont = TextEditingController();
  TextEditingController panNumberCont = TextEditingController();

  FocusNode bankNameFocus = FocusNode();
  FocusNode branchNameFocus = FocusNode();
  FocusNode accNumberFocus = FocusNode();
  FocusNode ifscCodeFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode aadharCardNumberFocus = FocusNode();
  FocusNode panNumberFocus = FocusNode();

  Future<void> update() async {
    MultipartRequest multiPartRequest = await getMultiPartRequest('save-bank');
    multiPartRequest.fields[UserKeys.id] = isUpdate ? widget.data!.id.toString() : "";
    multiPartRequest.fields[UserKeys.providerId] = appStore.userId.toString();
    multiPartRequest.fields[BankServiceKey.bankName] = bankNameCont.text;
    multiPartRequest.fields[BankServiceKey.branchName] = branchNameCont.text;
    multiPartRequest.fields[BankServiceKey.accountNo] = accNumberCont.text;
    multiPartRequest.fields[BankServiceKey.ifscNo] = ifscCodeCont.text;
    multiPartRequest.fields[BankServiceKey.mobileNo] = contactNumberCont.text;
    multiPartRequest.fields[BankServiceKey.aadharNo] = aadharCardNumberCont.text;
    multiPartRequest.fields[BankServiceKey.panNo] = panNumberCont.text;
    multiPartRequest.fields[BankServiceKey.bankAttachment] = '';
    multiPartRequest.fields[UserKeys.status] = getStatusValue().toString();
    multiPartRequest.fields[UserKeys.isDefault] = widget.data?.isDefault.toString() ?? "0";

    multiPartRequest.headers.addAll(buildHeaderTokens());

    appStore.setLoading(true);

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        if (data != null) {
          print(data);
          if ((data as String).isJson()) {
            BaseResponseModel res = BaseResponseModel.fromJson(jsonDecode(data));
            finish(context, [true, bankNameCont.text]);
            if (res.status ?? false) {}
            snackBar(context, title: res.message!);
          }
        }
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

  String bankStatus = 'ACTIVE';
  int getStatusValue() {
    if (bankStatus == 'ACTIVE') {
      return 1;
    } else {
      return 0;
    }
  }

  bool isUpdate = true;

  List<StaticDataModel> statusListStaticData = [
    StaticDataModel(key: ACTIVE, value: languages.active),
    StaticDataModel(key: INACTIVE, value: languages.inactive),
  ];
  StaticDataModel? blogStatusModel;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      bankNameCont.text = widget.data!.bankName.validate();
      branchNameCont.text = widget.data!.branchName.validate();
      accNumberCont.text = widget.data!.accountNo.validate();
      ifscCodeCont.text = widget.data!.ifscNo.validate();
      contactNumberCont.text = widget.data!.mobileNo.validate();
      aadharCardNumberCont.text = widget.data!.aadharNo.validate();
      panNumberCont.text = widget.data!.panNo.validate();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.addBank,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              return await update();
            },
            child: Form(
              key: formKey,
              child: AnimatedScrollView(
                padding: EdgeInsets.all(16),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: bankNameCont,
                    focus: bankNameFocus,
                    nextFocus: branchNameFocus,
                    decoration: inputDecoration(context, hint: languages.bankName),
                    suffix: ic_piggy_bank.iconImage(size: 10).paddingAll(14),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: branchNameCont,
                    focus: branchNameFocus,
                    nextFocus: accNumberFocus,
                    decoration: inputDecoration(context, hint: languages.fullNameOnBankAccount),
                    suffix: ic_piggy_bank.iconImage(size: 10).paddingAll(14),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: accNumberCont,
                    focus: accNumberFocus,
                    nextFocus: ifscCodeFocus,
                    decoration: inputDecoration(context, hint: languages.accountNumber, counter: false),
                    suffix: ic_password.iconImage(size: 10, fit: BoxFit.contain).paddingAll(14),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: ifscCodeCont,
                    focus: ifscCodeFocus,
                    nextFocus: contactNumberFocus,
                    decoration: inputDecoration(context, hint: languages.iFSCCode, counter: false),
                    suffix: profile.iconImage(size: 10).paddingAll(14),
                    isValidationRequired: false,
                  ),
                  16.height,
                  DropdownButtonFormField<StaticDataModel>(
                    isExpanded: true,
                    dropdownColor: context.cardColor,
                    value: blogStatusModel != null ? blogStatusModel : statusListStaticData.first,
                    items: statusListStaticData.map((StaticDataModel data) {
                      return DropdownMenuItem<StaticDataModel>(
                        value: data,
                        child: Text(data.value.validate(), style: primaryTextStyle()),
                      );
                    }).toList(),
                    decoration: inputDecoration(context, hint: languages.lblStatus),
                    onChanged: (StaticDataModel? value) async {
                      bankStatus = value!.key.validate();
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null) return errorThisFieldRequired;
                      return null;
                    },
                  ),
                  100.height,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: AppButton(
              text: languages.btnSave,
              color: primaryColor,
              textStyle: boldTextStyle(color: white),
              width: context.width(),
              onTap: () {
                if (formKey.currentState!.validate()) {
                  hideKeyboard(context);
                  update();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
