// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handyman_provider_flutter/components/app_common_dialog.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/basic_info_component.dart';
import 'package:handyman_provider_flutter/components/booking_history_bottom_sheet.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/countdown_widget.dart';
import 'package:handyman_provider_flutter/components/price_common_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/components/review_list_view_component.dart';
import 'package:handyman_provider_flutter/components/view_all_label_component.dart';
import 'package:handyman_provider_flutter/handyman/component/service_proof_list_widget.dart';
import 'package:handyman_provider_flutter/handyman/service_proof_screen.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/package_response.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/extra_charges_model.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/components/assign_handyman_screen.dart';
import 'package:handyman_provider_flutter/provider/handyman_info_screen.dart';
import 'package:handyman_provider_flutter/provider/services/service_detail_screen.dart';
import 'package:handyman_provider_flutter/screens/cash_management/component/cash_confirm_dialog.dart';
import 'package:handyman_provider_flutter/screens/cash_management/view/cash_payment_history_screen.dart';
import 'package:handyman_provider_flutter/screens/extra_charges/add_extra_charges_screen.dart';
import 'package:handyman_provider_flutter/screens/rating_view_all_screen.dart';
import 'package:handyman_provider_flutter/screens/track_location.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/color_extension.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import '../components/base_scaffold_widget.dart';
import '../components/empty_error_state_widget.dart';
import '../models/update_location_response.dart';
import '../provider/services/addons/component/service_addons_component.dart';
import '../utils/images.dart';
import '../utils/permissions.dart';
import 'shimmer/booking_detail_shimmer.dart';

class BookingDetailScreen extends StatefulWidget {
  final int bookingId;

  BookingDetailScreen({required this.bookingId});

  @override
  BookingDetailScreenState createState() => BookingDetailScreenState();
}

class BookingDetailScreenState extends State<BookingDetailScreen> with WidgetsBindingObserver {
  late Future<BookingDetailResponse> future;

  // region Variables
  UniqueKey _paymentUniqueKey = UniqueKey();
  GlobalKey countDownKey = GlobalKey();
  String? startDateTime = '';
  String? endDateTime = '';
  String? timeInterval = '0';
  String? paymentStatus = '';

  bool? confirmPaymentBtn = false;
  bool isCompleted = false;
  bool showBottomActionBar = false;
  UpdateLocationResponse? handymanLocation;
  BitmapDescriptor? customIcon;
  Timer? _locationUpdateTimer;
  Timer? locationTimers;
  bool isLocationLoader = false;
  GoogleMapController? mapController;
  LatLng? _currentPosition;
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  String locationTime = DateTime.now().toString();
  int providerLocationRefreshPeriodInSeconds = 30;
  int handymanUpdateLocationRefreshPeriodInSeconds = 1;
  String bookingStatus = "";
  int handymanId = -1;

  // endregion Variables

  @override
  void initState() {
    init();
    _createCustomMarkerIcon();
    super.initState();
  }

  void init({bool flag = false, bool isStartDrive = false}) async {
    future = bookingDetail({CommonKeys.bookingId: widget.bookingId.toString()}, callbackForStatus: (status, id) async {
      bookingStatus = status;
      handymanId = id;
      afterBuildCreated(() => startLocationUpdates(status: status, handymanID: id, isFirstTimeLoad: true));
    });
    if (flag) {
      _paymentUniqueKey = UniqueKey();
      setState(() {});
    }
  }

  //region Methods
  Future<void> confirmationRequestDialog(BuildContext context, String status, BookingDetailResponse res) async {
    if (status == BookingStatusKeys.complete && res.bookingDetail!.paymentMethod == PAYMENT_METHOD_COD) {
      showInDialog(
        context,
        contentPadding: EdgeInsets.all(0),
        builder: (p0) {
          return AppCommonDialog(
            title: languages.cashPaymentConfirmation,
            child: CashConfirmDialog(
              bookingId: res.bookingDetail!.id.validate(),
              bookingAmount: res.bookingDetail!.totalAmount.validate(),
              onAccept: (String remarks) {
                appStore.setLoading(true);
                finish(context);
                updateBooking(res, '$remarks', BookingStatusKeys.complete);
              },
            ),
          );
        },
      );

      return;
    }
    showConfirmDialogCustom(
      context,
      title: languages.confirmationRequestTxt,
      primaryColor: status == BookingStatusKeys.rejected ? Colors.redAccent : primaryColor,
      positiveText: languages.lblYes,
      negativeText: languages.lblNo,
      onAccept: (context) async {
        if (status == BookingStatusKeys.pending) {
          appStore.setLoading(true);
          updateBooking(res, '', BookingStatusKeys.accept);
        } else if (status == BookingStatusKeys.rejected) {
          appStore.setLoading(true);
          updateBooking(res, '', BookingStatusKeys.rejected);
        } else if (status == BookingStatusKeys.complete) {
          if (res.bookingDetail!.paymentMethod == PAYMENT_METHOD_COD) {
            return;
          }
        }
      },
    );
  }

  Future<void> assignBookingDialog(BuildContext context, int? bookingId, int? addressId) async {
    AssignHandymanScreen(
      bookingId: bookingId,
      serviceAddressId: addressId,
      onUpdate: () {
        appStore.setLoading(true);
        init(flag: true);
        if (appStore.isLoading) appStore.setLoading(false);
      },
    ).launch(context);
  }

