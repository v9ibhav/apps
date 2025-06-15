// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/auth/sign_in_screen.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/selected_item_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
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

import '../components/back_widget.dart';
import '../components/cached_image_widget.dart';
import '../models/user_data.dart';
import '../provider/provider_list_screen.dart';

bool isNew = false;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //-------------------------------- Variables -------------------------------//

  /// TextEditing controller
  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController designationCont = TextEditingController();

  /// FocusNodes
  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode userTypeFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode designationFocus = FocusNode();

  String? selectedUserTypeValue;

  List<UserTypeData> commissionTypeList = [UserTypeData(name: languages.lblSelectCommission, id: -1)];

  UserTypeData? selectedUserCommissionType;

  bool isAcceptedTc = false;
  Country selectedCountry = defaultCountry();

  ValueNotifier _valueNotifier = ValueNotifier(true);

  UserData? selectedProvider;

  int? selectedProviderId;

  @override
  void dispose() {
    super.dispose();

    fNameCont.dispose();
    lNameCont.dispose();
    emailCont.dispose();
    userNameCont.dispose();
    mobileCont.dispose();
    passwordCont.dispose();
    designationCont.dispose();

    fNameFocus.dispose();
    lNameFocus.dispose();
    emailFocus.dispose();
    userNameFocus.dispose();
    mobileFocus.dispose();
    userTypeFocus.dispose();
    typeFocus.dispose();
    passwordFocus.dispose();
    designationFocus.dispose();
  }

  //----------------------------------- UI -----------------------------------//

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: transparentColor,
          leading: Container(
              margin: EdgeInsets.only(left: 6),
              padding: EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: BackWidget(color: context.iconColor)),
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: context.scaffoldBackgroundColor),
        ),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTopWidget(),
                    _buildFormWidget(),
                    _buildFooterWidget(),
                  ],
                ),
              ),
            ),
            Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }

  //------------------------------ Helper Widgets-----------------------------//
  // Build hello user With Create Your Account for Better Experience text...
  Widget _buildTopWidget() {
    return Column(
      children: [
        (context.height() * 0.12).toInt().height,
        Container(
          width: 85,
          height: 85,
          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryColor),
          child: Image.asset(profile, height: 45, width: 45, color: white),
        ),
        16.height,
        Text(languages.lblSignupTitle, style: boldTextStyle(size: 18)),
        16.height,
        Text(
          languages.lblSignupSubtitle,
          style: secondaryTextStyle(size: 14),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 32),
        32.height,
      ],
    );
  }

  Widget _buildFormWidget() {
    return Column(
      children: [
        // First name text field...
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: fNameCont,
          focus: fNameFocus,
          nextFocus: lNameFocus,
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintFirstNameTxt),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // Last name text field...
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: lNameCont,
          focus: lNameFocus,
          nextFocus: userNameFocus,
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintLastNameTxt),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // User name test field...
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: userNameCont,
          focus: userNameFocus,
          nextFocus: emailFocus,
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintUserNameTxt),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // Email text field...
        AppTextField(
          textFieldType: TextFieldType.EMAIL_ENHANCED,
          controller: emailCont,
          focus: emailFocus,
          nextFocus: mobileFocus,
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintEmailAddressTxt),
          suffix: ic_message.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country code ...
            Container(
              height: 48.0,
              decoration: BoxDecoration(
                color: context.cardColor,
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
                  ).paddingOnly(left: 8),
                ),
              ),
            ).onTap(() => changeCountry()),
            10.width,
            // Mobile number text field...
            AppTextField(
              textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
              controller: mobileCont,
              focus: mobileFocus,
              errorThisFieldRequired: languages.hintRequired,
              nextFocus: passwordFocus,
              decoration: inputDecoration(context, hint: '${languages.hintContactNumberTxt}').copyWith(
                hintText: '${languages.lblExample}: ${selectedCountry.example}',
                hintStyle: secondaryTextStyle(),
              ),
              maxLength: 15,
              suffix: calling.iconImage(size: 10).paddingAll(14),
            ).expand(),
          ],
        ),
        8.height,
        // Designation text field...
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: designationCont,
          isValidationRequired: false,
          focus: designationFocus,
          nextFocus: passwordFocus,
          decoration: inputDecoration(context, hint: languages.lblDesignation),
          suffix: profile.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // User role text field...
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                child: Text(languages.provider, style: primaryTextStyle()),
                value: USER_TYPE_PROVIDER,
              ),
              DropdownMenuItem(
                child: Text(languages.handyman, style: primaryTextStyle()),
                value: USER_TYPE_HANDYMAN,
              ),
            ],
            focusNode: userTypeFocus,
            dropdownColor: context.cardColor,
            decoration: inputDecoration(context, hint: languages.userRole),
            value: selectedUserTypeValue,
            validator: (value) {
              if (value == null) return errorThisFieldRequired;
              return null;
            },
            onChanged: (c) {
              hideKeyboard(context);
              selectedUserTypeValue = c.validate();
              setState(() {});

              if (selectedProvider != null) {
                selectedProvider = null;
                setState(() {});
              }

              commissionTypeList.clear();
              selectedUserCommissionType = null;

              getCommissionType(type: selectedUserTypeValue!).then((value) {
                commissionTypeList = value.userTypeData.validate();

                _valueNotifier.notifyListeners();
              }).catchError((e) {
                commissionTypeList = [UserTypeData(name: languages.lblSelectCommission, id: -1)];
                log(e.toString());
              });
            },
          ),
        ),
        if (selectedUserTypeValue != USER_TYPE_HANDYMAN) 16.height,
        if (selectedUserTypeValue == USER_TYPE_HANDYMAN)
          Container(
            decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
            padding: EdgeInsets.only(
              top: selectedProvider != null ? 16 : 0,
              bottom: selectedProvider != null ? 16 : 0,
              left: selectedProvider != null ? 16 : 0,
              right: 4,
            ),
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (selectedProvider != null)
                  GestureDetector(
                    onTap: () {
                      pickProvider();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(languages.selectedProvider, style: secondaryTextStyle()).paddingOnly(bottom: 8),
                        Row(
                          children: [
                            CachedImageWidget(
                              url: selectedProvider!.profileImage.validate(),
                              height: 24,
                              circle: true,
                              fit: BoxFit.cover,
                            ),
                            8.width,
                            Text(
                              selectedProvider!.displayName.validate(),
                              style: primaryTextStyle(size: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).expand(),
                if (selectedProvider != null)
                  IconButton(
                    onPressed: () {
                      selectedProvider = null;
                      setState(() {});

                      commissionTypeList.clear();
                      selectedUserCommissionType = null;

                      getCommissionType(type: selectedUserTypeValue!).then((value) {
                        commissionTypeList = value.userTypeData.validate();

                        _valueNotifier.notifyListeners();
                      }).catchError((e) {
                        commissionTypeList = [UserTypeData(name: languages.lblSelectCommission, id: -1)];
                        log(e.toString());
                      });
                    },
                    icon: Icon(Icons.close),
                  )
                else
                  TextButton(
                    onPressed: () async {
                      pickProvider();
                    },
                    child: Text(languages.pickAProviderYou),
                  ),
              ],
            ),
          ),
        // Select user type text field...
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => DropdownButtonFormField<UserTypeData>(
            onChanged: (UserTypeData? val) {
              selectedUserCommissionType = val;
              _valueNotifier.notifyListeners();
            },
            validator: selectedUserCommissionType == null
                ? (c) {
                    if (c == null) return errorThisFieldRequired;
                    return null;
                  }
                : null,
            value: selectedUserCommissionType,
            dropdownColor: context.cardColor,
            decoration: inputDecoration(context, hint: languages.lblSelectCommission),
            items: List.generate(
              commissionTypeList.length,
              (index) {
                UserTypeData data = commissionTypeList[index];

                return DropdownMenuItem<UserTypeData>(
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
                  value: data,
                );
              },
            ),
          ),
        ),
        16.height,
        // Password text field...
        AppTextField(
          textFieldType: TextFieldType.PASSWORD,
          controller: passwordCont,
          focus: passwordFocus,
          obscureText: true,
          suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
          suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
          errorThisFieldRequired: languages.hintRequired,
          decoration: inputDecoration(context, hint: languages.hintPassword),
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
            saveUser();
          },
        ),
        20.height,
        _buildTcAcceptWidget(),
        8.height,
        // Sign up button
        AppButton(
          text: languages.lblSignup,
          height: 40,
          color: primaryColor,
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            saveUser();
          },
        ),
      ],
    );
  }

  // Pick a Provider
  void pickProvider() async {
    UserData? user = await ProviderListScreen(status: '$USER_STATUS_CODE').launch(context);

    if (user != null) {
      selectedProvider = user;
      selectedProviderId = user.id.validate();
      setState(() {});

      commissionTypeList.clear();
      selectedUserCommissionType = null;

      getCommissionType(type: selectedUserTypeValue!, providerId: selectedProviderId).then((value) {
        commissionTypeList = value.userTypeData.validate();

        _valueNotifier.notifyListeners();
      }).catchError((e) {
        commissionTypeList = [UserTypeData(name: languages.lblSelectCommission, id: -1)];
        log(e.toString());
      });
    }
  }

  // Termas of service and Provacy policy text
  Widget _buildTcAcceptWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) => SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
            isAcceptedTc = !isAcceptedTc;
            _valueNotifier.notifyListeners();
          }),
        ),
        16.width,
        RichTextWidget(
          list: [
            TextSpan(text: '${languages.lblIAgree} ', style: secondaryTextStyle()),
            TextSpan(
              text: languages.lblTermsOfService,
              style: boldTextStyle(color: primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  checkIfLink(context, appConfigurationStore.termConditions, title: languages.lblTermsAndConditions);
                },
            ),
            TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: languages.lblPrivacyPolicy,
              style: boldTextStyle(color: primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  checkIfLink(context, appConfigurationStore.privacyPolicy, title: languages.lblPrivacyPolicy);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingAll(16);
  }

  // Already have an account with sign in text
  Widget _buildFooterWidget() {
    return Column(
      children: [
        16.height,
        RichTextWidget(
          list: [
            TextSpan(text: "${languages.alreadyHaveAccountTxt}? ", style: secondaryTextStyle()),
            TextSpan(
              text: languages.signIn,
              style: boldTextStyle(color: primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  finish(context);
                },
            ),
          ],
        ),
        30.height,
      ],
    );
  }

  //----------------------------- Helper Functions----------------------------//
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

  // Build mobile number with phone code and number
  String buildMobileNumber() {
    if (mobileCont.text.isEmpty) {
      return '';
    } else {
      return '+${selectedCountry.phoneCode}-${mobileCont.text.trim()}';
    }
  }

  // Sign up user
  void saveUser() async {
    if (formKey.currentState!.validate()) {
      if (selectedUserCommissionType == null || selectedUserCommissionType!.id == -1) {
        return toast(languages.pleaseSelectCommission);
      }

      formKey.currentState!.save();

      hideKeyboard(context);

      if (isAcceptedTc) {
        appStore.setLoading(true);

        var request = {
          UserKeys.firstName: fNameCont.text.trim(),
          UserKeys.lastName: lNameCont.text.trim(),
          UserKeys.userName: userNameCont.text.trim(),
          UserKeys.userType: selectedUserTypeValue,
          UserKeys.contactNumber: buildMobileNumber(),
          UserKeys.email: emailCont.text.trim(),
          UserKeys.password: passwordCont.text.trim(),
          UserKeys.designation: designationCont.text.trim(),
          UserKeys.status: 0,
        };
        print(request);
        if (selectedProvider != null) {
          request.putIfAbsent(UserKeys.providerId, () => selectedProviderId);
        }

        if (selectedUserTypeValue == USER_TYPE_PROVIDER) {
          request.putIfAbsent(UserKeys.providerTypeId, () => selectedUserCommissionType!.id.toString());
        } else {
          request.putIfAbsent(UserKeys.handymanTypeId, () => selectedUserCommissionType!.id.toString());
        }

        log(request);

        await registerUser(request).then((userRegisterData) async {
          appStore.setLoading(false);
          toast(userRegisterData.message.validate());

          push(SignInScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        }).catchError((e) {
          toast(e.toString(), print: true);
          appStore.setLoading(false);
        });
      } else {
        toast(languages.lblTermCondition);
        appStore.setLoading(false);
      }
    }
  }

//endregion
}
