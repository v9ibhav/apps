// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/bank_details/add_bank_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_widgets.dart';
import '../../../components/price_widget.dart';
import '../../../components/success_dialog.dart';
import '../../../models/bank_list_response.dart';

class WithdrawRequest extends StatefulWidget {
  num availableBalance = 0;

  WithdrawRequest({super.key, required this.availableBalance});

  @override
  State<WithdrawRequest> createState() => _WithdrawRequestState();
}

class _WithdrawRequestState extends State<WithdrawRequest> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController chooseBank = TextEditingController();

  FocusNode amountFocus = FocusNode();
  FocusNode chooseBankFocus = FocusNode();

  Future<List<BankHistory>>? future;
  List<BankHistory> bankHistoryList = [];
  BankHistory? selectedBank;
  String? selectedWithdrawalMethod;

  List<String> withdrawalMethodList = [
    PAYMENT_METHOD_BANK,
    PAYMENT_METHOD_COD,
  ];

  int page = 1;
  bool isLastPage = false;

  bool get isWithdrawMethodIsBank => selectedWithdrawalMethod == PAYMENT_METHOD_BANK;

  @override
  void initState() {
    super.initState();
    init("");
  }

  init(String bankName) async {
    appStore.setLoading(true);
    getBankListDetail(
      page: page,
      list: bankHistoryList,
      lastPageCallback: (b) {
        isLastPage = b;
      },
      userId: appStore.userId,
    ).then((value) {
      setState(() {
        bankHistoryList = value;
      });
      bankHistoryList.forEach((value) {
        if (bankName.isNotEmpty && bankName == value.bankName) {
          setState(() {
            selectedBank = value;
          });
        } else if (value.isDefault == 1) {
          setState(() {
            selectedBank = value;
          });
        }
      });
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  Future<void> withdrawMoney() async {
    appStore.setLoading(true);
    Map request = {
      "_token": appStore.token.validate(),
      "user_id": appStore.userId,
      "payment_method": selectedWithdrawalMethod,
      "payment_gateway": isWithdrawMethodIsBank ? "razorpayx" : "",
      "bank": isWithdrawMethodIsBank ? selectedBank?.id : "",
      "amount": amount.text.toDouble(),
    };

    await walletMoneyWithdrawal(request: request).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          title: languages.successful,
          description: languages.yourWithdrawalRequestHasBeenSuccessfullySubmitted,
          buttonText: languages.done,
        ),
      );
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.withdrawRequest,
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: AnimatedScrollView(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.availableBalance, style: secondaryTextStyle(size: 12)),
                    PriceWidget(price: widget.availableBalance.validate(), color: context.primaryColor, isBoldText: true),
                  ],
                ),
                24.height,
                Text(languages.lblEnterAmount, style: primaryTextStyle(size: 12, weight: FontWeight.w600)),
                8.height,
                AppTextField(
                  textFieldType: TextFieldType.NUMBER,
                  controller: amount,
                  focus: amountFocus,
                  nextFocus: chooseBankFocus,
                  decoration: inputDecoration(context, hint: languages.eg3000),
                  isValidationRequired: true,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return errorThisFieldRequired;
                    } else if (num.parse(value.toString()) > num.parse(widget.availableBalance.toString())) {
                      return "${languages.pleaseAddLessThanOrEqualTo} ${widget.availableBalance.validate().toPriceFormat()}";
                    }
                    return null;
                  },
                ),
                16.height,
                DropdownButtonFormField<String>(
                  decoration: inputDecoration(context),
                  isExpanded: true,
                  menuMaxHeight: 300,
                  value: selectedWithdrawalMethod,
                  hint: Text(
                    languages.chooseWithdrawalMethod,
                    style: secondaryTextStyle(size: 12),
                  ),
                  icon: ic_down_arrow.iconImage(size: 16),
                  dropdownColor: context.cardColor,
                  items: withdrawalMethodList.map((String e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e.toPaymentMethodText, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (String? value) async {
                    selectedWithdrawalMethod = value;
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null) return errorThisFieldRequired;
                    return null;
                  },
                ),
                if (isWithdrawMethodIsBank) ...[
                  8.height,
                  Row(
                    children: [
                      Text(languages.chooseBank, style: primaryTextStyle(size: 12, weight: FontWeight.w600)),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          AddBankScreen().launch(context).then((value) {
                            if (value.isNotEmpty) {
                              if (value[0]) {
                                init(value[1]);
                                setState(() {});
                              }
                            }
                          });
                        },
                        child: Text(languages.addBank, style: boldTextStyle(size: 12, color: primaryColor)),
                      ),
                    ],
                  ),
                  8.height,
                  DropdownButtonFormField<BankHistory>(
                    decoration: inputDecoration(context),
                    isExpanded: true,
                    menuMaxHeight: 300,
                    value: selectedBank,
                    hint: Text(
                      languages.egCentralNationalBank,
                      style: secondaryTextStyle(size: 12),
                    ),
                    icon: ic_down_arrow.iconImage(size: 16),
                    dropdownColor: context.cardColor,
                    items: bankHistoryList.map((BankHistory e) {
                      return DropdownMenuItem<BankHistory>(
                        value: e,
                        child: Text(e.bankName.validate(), style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (BankHistory? value) async {
                      selectedBank = value;
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null) return errorThisFieldRequired;
                      return null;
                    },
                  ),
                ],
                40.height,
                AppButton(
                  text: languages.withdraw,
                  height: 40,
                  color: primaryColor,
                  textStyle: boldTextStyle(color: white),
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      hideKeyboard(context);
                      withdrawMoney();
                    }
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 16),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}