  Future<void> updateBooking(BookingDetailResponse bookDetail, String updateReason, String updatedStatus) async {
    DateTime now = DateTime.now();
    if (updatedStatus == BookingStatusKeys.inProgress) {
      startDateTime = DateFormat(BOOKING_SAVE_FORMAT).format(now);
      endDateTime = bookDetail.bookingDetail!.endAt.validate();
      timeInterval = bookDetail.bookingDetail!.durationDiff.validate().isEmptyOrNull ? "0" : bookDetail.bookingDetail!.durationDiff.validate();
      paymentStatus = bookDetail.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : bookDetail.bookingDetail!.paymentStatus.validate();
      //
    } else if (updatedStatus == BookingStatusKeys.hold) {
      String? currentDateTime = DateFormat(BOOKING_SAVE_FORMAT).format(now);
      startDateTime = bookDetail.bookingDetail!.startAt.validate();
      endDateTime = currentDateTime;
      var diff = DateTime.parse(currentDateTime).difference(DateTime.parse(bookDetail.bookingDetail!.startAt.validate())).inMinutes;
      num count = int.parse(bookDetail.bookingDetail!.durationDiff.validate()) + diff;
      timeInterval = count.toString();
      paymentStatus = bookDetail.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : bookDetail.bookingDetail!.paymentStatus.validate();
    } else if (updatedStatus == BookingStatusKeys.pendingApproval) {
      startDateTime = bookDetail.bookingDetail!.startAt.toString();
      endDateTime = bookDetail.bookingDetail!.endAt.toString();
      timeInterval = bookDetail.bookingDetail!.durationDiff.validate();
      paymentStatus = bookDetail.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : bookDetail.bookingDetail!.paymentStatus.validate();
    } else if (updatedStatus == BookingStatusKeys.complete) {
      if (bookDetail.bookingDetail!.paymentStatus == PENDING && bookDetail.bookingDetail!.paymentMethod == PAYMENT_METHOD_COD) {
        startDateTime = bookDetail.bookingDetail!.startAt.toString();
        endDateTime = bookDetail.bookingDetail!.endAt.toString();
        timeInterval = bookDetail.bookingDetail!.durationDiff.validate();
        paymentStatus = PENDING_BY_ADMINS;
        confirmPaymentBtn = false;
        isCompleted = true;
      } else {
        endDateTime = DateFormat(BOOKING_SAVE_FORMAT).format(now);
        startDateTime = bookDetail.bookingDetail!.startAt.validate();
        var diff = DateTime.parse(endDateTime.validate()).difference(DateTime.parse(bookDetail.bookingDetail!.startAt.validate())).inMinutes;
        num count = int.parse(bookDetail.bookingDetail!.durationDiff.validate()) + diff;
        timeInterval = count.toString();
        paymentStatus = bookDetail.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : bookDetail.bookingDetail!.paymentStatus.validate();
      }
      //
    } else if (updatedStatus == BookingStatusKeys.rejected || updatedStatus == BookingStatusKeys.cancelled) {
      startDateTime = bookDetail.bookingDetail!.startAt.validate().isNotEmpty ? bookDetail.bookingDetail!.startAt.validate() : bookDetail.bookingDetail!.date.validate();
      endDateTime = DateFormat(BOOKING_SAVE_FORMAT).format(now);
      timeInterval = bookDetail.bookingDetail!.durationDiff.toString();
      paymentStatus = bookDetail.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : bookDetail.bookingDetail!.paymentStatus.validate();
      //
    } else {
      paymentStatus = bookDetail.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : bookDetail.bookingDetail!.paymentStatus.validate();
    }
    countDownKey = GlobalKey();
    setState(() {});

    hideKeyboard(context);

    var request = {
      CommonKeys.id: bookDetail.bookingDetail!.id,
      BookingUpdateKeys.startAt: startDateTime,
      BookingUpdateKeys.endAt: endDateTime,
      BookingUpdateKeys.durationDiff: timeInterval,
      BookingUpdateKeys.reason: updateReason,
      BookingUpdateKeys.status: updatedStatus,
      BookingUpdateKeys.paymentStatus: paymentStatus
    };

    await bookingUpdate(request).then((res) async {
      // if (paymentStatus == PENDING_BY_ADMINS) {
      //   finish(context);
      // }
      init(flag: true, isStartDrive: updatedStatus == BookingStatusKeys.onGoing ? true : false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  String? latitude;
  String? longitude;

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    } catch (e) {
      appStore.setLoading(false);
    }
  }

  Future<void> setLocation() async {
    await getLocation();
    await updateLocation(widget.bookingId, latitude ?? "", longitude ?? "").then((value) async {
      handymanLocation = value;
      locationTime = "${DateTime.parse(value.data.datetime.toString()).timeAgo}";
      locationTimer();
      setState(() {});
    }).catchError((error) {
      toast(error.toString());
    }).whenComplete(() {});
  }

  locationTimer() {
    locationTimers?.cancel();
    locationTimers = Timer.periodic(Duration(seconds: handymanUpdateLocationRefreshPeriodInSeconds), (Timer timer) {
      locationTime = "${DateTime.parse(handymanLocation?.data.datetime.toString() ?? DateTime.now().toString()).timeAgo}";
      setState(() {});
    });
  }

  void _handlePendingApproval({
    required BookingDetailResponse val,
    bool isAddExtraCharges = false,
    bool isEditExtraCharges = false,
  }) async {
    appStore.setLoading(true);

    Map req = isEditExtraCharges
        ? {
            CommonKeys.id: val.bookingDetail!.id.validate(),
            BookingUpdateKeys.durationDiff: val.bookingDetail!.durationDiff.toInt(),
            BookingUpdateKeys.paymentStatus: val.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : val.bookingDetail!.paymentStatus.validate(),
            BookingUpdateKeys.status: BookingStatusKeys.complete,
          }
        : {
            CommonKeys.id: val.bookingDetail!.id.validate(),
            BookingUpdateKeys.startAt: val.bookingDetail!.startAt.toString(),
            BookingUpdateKeys.endAt: val.bookingDetail!.endAt.toString(),
            BookingUpdateKeys.status: BookingStatusKeys.complete,
            BookingUpdateKeys.durationDiff: val.bookingDetail!.durationDiff.toInt(),
            BookingUpdateKeys.paymentStatus: val.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : val.bookingDetail!.paymentStatus.validate(),
          };

    if (chargesList.isNotEmpty && isAddExtraCharges) {
      List<Map<String, dynamic>> charges = [];

      chargesList.forEach((element) {
        charges.add({
          "title": element.title.validate(),
          "qty": element.qty.validate(),
          "price": element.price.validate(),
        });
      });
      req.putIfAbsent(BookingServiceKeys.extraCharges, () => charges);
    }

    if (chargesList.isNotEmpty && isEditExtraCharges) {
      List<Map<String, dynamic>> charges = [];

      chargesList.forEach((element) {
        charges.add({
          "id": element.id.validate(),
          "title": element.title.validate(),
          "qty": element.qty.validate(),
          "price": element.price.validate(),
        });
      });
      req.putIfAbsent(BookingServiceKeys.extraCharges, () => charges);
    }

    await bookingUpdate(req).then((res) async {
      //
      init(flag: true);
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> _createCustomMarkerIcon() async {
    final ImageConfiguration imageConfiguration = ImageConfiguration(size: Size(24, 24));
    // ignore: deprecated_member_use
    customIcon = await BitmapDescriptor.fromAssetImage(
      imageConfiguration,
      indicator_2,
    );
  }

  Future<void> _getCurrentLocation({required bool isFirstTime}) async {
    await getHandymanLocation(widget.bookingId).then((value) {
      handymanLocation = value;
      setState(() {});
      if (value != null && value.data.latitude != null && value.data.longitude != null) {
        setState(() {
          if (isFirstTime) {
            locationTime = DateTime.parse(value.data.datetime.toString()).timeAgo;
          }
          _currentPosition = LatLng(
            double.parse(value.data.latitude.toString()),
            double.parse(value.data.longitude.toString()),
          );
          if (mapController != null) {
            mapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _currentPosition!,
                zoom: 15.0,
              ),
            ));
          }
        });
      } else {
        _currentPosition = LatLng(0, 0);
      }
    });
  }

  void startLocationUpdates({required String status, required int handymanID, bool isFirstTimeLoad = false}) async {
    if (bookingStatus == BookingStatusKeys.onGoing) {
      bool isPermenetlyDenied = await PermissionHandlerPlatform.instance.checkPermissionStatus(Permission.locationAlways) == PermissionStatus.permanentlyDenied ||
          await PermissionHandlerPlatform.instance.checkPermissionStatus(Permission.location) == PermissionStatus.permanentlyDenied ||
          await PermissionHandlerPlatform.instance.checkPermissionStatus(Permission.locationWhenInUse) == PermissionStatus.permanentlyDenied;
      if (isPermenetlyDenied && isUserTypeProvider && handymanID != appStore.userId) {
        stopLocationUpdates();
        showConfirmDialogCustom(
          context,
          title: languages.youHavePermanentlyDenied,
          primaryColor: primaryColor,
          positiveText: languages.lblYes,
          negativeText: languages.lblNo,
          onAccept: (context) async {
            openAppSettings();
          },
        );
      } else if (await Permissions.locationPermissionsGranted()) {
        if (isFirstTimeLoad) {
          await refreshProviderAndHandymanLocation(status: status, handymanID: handymanID);
        }
        if (_locationUpdateTimer == null || !_locationUpdateTimer!.isActive) {
          _locationUpdateTimer = Timer.periodic(
            Duration(seconds: providerLocationRefreshPeriodInSeconds),
            (Timer timer) async {
              refreshProviderAndHandymanLocation(status: status, handymanID: handymanID);
            },
          );
        }
      }
    } else {
      stopLocationUpdates();
    }
  }

  refreshProviderAndHandymanLocation({required String status, required int handymanID}) async {
    if (status == BookingStatusKeys.onGoing && isUserTypeHandyman) {
      await setLocation();
    } else if (status == BookingStatusKeys.onGoing && isUserTypeProvider) {
      if (handymanID == appStore.userId) {
        await setLocation();
      } else if (handymanID != appStore.userId && handymanID != -1) {
        await _getCurrentLocation(isFirstTime: true);
      } else {
        stopLocationUpdates();
      }
    } else {
      stopLocationUpdates();
    }
  }

  shareComponent() {
    String url = 'https://www.google.com/maps/search/?api=1&query=${handymanLocation?.data.latitude},${handymanLocation?.data.longitude}';
    share(url: url, context: context);
  }

  void stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
    locationTimers?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      stopLocationUpdates();
    } else if (state == AppLifecycleState.resumed) {
      startLocationUpdates(status: bookingStatus, handymanID: handymanId);
    }
  }

