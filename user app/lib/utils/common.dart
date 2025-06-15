import 'dart:io';

import 'package:booking_system_flutter/component/app_common_dialog.dart';
import 'package:booking_system_flutter/component/html_widget.dart';
import 'package:booking_system_flutter/component/location_service_dialog.dart';
import 'package:booking_system_flutter/component/new_update_dialog.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/services/location_service.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/permissions.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../component/cached_image_widget.dart';
import 'app_configuration.dart';
import 'constant.dart';

Future<bool> get isIqonicProduct async => await getPackageName() == appPackageName;

bool get isUserTypeHandyman => appStore.userType == USER_TYPE_HANDYMAN;

bool get isUserTypeProvider => appStore.userType == USER_TYPE_PROVIDER;

bool get isUserTypeUser => appStore.userType == USER_TYPE_USER;

bool get isLoginTypeUser => appStore.loginType == LOGIN_TYPE_USER;

bool get isLoginTypeGoogle => appStore.loginType == LOGIN_TYPE_GOOGLE;

bool get isLoginTypeApple => appStore.loginType == LOGIN_TYPE_APPLE;

bool get isLoginTypeOTP => appStore.loginType == LOGIN_TYPE_OTP;

ThemeMode get appThemeMode => appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light;

bool get isRTL => RTL_LanguageS.contains(appStore.selectedLanguageCode);

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('${language.invalidURL}: $address');

    throw e;
  });
}

void viewFiles(String url) {
  if (url.isNotEmpty) {
    commonLaunchUrl(url, launchMode: LaunchMode.externalApplication);
  }
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS)
      commonLaunchUrl('tel://' + url!, launchMode: LaunchMode.externalApplication);
    else
      commonLaunchUrl('tel:' + url!, launchMode: LaunchMode.externalApplication);
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(GOOGLE_MAP_PREFIX + Uri.encodeFull(url!), launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('$MAIL_TO$url', launchMode: LaunchMode.externalApplication);
  }
}

void checkIfLink(BuildContext context, String value, {String? title}) {
  if (value.validate().isEmpty) return;

  String temp = parseHtmlString(value.validate());
  if (temp.startsWith("https") || temp.startsWith("http")) {
    launchUrlCustomTab(temp.validate());
  } else if (temp.validateEmail()) {
    launchMail(temp);
  } else if (temp.validatePhone() || temp.startsWith('+')) {
    launchCall(temp);
  } else {
    HtmlWidget(postContent: value, title: title).launch(context);
  }
}

