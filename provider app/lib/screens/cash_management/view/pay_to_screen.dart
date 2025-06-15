import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_provider_flutter/components/image_border_component.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/user_bank_model.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/models/user_info_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/screens/cash_management/cash_constant.dart';
import 'package:handyman_provider_flutter/screens/cash_management/cash_repository.dart';
import 'package:handyman_provider_flutter/screens/cash_management/model/cash_filter_model.dart';
import 'package:handyman_provider_flutter/screens/cash_management/model/payment_history_model.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class PayToScreen extends StatefulWidget {
  final PaymentHistoryData paymentData;
  final num? totalNumberOfBookings;

  PayToScreen({Key? key, required this.paymentData, this.totalNumberOfBookings}) : super(key: key);

  @override
  State<PayToScreen> createState() => _PayToScreenState();
}

class _PayToScreenState extends State<PayToScreen> {
  GlobalKey<FormState> _formState = GlobalKey();
  TextEditingController referenceIdCont = TextEditingController();
  List<CashFilterModel> paymentList = getCashPaymentList();
  CashFilterModel? selectedPaymentList;

  Future<UserBankDetails>? future;
  UserBankDetails? initialData;

  Future<UserInfoResponse>? userDataFuture;
  BoxDecoration headingDecoration = BoxDecoration();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    userDataFuture = getUserDetail(appStore.providerId.validate());
  }

  void loadBankDetails() {
    future = getUserBankDetail(userId: appStore.providerId.validate());
  }

  Widget buildTotalAmountWidget() {
    return SettingSection(
      title: Text(languages.totalAmountToPay, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
      headerPadding: EdgeInsets.only(top: 24, bottom: 12, left: 16, right: 16),
      headingDecoration: headingDecoration,
      divider: Offstage(),
      items: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: boxDecorationDefault(color: context.cardColor),
          child: Row(
            children: [
              PriceWidget(price: widget.paymentData.totalAmount.validate(), size: 16),
              8.width,
              if (widget.totalNumberOfBookings != null) Text('${languages.from} ${widget.totalNumberOfBookings} ${languages.booking}', style: secondaryTextStyle()),
            ],
          ),
        )
      ],
    );
  }

  Widget buildPaymentWidget() {
    return SettingSection(
      title: Text(languages.choosePaymentMethod, style: boldTextStyle()),
      headingDecoration: headingDecoration,
      headerPadding: EdgeInsets.only(top: 24, bottom: 8, left: 16, right: 16),
      divider: Offstage(),
      items: [
        Wrap(
          children: List.generate(
            paymentList.length,
            (index) {
              CashFilterModel data = paymentList[index];

              return RadioListTile<CashFilterModel>(
                value: data,
                tileColor: data == selectedPaymentList ? context.cardColor : null,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(data.name.validate(), style: primaryTextStyle()),
                groupValue: selectedPaymentList,
                onChanged: (value) {
                  selectedPaymentList = value;
                  if (selectedPaymentList!.type == BANK) {
                    loadBankDetails();
                  }
                  setState(() {});
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildBankAndReferenceWidget() {
    if (selectedPaymentList != null && selectedPaymentList!.type == BANK) {
      return FutureBuilder<UserBankDetails>(
        initialData: initialData,
        future: future,
        builder: (context, snap) {
          if (snap.hasData) {
            if (initialData == null) {
              initialData = snap.data;
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SettingSection(
              headerPadding: EdgeInsets.only(left: 0, right: 0, bottom: 12, top: 8),
              title: Text(languages.detailsOfTheBank, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
              subTitle: Text(
                languages.selectABankTransferMoneyAndEnterTheReferenceIDInTheTextFieldBelow,
                style: secondaryTextStyle(),
              ).paddingBottom(8),
              headingDecoration: headingDecoration,
              divider: Offstage(),
              items: [
                if (snap.hasData)
                  if (snap.data!.bankData.validate().isEmpty)
                    NoDataWidget(
                      title: languages.noBanksAvailable,
                      subTitle: languages.chooseCashOrContactAdminForBankInformation,
                      imageWidget: ErrorStateWidget(),
                      retryText: languages.reload,
                      onRetry: () {
                        appStore.setLoading(true);
                        loadBankDetails();
                        setState(() {});
                      },
                    ).paddingTop(10)
                  else ...[
                    Form(
                      key: _formState,
                      child: AppTextField(
                        controller: referenceIdCont,
                        textFieldType: TextFieldType.NUMBER,
                        decoration: inputDecoration(context, hint: languages.refNumber, prefixIcon: ic_document.iconImage(size: 10).paddingAll(14)),
                      ),
                    ),
                    16.height,
                    ListView.builder(
                      itemCount: snap.data!.bankData.validate().length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        BankData data = snap.data!.bankData.validate()[index];
                        return Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                          decoration: boxDecorationDefault(color: context.cardColor),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(languages.bankName, style: secondaryTextStyle()).expand(),
                                  Text(data.bankName.validate(), style: boldTextStyle(), textAlign: TextAlign.end).expand(),
                                ],
                              ),
                              Divider(height: 20, color: context.dividerColor),
                              Row(
                                children: [
                                  Text(languages.accountNumber, style: secondaryTextStyle()),
                                  8.width,
                                  GestureDetector(
                                    onTap: () {
                                      data.accountNo.validate().copyToClipboard();
                                    },
                                    child: Icon(Icons.copy, size: 14),
                                  ),
                                  Text(data.accountNo.validate(), style: boldTextStyle(), textAlign: TextAlign.end).expand(),
                                ],
                              ),
                              Divider(height: 20, color: context.dividerColor),
                              Row(
                                children: [
                                  Text(languages.iFSCCode, style: secondaryTextStyle()).expand(),
                                  Text(data.ifscNo.validate(), style: boldTextStyle(), textAlign: TextAlign.end).expand(),
                                ],
                              ),
                              Divider(height: 20, color: context.dividerColor),
                              Row(
                                children: [
                                  Text(languages.bankAddress, style: secondaryTextStyle()).expand(),
                                  Text(data.branchName.validate(), style: boldTextStyle(), textAlign: TextAlign.end).expand(),
                                ],
                              ),
                              Divider(height: 20, color: context.dividerColor),
                            ],
                          ),
                        );
                      },
                    ).paddingTop(16)
                  ]
                else
                  Text(languages.pleaseWaitWhileWeLoadBankDetails, style: primaryTextStyle()).center().paddingTop(60),
              ],
            ),
          );
        },
      );
    }
    return Offstage();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: isUserTypeProvider ? languages.sendCashToAdmin : languages.sendCashToProvider,
      body: SnapHelperWidget<UserInfoResponse>(
        future: userDataFuture,
        loadingWidget: LoaderWidget(),
        onSuccess: (snap) {
          UserData data = snap.data!;
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScrollView(
                padding: EdgeInsets.only(bottom: 90),
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  CashProviderWidget(headingDecoration: headingDecoration, context: context, data: data),
                  buildTotalAmountWidget(),
                  buildPaymentWidget(),
                  buildBankAndReferenceWidget(),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: AppButton(
                  onTap: () {
                    if (selectedPaymentList == null) {
                      return toast(languages.choosePaymentMethod);
                    }
                    widget.paymentData.type = selectedPaymentList!.type;
                    widget.paymentData.senderId = appStore.userId;
                    widget.paymentData.receiverId = appStore.providerId;
                    widget.paymentData.txnId = referenceIdCont.text;
                    if (selectedPaymentList!.type == BANK) {
                      if (_formState.currentState!.validate()) {
                        _formState.currentState!.save();
                        transferAmountAPI(
                          context,
                          isFinishRequired: true,
                          paymentData: widget.paymentData,
                          status: isUserTypeProvider ? PENDING_BY_ADMIN : PENDING_BY_PROVIDER,
                          action: isUserTypeProvider ? PROVIDER_SEND_ADMIN : HANDYMAN_SEND_PROVIDER,
                        );
                      }
                    } else {
                      transferAmountAPI(
                        context,
                        isFinishRequired: true,
                        paymentData: widget.paymentData,
                        status: isUserTypeProvider ? PENDING_BY_ADMIN : PENDING_BY_PROVIDER,
                        action: isUserTypeProvider ? PROVIDER_SEND_ADMIN : HANDYMAN_SEND_PROVIDER,
                      );
                    }
                  },
                  text: (isUserTypeProvider ? languages.sendToAdmin : languages.sendToProvider),
                  color: context.primaryColor,
                ),
              ).visible(!appStore.isLoading),
            ],
          );
        },
      ),
    );
  }
}