  BookingDetailResponse? initialData() {
    if (cachedBookingDetailList.any((element) => element.bookingDetail!.id == widget.bookingId.validate())) {
      return cachedBookingDetailList.firstWhere((element) => element.bookingDetail!.id == widget.bookingId);
    }
    return null;
  }

  String getDateTimeText(BookingData bookingDetail) {
    String dateTimeText = formatDate(bookingDetail.date.validate(), format: DATE_FORMAT_2);
    if (bookingDetail.bookingSlot == null) {
      return '${dateTimeText} at ${formatDate(bookingDetail.date.validate(), isTime: true)}';
    } else
      return '${dateTimeText} at ${formatDate(getSlotWithDate(date: bookingDetail.date.validate(), slotTime: bookingDetail.bookingSlot.validate()), isTime: true)}';
  }

  //endregion

  //region Components
  Widget _serviceDetailWidget({required BookingDetailResponse bookingResponse}) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: boxDecorationDefault(
              color: primaryColor,
              borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languages.lblBookingID,
                  style: boldTextStyle(size: LABEL_TEXT_SIZE, color: Colors.white),
                ),
                Text('#' + bookingResponse.bookingDetail!.id.toString().validate(), style: boldTextStyle(color: Colors.white, size: 16)),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 8),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (bookingResponse.bookingDetail!.isPostJob || bookingResponse.bookingDetail!.isPackageBooking) {
                    //
                  } else {
                    ServiceDetailScreen(serviceId: bookingResponse.bookingDetail!.serviceId.validate()).launch(context);
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (bookingResponse.service!.attchments!.isNotEmpty && !bookingResponse.bookingDetail!.isPackageBooking)
                      CachedImageWidget(
                        url: bookingResponse.service!.attchments!.isNotEmpty ? bookingResponse.service!.attchments!.first.url.validate() : "",
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                        radius: 8,
                      )
                    else
                      CachedImageWidget(
                        url: bookingResponse.bookingDetail!.bookingPackage != null
                            ? bookingResponse.bookingDetail!.bookingPackage!.imageAttachments.validate().isNotEmpty
                                ? bookingResponse.bookingDetail!.bookingPackage!.imageAttachments.validate().first.validate().isNotEmpty
                                    ? bookingResponse.bookingDetail!.bookingPackage!.imageAttachments.validate().first.validate()
                                    : ''
                                : ''
                            : '',
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                        radius: 8,
                      ),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (bookingResponse.bookingDetail!.isPackageBooking)
                          Text(
                            bookingResponse.bookingDetail!.bookingPackage!.name.validate(),
                            style: boldTextStyle(size: LABEL_TEXT_SIZE),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            bookingResponse.bookingDetail!.serviceName.validate(),
                            style: boldTextStyle(size: LABEL_TEXT_SIZE),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        8.height,
                        if (bookingResponse.bookingDetail!.bookingPackage != null)
                          PriceWidget(
                            price: bookingResponse.bookingDetail!.totalAmount.validate(),
                            color: primaryColor,
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PriceWidget(
                                isFreeService: bookingResponse.bookingDetail!.type == SERVICE_TYPE_FREE,
                                price: bookingResponse.bookingDetail!.amount.validate(),
                                color: primaryColor,
                                isHourlyService: bookingResponse.bookingDetail!.isHourlyService,
                              ),
                              if (bookingResponse.bookingDetail!.discount.validate() != 0)
                                Text(
                                  '(${bookingResponse.bookingDetail!.discount.validate()}% ${languages.lblOff})',
                                  style: boldTextStyle(size: 12, color: Colors.green),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ).paddingLeft(4).expand(),
                            ],
                          ),
                      ],
                    ).expand()
                  ],
                ).paddingSymmetric(horizontal: 16),
              ),
              if (bookingResponse.bookingDetail!.description.validate().isNotEmpty) ...[
                16.height,
                ReadMoreText(
                  trimLength: 65,
                  bookingResponse.bookingDetail!.description.validate(),
                  style: secondaryTextStyle(),
                  colorClickableText: context.primaryColor,
                ).paddingSymmetric(horizontal: 16)
              ],
              if (bookingResponse.bookingDetail!.status != BookingStatusKeys.pending && bookingResponse.bookingDetail!.date.validate().isNotEmpty) ...[
                16.height,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: appStore.isDarkMode ? context.cardColor : whiteColor,
                    border: Border.all(color: context.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${languages.lblDate} & ${languages.lblTime}:',
                        style: secondaryTextStyle(),
                      ).expand(flex: 2),
                      8.width,
                      Marquee(
                        child: Text(
                          getDateTimeText(bookingResponse.bookingDetail!),
                          style: boldTextStyle(size: 12),
                          textAlign: TextAlign.left,
                        ),
                      ).expand(flex: 5),
                    ],
                  ).paddingSymmetric(vertical: 16, horizontal: 16),
                ),
              ],
              Align(
                alignment: bookingResponse.bookingDetail!.status == BookingStatusKeys.pending ? Alignment.centerLeft : Alignment.center,
                child: TextButton(
                  onPressed: () {
                    if (mounted)
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
                        builder: (_) {
                          return DraggableScrollableSheet(
                            initialChildSize: 0.50,
                            minChildSize: 0.2,
                            maxChildSize: 1,
                            builder: (context, scrollController) {
                              return BookingHistoryBottomSheet(
                                data: bookingResponse.bookingActivity!.reversed.toList(),
                                scrollController: scrollController,
                              );
                            },
                          );
                        },
                      );
                  },
                  child: Text(
                    languages.viewStatus,
                    style: boldTextStyle(color: primaryColor, size: 14),
                  ),
                ),
              ),
            ],
          ).paddingOnly(top: 16),
        ],
      ),
    );
  }

  Widget _buildCounterWidget({required BookingDetailResponse value}) {
    if (value.bookingDetail!.isHourlyService &&
        (value.bookingDetail!.status == BookingStatusKeys.inProgress || value.bookingDetail!.status == BookingStatusKeys.hold || value.bookingDetail!.status == BookingStatusKeys.complete || value.bookingDetail!.status == BookingStatusKeys.onGoing))
      return CountdownWidget(bookingDetailResponse: value, key: countDownKey).paddingSymmetric(horizontal: 16);
    else
      return Offstage();
  }

  Widget _buildReasonWidget({required BookingDetailResponse snap}) {
    if ((snap.bookingDetail!.status == BookingStatusKeys.hold || snap.bookingDetail!.status == BookingStatusKeys.cancelled || snap.bookingDetail!.status == BookingStatusKeys.rejected || snap.bookingDetail!.status == BookingStatusKeys.failed) &&
        ((snap.bookingDetail!.reason != null && snap.bookingDetail!.reason!.isNotEmpty)))
      return Container(
        padding: EdgeInsets.only(top: 14, left: 14, bottom: 14),
        color: redColor.withValues(alpha:0.2),
        width: context.width(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${languages.cancelled} ${languages.lblReason.toLowerCase()}: ", style: boldTextStyle(size: 12)),
            Marquee(child: Text(snap.bookingDetail!.reason.validate(), style: boldTextStyle(color: redColor, size: 12))).expand(),
          ],
        ),
      );

    return Offstage();
  }

  Widget _customerReviewWidget({required BookingDetailResponse bookingDetailResponse}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bookingDetailResponse.ratingData!.isNotEmpty)
          ViewAllLabel(
            label: '${languages.review} (${bookingDetailResponse.bookingDetail!.totalReview})',
            list: bookingDetailResponse.ratingData!,
            onTap: () {
              RatingViewAllScreen(serviceId: bookingDetailResponse.service!.id!).launch(context);
            },
          ),
        8.height,
        ReviewListViewComponent(
          ratings: bookingDetailResponse.ratingData!,
          padding: EdgeInsets.symmetric(vertical: 6),
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    ).paddingSymmetric(horizontal: 16).visible(bookingDetailResponse.service!.totalRating != null);
  }

  Widget locationTrackWidget({BookingDetailResponse? data}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Text(
          languages.handymanLocation,
          style: boldTextStyle(),
        ),
        4.height,
        Row(
          children: [
            Text("${languages.lastUpdatedAt} ", style: secondaryTextStyle(size: 10)),
            Text(
              "${DateTime.parse(handymanLocation?.data.datetime.toString() ?? DateTime.now().toString()).timeAgo}",
              style: primaryTextStyle(size: 10),
            ),
          ],
        ).visible(handymanLocation?.data.datetime.isNotEmpty ?? false),
        12.height,
        Container(
          height: 250,
          decoration: boxDecorationDefault(),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _initialLocation,
                mapType: MapType.normal,
                minMaxZoomPreference: MinMaxZoomPreference(1, 40),
                gestureRecognizers: Set()
                  ..add(Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer()))
                  ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                  ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                  ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                  ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
                onMapCreated: (GoogleMapController controller) {
                  print("Map created");
                  mapController = controller;
                  if (_currentPosition != null) {
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: _currentPosition!, zoom: 15),
                    ));
                  }
                },
                markers: _currentPosition != null && customIcon != null
                    ? {
                        Marker(
                          markerId: MarkerId('handyman_location'),
                          position: _currentPosition!,
                          icon: customIcon!,
                        ),
                      }
                    : {},
              ),
              Positioned(
                left: 10,
                top: 10,
                child: CupertinoActivityIndicator(color: black).visible(isLocationLoader),
              ),
            ],
          ),
        ),
        10.height,
        Row(
          children: [
            AppButton(
              onTap: () {
                TrackLocation(
                  bookingId: widget.bookingId,
                ).launch(context);
              },
              padding: EdgeInsets.only(top: 0, left: 8, right: 8),
              height: 42,
              color: Color(0xFF39A81D),
              textColor: white,
              text: languages.track,
            ).expand(),
            16.width,
            Container(
              width: 42,
              height: 42,
              padding: EdgeInsets.all(12),
              decoration: boxDecorationDefault(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: CachedImageWidget(
                url: ic_refresh,
                color: textSecondaryColor,
                height: 42,
              ),
            ).onTap(() {
              startLocationUpdates(status: data?.bookingDetail?.status.validate() ?? "", handymanID: data?.handymanData?.first.id.validate() ?? -1);
            }),
            16.width,
            Container(
              width: 42,
              height: 42,
              padding: EdgeInsets.all(12),
              decoration: boxDecorationDefault(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: CachedImageWidget(
                url: ic_share,
                color: textSecondaryColor,
                height: 42,
              ),
            ).onTap(
              () {
                shareComponent();
              },
            ),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }

  Widget myServiceList({required List<ServiceData> serviceList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.height,
        Text(languages.lblMyService, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        8.height,
        AnimatedListView(
          itemCount: serviceList.length,
          shrinkWrap: true,
          listAnimationType: ListAnimationType.FadeIn,
          itemBuilder: (_, i) {
            ServiceData data = serviceList[i];

            return Container(
              width: context.width(),
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
              child: Row(
                children: [
                  CachedImageWidget(
                    url: data.imageAttachments.validate().isNotEmpty ? data.imageAttachments!.first.validate() : "",
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                    radius: defaultRadius,
                  ),
                  16.width,
                  Text(data.name.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                ],
              ),
            );
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget packageWidget({required PackageData package}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(languages.includedInThisPackage, style: boldTextStyle()).paddingSymmetric(horizontal: 16, vertical: 8),
        AnimatedListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          itemCount: package.serviceList!.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (_, i) {
            ServiceData data = package.serviceList![i];

            return Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(),
                backgroundColor: context.cardColor,
                border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedImageWidget(
                    url: data.imageAttachments!.isNotEmpty ? data.imageAttachments!.first.validate() : "",
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    radius: 8,
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name.validate(), style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      4.height,
                      if (data.subCategoryName.validate().isNotEmpty)
                        Marquee(
                          child: Row(
                            children: [
                              Text('${data.categoryName}', style: boldTextStyle(size: 12, color: textSecondaryColorGlobal)),
                              Text('  >  ', style: boldTextStyle(size: 14, color: textSecondaryColorGlobal)),
                              Text('${data.subCategoryName}', style: boldTextStyle(size: 12, color: context.primaryColor)),
                            ],
                          ),
                        )
                      else
                        Text('${data.categoryName}', style: boldTextStyle(size: 12, color: context.primaryColor)),
                      4.height,
                      PriceWidget(
                        price: data.price.validate(),
                        hourlyTextColor: Colors.white,
                        size: 16,
                      ),
                    ],
                  ).flexible()
                ],
              ),
            ).onTap(() {
              ServiceDetailScreen(serviceId: data.id!).launch(context);
            });
          },
        )
      ],
    );
  }

  Widget _action({required BookingDetailResponse res}) {
    showBottomActionBar = false;
    if (isUserTypeProvider) {
      if (res.isMe.validate()) {
        return handleHandyman(res: res);
      } else {
        return handleProvider(res: res);
      }
    } else if (isUserTypeHandyman) {
      return handleHandyman(res: res);
    }

    return Offstage();
  }

  Widget handleProvider({required BookingDetailResponse res}) {
    if (res.bookingDetail!.status == BookingStatusKeys.pending) {
      showBottomActionBar = true;
      return Row(
        children: [
          AppButton(
            text: languages.accept,
            color: context.primaryColor,
            onTap: () async {
              /// If Auto Assign is enabled, Assign to current Provider it self
              if (appConfigurationStore.autoAssignStatus) {
                await showConfirmDialogCustom(
                  context,
                  title: languages.lblAreYouSureYouWantToAssignToYourself,
                  primaryColor: context.primaryColor,
                  positiveText: languages.lblYes,
                  negativeText: languages.lblCancel,
                  onAccept: (c) async {
                    var request = {
                      CommonKeys.id: widget.bookingId.validate(),
                      CommonKeys.handymanId: [appStore.userId.validate()],
                    };
                    appStore.setLoading(true);

                    await assignBooking(request).then((res) async {
                      LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
                      init(flag: true);
                    }).catchError((e) {
                      toast(e.toString());
                    });
                  },
                );
              } else {
                await showConfirmDialogCustom(
                  context,
                  title: languages.wouldYouLikeToAssignThisBooking,
                  primaryColor: primaryColor,
                  positiveText: languages.lblYes,
                  negativeText: languages.lblNo,
                  onAccept: (_) async {
                    var request = {
                      CommonKeys.id: res.bookingDetail!.id.validate(),
                      BookingUpdateKeys.status: BookingStatusKeys.accept,
                      BookingUpdateKeys.paymentStatus: res.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : res.bookingDetail!.paymentStatus.validate(),
                    };
                    appStore.setLoading(true);

                    bookingUpdate(request).then((res) async {
                      LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
                      init(flag: true);
                    }).catchError((e) {
                      toast(e.toString());
                    });
                  },
                );
              }
            },
          ).expand(),
          16.width,
          AppButton(
            text: languages.decline,
            textColor: textPrimaryColorGlobal,
            onTap: () {
              confirmationRequestDialog(context, BookingStatusKeys.rejected, res);
            },
          ).expand(),
        ],
      );
    } else if (res.bookingDetail!.status == BookingStatusKeys.accept) {
      showBottomActionBar = true;

      if (res.handymanData.validate().isEmpty) {
        return AppButton(
          text: languages.lblAssignHandyman,
          color: context.primaryColor,
          onTap: () {
            assignBookingDialog(context, res.bookingDetail!.id, res.bookingDetail!.bookingAddressId);
          },
        );
      } else if (res.handymanData!.isNotEmpty) {
        return Column(
          children: [
            Text('${res.handymanData!.first.displayName.validate()} ${languages.lblAssigned}', style: boldTextStyle()).center(),
            16.height,
            AppButton(
              width: context.width(),
              text: languages.lblReassign,
              color: context.primaryColor,
              onTap: () {
                assignBookingDialog(context, res.bookingDetail!.id, res.bookingDetail!.bookingAddressId);
              },
            ),
          ],
        );
      }
    }

    return Offstage();
  }

  Widget handleHandyman({required BookingDetailResponse res}) {
    if (res.bookingDetail!.status == BookingStatusKeys.accept) {
      showBottomActionBar = true;

      return Container(
        child: Row(
          children: [
            AppButton(
              text: res.service!.isOnlineService.validate() ? languages.start : languages.lblStartDrive,
              color: startDriveButtonColor,
              onTap: () {
                showConfirmDialogCustom(
                  context,
                  title: languages.confirmationRequestTxt,
                  primaryColor: context.primaryColor,
                  positiveText: languages.lblYes,
                  negativeText: languages.lblNo,
                  onAccept: (c) async {
                    appStore.setLoading(true);
                    await updateBooking(
                      res,
                      '',
                      res.service!.isOnlineService.validate() ? BookingStatusKeys.inProgress : BookingStatusKeys.onGoing,
                    );
                    startLocationUpdates(status: res.bookingDetail?.status.validate() ?? "", handymanID: res.handymanData?.first.id.validate() ?? -1);
                  },
                );
              },
            ).expand(),
            16.width,
            AppButton(
              text: languages.decline,
              textColor: textPrimaryColorGlobal,
              onTap: () {
                showConfirmDialogCustom(
                  context,
                  title: languages.confirmationRequestTxt,
                  positiveText: languages.lblYes,
                  negativeText: languages.lblNo,
                  onAccept: (val) {
                    appStore.setLoading(true);
                    updateBooking(res, '', BookingStatusKeys.pending);
                  },
                  primaryColor: context.primaryColor,
                );
              },
            ).expand(),
          ],
        ),
      );
    } else if (res.bookingDetail!.status == BookingStatusKeys.pendingApproval) {
      showBottomActionBar = true;
      return Container(
        child: Row(
          children: [
            AppButton(
              text: languages.lblCompleted,
              textStyle: boldTextStyle(color: white),
              color: context.primaryColor,
              onTap: () {
                bool isAnyServiceAddonUnCompleted = res.bookingDetail!.serviceaddon.validate().any((element) => element.status.getBoolInt() == false);
                showConfirmDialogCustom(
                  context,
                  onAccept: (_) {
                    _handlePendingApproval(val: res, isAddExtraCharges: false);
                  },
                  primaryColor: context.primaryColor,
                  positiveText: languages.lblYes,
                  negativeText: languages.lblNo,
                  subTitle: isAnyServiceAddonUnCompleted ? languages.pleaseNoteThatAllServiceMarkedCompleted : null,
                  title: languages.confirmationRequestTxt,
                );
              },
            ).expand(),
            if (!res.bookingDetail!.isFreeService && res.bookingDetail!.bookingPackage == null)
              AppButton(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  languages.lblAddExtraCharges,
                  style: boldTextStyle(color: Colors.white),
                ).fit(),
                color: addExtraCharge,
                onTap: () async {
                  chargesList.clear();
                  bool? a = await AddExtraChargesScreen().launch(context);

                  if (a ?? false) {
                    _handlePendingApproval(val: res, isAddExtraCharges: true);
                  }
                },
              ).expand(),
          ],
        ),
      );
    } else if (res.bookingDetail!.status == BookingStatusKeys.onGoing) {
      showBottomActionBar = true;

      return Text(languages.lblWaitingForResponse, style: boldTextStyle()).center();
    } else if (res.bookingDetail!.status == BookingStatusKeys.complete) {
      if (res.bookingDetail!.paymentMethod == PAYMENT_METHOD_COD && res.bookingDetail!.paymentStatus == PENDING) {
        showBottomActionBar = true;
        return appStore.isLoading
            ? Offstage()
            : AppButton(
                text: languages.lblConfirmPayment,
                color: context.primaryColor,
                onTap: () {
                  confirmationRequestDialog(context, BookingStatusKeys.complete, res);
                },
              );
      } else if (res.bookingDetail!.paymentStatus == PAID || res.bookingDetail!.paymentStatus == PENDING_BY_ADMINS) {
        showBottomActionBar = true;
        return AppButton(
          text: languages.lblServiceProof,
          color: context.primaryColor,
          onTap: () {
            ServiceProofScreen(bookingDetail: res).launch(context, pageRouteAnimation: PageRouteAnimation.Fade).then((value) {
              init(flag: true);
            });
          },
        );
      }
    } else if (res.bookingDetail!.status == BookingStatusKeys.inProgress) {
      showBottomActionBar = true;

      return Text(res.bookingDetail!.statusLabel.validate(), style: boldTextStyle()).center();
    }
    return Offstage();
  }

  Widget extraChargesWidget({required List<ExtraChargesModel> extraChargesList, required BookingDetailResponse res}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(languages.lblExtraCharges, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
            IconButton(
              style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
              icon: ic_edit_square.iconImage(size: 18),
              visualDensity: VisualDensity.compact,
              onPressed: () async {
                chargesList.clear();
                chargesList.addAll(extraChargesList);
                bool? a = await AddExtraChargesScreen(isFromEditExtraCharge: true).launch(context);

                if (a ?? false) {
                  _handlePendingApproval(val: res, isEditExtraCharges: true);
                }
              },
            ).visible(res.bookingDetail!.paymentStatus != PAID && res.bookingDetail!.paymentStatus != PENDING_BY_ADMINS),
          ],
        ),
        16.height,
        Container(
          decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius()),
          padding: EdgeInsets.all(16),
          child: AnimatedWrap(
            itemCount: extraChargesList.length,
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            runSpacing: 8,
            spacing: 8,
            itemBuilder: (_, i) {
              ExtraChargesModel data = extraChargesList[i];

              return Row(
                children: [
                  Text(data.title.validate(), style: secondaryTextStyle(size: 14)).expand(),
                  16.width,
                  Row(
                    children: [
                      Text('${data.qty} * ${data.price.validate()} = ', style: secondaryTextStyle()),
                      4.width,
                      PriceWidget(price: '${data.price.validate() * data.qty.validate()}'.toDouble(), size: 16, color: textPrimaryColorGlobal, isBoldText: true),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  //endregion

  //region Body
  Widget buildBodyWidget(AsyncSnapshot<BookingDetailResponse> res) {
    if (res.hasError) {
      return NoDataWidget(
        title: res.error.toString(),
        imageWidget: ErrorStateWidget(),
        retryText: languages.reload,
        onRetry: () {
          appStore.setLoading(true);

          init();
          setState(() {});
        },
      );
    } else if (res.hasData) {
      countDownKey = GlobalKey();
      return Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            children: [
              AnimatedScrollView(
                padding: EdgeInsets.only(bottom: 120),
                physics: AlwaysScrollableScrollPhysics(),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Show Reason if booking is canceled
                  _buildReasonWidget(snap: res.data!),

                  /// Booking & Service Details
                  _serviceDetailWidget(bookingResponse: res.data!),

                  /// Total Service Time
                  _buildCounterWidget(value: res.data!),

                  /// Location Tracking
                  locationTrackWidget(data: res.data).visible(BookingStatusKeys.onGoing == res.data!.bookingDetail!.status && !isUserTypeHandyman && res.data!.handymanData![0].id != appStore.userId),

                  /// My Service List
                  if (res.data!.postRequestDetail != null && res.data!.postRequestDetail!.service != null) myServiceList(serviceList: res.data!.postRequestDetail!.service!),

                  /// Package Info if User selected any Package
                  if (res.data!.bookingDetail!.bookingPackage != null) packageWidget(package: res.data!.bookingDetail!.bookingPackage!),

                  /// Service Proof Images
                  ServiceProofListWidget(serviceProofList: res.data!.serviceProof!),

                  /// Last Updated
                  if (BookingStatusKeys.onGoing == res.data!.bookingDetail!.status && res.data!.handymanData![0].id == appStore.userId) 16.height,
                  if (BookingStatusKeys.onGoing == res.data!.bookingDetail!.status && res.data!.handymanData![0].id == appStore.userId)
                    Container(
                      width: context.width(),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      padding: EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 4),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              12.height,
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: languages.lastUpdatedAt, style: secondaryTextStyle(size: 12)),
                                    TextSpan(text: " ${DateTime.parse(handymanLocation?.data.datetime.toString() ?? DateTime.now().toString()).timeAgo}", style: secondaryTextStyle(size: 12)),
                                  ],
                                ),
                              ).paddingOnly(left: 16),
                              TextButton(
                                // iconAlignment: IconAlignment.start,
                                child: Text(languages.updateYourLocation, style: boldTextStyle(size: 12, color: primaryColor)),
                                onPressed: () {
                                  startLocationUpdates(status: res.data?.bookingDetail?.status.validate() ?? "", handymanID: res.data?.handymanData?.first.id.validate() ?? -1);
                                },
                                isSemanticButton: false,
                              ).paddingLeft(3),
                            ],
                          ).expand(),
                          CachedImageWidget(url: img_location, height: 80)
                        ],
                      ),
                    ).paddingOnly(left: 16, right: 16),

                  /// About Handyman Card
                  if (res.data!.handymanData!.isNotEmpty && appStore.userType != USER_TYPE_HANDYMAN)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (res.data!.bookingDetail!.status != BookingStatusKeys.pending) 24.height,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between items
                          children: [
                            Text(languages.lblAboutHandyman, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                            Column(
                              children: res.data!.handymanData!.map(
                                (e) {
                                  return Text(
                                    languages.viewAll,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor, // Adjust color as needed
                                    ),
                                  ).visible(res.data!.bookingDetail!.canCustomerContact && e.id != appStore.userId).onTap(() {
                                    {
                                      HandymanInfoScreen(handymanId: e.id, service: res.data!.service).launch(context).then((value) => null);
                                    }
                                  });
                                },
                              ).toList(),
                            ),
                          ],
                        ),

                        16.height,
                        Container(
                          decoration: boxDecorationDefault(color: context.cardColor),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: res.data!.handymanData!.map(
                              (e) {
                                return BasicInfoComponent(
                                  1,
                                  handymanData: e,
                                  service: res.data!.service,
                                  bookingDetail: res.data!.bookingDetail!,
                                  bookingInfo: res.data!,
                                ).onTap(() {
                                  if (res.data!.bookingDetail!.canCustomerContact && e.id != appStore.userId) {
                                    HandymanInfoScreen(handymanId: e.id, service: res.data!.service).launch(context).then((value) => null);
                                  }
                                });
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ).paddingOnly(left: 16, right: 16),

                  /// About Customer Card
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (res.data!.bookingDetail!.status != BookingStatusKeys.pending) 24.height,
                      aboutCustomerWidget(context: context, bookingDetail: res.data!.bookingDetail),
                      16.height,
                      Container(
                        decoration: boxDecorationDefault(color: context.cardColor),
                        padding: EdgeInsets.all(16),
                        child: BasicInfoComponent(
                          0,
                          customerData: res.data!.customer,
                          service: res.data!.service,
                          bookingDetail: res.data!.bookingDetail,
                        ),
                      ),

                      8.height,

                      ///Add-ons
                      if (res.data!.bookingDetail!.serviceaddon.validate().isNotEmpty)
                        AddonComponent(
                          serviceAddon: res.data!.bookingDetail!.serviceaddon.validate(),
                        ),
                    ],
                  ).paddingOnly(left: 16, right: 16, bottom: 16),

                  /// Price Detail Card
                  if (res.data!.bookingDetail != null && !res.data!.bookingDetail!.isFreeService)
                    PriceCommonWidget(
                      bookingDetail: res.data!.bookingDetail!,
                      serviceDetail: res.data!.service!,
                      taxes: res.data!.bookingDetail!.taxes.validate(),
                      couponData: res.data!.couponData != null ? res.data!.couponData! : null,
                      bookingPackage: res.data!.bookingDetail!.bookingPackage != null ? res.data!.bookingDetail!.bookingPackage : null,
                    ).paddingOnly(bottom: 16, left: 16, right: 16),

                  /// Extra Charges
                  if (res.data!.bookingDetail!.extraCharges.validate().isNotEmpty) extraChargesWidget(extraChargesList: res.data!.bookingDetail!.extraCharges.validate(), res: res.data!).paddingOnly(left: 16, right: 16, bottom: 16),

                  /// Payment Detail Card
                  if (res.data!.bookingDetail!.paymentId != null && res.data!.bookingDetail!.paymentStatus != null && !res.data!.bookingDetail!.isFreeService)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ViewAllLabel(
                          label: languages.lblPaymentDetail,
                          list: [],
                        ),
                        8.height,
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            backgroundColor: context.cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(languages.lblId, style: secondaryTextStyle(size: 14)),
                                  Text("#" + res.data!.bookingDetail!.paymentId.toString(), style: boldTextStyle()),
                                ],
                              ),
                              16.height,
                              if (res.data!.bookingDetail!.paymentMethod.validate().isNotEmpty)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(languages.lblMethod, style: secondaryTextStyle(size: 14)),
                                    Text(
                                      (res.data!.bookingDetail!.paymentMethod != null ? res.data!.bookingDetail!.paymentMethod.toString() : languages.notAvailable).capitalizeFirstLetter(),
                                      style: boldTextStyle(),
                                    ),
                                  ],
                                ),
                              16.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(languages.lblStatus, style: secondaryTextStyle(size: 14)),
                                  Text(
                                    buildPaymentStatusWithMethod(
                                      res.data!.bookingDetail!.paymentStatus.validate(),
                                      res.data!.bookingDetail!.paymentMethod.validate().capitalizeFirstLetter(),
                                    ),
                                    style: boldTextStyle(color: res.data!.bookingDetail!.paymentStatus.validate().getPaymentStatusColor),
                                  ),
                                ],
                              ),
                              16.height,
                              Row(
                                children: [
                                  Text(languages.transactionId, style: secondaryTextStyle(size: 14)),
                                  8.width,
                                  Row(
                                    children: [
                                      Text(res.data!.bookingDetail!.txnId.validate(), textAlign: TextAlign.right, style: boldTextStyle(color: pending), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                                      4.width,
                                      InkWell(
                                        onTap: () async {
                                          await res.data!.bookingDetail!.txnId.validate().copyToClipboard();
                                          toast(languages.copied);
                                        },
                                        child: SizedBox(width: 23, height: 23, child: Icon(Icons.copy, size: 18)),
                                      ),
                                    ],
                                  ).expand(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).paddingOnly(left: 16, right: 16, bottom: 16),

                  CashPaymentHistoryScreen(
                    bookingId: res.data!.bookingDetail!.id.validate().toString(),
                    key: _paymentUniqueKey,
                  ),

                  /// Customer Review Widget
                  if (res.data!.ratingData.validate().isNotEmpty) _customerReviewWidget(bookingDetailResponse: res.data!),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: context.width(),
                  decoration: BoxDecoration(color: context.cardColor),
                  child: _action(res: res.data!),
                  padding: showBottomActionBar ? EdgeInsets.all(16) : EdgeInsets.zero,
                ),
              )
            ],
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      );
    }
    return BookingDetailShimmer();
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookingDetailResponse>(
      future: future,
      initialData: initialData(),
      builder: (context, snap) {
        return RefreshIndicator(
          onRefresh: () async {
            init(flag: true);
            return await 2.seconds.delay;
          },
          child: AppScaffold(
            appBarTitle: snap.hasData ? snap.data!.bookingDetail!.status.validate().toBookingStatus() : "",
            body: buildBodyWidget(snap),
          ),
        );
      },
    );
  }
}