void launchUrlCustomTab(String? url) {
  if (url.validate().isNotEmpty) {
    custom_tabs.launchUrl(
      Uri.parse(url!),
      customTabsOptions: custom_tabs.CustomTabsOptions(
        showTitle: true,
        colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(toolbarColor: primaryColor),
      ),
      safariVCOptions: custom_tabs.SafariViewControllerOptions(
        preferredBarTintColor: primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: true,
        dismissButtonStyle: custom_tabs.SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/flag/ic_fr.png'),
    LanguageDataModel(id: 5, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'assets/flag/ic_de.png'),
  ];
}

InputDecoration inputDecoration(BuildContext context, {Widget? prefixIcon, String? labelText, String? hintText, double? borderRadius, bool? counter, String? counterText,  Color? fillColor}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    counterText: counter == false ? "" : counterText,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: true,
    fillColor: fillColor ?? context.cardColor,
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String formatDate(String? dateTime, {bool isFromMicrosecondsSinceEpoch = false, bool isLanguageNeeded = true, bool isTime = false, bool showDateWithTime = false}) {
  final languageCode = isLanguageNeeded ? appStore.selectedLanguageCode : null;
  final parsedDateTime = isFromMicrosecondsSinceEpoch ? DateTime.fromMicrosecondsSinceEpoch(dateTime.validate().toInt() * 1000) : DateTime.parse(dateTime.validate());
  if (isTime) {
    return DateFormat('${getStringAsync(TIME_FORMAT)}', languageCode).format(parsedDateTime);
  } else {
    if (getStringAsync(DATE_FORMAT).validate().contains('dS')) {
      int day = parsedDateTime.day;
      if (DateFormat('${getStringAsync(DATE_FORMAT)}', languageCode).format(parsedDateTime).contains('$day')) {
        return DateFormat('${getStringAsync(DATE_FORMAT).replaceAll('S', '')}${showDateWithTime ? ' ${getStringAsync(TIME_FORMAT)}' : ''}', languageCode)
            .format(parsedDateTime)
            .replaceFirst('$day', '${addOrdinalSuffix(day)}');
      }
    }
    return DateFormat('${getStringAsync(DATE_FORMAT)}${showDateWithTime ? ' ${getStringAsync(TIME_FORMAT)}' : ''}', languageCode).format(parsedDateTime);
  }
}

String formatBookingDate(String? dateTime, {String format = DATE_FORMAT_1, bool isFromMicrosecondsSinceEpoch = false, bool isLanguageNeeded = true, bool isTime = false, bool showDateWithTime = false}) {
  final languageCode = isLanguageNeeded ? appStore.selectedLanguageCode : null;
  final parsedDateTime = isFromMicrosecondsSinceEpoch ? DateTime.fromMicrosecondsSinceEpoch(dateTime.validate().toInt() * 1000) : DateTime.parse(dateTime.validate());

  return DateFormat(format, languageCode).format(parsedDateTime);
}

String getSlotWithDate({required String date, required String slotTime}) {
  DateTime originalDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
  DateTime newTime = DateFormat('HH:mm:ss').parse(slotTime);
  DateTime newDateTime = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day, newTime.hour, newTime.minute, newTime.second);
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(newDateTime);
}

String getConfirmBookingDateFormat({required String date}) {
  DateTime originalDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
  return DateFormat("d MMMM, yyyy, 'at' h:mm a").format(originalDateTime);}

String getDateFormat(String phpFormat) {
  final formatMapping = {
    'Y': 'yyyy',
    'm': 'MM',
    'd': 'dd',
    'j': 'd',
    'S': 'S',
    'M': 'MMM',
    'F': 'MMMM',
    'l': 'EEEE',
    'D': 'EEE',
    'H': 'HH',
    'i': 'mm',
    's': 'ss',
    'A': 'a',
    'T': 'z',
    'v': 'S',
    'U': 'y-MM-ddTHH:mm:ssZ',
    'u': 'y-MM-ddTHH:mm:ss.SSSZ',
    'G': 'H',
    'B': 'EEE, d MMM y HH:mm:ss Z',
  };

  String dartFormat = phpFormat.replaceAllMapped(
    RegExp('[YmjdSFMlDHisaTvGuB]'),
    (match) => formatMapping[match.group(0)] ?? match.group(0).validate(),
  );

  dartFormat = dartFormat.replaceAllMapped(
    RegExp(r"\\(.)"),
    (match) => match.group(1) ?? '',
  );

  return dartFormat;
}

String addOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return '${day}th';
  }
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}

String getDisplayTimeFormat(String phpFormat) {
  switch (phpFormat) {
    case 'H:i':
      return 'HH:mm';
    case 'H:i:s':
      return 'HH:mm:ss';
    case 'g:i A':
      return 'h:mm a';
    case 'H:i:s T':
      return 'HH:mm:ss z';
    case 'H:i:s.v':
      return 'HH:mm:ss.S';
    case 'U':
      return 'HH:mm:ssZ';
    case 'u':
      return 'HH:mm:ss.SSSZ';
    case 'G.i':
      return 'H.mm';
    case '@BMT':
      return 'HH:mm:ss Z';
    default:
      return DISPLAY_TIME_FORMAT; // Return the same format if not found in the mapping
  }
}

bool containsTime(String dateString) {
  RegExp timeRegex = RegExp(r'\b\d{1,2}:\d{1,2}(:\d{1,2})?\b');

  return timeRegex.hasMatch(dateString);
}

Future<bool> addToWishList({required int serviceId}) async {
  Map req = {"id": "", "service_id": serviceId, "user_id": appStore.userId};
  return await addWishList(req).then((res) {
    toast(language.serviceAddedToFavourite);
    return true;
  }).catchError((error) {
    toast(error.toString());
    return false;
  });
}

