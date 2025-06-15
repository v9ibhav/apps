import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/screens/cash_management/cash_constant.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constant.dart';

extension colorExt on String {
  Color get getBookingStatusBackgroundColor {
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

  Color get getCashPaymentStatusBackgroundColor {
    Color text = Colors.transparent;
    if (this == APPROVED_BY_HANDYMAN) {
      text = completed;
    } else if (this == SEND_TO_PROVIDER) {
      text = assigned_booking;
    } else if (this == PENDING_BY_PROVIDER) {
      text = add_booking;
    } else if (this == APPROVED_BY_PROVIDER) {
      text = completed;
    } else if (this == PENDING_BY_ADMIN) {
      text = add_booking;
    } else if (this == APPROVED_BY_ADMIN) {
      text = completed;
    } else if (this == SEND_TO_ADMIN) {
      text = assigned_booking;
    }
    return text;
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

  Color get getPromBannerStatusBackgroundColor {
    switch (this) {
      case PROMOTIONAL_BANNER_ACCEPTED:
        return completed;
      case PROMOTIONAL_BANNER_PENDING:
        return promotionalBannerPendingStatus;
      case PROMOTIONAL_BANNER_REJECT:
        return pending;

      default:
        return defaultStatus;
    }
  }

  Color? get getPaymentStatusColor {
    if (this.isEmpty)
      return pending;
    else if (this == PAYMENT_STATUS_ADVANCE)
      return waiting;
    else if (this == BOOKING_STATUS_PAID)
      return completed;
    return null;
  }

  Color? get getServiceApprovalStatusColor {
    if (this.isEmpty)
      return pending_service;
    else if (this == SERVICE_APPROVE)
      return approved_service;
    else if (this == SERVICE_PENDING)
      return pending_service;
    else if (this == SERVICE_REJECT)
      return rejected_service;
    return null;
  }
}