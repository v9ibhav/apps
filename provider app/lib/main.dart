import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/locale/applocalizations.dart';
import 'package:handyman_provider_flutter/locale/base_language.dart';
import 'package:handyman_provider_flutter/locale/language_en.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/notification_list_response.dart';
import 'package:handyman_provider_flutter/models/revenue_chart_data.dart';
import 'package:handyman_provider_flutter/models/service_detail_response.dart';
import 'package:handyman_provider_flutter/models/total_earning_response.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/models/wallet_history_list_response.dart';
import 'package:handyman_provider_flutter/networks/firebase_services/auth_services.dart';
import 'package:handyman_provider_flutter/networks/firebase_services/chat_messages_service.dart';
import 'package:handyman_provider_flutter/networks/firebase_services/notification_service.dart';
import 'package:handyman_provider_flutter/networks/firebase_services/user_services.dart';
import 'package:handyman_provider_flutter/provider/jobRequest/models/post_job_detail_response.dart';
import 'package:handyman_provider_flutter/screens/splash_screen.dart';
import 'package:handyman_provider_flutter/services/in_app_purchase.dart';
import 'package:handyman_provider_flutter/store/AppStore.dart';
import 'package:handyman_provider_flutter/store/filter_store.dart';
import 'package:handyman_provider_flutter/store/roles_and_permission_store.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'app_theme.dart';
import 'helpDesk/model/help_desk_response.dart';
import 'models/bank_list_response.dart';
import 'models/booking_list_response.dart';
import 'models/booking_status_response.dart';
import 'models/dashboard_response.dart';
import 'models/extra_charges_model.dart';
import 'models/handyman_dashboard_response.dart';
import 'models/payment_list_reasponse.dart';
import 'provider/promotional_banner/model/promotional_banner_response.dart';
import 'provider/timeSlots/timeSlotStore/time_slot_store.dart';
import 'store/app_configuration_store.dart';
import 'utils/firebase_messaging_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//region Handle Background Firebase Message
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Message Data : ${message.data}');
  Firebase.initializeApp();
}
//endregion

//region Mobx Stores
AppStore appStore = AppStore();
TimeSlotStore timeSlotStore = TimeSlotStore();
AppConfigurationStore appConfigurationStore = AppConfigurationStore();
FilterStore filterStore = FilterStore();
RolesAndPermissionStore rolesAndPermissionStore = RolesAndPermissionStore();
//endregion

//region Firebase Services
UserService userService = UserService();
AuthService authService = AuthService();

ChatServices chatServices = ChatServices();
NotificationService notificationService = NotificationService();
//endregion

//region In App Purchase Service
InAppPurchaseService inAppPurchaseService=InAppPurchaseService();
//region

//region Global Variables
Languages languages = LanguageEn();
List<RevenueChartData> chartData = [];
List<ExtraChargesModel> chargesList = [];
//endregion

//region Cached Response Variables for Dashboard Tabs
DashboardResponse? cachedProviderDashboardResponse;
HandymanDashBoardResponse? cachedHandymanDashboardResponse;
List<BookingData>? cachedBookingList;
List<PaymentData>? cachedPaymentList;
List<NotificationData>? cachedNotifications;
List<BookingStatusResponse>? cachedBookingStatusDropdown;
List<(int serviceId, ServiceDetailResponse)?> listOfCachedData = [];
List<BookingDetailResponse> cachedBookingDetailList = [];
List<(int postJobId, PostJobDetailResponse)?> cachedPostJobList = [];
List<UserData>? cachedHandymanList;
List<TotalData>? cachedTotalDataList;
List<WalletHistory>? cachedWalletList;
List<BankHistory>? cachedBankList;
List<HelpDeskListData>? cachedHelpDeskListData;
List<PromotionalBannerListData>? cachedPromotionalBannerListData;
//endregion

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();

  if (!isDesktop) {
    Firebase.initializeApp().then((value) {
      if (kReleaseMode) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
      }

      /// Subscribe Firebase Topic
      subscribeToFirebaseTopic();
    }).catchError((e) {
      log(e.toString());
    });
  }
 HttpOverrides.global = MyHttpOverrides();

  defaultSettings();

  localeLanguageList = languageList();

  appStore.setLanguage(
      getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    afterBuildCreated(() {
      int val = getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);

      if (val == THEME_MODE_LIGHT) {
        appStore.setDarkMode(false);
      } else if (val == THEME_MODE_DARK) {
        appStore.setDarkMode(true);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Observer(
        builder: (_) => MaterialApp(
         
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          home: SplashScreen(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}