Future<bool> removeToWishList({required int serviceId}) async {
  Map req = {"user_id": appStore.userId, 'service_id': serviceId};

  return await removeWishList(req).then((res) {
    toast(language.serviceRemovedFromFavourite);
    return true;
  }).catchError((error) {
    toast(error.toString());
    return false;
  });
}

void locationWiseService(BuildContext context, VoidCallback onTap) async {
  Permissions.cameraFilesAndLocationPermissionsGranted().then((value) async {
    await setValue(PERMISSION_STATUS, value);

    if (value) {
      bool? res = await showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        builder: (p0) {
          return AppCommonDialog(
            title: language.lblAlert,
            child: LocationServiceDialog(),
          );
        },
      );

      if (res ?? false) {
        appStore.setLoading(true);

        await setValue(PERMISSION_STATUS, value);
        await getUserLocation().then((value) async {
          await appStore.setCurrentLocation(!appStore.isCurrentLocation);
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });

        onTap.call();
      }
    }
  }).catchError((e) {
    toast(e.toString(), print: true);
  });
}

Future<List<File>> pickFiles({
  FileType type = FileType.any,
  List<String> allowedExtensions = const [],
  int maxFileSizeMB = 5,
  bool allowMultiple = false,
}) async {
  List<File> _filePath = [];
  try {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: allowMultiple,
      withData: Platform.isAndroid ? false : true,
      allowedExtensions: allowedExtensions,
      onFileLoading: (FilePickerStatus status) => print(status),
    );
    if (filePickerResult != null) {
      if (Platform.isAndroid) {
        // For Android, check file size and use the PlatformFile directly
        for (PlatformFile file in filePickerResult.files) {
          if (file.size <= maxFileSizeMB * 1024 * 1024) {
            _filePath.add(File(file.path!));
          } else {
            // File size exceeds the limit
            toast('File size should be less than $maxFileSizeMB MB');
          }
        }
      } else {
        Directory cacheDir = await getTemporaryDirectory();
        for (PlatformFile file in filePickerResult.files) {
          if (file.bytes != null && file.size <= maxFileSizeMB * 1024 * 1024) {
            String filePath = '${cacheDir.path}/${file.name}';
            File cacheFile = File(filePath);
            await cacheFile.writeAsBytes(file.bytes!.toList());
            _filePath.add(cacheFile);
          } else {
            // File size exceeds the limit
            toast('File size should be less than $maxFileSizeMB MB');
          }
        }
      }
    }
  } on PlatformException catch (e) {
    print('Unsupported operation' + e.toString());
  } catch (e) {
    print(e.toString());
  }
  return _filePath;
}

// Logic For Calculate Time
String calculateTimer(int secTime) {
  int hour = 0, minute = 0, seconds = 0;

  hour = secTime ~/ 3600;

  minute = ((secTime - hour * 3600)) ~/ 60;

  seconds = secTime - (hour * 3600) - (minute * 60);

  String hourLeft = hour.toString().length < 2 ? "0" + hour.toString() : hour.toString();

  String minuteLeft = minute.toString().length < 2 ? "0" + minute.toString() : minute.toString();

  String minutes = minuteLeft == '00' ? '01' : minuteLeft;

  String result = "$hourLeft:$minutes";

  log(seconds);

  return result;
}

String convertToHourMinute(String timeStr) {
  if (timeStr.isEmpty) {
    return ''; // Handle empty time string
  }

  // Normalize time string to always have two digits for hours
  List<String> parts = timeStr.split(':');
  int hours = int.parse(parts[0]) % 24; // Ensure hours are within 24 hours
  int minutes = int.parse(parts[1]);

  // Construct the resulting string
  String result = '';
  if (hours > 0) {
    result += '${hours}${language.lblHr}';
  }
  if (minutes > 0) {
    result = (result.validate().isNotEmpty) ? '$result $minutes ${language.min}' : '$minutes ${language.min}';
  }
  return result;
}

