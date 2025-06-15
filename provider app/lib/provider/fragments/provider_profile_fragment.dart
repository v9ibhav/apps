import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/auth/change_password_screen.dart';
import 'package:handyman_provider_flutter/auth/edit_profile_screen.dart';
import 'package:handyman_provider_flutter/auth/sign_in_screen.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/theme_selection_dailog.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/bank_details/bank_details.dart';
import 'package:handyman_provider_flutter/provider/blog/view/blog_list_screen.dart';
import 'package:handyman_provider_flutter/provider/components/commission_component.dart';
import 'package:handyman_provider_flutter/provider/handyman_commission_list_screen.dart';
import 'package:handyman_provider_flutter/provider/handyman_list_screen.dart';
import 'package:handyman_provider_flutter/provider/jobRequest/bid_list_screen.dart';
import 'package:handyman_provider_flutter/provider/packages/package_list_screen.dart';
import 'package:handyman_provider_flutter/provider/service_address/service_addresses_screen.dart';
import 'package:handyman_provider_flutter/provider/services/service_list_screen.dart';
import 'package:handyman_provider_flutter/provider/subscription/subscription_history_screen.dart';
import 'package:handyman_provider_flutter/provider/taxes/taxes_screen.dart';
import 'package:handyman_provider_flutter/provider/timeSlots/my_time_slots_screen.dart';
import 'package:handyman_provider_flutter/provider/wallet/wallet_history_screen.dart';
import 'package:handyman_provider_flutter/screens/about_us_screen.dart';
import 'package:handyman_provider_flutter/screens/languages_screen.dart';
import 'package:handyman_provider_flutter/screens/verify_provider_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/switch_push_notification_subscription_component.dart';
import '../../helpDesk/help_desk_list_screen.dart';
import '../earning/handyman_earning_list_screen.dart';
import '../promotional_banner/promotional_banner_list_screen.dart';
import '../services/addons/addon_service_list_screen.dart';

class ProviderProfileFragment extends StatefulWidget {
  final List<UserData>? list;

  ProviderProfileFragment({this.list});

  @override
  ProviderProfileFragmentState createState() => ProviderProfileFragmentState();
}

