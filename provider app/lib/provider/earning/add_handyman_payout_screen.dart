import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../main.dart';
import '../../utils/common.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';
import 'handyman_earning_repository.dart';
import 'model/earning_list_model.dart';

class AddHandymanPayoutScreen extends StatefulWidget {
  final EarningListModel earningModel;

  const AddHandymanPayoutScreen({Key? key, required this.earningModel}) : super(key: key);

  @override
  State<AddHandymanPayoutScreen> createState() => _AddHandymanPayoutScreenState();
}

class _AddHandymanPayoutScreenState extends State<AddHandymanPayoutScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController descriptionCont = TextEditingController();
  TextEditingController earningCont = TextEditingController();

  FocusNode earningFocus = FocusNode();

  String selectedMethod = PAYMENT_METHOD_COD;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    earningCont.text = widget.earningModel.handymanDueAmount.validate().toStringAsFixed(appConfigurationStore.priceDecimalPoint);
  }

  /// Provider Payout
  Future<void> saveProviderPayout() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      Map request = {
        "id": null,
        "handyman_id": widget.earningModel.handymanId.validate(),
        "payment_method": selectedMethod,
        "description": descriptionCont.text.validate(),
        "amount": earningCont.text.trim().replaceAll(appConfigurationStore.currencySymbol, ''),
      };
      appStore.setLoading(true);
      await handymanPayout(request: request).then((value) {
        appStore.setLoading(false);
        toast(value.message);

        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.addHandymanPayout,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(
                    child: Text(languages.cash, style: primaryTextStyle()),
                    value: PAYMENT_METHOD_COD,
                  ),
                  if (getStringAsync(EARNING_TYPE) == EARNING_TYPE_COMMISSION)
                    DropdownMenuItem(
                      child: Text(languages.lblWallet, style: primaryTextStyle()),
                      value: WALLET,
                    ),
                ],
                dropdownColor: context.cardColor,
                decoration: inputDecoration(context, hint: languages.selectMethod),
                value: selectedMethod,
                validator: (value) {
                  if (value == null) return errorThisFieldRequired;
                  return null;
                },
                onChanged: (c) {
                  hideKeyboard(context);
                  selectedMethod = c.validate();
                },
              ),
              24.height,
              AppTextField(
                textFieldType: TextFieldType.MULTILINE,
                controller: descriptionCont,
                nextFocus: earningFocus,
                errorThisFieldRequired: languages.hintRequired,
                decoration: inputDecoration(context, hint: languages.hintDescription),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NUMBER,
                controller: earningCont,
                readOnly: true,
                focus: earningFocus,
                errorThisFieldRequired: languages.hintRequired,
                decoration: inputDecoration(context, hint: languages.handymanEarning),
              ),
              20.height,
              AppButton(
                text: languages.btnSave,
                color: primaryColor,
                width: context.width(),
                onTap: () {
                  saveProviderPayout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
