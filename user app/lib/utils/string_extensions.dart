import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'constant.dart';

extension strEtx on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? (appStore.isDarkMode ? Colors.white : appTextSecondaryColor),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(ic_no_photo, height: size ?? 24, width: size ?? 24);
      },
    );
  }

  Color get getPaymentStatusBackgroundColor {
    switch (this) {
      case BOOKING_STATUS_PENDING:
        return pending;
      case BOOKING_STATUS_ACCEPT:
        return accept;
      case BOOKING_STATUS_ON_GOING:
        return on_going;
      case BOOKING_STATUS_IN_PROGRESS:
        return in_progress;
      case BOOKING_STATUS_HOLD:
        return hold;
      case BOOKING_STATUS_CANCELLED:
        return cancelled;
      case BOOKING_STATUS_REJECTED:
        return rejected;
      case BOOKING_STATUS_FAILED:
        return failed;
      case BOOKING_STATUS_COMPLETED:
        return completed;
      case BOOKING_STATUS_PENDING_APPROVAL:
        return pendingApprovalColor;
      case BOOKING_STATUS_WAITING_ADVANCED_PAYMENT:
        return waiting;

      default:
        return defaultStatus;
    }
  }

  Color get getBookingActivityStatusColor {
    switch (this.validate().replaceAll(' ', '_').toLowerCase()) {
      case ADD_BOOKING:
        return add_booking;
      case ASSIGNED_BOOKING:
        return assigned_booking;
      case TRANSFER_BOOKING:
        return transfer_booking;
      case UPDATE_BOOKING_STATUS:
        return update_booking_status;
      case CANCEL_BOOKING:
        return cancel_booking;
      case PAYMENT_MESSAGE_STATUS:
        return payment_message_status;

      default:
        return defaultActivityStatus;
    }
  }

  Color get getJobStatusColor {
    switch (this) {
      case BOOKING_STATUS_PENDING:
        return pending;
      case BOOKING_STATUS_ACCEPT:
        return accept;
      case BOOKING_STATUS_ON_GOING:
        return on_going;
      case BOOKING_STATUS_IN_PROGRESS:
        return in_progress;
      case BOOKING_STATUS_HOLD:
        return hold;
      case BOOKING_STATUS_CANCELLED:
        return cancelled;
      case BOOKING_STATUS_REJECTED:
        return rejected;
      case BOOKING_STATUS_FAILED:
        return failed;
      case BOOKING_STATUS_COMPLETED:
        return completed;
      case BOOKING_STATUS_PENDING_APPROVAL:
        return pendingApprovalColor;
      case BOOKING_STATUS_WAITING_ADVANCED_PAYMENT:
        return waiting;

      default:
        return defaultStatus;
    }
  }

  Color get getHelpDeskStatusBackgroundColor {
    switch (this) {
      case OPEN:
        return completed;
      case CLOSED:
        return pending;

      default:
        return defaultStatus;
    }
  }

  String toBookingStatus({String? method}) {
    String temp = this.toLowerCase();

    if (temp == BOOKING_TYPE_ALL) {
      return language.lblAll;
    } else if (temp == BOOKING_STATUS_PENDING) {
      return language.lblPending;
    } else if (temp == BOOKING_STATUS_ACCEPT) {
      return language.accepted;
    } else if (temp == BOOKING_STATUS_ON_GOING) {
      return language.onGoing;
    } else if (temp == BOOKING_STATUS_IN_PROGRESS) {
      return language.inProgress;
    } else if (temp == BOOKING_STATUS_HOLD) {
      return language.lblHold;
    } else if (temp == BOOKING_STATUS_CANCELLED) {
      return language.cancelled;
    } else if (temp == BOOKING_STATUS_REJECTED) {
      return language.rejected;
    } else if (temp == BOOKING_STATUS_FAILED) {
      return language.failed;
    } else if (temp == BOOKING_STATUS_COMPLETED) {
      return language.completed;
    } else if (temp == BOOKING_STATUS_PENDING_APPROVAL) {
      return language.pendingApproval;
    } else if (temp == BOOKING_STATUS_WAITING_ADVANCED_PAYMENT) {
      return language.waiting;
    }

    return this;
  }

  String toPostJobStatus({String? method}) {
    String temp = this.toLowerCase();
    if (temp == JOB_REQUEST_STATUS_REQUESTED) {
      return language.requested;
    } else if (temp == JOB_REQUEST_STATUS_ACCEPTED) {
      return language.accepted;
    } else if (temp == JOB_REQUEST_STATUS_ASSIGNED) {
      return language.assigned;
    }

    return this;
  }

  String toHelpDeskStatus({String? method}) {
    String temp = this.toLowerCase();
    if (temp == OPEN) {
      return language.open;
    } else if (temp == CLOSED) {
      return language.closed;
    }

    return this;
  }

  String toHelpDeskActivityType({String? method}) {
    String temp = this;
    if (temp == ADD_HELP_DESK) {
      return language.createBy;
    } else if (temp == REPLIED_HELP_DESK) {
      return language.repliedBy;
    } else if (temp == CLOSED_HELP_DESK) {
      return language.closedBy;
    }

    return this;
  }

  String toBookingFilterSectionType({String? type}) {
    String temp = this;
    if (temp == SERVICE) {
      return language.lblService;
    } else if (temp == DATE_RANGE) {
      return language.dateRange;
    } else if (temp == PROVIDER) {
      return language.textProvider;
    } else if (temp == HANDYMAN) {
      return language.textHandyman;
    } else if (temp == BOOKING_STATUS) {
      return language.bookingStatus;
    } else if (temp == PAYMENT_TYPE) {
      return language.paymentType;
    } else if (temp == PAYMENT_STATUS) {
      return language.paymentStatus;
    }

    return this;
  }
}