String getPaymentStatusFilterText(String? status) {
  if (status!.isEmpty) {
    return language.lblPending;
  } else if (status == SERVICE_PAYMENT_STATUS_PAID || status == PENDING_BY_ADMIN) {
    return language.paid;
  } else if (status == SERVICE_PAYMENT_STATUS_ADVANCE_PAID) {
    return language.advancePaid;
  } else if (status == SERVICE_PAYMENT_STATUS_PENDING) {
    return language.lblPending;
  } else if (status == SERVICE_PAYMENT_STATUS_ADVANCE_REFUND) {
    return language.advancedRefund;
  } else {
    return "";
  }
}

String getPaymentStatusText(String? status, String? method) {
  if (status!.isEmpty) {
    return language.lblPending;
  } else if (status == SERVICE_PAYMENT_STATUS_PAID || status == PENDING_BY_ADMIN) {
    return language.paid;
  } else if (status == SERVICE_PAYMENT_STATUS_ADVANCE_PAID) {
    return language.advancePaid;
  } else if ((status == SERVICE_PAYMENT_STATUS_PENDING || status == 'pending_approval') && method == PAYMENT_METHOD_COD) {
    return language.pendingApproval;  //TODO: check this condition 'pending_approval' status not coming from backend
  } else if (status == SERVICE_PAYMENT_STATUS_PENDING) {
    return language.lblPending;
  } else if (status == SERVICE_PAYMENT_STATUS_ADVANCE_REFUND) {
    return language.cancelled;
  } else {
    return "";
  }
}

String buildPaymentStatusWithMethod(String status, String method) {
  return '${getPaymentStatusText(status, method)}${(status == SERVICE_PAYMENT_STATUS_PAID || status == PENDING_BY_ADMIN) ? ' ${language.by} ${method.capitalizeFirstLetter()}' : ''}';
}

Color getRatingBarColor(int rating, {bool showRedForZeroRating = false}) {
  if (rating == 1 || rating == 2) {
    return showRedForZeroRating ? showRedForZeroRatingColor : ratingBarColor;
  } else if (rating == 3) {
    return Color(0xFFff6200);
  } else if (rating == 4 || rating == 5) {
    return Color(0xFF73CB92);
  } else {
    return showRedForZeroRating ? showRedForZeroRatingColor : ratingBarColor;
  }
}

void ifNotTester(VoidCallback callback) {
  if (appStore.userEmail != DEFAULT_EMAIL) {
    callback.call();
  } else {
    toast(language.lblUnAuthorized);
  }
}

void doIfLoggedIn(BuildContext context, VoidCallback callback) {
  if (appStore.isLoggedIn) {
    callback.call();
  } else {
    SignInScreen(returnExpected: true).launch(context).then((value) {
      if (value ?? false) {
        callback.call();
      }
    });
  }
}

Widget get trailing {
  return ic_arrow_right.iconImage(size: 16);
}

void showNewUpdateDialog(BuildContext context, {required int currentAppVersionCode}) async {
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    barrierDismissible: currentAppVersionCode >= getIntAsync(USER_APP_MINIMUM_VERSION).toInt(),
    builder: (_) {
      return WillPopScope(
        onWillPop: () {
          return Future(() => currentAppVersionCode >= getIntAsync(USER_APP_MINIMUM_VERSION).toInt());
        },
        child: NewUpdateDialog(canClose: currentAppVersionCode >= getIntAsync(USER_APP_MINIMUM_VERSION).toInt()),
      );
    },
  );
}

Future<void> showForceUpdateDialog(BuildContext context) async {
  if (getBoolAsync(UPDATE_NOTIFY, defaultValue: true)) {
    getPackageInfo().then((value) {
      if (isAndroid && getIntAsync(USER_APP_LATEST_VERSION).toInt() > value.versionCode.validate().toInt()) {
        showNewUpdateDialog(context, currentAppVersionCode: value.versionCode.validate().toInt());
      } else if (isIOS && getIntAsync(USER_APP_LATEST_VERSION).toInt() > value.versionCode.validate().toInt()) {
        showNewUpdateDialog(context, currentAppVersionCode: value.versionCode.validate().toInt());
      }
    });
  }
}

