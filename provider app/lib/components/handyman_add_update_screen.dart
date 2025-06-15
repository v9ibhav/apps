import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_address_response.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/models/user_type_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../provider/earning/handyman_payout_list_screen.dart';

class HandymanAddUpdateScreen extends StatefulWidget {
  final String? userType;
  final UserData? data;
  final Function? onUpdate;

  HandymanAddUpdateScreen({this.userType, this.data, this.onUpdate});

  @override
  HandymanAddUpdateScreenState createState() => HandymanAddUpdateScreenState();
}

class HandymanAddUpdateScreenState extends State<HandymanAddUpdateScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController cPasswordCont = TextEditingController();
  TextEditingController designationCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode cPasswordFocus = FocusNode();
  FocusNode designationFocus = FocusNode();

  ValueNotifier _valueNotifier = ValueNotifier(true);

  Country selectedCountry = defaultCountry();

  List<AddressResponse> serviceAddressList = [];
  AddressResponse? selectedServiceAddress;

  List<UserTypeData> commissionList = [
    UserTypeData(name: languages.lblSelectCommission, id: -1)
  ];
  UserTypeData? selectedHandymanCommission;

  int? serviceAddressId;
  int? commissionId;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      isUpdate = true;
      fNameCont.text = widget.data!.firstName.validate();
      lNameCont.text = widget.data!.lastName.validate();
      emailCont.text = widget.data!.email.validate();
      userNameCont.text = widget.data!.username.validate();
      mobileCont.text = widget.data!.contactNumber?.split("-").last.validate() ?? "";
      serviceAddressId = widget.data!.serviceAddressId.validate();
      commissionId = widget.data!.handymanCommissionId.validate();
      designationCont.text = widget.data!.designation.validate();
      selectedCountry = Country(
        phoneCode: widget.data!.contactNumber?.split("-").first.validate() ?? "",
        countryCode: "",
        e164Sc: 0,
        geographic: true,
        level: 0,
        name: "",
        example: "",
        displayName: "",
        displayNameNoCountryCode: "",
        e164Key: "",
      );
      widget.data!.contactNumber?.split("-").first.validate();
    }

    init();
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
  }

  Future<void> init() async {
    getAddressList();
    getCommissionList();
  }

  Future<void> getAddressList() async {
    getAddresses(providerId: appStore.userId).then((value) {
      appStore.setLoading(false);
      serviceAddressList.addAll(value.addressResponse!);

      serviceAddressList.forEach((e) {
        if (e.id == serviceAddressId) {
          selectedServiceAddress = e;
        }
      });
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> getCommissionList() async {
    getCommissionType(type: USER_TYPE_HANDYMAN, providerId: appStore.userId).then((value) {
      appStore.setLoading(false);
      commissionList.addAll(value.userTypeData!);

      commissionList.forEach((e) {
        if (e.id == commissionId) {
          selectedHandymanCommission = e;
        }
      });
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      commissionList = [
        UserTypeData(name: languages.lblSelectCommission, id: -1)
      ];
      log(e.toString());
    });
  }

  // Build mobile number with phone code and number
  String buildMobileNumber() {
    return '${selectedCountry.phoneCode}-${mobileCont.text.trim()}';
  }

  /// Register the Handyman
  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      if (selectedHandymanCommission == null || selectedHandymanCommission!.id == -1) {
        return toast(languages.pleaseSelectCommission);
      }
      formKey.currentState!.save();
      hideKeyboard(context);
      String? type = widget.userType;
      var request = {
        if (isUpdate) CommonKeys.id: widget.data!.id,
        UserKeys.firstName: fNameCont.text,
        UserKeys.lastName: lNameCont.text,
        UserKeys.userName: userNameCont.text,
        UserKeys.userType: type,
        UserKeys.providerId: appStore.userId,
        UserKeys.status: USER_STATUS_CODE,
        UserKeys.contactNumber: buildMobileNumber(),
        UserKeys.designation: designationCont.text.validate(),
        if (serviceAddressId != null && serviceAddressId != -1)
          UserKeys.serviceAddressId: serviceAddressId.validate(),
        UserKeys.email: emailCont.text,
        UserKeys.handymanTypeId: selectedHandymanCommission?.id,
        if (!isUpdate) UserKeys.password: passwordCont.text
      };
      appStore.setLoading(true);
      if (isUpdate) {
        await updateProfile(request).then((res) async {
          toast(res.message.validate());
          finish(context, widget.onUpdate!.call());
        }).catchError((e) {
          toast(e.toString());
        });
      } else {
        await registerUser(request).then((res) async {
          toast(res.message.validate());
          finish(context, widget.onUpdate!.call());
        }).catchError((e) {
          toast(e.toString());
        });
      }
      appStore.setLoading(false);
    }
  }

  /// Remove the Handyman
  Future<void> removeHandyman(int? id) async {
    appStore.setLoading(true);
    await deleteHandyman(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, widget.onUpdate!.call());

      toast(languages.lblTrashHandyman, print: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore the Handyman
  Future<void> restoreHandymanData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      'type': RESTORE,
    };

    await restoreHandyman(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, widget.onUpdate!.call());
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete the Handyman
  Future<void> forceDeleteHandymanData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      'type': FORCE_DELETE,
    };

    await restoreHandyman(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, widget.onUpdate!.call());
      setState(() {});
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.cardColor,
        appBar: appBarWidget(
          isUpdate ? languages.lblUpdate : languages.lblAddHandyman,
          textColor: white,
          color: context.primaryColor,
          backWidget: BackWidget(),
          showBack: true,
          actions: [
            IconButton(
              onPressed: () {
                if (widget.data != null) {
                  HandymanPayoutListScreen(user: widget.data!).launch(context);
                }
              },
              icon: Icon(Icons.payments_outlined, size: 24, color: white),
              tooltip: languages.handymanPayoutList,
            ).visible(isUpdate),
            if (isUpdate && rolesAndPermissionStore.handymanDelete)
              PopupMenuButton(
                icon: Icon(Icons.more_vert, size: 24, color: white),
                onSelected: (selection) async {
                  if (selection == 1) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: languages.lblDoYouWantToDelete,
                      positiveText: languages.lblDelete,
                      negativeText: languages.lblCancel,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          removeHandyman(widget.data!.id.validate());
                        });
                      },
                    );
                  } else if (selection == 2) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: languages.lblDoYouWantToRestore,
                      positiveText: languages.lblRestore,
                      negativeText: languages.lblCancel,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          restoreHandymanData();
                        });
                      },
                    );
                  } else if (selection == 3) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: languages.lblDoYouWantToDeleteForcefully,
                      positiveText: languages.lblDelete,
                      negativeText: languages.lblCancel,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          forceDeleteHandymanData();
                        });
                      },
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(languages.lblDelete),
                    value: 1,
                    enabled: widget.data!.deletedAt == null,
                    textStyle: boldTextStyle(color: widget.data!.deletedAt == null ? textPrimaryColorGlobal : null),
                  ),
                  PopupMenuItem(
                    child: Text(languages.lblRestore),
                    value: 2,
                    textStyle: boldTextStyle(color: widget.data!.deletedAt != null ? textPrimaryColorGlobal : null),
                    enabled: widget.data!.deletedAt != null,
                  ),
                  PopupMenuItem(
                    child: Text(languages.lblForceDelete),
                    textStyle: boldTextStyle(),
                    value: 3,
                    enabled: widget.data!.deletedAt != null,
                  ),
                ],
              ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isUpdate)
                      CachedImageWidget(
                        url: widget.data!.profileImage.validate(value: profile),
                        height: 100,
                        circle: true,
                        fit: BoxFit.cover,
                      ).center(),
                    30.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: fNameCont,
                      focus: fNameFocus,
                      enabled: isUpdate? rolesAndPermissionStore.handymanEdit: true,
                      nextFocus: lNameFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintFirstNameTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: profile.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: lNameCont,
                      focus: lNameFocus,
                      enabled: isUpdate? rolesAndPermissionStore.handymanEdit: true,
                      nextFocus: userNameFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintLastNameTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: profile.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: userNameCont,
                      focus: userNameFocus,
                      nextFocus: emailFocus,
                      enabled: isUpdate? rolesAndPermissionStore.handymanEdit: true,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintUserNameTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: profile.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.EMAIL_ENHANCED,
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: mobileFocus,
                      enabled: isUpdate? rolesAndPermissionStore.handymanEdit: true,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintEmailAddressTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: ic_message.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    IgnorePointer(
                    ignoring: isUpdate ? !rolesAndPermissionStore.handymanEdit : false,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: context.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: ValueListenableBuilder(
                              valueListenable: _valueNotifier,
                              builder: (context, value, child) => Row(
                                children: [
                                  Text(
                                    "+${selectedCountry.phoneCode}",
                                    style: primaryTextStyle(size: 12),
                                  ).paddingOnly(left: 8),
                                  Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                          ),
                        )
                            .onTap(
                              () => changeCountry(),
                            )
                            .paddingOnly(right: 10.0),
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.PHONE,
                            controller: mobileCont,
                            focus: mobileFocus,
                            nextFocus: designationFocus,
                            decoration: inputDecoration(
                              context,
                              hint: languages.hintContactNumberTxt,
                              fillColor: context.scaffoldBackgroundColor,
                            ),
                            suffix: calling.iconImage(size: 10).paddingAll(14),
                            validator: (mobileCont) {
                              if (mobileCont!.isEmpty) return languages.lblPleaseEnterMobileNumber;
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                   ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: designationCont,
                      isValidationRequired: false,
                      enabled: isUpdate? rolesAndPermissionStore.handymanEdit: true,
                      focus: designationFocus,
                      nextFocus: passwordFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.lblDesignation,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                    ),
                    16.height,
                    // Select commission text field...
                   IgnorePointer(
                    ignoring: isUpdate ? !rolesAndPermissionStore.handymanEdit : false,
                    child:  DropdownButtonFormField<UserTypeData>(
                      decoration: inputDecoration(
                        context,
                        hint: languages.lblSelectCommission,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      isExpanded: true,
                      dropdownColor: context.cardColor,
                      value: selectedHandymanCommission != null
                          ? selectedHandymanCommission
                          : null,
                      items: commissionList.map((data) {
                        return DropdownMenuItem<UserTypeData>(
                          value: data,
                          child: Row(
                            children: [
                              Text(data.name.toString(), style: primaryTextStyle()),
                              4.width,
                              if (data.type == COMMISSION_TYPE_PERCENT)
                                Text(
                                  '(${data.commission.toString()}%)',
                                  style: primaryTextStyle(),
                                )
                              else if (data.type == COMMISSION_TYPE_FIXED)
                                Text('(${data.commission.validate().toPriceFormat()})', style: primaryTextStyle()),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (UserTypeData? value) async {
                        selectedHandymanCommission = value;
                        commissionId = selectedHandymanCommission!.id.validate();
                        setState(() {});
                      },
                     ),
                    ).visible(commissionList.isNotEmpty),
                    16.height,
                    IgnorePointer(
                    ignoring: isUpdate ? !rolesAndPermissionStore.handymanEdit : false,
                    child: DropdownButtonFormField<AddressResponse>(
                      decoration: inputDecoration(
                        context,
                        hint: languages.lblAddress,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      isExpanded: true,
                      dropdownColor: context.cardColor,
                      value: selectedServiceAddress != null ? selectedServiceAddress : null,
                      items: serviceAddressList.map((data) {
                        return DropdownMenuItem<AddressResponse>(
                          value: data,
                          child: Text(
                            data.address.validate(),
                            style: primaryTextStyle(),
                          ),
                        );
                      }).toList(),
                      onChanged: (AddressResponse? value) async {
                        selectedServiceAddress = value;
                        serviceAddressId = selectedServiceAddress!.id.validate();
                        setState(() {});
                      },
                     ),
                    ).visible(serviceAddressList.isNotEmpty),
                    16.height.visible(!isUpdate),
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: passwordCont,
                      focus: passwordFocus,
                      enabled: isUpdate? rolesAndPermissionStore.handymanEdit: true,
                      obscureText: true,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintPassword,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      isValidationRequired: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return languages.hintRequired;
                        } else if (val.length < 8 || val.length > 12) {
                          return languages.passwordLengthShouldBe;
                        }
                        return null;
                      },
                      onFieldSubmitted: (s) {
                        ifNotTester(context, () {
                          register();
                        });
                      },
                    ).visible(!isUpdate),
                    16.height,
                    if (isUpdate)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.data!.displayName} ${languages.lblRegistered} ${DateTime.parse(widget.data!.createdAt!).timeAgo}\n${formatBookingDate(widget.data!.createdAt!)}', style: secondaryTextStyle()),
                          if (widget.data!.emailVerifiedAt.validate().isNotEmpty)
                            TextIcon(
                              text: '${languages.lblEmailIsVerified}',
                              textStyle: primaryTextStyle(color: Colors.green),
                              prefix: Container(
                                child: Icon(Icons.check, color: Colors.white, size: 14),
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                              ),
                            ).paddingTop(8),
                        ],
                      ),
                    24.height,
                    Observer(
                      builder: (context) => AppButton(
                        text: languages.btnSave,
                        height: 40,
                        color: primaryColor,
                        textColor: white,
                        width: context.width() - context.navigationBarHeight,
                        onTap: appStore.isLoading
                            ? null
                            : () {
                                ifNotTester(context, () {
                                  if(isUpdate){
                                    if(rolesAndPermissionStore.handymanEdit){
                                      register();
                                    }else{
                                      toast(languages.permissionDeniedUnableTo);
                                    }
                                  }else{
                                  register();
                                  }
                                });
                              },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }

  // Change country code function...
  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        inputDecoration: InputDecoration(
          labelText: languages.search,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withValues(alpha:0.2),
            ),
          ),
        ),
      ),
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        _valueNotifier.notifyListeners();
      },
    );
  }
}