class CashProviderWidget extends StatelessWidget {
  const CashProviderWidget({
    super.key,
    required this.headingDecoration,
    required this.context,
    required this.data,
  });

  final BoxDecoration headingDecoration;
  final BuildContext context;
  final UserData data;

  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: Text(isUserTypeProvider ? languages.admin : languages.provider, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
      headingDecoration: headingDecoration,
      divider: Offstage(),
      items: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: boxDecorationDefault(color: context.cardColor),
          child: Row(
            children: [
              ImageBorder(src: data.profileImage.validate(), height: 60),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.displayName.validate(), style: boldTextStyle(size: 12)),
                  TextIcon(
                    spacing: 6,
                    edgeInsets: EdgeInsets.fromLTRB(0, 4, 8, 8),
                    onTap: () {
                      launchMail("${data.email.validate()}");
                    },
                    prefix: Image.asset(ic_message, width: 12, height: 12, color: appStore.isDarkMode ? Colors.white : Colors.black),
                    text: data.email.validate(),
                    textStyle: secondaryTextStyle(),
                    expandedText: true,
                  ),
                  TextIcon(
                    edgeInsets: EdgeInsets.fromLTRB(0, 0, 8, 8),
                    spacing: 6,
                    onTap: () {
                      launchCall(data.contactNumber.validate());
                    },
                    prefix: Image.asset(calling, width: 12, height: 12, color: appStore.isDarkMode ? Colors.white : Colors.black),
                    text: '${data.contactNumber.validate()}',
                    textStyle: secondaryTextStyle(),
                    expandedText: true,
                  ),
                ],
              ).expand(),
            ],
          ),
        ),
      ],
    );
  }
}