class ProviderProfileFragmentState extends State<ProviderProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    init();
    afterBuildCreated(() {
      appStore.setLoading(false);
      setStatusBarColor(context.primaryColor);
    });
  }

  Future<void> init() async {
    /// get wallet balance api call
    appStore.setUserWalletAmount();
  }

  @override
  Widget build(BuildContext context) {
    log("appConfigurationStore.isPromotionalBanner===== ${appConfigurationStore.isPromotionalBanner}");
    return Observer(
      builder: (_) {
        return AnimatedScrollView(
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          physics: AlwaysScrollableScrollPhysics(),
          onSwipeRefresh: () async {
            init();
            setState(() {});
            return 1.seconds.delay;
          },
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(),
                backgroundColor: appStore.isDarkMode ? context.cardColor : lightPrimaryColor,
              ),
              child: Row(
                children: [
                  if (appStore.userProfileImage.isNotEmpty)
                    Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        CachedImageWidget(
                          url: appStore.userProfileImage.validate(),
                          height: 66,
                          fit: BoxFit.cover,
                          circle: true,
                        ).paddingBottom(3),
                        Positioned(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: boxDecorationDefault(
                              color: primaryColor,
                              border: Border.all(color: lightPrimaryColor, width: 2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(languages.lblEdit.toUpperCase(), style: secondaryTextStyle(color: whiteColor)),
                          ).onTap(() {
                            EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                          }),
                        ),
                      ],
                    ),
                  24.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        appStore.userFullName,
                        style: boldTextStyle(color: primaryColor, size: 16),
                      ),
                      4.height,
                      Text(appStore.userEmail, style: secondaryTextStyle()),
                    ],
                  ),
                ],
              ),
            ).paddingOnly(left: 16, right: 16, top: 24,).visible(appStore.isLoggedIn),
            if (appStore.earningTypeSubscription && appStore.isPlanSubscribe)
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  backgroundColor: primaryColor,
                ),
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages.lblCurrentPlan, style: secondaryTextStyle(color: whiteColor)),
                        Text(
                          appStore.planTitle.validate().capitalizeFirstLetter(),
                          style: boldTextStyle(color: Colors.yellow),
                        ),
                      ],
                    ),
                    4.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          languages.lblValidTill,
                          style: boldTextStyle(color: whiteColor, fontStyle: FontStyle.italic, size: 12),
                        ),
                        4.width,
                        Text(
                          formatDate(appStore.planEndDate.validate(), format: DATE_FORMAT_2),
                          style: boldTextStyle(color: white, fontStyle: FontStyle.italic, size: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ).onTap(() {
                SubscriptionHistoryScreen().launch(context).then((value) {
                  setState(() {});
                });
              }, overlayColor: WidgetStatePropertyAll(transparentColor)),
            16.height,
            if (getStringAsync(DASHBOARD_COMMISSION).validate().isNotEmpty) ...[
              CommissionComponent(
                commission: Commission.fromJson(jsonDecode(getStringAsync(DASHBOARD_COMMISSION))),
              ),
              16.height,
            ],
            SettingSection(
              title: Text(languages.general, style: boldTextStyle(color: primaryColor)),
              headingDecoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16)),
              ),
              divider: Offstage(),
              items: [
                16.height,
                SettingItemWidget(
                  decoration: BoxDecoration(color: context.cardColor),
                  leading: ic_un_fill_wallet.iconImage(size: 16),
                  title: languages.walletBalance,
                  titleTextStyle: boldTextStyle(size: 12),
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  onTap: () {
                    if (appConfigurationStore.onlinePaymentStatus) {
                      WalletHistoryScreen().launch(context);
                    }
                  },
                  trailing: Text(
                    appStore.userWalletAmount.toPriceFormat(),
                    style: boldTextStyle(color: Colors.green),
                  ),
                ),
                if (appStore.earningTypeSubscription)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(services, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.lblSubscriptionHistory,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 16),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () async {
                      SubscriptionHistoryScreen().launch(context).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                if (rolesAndPermissionStore.serviceList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(services, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.lblServices,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      ServiceListScreen().launch(context);
                    },
                  ),
                if (appStore.userType != USER_TYPE_HANDYMAN && rolesAndPermissionStore.providerDocumentList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_document, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.btnVerifyId,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      VerifyProviderScreen().launch(context);
                    },
                  ),
                if (appStore.userType != USER_TYPE_HANDYMAN && rolesAndPermissionStore.blogList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_blog, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.blogs,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      BlogListScreen().launch(context);
                    },
                  ),
                if (rolesAndPermissionStore.handymanList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(handyman, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.lblAllHandyman,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      HandymanListScreen().launch(context);
                    },
                  ),
                if (appStore.isLoggedIn && rolesAndPermissionStore.helpDeskList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: ic_help_desk.iconImage(size: 16),
                    title: languages.helpDesk,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      HelpDeskListScreen().launch(context);
                    },
                  ),
                if (appStore.userType != USER_TYPE_HANDYMAN && rolesAndPermissionStore.handymanPayout)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_earning, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8)),
                    title: languages.handymanEarningList,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      HandymanEarningListScreen().launch(context);
                    },
                  ),
                  if(rolesAndPermissionStore.handymanTypeList)
                SettingItemWidget(
                  decoration: BoxDecoration(color: context.cardColor),
                  leading: Image.asset(percent_line, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                  title: languages.handymanCommission,
                  titleTextStyle: boldTextStyle(size: 12),
                  trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha:0.8), size: 18),
                  padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                  onTap: () {
                    HandymanCommissionTypeListScreen().launch(context);
                  },
                ),
                if (appConfigurationStore.servicePackageStatus && rolesAndPermissionStore.servicePackageList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_packages, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.packages,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      PackageListScreen().launch(context);
                    },
                  ),
                if (appConfigurationStore.serviceAddonStatus && rolesAndPermissionStore.serviceAddOnList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_addon_service, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.addonServices,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      AddonServiceListScreen().launch(context);
                    },
                  ),
                if (appConfigurationStore.slotServiceStatus)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_time_slots, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.timeSlots,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      MyTimeSlotsScreen().launch(context);
                    },
                  ),
                SettingItemWidget(
                  decoration: BoxDecoration(color: context.cardColor),
                  leading: Image.asset(servicesAddress, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                  title: languages.lblServiceAddress,
                  titleTextStyle: boldTextStyle(size: 12),
                  trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                  padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                  onTap: () {
                    ServiceAddressesScreen().launch(context);
                  },
                ),
                if (rolesAndPermissionStore.postJobList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(list, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.bidList,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      BidListScreen().launch(context);
                    },
                  ),
                if (rolesAndPermissionStore.taxList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_tax, height: 16, width: 14, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.lblTaxes,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      TaxesScreen().launch(context);
                    },
                  ),
                if (appStore.earningTypeCommission)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_wallet_history, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.lblWalletHistory,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      WalletHistoryScreen().launch(context);
                    },
                  ),
                if (rolesAndPermissionStore.bankList)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_card, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                    title: languages.lblBankDetails,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.only(right: 16, left: 16, top: 20),
                    onTap: () {
                      BankDetails().launch(context);
                    },
                  ),
                if (appStore.userType == USER_TYPE_PROVIDER && appConfigurationStore.isPromotionalBanner)
                  SettingItemWidget(
                    decoration: BoxDecoration(color: context.cardColor),
                    leading: Image.asset(ic_promotional_banner, height: 16, width: 16, color: appStore.isDarkMode ? white.withValues(alpha: 0.9) : appTextSecondaryColor.withValues(alpha: 0.8)),
                    title: languages.promotionalBanners,
                    titleTextStyle: boldTextStyle(size: 12),
                    trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    onTap: () {
                      PromotionalBannerListScreen().launch(context);
                    },
                  ),
                SettingItemWidget(
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(16))),
                  title: "",
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.only(right: 16, left: 16, top: 0),
                  onTap: () {},
                ),
                8.height,
              ],
            ).paddingSymmetric(horizontal: 16),
            16.height,
            SettingSection(
              title: Text(languages.other, style: boldTextStyle(color: primaryColor)),
              headingDecoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16)),
              ),
              divider: Offstage(),
              items: [
                8.height,
                SwitchPushNotificationSubscriptionComponent(),
                SettingItemWidget(
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(16)),
                  ),
                  leading: Image.asset(
                    ic_check_update,
                    height: 14,
                    width: 14,
                    color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8),
                  ),
                  title: languages.lblOptionalUpdateNotify,
                  titleTextStyle: boldTextStyle(size: 12),
                  padding: EdgeInsets.only(bottom: 16, right: 16, left: 16, top: 20),
                  trailing: Transform.scale(
                    scale: 0.6,
                    child: Switch.adaptive(
                      value: getBoolAsync(UPDATE_NOTIFY, defaultValue: true),
                      onChanged: (v) {
                        setValue(UPDATE_NOTIFY, v);
                        setState(() {});
                      },
                    ).withHeight(16),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            16.height,
            SettingSection(
              title: Text(languages.setting, style: boldTextStyle(color: primaryColor)),
              headingDecoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16)),
              ),
              divider: Offstage(),
              items: [
                8.height,
                SettingItemWidget(
                  decoration: BoxDecoration(color: context.cardColor),
                  leading: Image.asset(ic_theme, height: 16, width: 14, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                  title: languages.appTheme,
                  titleTextStyle: boldTextStyle(size: 12),
                  trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                  padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                  onTap: () async {
                    await showInDialog(
                      context,
                      builder: (context) => ThemeSelectionDaiLog(context),
                      contentPadding: EdgeInsets.zero,
                    );
                  },
                ),
                SettingItemWidget(
                  decoration: BoxDecoration(color: context.cardColor),
                  leading: Image.asset(language, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                  title: languages.language,
                  titleTextStyle: boldTextStyle(size: 12),
                  trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                  padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                  onTap: () {
                    LanguagesScreen().launch(context);
                  },
                ),
                SettingItemWidget(
                  decoration: BoxDecoration(color: context.cardColor),
                  leading: Image.asset(changePassword, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                  title: languages.changePassword,
                  titleTextStyle: boldTextStyle(size: 12),
                  trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                  padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                  onTap: () {
                    ChangePasswordScreen().launch(context);
                  },
                ),
                SettingItemWidget(
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(16))),
                  leading: Image.asset(about, height: 16, width: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                  title: languages.lblAbout,
                  titleTextStyle: boldTextStyle(size: 12),
                  trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withValues(alpha: 0.8), size: 18),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.only(bottom: 16, right: 16, left: 16, top: 20),
                  onTap: () {
                    AboutUsScreen().launch(context);
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            16.height,
            SettingSection(
              title: Text(languages.lblDangerZone.toUpperCase(), style: boldTextStyle(color: redColor)),
              headingDecoration: BoxDecoration(color: redColor.withValues(alpha: 0.08), borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16))),
              divider: Offstage(),
              items: [
                8.height,
                SettingItemWidget(
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(16))),
                  leading: ic_delete_account.iconImage(size: 16, color: appStore.isDarkMode ? white : appTextSecondaryColor),
                  paddingBeforeTrailing: 4,
                  title: languages.lblDeleteAccount,
                  titleTextStyle: boldTextStyle(size: 12),
                  padding: EdgeInsets.only(bottom: 16, right: 16, left: 16, top: 20),
                  onTap: () {
                    showConfirmDialogCustom(
                      context,
                      negativeText: languages.lblCancel,
                      positiveText: languages.lblDelete,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          appStore.setLoading(true);

                          deleteAccountCompletely().then((value) async {
                            if (appStore.uid != "") {
                              await userService.removeDocument(appStore.uid);
                              await userService.deleteUser();
                            }
                            appStore.setLoading(false);

                            await clearPreferences();
                            toast(value.message);

                            push(SignInScreen(), isNewTask: true);
                          }).catchError((e) {
                            appStore.setLoading(false);
                            toast(e.toString());
                          });
                        });
                      },
                      dialogType: DialogType.DELETE,
                      title: languages.lblDeleteAccountConformation,
                    );
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            16.height,
            TextButton(
              child: Text(languages.logout, style: boldTextStyle(color: primaryColor, size: 16)),
              onPressed: () {
                appStore.setLoading(false);
                logout(context);
              },
            ).center().visible(appStore.isLoggedIn),
            VersionInfoWidget(prefixText: 'v', textStyle: secondaryTextStyle()).center(),
            16.height,
          ],
        );
      },
    );
  }
}