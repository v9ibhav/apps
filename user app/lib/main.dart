import 'package:booking_system_flutter/app_theme.dart';
import 'package:booking_system_flutter/locale/app_localizations.dart';
import 'package:booking_system_flutter/locale/language_en.dart';
import 'package:booking_system_flutter/locale/languages.dart';
import 'package:booking_system_flutter/model/booking_detail_model.dart';
import 'package:booking_system_flutter/model/get_my_post_job_list_response.dart';
import 'package:booking_system_flutter/model/material_you_model.dart';
import 'package:booking_system_flutter/model/notification_model.dart';
import 'package:booking_system_flutter/model/provider_info_response.dart';
import 'package:booking_system_flutter/model/remote_config_data_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/model/user_wallet_history.dart';
import 'package:booking_system_flutter/screens/blog/model/blog_detail_response.dart';
import 'package:booking_system_flutter/screens/blog/model/blog_response_model.dart';
import 'package:booking_system_flutter/screens/helpDesk/model/help_desk_response.dart';
import 'package:booking_system_flutter/screens/splash_screen.dart';
import 'package:booking_system_flutter/services/auth_services.dart';
import 'package:booking_system_flutter/services/chat_services.dart';
import 'package:booking_system_flutter/services/user_services.dart';
import 'package:booking_system_flutter/store/app_configuration_store.dart';
import 'package:booking_system_flutter/store/app_store.dart';
import 'package:booking_system_flutter/store/filter_store.dart';
import 'package:booking_system_flutter/store/roles_and_permission_store.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/firebase_messaging_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'model/bank_list_response.dart';
import 'model/booking_data_model.dart';
import 'model/booking_status_model.dart';
import 'model/category_model.dart';
import 'model/coupon_list_model.dart';
import 'model/dashboard_model.dart';

//region Handle Background Firebase Message
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Message Data : ${message.data}');
  await Firebase.initializeApp().then((value) {}).catchError((e) {});
}

//endregion
//region Mobx Stores
AppStore appStore = AppStore();
FilterStore filterStore = FilterStore();
AppConfigurationStore appConfigurationStore = AppConfigurationStore();
RolesAndPermissionStore rolesAndPermissionStore = RolesAndPermissionStore();
//endregion

//region Global Variables
BaseLanguage language = LanguageEn();
//endregion

//region Services
UserService userService = UserService();
AuthService authService = AuthService();
ChatServices chatServices = ChatServices();
RemoteConfigDataModel remoteConfigDataModel = RemoteConfigDataModel();
//endregion

//region Cached Response Variables for Dashboard Tabs
DashboardResponse? cachedDashboardResponse;
List<BookingData>? cachedBookingList;
List<CategoryData>? cachedCategoryList;
List<BookingStatusResponse>? cachedBookingStatusDropdown;
List<PostJobData>? cachedPostJobList;
List<WalletDataElement>? cachedWalletHistoryList;

List<ServiceData>? cachedServiceFavList;
List<UserData>? cachedProviderFavList;
List<UserData>? cachedHandymanList;
List<BlogData>? cachedBlogList;
List<RatingData>? cachedRatingList;
List<HelpDeskListData>? cachedHelpDeskListData;
List<NotificationData>? cachedNotificationList;
CouponListResponse? cachedCouponListResponse;
List<BankHistory>? cachedBankList;
List<(int blogId, BlogDetailResponse list)?> cachedBlogDetail = [];
List<(int serviceId, ServiceDetailResponse list)?> listOfCachedData = [];
List<(int providerId, ProviderInfoResponse list)?> cachedProviderList = [];
List<(int categoryId, List<CategoryData> list)?> cachedSubcategoryList = [];
List<(int bookingId, BookingDetailResponse list)?> cachedBookingDetailList = [];
//endregion

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    /// Firebase Notification
    initFirebaseMessaging();
    if (kReleaseMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
  });

  passwordLengthGlobal = 6;
  appButtonBackgroundColorGlobal = primaryColor;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultRadius = 12;
  defaultBlurRadius = 0;
  defaultSpreadRadius = 0;
  textSecondaryColorGlobal = appTextSecondaryColor;
  textPrimaryColorGlobal = appTextPrimaryColor;
  defaultAppButtonElevation = 0;
  pageRouteTransitionDurationGlobal = 400.milliseconds;
  textBoldSizeGlobal = 14;
  textPrimarySizeGlobal = 14;
  textSecondarySizeGlobal = 12;

  await initialize();
  localeLanguageList = languageList();

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
  if (themeModeIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }

  defaultToastBackgroundColor = appStore.isDarkMode ? Colors.white : Colors.black;
  defaultToastTextColor = appStore.isDarkMode ? Colors.black : Colors.white;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Observer(
        builder: (_) => FutureBuilder<Color>(
          future: getMaterialYouData(),
          builder: (_, snap) {
            return Observer(
              builder: (_) => MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                home: SplashScreen(),
                theme: AppTheme.lightTheme(color: snap.data),
                darkTheme: AppTheme.darkTheme(color: snap.data),
                themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                title: APP_NAME,
                supportedLocales: LanguageDataModel.languageLocales(),
                localizationsDelegates: [
                  AppLocalizations(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                builder: (context, child) {
                  return MediaQuery(
                    child: child!,
                    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
                  );
                },
                localeResolutionCallback: (locale, supportedLocales) => locale,
                locale: Locale(appStore.selectedLanguageCode),
              ),
            );
          },
        ),
      ),
    );
  }
}