bool checkTimeDifference({required DateTime inputDateTime}) {
  DateTime currentTime = DateTime.now();

  log("Booking Time Diffrence ==> ${inputDateTime.difference(currentTime).inHours}");
  if (currentTime.isBefore(inputDateTime) && inputDateTime.difference(currentTime).inHours <= appConfigurationStore.cancellationChargeHours) {
    return true;
  }

  // Check if the current time is after the booking date and time
  if (currentTime.isAfter(inputDateTime)) {
    return false;
  }

  // Otherwise, it's more than 12 hours before the booking time
  return false;
}

String bankAccountWidget(String accountNo) {
  if (accountNo.length <= 4) {
    return accountNo;
  }
  final obscuredPart = '*' * (accountNo.length - 4);
  final visiblePart = accountNo.substring(accountNo.length - 4);
  return obscuredPart + visiblePart;
}

Widget mobileNumberInfoWidget(BuildContext context) {
  return RichTextWidget(
    list: [
      TextSpan(text: '${language.addYourCountryCode}', style: secondaryTextStyle()),
      TextSpan(text: ' "91-", "236-" ', style: boldTextStyle(size: 12)),
      TextSpan(
        text: ' (${language.help})',
        style: boldTextStyle(size: 12, color: primaryColor),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchUrlCustomTab("https://countrycode.org/");
          },
      ),
    ],
  );
}

class OptionListWidget extends StatelessWidget {
  final List<OptionModel> optionList;

  const OptionListWidget({super.key, required this.optionList});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        optionList.length,
        (index) => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: optionList[index].onTap,
              child: Text(
                optionList[index].title,
                style: secondaryTextStyle(
                  color: primaryColor,
                  size: 12,
                  weight: FontWeight.bold,
                ),
              ),
            ),
            8.width,
            Text("|", style: secondaryTextStyle()).visible(optionList.length != index + 1),
            8.width,
          ],
        ),
      ),
    );
  }
}

class OptionModel {
  final String title;
  final Function()? onTap;

  OptionModel({required this.title, required this.onTap});
}

String sumTimes(String time1, String time2) {
  // Parse the time strings into Duration objects
  Duration duration1 = _parseTimeToDuration(time1);
  Duration duration2 = _parseTimeToDuration(time2);

  // Sum the durations
  Duration totalDuration = duration1 + duration2;

  // Convert the total duration back to a formatted time string
  return _formatDurationToTime(totalDuration);
}

Duration _parseTimeToDuration(String time) {
  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = int.parse(parts[2]);

  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

String _formatDurationToTime(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;

  return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}

void share({required String url, required BuildContext context}) {
  if (Platform.isIOS) {
    try {
      final box = context.findRenderObject() as RenderBox?;
      Share.share(url, subject: "", sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } catch (e) {
      log('Failed to share: $e');
    }
  } else {
    Share.share(url);
  }
}

Future<List<File>> getMultipleImageSource({bool isCamera = true}) async {
  final pickedImage = await ImagePicker().pickMultiImage();
  return pickedImage.map((e) => File(e.path)).toList();
}

Future<File> getCameraImage({bool isCamera = true}) async {
  final pickedImage = await ImagePicker().pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
  return File(pickedImage!.path);
}

//region Multi Language Component
class MultiLanguageWidget extends StatelessWidget {
  final Function(LanguageDataModel languageDetails) onTap;

  const MultiLanguageWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(color: context.scaffoldBackgroundColor),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                languageList().length,
                (index) {
                  LanguageDataModel languageData = languageList()[index];
                  return ElevatedButton(
                    onPressed: () {
                      onTap(languageData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appStore.selectedLanguage.languageCode == languageData.languageCode ? primaryColor : context.scaffoldBackgroundColor,
                      elevation: 0,
                      side: BorderSide(width: 1, color: context.iconColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedImageWidget(url: languageData.flag.validate(), height: 16),
                        4.width,
                        Text(languageData.name.validate().toUpperCase(), style: secondaryTextStyle(color: appStore.selectedLanguage.languageCode == languageData.languageCode ? white : textSecondaryColorGlobal))
                      ],
                    ),
                  ).paddingOnly(right: 8, left: languageList().first.languageCode == languageData.languageCode ? 16 : 0);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
//endregion
