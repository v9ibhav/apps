import 'dart:convert';

import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/base_scaffold_body.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/auth/sign_up_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../network/rest_apis.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';
import '../dashboard/dashboard_screen.dart';

class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({Key? key}) : super(key: key);

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();
  FocusNode _mobileNumberFocus = FocusNode();

  Country selectedCountry = defaultCountry();

  String otpCode = '';
  String verificationId = '';

  ValueNotifier _valueNotifier = ValueNotifier(true);

  bool isCodeSent = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  Future<void> init() async {
    appStore.setLoading(false);
  }

  //region Methods
  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        inputDecoration: InputDecoration(
          labelText: language.search,
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
        log(jsonEncode(selectedCountry.toJson()));
        setState(() {});
      },
    );
  }

  Future<void> sendOTP() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);

      toast(language.sendingOTP);

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+${selectedCountry.phoneCode}${numberController.text.trim()}",
          verificationCompleted: (PhoneAuthCredential credential) async {
            toast(language.verified);

            if (isAndroid) {
              await FirebaseAuth.instance.signInWithCredential(credential);
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            appStore.setLoading(false);
            if (e.code == 'invalid-phone-number') {
              toast(language.theEnteredCodeIsInvalidPleaseTryAgain, print: true);
            } else {
              toast(e.toString(), print: true);
            }
          },
          codeSent: (String _verificationId, int? resendToken) async {
            toast(language.otpCodeIsSentToYourMobileNumber);

            appStore.setLoading(false);

            verificationId = _verificationId;

            if (verificationId.isNotEmpty) {
              isCodeSent = true;
              setState(() {});
            } else {
              //Handle
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            FirebaseAuth.instance.signOut();
            isCodeSent = false;
            setState(() {});
          },
        );
      } on Exception catch (e) {
        log(e);
        appStore.setLoading(false);

        toast(e.toString(), print: true);
      }
    }
  }

  Future<void> submitOtp() async {
    log(otpCode);
    if (otpCode.validate().isNotEmpty) {
      if (otpCode.validate().length >= OTP_TEXT_FIELD_LENGTH) {
        hideKeyboard(context);
        appStore.setLoading(true);

        try {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpCode);
          UserCredential credentials = await FirebaseAuth.instance.signInWithCredential(credential);

          Map<String, dynamic> request = {
            'username': numberController.text.trim(),
            'password': numberController.text.trim(),
            'login_type': LOGIN_TYPE_OTP,
            "uid": credentials.user!.uid.validate(),
          };

          try {
            await loginUser(request, isSocialLogin: true).then((loginResponse) async {
              if (loginResponse.isUserExist.validate(value: true)) {
                await saveUserData(loginResponse.userData!);
                await appStore.setLoginType(LOGIN_TYPE_OTP);
                DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
              } else {
                appStore.setLoading(false);
                finish(context);

                SignUpScreen(
                  isOTPLogin: true,
                  phoneNumber: numberController.text.trim(),
                  countryCode: selectedCountry.countryCode,
                  uid: credentials.user!.uid.validate(),
                  tokenForOTPCredentials: credential.token,
                ).launch(context);
              }
            }).catchError((e) {
              finish(context);
              toast(e.toString());
              appStore.setLoading(false);
            });
          } catch (e) {
            appStore.setLoading(false);
            toast(e.toString(), print: true);
          }
        } on FirebaseAuthException catch (e) {
          appStore.setLoading(false);
          if (e.code.toString() == 'invalid-verification-code') {
            toast(language.theEnteredCodeIsInvalidPleaseTryAgain, print: true);
          } else {
            toast(e.message.toString(), print: true);
          }
        } on Exception catch (e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        }
      } else {
        toast(language.pleaseEnterValidOTP);
      }
    } else {
      toast(language.pleaseEnterValidOTP);
    }
  }

  // endregion

  Widget _buildMainWidget() {
    if (isCodeSent) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            32.height,
            OTPTextField(
              pinLength: OTP_TEXT_FIELD_LENGTH,
              textStyle: primaryTextStyle(),
              decoration: inputDecoration(context).copyWith(
                counter: Offstage(),
              ),
              onChanged: (s) {
                otpCode = s;
                log(otpCode);
              },
              onCompleted: (pin) {
                otpCode = pin;
                submitOtp();
              },
            ).fit(),
            30.height,
            AppButton(
              onTap: () {
                submitOtp();
              },
              text: language.confirm,
              color: primaryColor,
              textColor: Colors.white,
              width: context.width(),
            ),
          ],
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: primaryColor,
                          )
                        ],
                      ).paddingOnly(left: 8),
                    ),
                  ),
                ).onTap(() => changeCountry()).fit(fit: BoxFit.cover),
                10.width,
                // Mobile number text field...
                AppTextField(
                  controller: numberController,
                  focus: _mobileNumberFocus,
                  textFieldType: TextFieldType.PHONE,
                  decoration: inputDecoration(context).copyWith(
                    hintText: '${language.lblExample}: ${selectedCountry.example}',
                    hintStyle: secondaryTextStyle(),
                  ),
                  autoFocus: true,
                  onFieldSubmitted: (s) {
                    sendOTP();
                  },
                ).expand(),
              ],
            ),
          ),
          30.height,
          AppButton(
            onTap: () {
              sendOTP();
            },
            text: language.btnSendOtp,
            color: primaryColor,
            textColor: Colors.white,
            width: context.width(),
          ),
        ],
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isCodeSent ? language.confirmOTP : language.lblEnterPhnNumber, style: boldTextStyle(size: APP_BAR_TEXT_SIZE)),
          elevation: 0,
          backgroundColor: context.scaffoldBackgroundColor,
          leading: Navigator.of(context).canPop() ? BackWidget(iconColor: context.iconColor) : null,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: context.scaffoldBackgroundColor),
        ),
        body: Body(
          child: Container(
            padding: EdgeInsets.all(16),
            child: _buildMainWidget(),
          ),
        ),
      ),
    );
  }
}
