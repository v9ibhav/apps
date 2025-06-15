import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:path/path.dart' as path;
import '../app_configuration.dart';
import '../constant.dart';

const int averageWordsPerMinute = 180;

extension intExt on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? (appStore.isDarkMode ? Colors.white : appTextSecondaryColor),
      errorBuilder: (context, error, stackTrace) => placeHolderWidget(height: size ?? 24, width: size ?? 24, fit: fit ?? BoxFit.cover),
    );
  }

  String toBookingStatus({String? method}) {
    String temp = this.toLowerCase();

    if (temp == BOOKING_PAYMENT_STATUS_ALL) {
      return languages.all;
    } else if (temp == BOOKING_STATUS_PENDING) {
      return languages.pending;
    } else if (temp == BOOKING_STATUS_ACCEPT) {
      return languages.accepted;
    } else if (temp == BOOKING_STATUS_ON_GOING) {
      return languages.onGoing;
    } else if (temp == BOOKING_STATUS_IN_PROGRESS) {
      return languages.inProgress;
    } else if (temp == BOOKING_STATUS_HOLD) {
      return languages.hold;
    } else if (temp == BOOKING_STATUS_CANCELLED) {
      return languages.cancelled;
    } else if (temp == BOOKING_STATUS_REJECTED) {
      return languages.rejected;
    } else if (temp == BOOKING_STATUS_FAILED) {
      return languages.failed;
    } else if (temp == BOOKING_STATUS_COMPLETED) {
      return languages.completed;
    } else if (temp == BOOKING_STATUS_PENDING_APPROVAL) {
      return languages.pendingApproval;
    } else if (temp == BOOKING_STATUS_WAITING_ADVANCED_PAYMENT) {
      return languages.waiting;
    }

    return this;
  }

  String toPostJobStatus({String? method}) {
    String temp = this.toLowerCase();
    if (temp == JOB_REQUEST_STATUS_REQUESTED) {
      return languages.requested;
    } else if (temp == JOB_REQUEST_STATUS_ACCEPTED) {
      return languages.accepted;
    } else if (temp == JOB_REQUEST_STATUS_ASSIGNED) {
      return languages.assigned;
    }

    return this;
  }

  int getWordsCount() {
    return this.split(' ').length;
  }

  int getEstimatedTimeInMin() {
    return (this.getWordsCount() / averageWordsPerMinute).ceil();
  }

  String get getFileExtension => path.extension(Uri.parse(this).path);

  String get getFileNameWithoutExtension => path.basenameWithoutExtension(Uri.parse(this).path);

  String get getFileName => path.basename(Uri.parse(this).path);

  String get getChatFileName => path.basename(Uri.parse(this).path).replaceFirst("$CHAT_FILES%2F", "");

  String toHelpDeskStatus({String? method}) {
    String temp = this.toLowerCase();
    if (temp == OPEN) {
      return languages.open;
    } else if (temp == CLOSED) {
      return languages.closed;
    }

    return this;
  }

  String toHelpDeskActivityType({String? method}) {
    String temp = this;
    if (temp == ADD_HELP_DESK) {
      return languages.createBy;
    } else if (temp == REPLIED_HELP_DESK) {
      return languages.repliedBy;
    } else if (temp == CLOSED_HELP_DESK) {
      return languages.closedBy;
    }

    return this;
  }

  String toPromotionalBannerStatus({String? method}) {
    String temp = this.toLowerCase();
    if (temp == PROMOTIONAL_BANNER_ACCEPTED) {
      return languages.accepted;
    } else if (temp == PROMOTIONAL_BANNER_PENDING) {
      return languages.pending;
    } else if (temp == PROMOTIONAL_BANNER_REJECT) {
      return languages.rejected;
    }

    return this;
  }

  String toPaymentStatus({String? method}){
    String temp = this.toLowerCase();
    if (temp == PAYMENT_STATUS_PAID) {
      return languages.paid;
    } else if (temp == PAYMENT_STATUS_PENDING) {
      return languages.pending;
    }

    return this;
  }

  String toPromotionalBannerType() {
    String temp = this.toLowerCase();
    if (temp == PROMOTIONAL_TYPE_SERVICE) {
      return languages.lblService;
    } else if (temp == PROMOTIONAL_TYPE_LINK) {
      return languages.link;
    }

    return this;
  }

  String toServiceApprovalStatusText() {
    String temp = this;
    if (temp == SERVICE_ALL) {
      return languages.all;
    } else if (temp == SERVICE_PENDING) {
      return languages.pending;
    } else if (temp == SERVICE_APPROVE) {
      return languages.approved;
    } else if (temp == SERVICE_REJECT) {
      return languages.rejected;
    }

    return this;
  }

  String toBookingFilterSectionType({String? type}) {
    String temp = this;
    if (temp == SERVICE_FILTER) {
      return languages.lblService;
    } else if (temp == DATE_RANGE) {
      return languages.dateRange;
    } else if (temp == CUSTOMER) {
      return languages.customer;
    } else if (temp == PROVIDER.toLowerCase()) {
      return languages.provider;
    } else if (temp == HANDYMAN.toLowerCase()) {
      return languages.handyman;
    } else if (temp == BOOKING_STATUS) {
      return languages.bookingStatus;
    } else if (temp == PAYMENT_TYPE) {
      return languages.paymentType;
    } else if (temp == PAYMENT_STATUS) {
      return languages.paymentStatus;
    }

    return this;
  }

  String get toServiceApprovalStatus {
    if (this.isEmpty)
      return languages.pending;
    else if (this == SERVICE_APPROVE)
      return languages.approved;
    else if (this == SERVICE_PENDING)
      return languages.pending;
    else if (this == SERVICE_REJECT)
      return languages.rejected;
    return languages.pending;
  }

  String get toPaymentMethodText {
    switch (this) {
      case PAYMENT_METHOD_COD:
        return languages.cash;
      case PAYMENT_METHOD_STRIPE:
        return languages.stripe;
      case PAYMENT_METHOD_RAZOR:
        return languages.razorPay;
      case PAYMENT_METHOD_FLUTTER_WAVE:
        return languages.flutterWave;
      case PAYMENT_METHOD_CINETPAY:
        return languages.cinet;
      case PAYMENT_METHOD_SADAD_PAYMENT:
        return languages.sadadPayment;
      case PAYMENT_METHOD_FROM_WALLET:
        return languages.wallet;
      case PAYMENT_METHOD_PAYPAL:
        return languages.payPal;
      case PAYMENT_METHOD_PAYSTACK:
        return languages.payStack;
      case PAYMENT_METHOD_AIRTEL:
        return languages.airtelMoney;
      case PAYMENT_METHOD_PHONEPE:
        return languages.phonePe;
      case PAYMENT_METHOD_PIX:
        return languages.pix;
      case PAYMENT_METHOD_MIDTRANS:
        return languages.midtrans;
      case PAYMENT_METHOD_IN_APP_PURCHASE:
        return languages.inAppPurchase;
      case PAYMENT_METHOD_BANK:
        return languages.bank;
      default:
        return this;
    }
  }
}