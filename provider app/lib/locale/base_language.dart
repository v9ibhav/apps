import 'package:flutter/material.dart';

abstract class Languages {
  static Languages of(BuildContext context) => Localizations.of<Languages>(context, Languages)!;

  String planAboutToExpire(int days);

  String get appName;

  String get provider;

  String get lblShowingOnly4Handyman;

  String get lblRecentlyOnlineHandyman;

  String get lblStartDrive;

  String get handyman;

  String get signIn;

  String get signUp;

  String get hintFirstNameTxt;

  String get hintLastNameTxt;

  String get hintContactNumberTxt;

  String get hintEmailAddressTxt;

  String get hintUserNameTxt;

  String get hintReenterPasswordTxt;

  String get confirm;

  String get forgotPassword;

  String get alreadyHaveAccountTxt;

  String get rememberMe;

  String get forgotPasswordTitleTxt;

  String get resetPassword;

  String get editProfile;

  String get saveChanges;

  String get camera;

  String get language;

  String get appTheme;

  String get bookingHistory;

  String get logout;

  String get afterLogoutTxt;

  String get chooseTheme;

  String get selectCountry;

  String get selectState;

  String get selectCity;

  String get changePassword;

  String get passwordNotMatch;

  String get doNotHaveAccount;

  String get hintNewPasswordTxt;

  String get hintOldPasswordTxt;

  String get review;

  String get notification;

  String get accept;

  String get decline;

  String get noDataFound;

  String get pending;

  String get darkMode;

  String get lightMode;

  String get systemDefault;

  String get confirmationRequestTxt;

  String get notAvailable;

  String get lblGallery;

  String get cantLogin;

  String get pleaseContactAdmin;

  String get lblOk;

  String get paymentStatus;

  String get paymentMethod;

  String get hintAddress;

  String get quantity;

  String get lblYes;

  String get lblNo;

  String get lblReason;

  String get lblSelectHandyman;

  String get lblAssign;

  String get lblCall;

  String get lblAssignHandyman;

  String get lblAssigned;

  String get viewAll;

  String get lblMonthlyRevenue;

  String get lblRevenue;

  String get lblAddHandyman;

  String get lblBooking;

  String get lblTotalBooking;

  String get lblTotalService;

  String get lblTotalHandyman;

  String get monthlyEarnings;

  String get lblPayment;

  String get lblBookingID;

  String get lblPaymentID;

  String get lblAmount;

  String get hintAddService;

  String get hintServiceName;

  String get hintSelectCategory;

  String get hintSelectType;

  String get hintSelectStatus;

  String get hintPrice;

  String get hintDiscount;

  String get hintDuration;

  String get hintDescription;

  String get hintSetAsFeature;

  String get hintAdd;

  String get hintChooseImage;

  String get customer;

  String get lblProfile;

  String get lblAllHandyman;

  String get lblTime;

  String get lblMyService;

  String get lblAllService;

  String get lblChat;

  String get selectAddress;

  String get btnSave;

  String get editAddress;

  String get lblUpdate;

  String get lblEdit;

  String get lblDelete;

  String get lblServiceAddress;

  String get lblServices;

  String get lblEditService;

  String get selectImgNote;

  String get lblDurationHr;

  String get lblDurationMin;

  String get lblWaitForAcceptReq;

  String get lblAddServiceAddress;

  String get errorPasswordLength;

  String get hintPassword;

  String get hintRequired;

  String get lblUnAuthorized;

  String get btnVerifyId;

  String get confirmationUpload;

  String get toastSuccess;

  String get lblSelectDoc;

  String get lblAddDoc;

  String get lblRateUs;

  String get lblTermsAndConditions;

  String get lblPrivacyPolicy;

  String get lblHelpAndSupport;

  String get lblAbout;

  String get lblProviderType;

  String get lblMyCommission;

  String get lblTaxes;

  String get lblTaxName;

  String get lblMyTax;

  String get lblLoginTitle;

  String get lblLoginSubtitle;

  String get lblSignupTitle;

  String get lblSignupSubtitle;

  String get lblSignup;

  String get lblUserType;

  String get lblPurchaseCode;

  String get lblRating;

  String get lblOff;

  String get lblHr;

  String get lblDate;

  String get lblAboutHandyman;

  String get lblAboutCustomer;

  String get lblPaymentDetail;

  String get lblId;

  String get lblMethod;

  String get lblStatus;

  String get lblPriceDetail;

  String get lblSubTotal;

  String get lblTax;

  String get lblCoupon;

  String get lblTotalAmount;

  String get lblOnBasisOf;

  String get lblCheckStatus;

  String get lblCancel;

  String get lblUnreadNotification;

  String get lblMarkAllAsRead;

  String get lblCloseAppMsg;

  String get lblAddress;

  String get lblType;

  String get lblHandymanType;

  String get lblFixed;

  String get lblHello;

  String get lblWelcomeBack;

  String get lblNoReviewYet;

  String get lblWaitingForResponse;

  String get lblConfirmPayment;

  String get lblDelivered;

  String get lblDay;

  String get lblYear;

  String get lblExperience;

  String get lblOf;

  String get lblSelectAddress;

  String get lblOppS;

  String get lblNoInternet;

  String get lblRetry;

  String get lblServiceStatus;

  String get lblMemberSince;

  String get lblDeleteAddress;

  String get lblDeleteAddressMsg;

  String get lblChoosePaymentMethod;

  String get lblNoPayments;

  String lblPayWith(String title);

  String get lblProceed;

  String get lblPricingPlan;

  String get lblSelectPlan;

  String get lblMakePayment;

  String get lblRestore;

  String get lblForceDelete;

  String get lblActivated;

  String get lblDeactivated;

  String get lblNoDescriptionAvailable;

  String get lblFAQs;

  String get lblGetDirection;

  String get lblDeleteTitle;

  String get lblDeleteSubTitle;

  String get lblUpcomingServices;

  String get lblTodayServices;

  String get lblPlanExpired;

  String get lblPlanSubTitle;

  String get btnTxtBuyNow;

  String get lblChooseYourPlan;

  String get lblRenewSubTitle;

  String get lblReminder;

  String get lblRenew;

  String get lblCurrentPlan;

  String get lblValidTill;

  String get lblSearchHere;

  String get lblEarningList;

  String get lblSubscriptionTitle;

  String get lblPlan;

  String get lblCancelPlan;

  String get lblSubscriptionHistory;

  String get lblTrashHandyman;

  String get lblPlsSelectAddress;

  String get lblPlsSelectCategory;

  String get lblEnterHours;

  String get lblEnterMinute;

  String get lblSelectSubCategory;

  String get lblServiceProof;

  String get lblTitle;

  String get lblAddImage;

  String get lblSubmit;

  String get lblWalletHistory;

  String get lblServiceRatings;

  String get lblWallet;

  String get lblSelectCommission;

  String get lblIAgree;

  String get lblTermsOfService;

  String get lblLoginAgain;

  String get lblTermCondition;

  String get lblServiceTotalTime;

  String get lblHelpLineNum;

  String get lblReasonCancelling;

  String get lblReasonRejecting;

  String get lblFailed;

  String get lblDesignation;

  String get lblHandymanIsOffline;

  String get lblDoYouWantToRestore;

  String get lblDoYouWantToDeleteForcefully;

  String get lblDoYouWantToDelete;

  String get lblPleaseEnterMobileNumber;

  String get lblDangerZone;

  String get lblDeleteAccount;

  String get lblDeleteAccountConformation;

  String get lblUnderMaintenance;

  String get lblCatchUpAfterAWhile;

  String get lblRecheck;

  String get lblTrialFor;

  String get lblDays;

  String get lblFreeTrial;

  String get lblAtLeastOneImage;

  String get lblService;

  String get lblNewUpdate;

  String get lblOptionalUpdateNotify;

  String get lblAnUpdateTo;

  String get lblIsAvailableWouldYouLike;

  String lblAreYouSureYouWantToAssignThisServiceTo(String name);

  String get lblAreYouSureYouWantToAssignToYourself;

  String get lblAssignToMyself;

  String get lblFree;

  String get lblMyProvider;

  String get lblAvailableStatus;

  String get lblYouAre;

  String get lblEmailIsVerified;

  String get lblHelp;

  String get lblAddYourCountryCode;

  String get lblRegistered;

  String get lblRequiredAfterCountryCode;

  String get lblExtraCharges;

  String get lblAddExtraCharges;

  String get lblCompleted;

  String get lblAddExtraChargesDetail;

  String get lblEnterExtraChargesDetail;

  String get lblTotalCharges;

  String get lblSuccessFullyAddExtraCharges;

  String get lblChargeName;

  String get lblPrice;

  String get lblEnterAmount;

  String get lblHourly;

  String get noBookingTitle;

  String get noBookingSubTitle;

  String get noNotificationTitle;

  String get noNotificationSubTitle;

  String get noHandymanAvailable;

  String get noHandymanYet;

  String get noHandymanSubTitle;

  String get noServiceFound;

  String get noServiceSubTitle;

  String get noServiceAddressTitle;

  String get noServiceAddressSubTitle;

  String get noSubscriptionPlan;

  String get noSubscriptionFound;

  String get noSubscriptionSubTitle;

  String get noTexesFound;

  String get noWalletHistoryTitle;

  String get noWalletHistorySubTitle;

  String get noExtraChargesHere;

  String get getYourFirstReview;

  String get ratingViewAllSubtitle;

  String get noDocumentFound;

  String get noDocumentSubTitle;

  String get noConversation;

  String get jobRequestList;

  String get bidList;

  String get bid;

  String get postJobTitle;

  String get postJobDescription;

  String get jobPrice;

  String get estimatedPrice;

  String get assignedProvider;

  String get giveYourEstimatePriceHere;

  String get pleaseEnterValidBidPrice;

  String get yourPriceShouldNotBeLessThan;

  String get enterBidPrice;

  String get myBid;

  String get inputMustBeNumberOrDigit;

  String get requiredAfterCountryCode;

  String get internetNotAvailable;

  String get pleaseTryAgain;

  String get somethingWentWrong;

  String get thisSlotIsNotAvailable;

  String get notes;

  String get timeSlotsNotes1;

  String get timeSlotsNotes2;

  String get timeSlotsNotes3;

  String get noSlotsAvailable;

  String get timeSlots;

  String get selectYourDay;

  String get chooseTime;

  String get copyTo;

  String get pleaseWaitWhileWeChangeTheStatus;

  String get myTimeSlots;

  String get day;

  String get pleaseSelectServiceAddresses;

  String get pleaseSelectImages;

  String get timeSlotAvailable;

  String get doesThisServicesContainsTimeslot;

  String get pleaseEnterTheDefaultTimeslotsFirst;

  String get chooseAction;

  String get chooseImage;

  String get removeImage;

  String get availableAt;

  String get clearChat;

  String get upcomingBookings;

  String get postJob;

  String get categoryBasedPackage;

  String get subTitleOfSelectService;

  String get enabled;

  String get disabled;

  String get doYouWantTo;

  String get enable;

  String get disable;

  String get package;

  String get packages;

  String get packageService;

  String get confirmationRemovePackage;

  String get packageName;

  String get selectService;

  String get packageDescription;

  String get packagePrice;

  String get startDate;

  String get endDate;

  String get pleaseSelectService;

  String get pleaseEnterTheEndDate;

  String get editPackage;

  String get addPackage;

  String get areYouSureWantToDeleteThe;

  String get packageNotAvailable;

  String get includedInThisPackage;

  String get packageServicesWillAppearHere;

  String get showingFixPriceServices;

  String get pleaseSelectTheCategory;

  String get lblInvalidTransaction;

  String get youWillGetTheseServicesWithThisPackage;

  String get lblSearchFullAddress;

  String get lblPleaseSelectCity;

  String get lblChooseOneImage;

  String get lblNoTransactionFound;

  String get lblSubTitleNoTransaction;

  String get lblCheckOutWithCinetPay;

  String get yourPaymentFailedPleaseTryAgain;

  String get yourPaymentHasBeenMadeSuccessfully;

  String get lblTransactionFailed;

  String get lblTransactionCancelled;

  String get lblStripeTestCredential;

  String get lblSuccessFullyActivated;

  String get lblNoTaxesFound;

  String get lblConfirmationForDeleteMsg;

  String get lblImage;

  String get lblVideo;

  String get lblAudio;

  String get lblMessage;

  String get chatCleared;

  String get lblNoEarningFound;

  String get lblNoUserFound;

  String get lblTokenExpired;

  String get lblFailedToLoadPredictions;

  String get personalInfo;

  String get essentialSkills;

  String get knownLanguages;

  String get addEssentialSkill;

  String get addKnownLanguage;

  String get authorBy;

  String get views;

  String get deleteBlogTitle;

  String get enterBlogTitle;

  String get updateBlog;

  String get addBlog;

  String get blogs;

  String get noBlogsFound;

  String get aboutYou;

  String get pleaseAddKnownLanguage;

  String get pleaseAddEssentialSkill;

  String get published;

  String get clearChatMessage;

  String get all;

  String get accepted;

  String get onGoing;

  String get inProgress;

  String get hold;

  String get cancelled;

  String get rejected;

  String get failed;

  String get completed;

  String get pendingApproval;

  String get waiting;

  String get paid;

  String get advancePaid;

  String get advancePayAmountPer;

  String get enablePrePayment;

  String get enablePrePaymentMessage;

  String get invalidInput;

  String get remainingAmount;

  String get advancePayment;

  String get valueConditionMessage;

  String get withExtraAndAdvanceCharge;

  String get withExtraCharge;

  String get min;

  String get hour;

  String get lblChangeCountry;

  String get lblExample;

  String get active;

  String get inactive;

  String get use24HourFormat;

  String get successfullyActivated;

  String get providerHome;

  String get handymanHome;

  String get home;

  String get selectPlanSubTitle;

  String get userRole;

  String get paymentHistory;

  String get theService;

  String get selectDuration;

  String get thisServiceMayTake;

  String get priceAmountValidationMessage;

  String get lblFeatureBlog;

  String get changePasswordTitle;

  String get forgotPasswordSubtitle;

  String get badRequest;

  String get forbidden;

  String get pageNotFound;

  String get tooManyRequests;

  String get internalServerError;

  String get badGateway;

  String get serviceUnavailable;

  String get gatewayTimeout;

  String get requested;

  String get assigned;

  String get reload;

  String get noConversationSubTitle;

  String get noServiceAccordingToCoordinates;

  String get isNotValid;

  String get unlimited;

  String get upTo;

  String get amountToBeReceived;

  String get yourCashPaymentForBookingId;

  String get isAcceptedAsOn;

  String get sendCashToProvider;

  String get sendCashToAdmin;

  String get cashPaymentApproval;

  String get approvedByHandyman;

  String get sentToProvider;

  String get pendingByProvider;

  String get approvedByProvider;

  String get pendingByAdmin;

  String get approvedByAdmin;

  String get sentToAdmin;

  String get ofTransfer;

  String get refNumber;

  String get todaySEarning;

  String get cash;

  String get bank;

  String get handymanApprovedTheRequest;

  String get requestSentToTheProvider;

  String get requestSentToTheAdmin;

  String get requestPendingWithTheProvider;

  String get providerApprovedTheRequest;

  String get requestPendingWithTheAdmin;

  String get adminApprovedTheRequest;

  String get today;

  String get yesterday;

  String get customDate;

  String get totalCash;

  String get tomorrow;

  String get cashList;

  String get sortBy;

  String get noPaymentsFounds;

  String get cashBalance;

  String get close;

  String get retryPaymentDetails;

  String get totalAmountToPay;

  String get from;

  String get booking;

  String get choosePaymentMethod;

  String get sendToAdmin;

  String get sendToProvider;

  String get detailsOfTheBank;

  String get selectABankTransferMoneyAndEnterTheReferenceIDInTheTextFieldBelow;

  String get noBanksAvailable;

  String get chooseCashOrContactAdminForBankInformation;

  String get bankName;

  String get accountNumber;

  String get iFSCCode;

  String get bankAddress;

  String get pleaseWaitWhileWeLoadBankDetails;

  String get cashPaymentConfirmation;

  String get remark;

  String get pleaseWaitWhileWeLoadChatDetails;

  String get isNotAvailableForChat;

  String get connectWithFirebaseForChat;

  String get admin;

  String get cashStatus;

  String get closeApp;

  String get youMustProvideValidCurrentPassword;

  String get selectUserType;

  String get pleaseSelectCommission;

  String get copied;

  String get pleaseContactYourAdmin;

  String get search;

  String get wouldYouLikeToAssignThisBooking;

  String get connect;

  String get youAreNotConnectedWithChatServer;

  String get tapBelowButtonToConnectWithOurChatServer;

  String get transactionId;

  String get appliedTaxes;

  String get by;

  String get thisOrderWillBe;

  String get externalWallet;

  String get start;

  String get digitalService;

  String get digitalServiceSwitchSubText;

  String get filterAtLeastOneBookingStatusToast;

  String get apply;

  String get clearFilter;

  String get bookingStatus;

  String get filterBy;

  String get cinetpayIsnTSupportedByCurrencies;

  String get totalAmountShouldBeMoreThan;

  String get totalAmountShouldBeLessThan;

  String get pleaseNoteThatAllServiceMarkedCompleted;

  String get serviceVisitType;

  String get thisServiceIsOnlineRemote;

  String get visitOption;

  String get onSiteVisit;

  String get onlineRemoteService;

  String get addOns;

  String get serviceAddOns;

  String get writeHere;

  String get writeShortLineAbout;

  String get reasonsToChooseYour;

  String get addReasons;

  String get addReason;

  String get writeReason;

  String get pleaseAddReason;

  String get isAvailableGoTo;

  String get later;

  String get addonServices;

  String get paymentSuccess;

  String get redirectingToBookings;

  String get transactionIsInProcess;

  String get pleaseCheckThePayment;

  String get enterYourMsisdnHere;

  String get theTransactionIsStill;

  String get transactionIsSuccessful;

  String get incorrectPinHasBeen;

  String get theUserHasExceeded;

  String get theAmountUserIs;

  String get userDidnTEnterThePin;

  String get transactionInPendingState;

  String get userWalletDoesNot;

  String get theTransactionWasRefused;

  String get thisIsAGeneric;

  String get payeeIsAlreadyInitiated;

  String get theTransactionWasTimed;

  String get theTransactionWasNot;

  String get xSignatureAndPayloadDid;

  String get encryptionKeyHasBeen;

  String get couldNotFetchEncryption;

  String get transactionHasBeenExpired;

  String get airtelMoneyPayment;

  String get addonServiceName;

  String get editAddonService;

  String get addAddonService;

  String get noteYouCanUpload;

  String get oppsLooksLikeYou;

  String get ambiguous;

  String get success;

  String get incorrectPin;

  String get exceedsWithdrawalAmountLimitS;

  String get invalidAmount;

  String get transactionIdIsInvalid;

  String get inProcess;

  String get notEnoughBalance;

  String get refused;

  String get doNotHonor;

  String get transactionNotPermittedTo;

  String get transactionTimedOut;

  String get transactionNotFound;

  String get forBidden;

  String get successfullyFetchedEncryptionKey;

  String get errorWhileFetchingEncryption;

  String get transactionExpired;

  String get pleaseSelectAService;

  String get verifyEmail;

  String get verified;

  String get minRead;

  String get loadingChats;

  String get monthly;

  String get mon;

  String get tue;

  String get wed;

  String get thu;

  String get fri;

  String get sat;

  String get sun;

  String get jan;

  String get feb;

  String get mar;

  String get apr;

  String get may;

  String get jun;

  String get july;

  String get aug;

  String get sept;

  String get oct;

  String get nov;

  String get dec;

  String get pushNotification;

  String get sentYouAMessage;

  String get deleteMessage;

  String get removeThisFile;

  String get areYouSureWantToRemoveThisFile;

  String get sendMessage;

  String get handymanLocation;

  String get track;

  String get trackHandymanLocation;

  String get lastUpdatedAt;

  String get lblBankDetails;

  String get withdraw;

  String get availableBalance;

  String get withdrawRequest;

  String get chooseBank;

  String get egCentralNationalBank;

  String get addBank;

  String get successful;

  String get yourWithdrawalRequestHasBeenSuccessfullySubmitted;

  String get done;

  String get requestList;

  String get filter;

  String get reset;

  String get bankList;

  String get lbldefault;

  String get setAsDefault;

  String get branchName;

  String get lblPleaseEnterAccountNumber;

  String get lblAccountNumberMustContainOnlyDigits;

  String get lblAccountNumberMustBetween11And16Digits;

  String get noBankDataTitle;

  String get noBankDataSubTitle;

  String get eg3000;

  String get pleaseAddLessThanOrEqualTo;

  String get deleteBankTitle;

  String get debit;

  String get credit;

  String get fullNameOnBankAccount;

  String get updateYourLocation;

  String get lbHours;

  String get lbMinutes;

  String get handymanCommission;

  String get commission;

  String get noCommissionTypeListFound;

  String get typeName;

  String get addHandymanCommission;

  String get editHandymanCommission;

  String get enterValidCommissionValue;

  String get percentage;

  String get selectStatus;

  String get youCanTUpdateDeleted;

  String get thisCommissionHasBeen;

  String get copyMessage;

  String get transactions;

  String get thisYear;

  String get thisMonth;

  String get thisWeek;

  String get providerList;

  String get walletBalance;

  String get remainingPayout;

  String get totalRevenue;

  String get totalActiveCount;

  String get completedBookings;

  String get pickAProviderYou;

  String get selectedProvider;

  String get youHavePermanentlyDenied;

  String get open;

  String get closed;

  String get createBy;

  String get repliedBy;

  String get closedBy;

  String get helpDesk;

  String get addNew;

  String get queryYet;

  String get toSubmitYourProblems;

  String get noRecordsFoundFor;

  String get queries;

  String get noActivityYet;

  String get noRecordsFound;

  String get reply;

  String get eGDuringTheService;

  String get doYouWantClosedThisQuery;

  String get markAsClosed;

  String get youCanMarkThis;

  String get subject;

  String get eGDamagedFurniture;

  String get closedOn;

  String get on;

  String get showMessage;

  String get viewDetail;

  String get serviceProofMediaUploadNote;

  String get uploadMedia;

  String get viewStatus;

  String get email;

  String get at;

  String get general;

  String get other;

  String get setting;

  String get viewBreakdown;

  String get totalAmount;

  String get role;

  String get paymentBreakdown;

  String get paymentType;

  String get dateRange;

  String get providerNotFound;

  String get noPaymentMethodsFound;

  String get handymanNotFound;

  String get selectStartDateEndDate;

  String get customerNotFound;

  String get to;

  String get chooseYourDateRange;

  String get advancedRefund;

  String get taxAmount;

  String get lblReassign;

  String get handymanPayoutList;

  String get earningDetails;

  String get adminEarning;

  String get handymanName;

  String get totalEarning;

  String get myEarning;

  String get handymanPayDue;

  String get handymanPaidAmount;

  String get payout;

  String get addHandymanPayout;

  String get selectMethod;

  String get handymanEarning;

  String get handymanEarnings;

  String get noPayoutFound;

  String get handymanEarningList;

  String get permissionDeniedUnableTo;

  String get passwordLengthShouldBe;

  String get promotionalBanners;

  String get chooseAnyOnePayment;

  String get thisBannerIsCurrently;

  String get doYouWantToDeleteBanner;

  String get link;

  String get youHaveAnInsufficient;

  String get addPromotionalBanner;

  String promoteYourBusinessBanners(String perDayAmount);

  String get advertiseYourServicesEffectively;

  String get shortDescription;

  String get eGHandymanTrustedService;

  String get chooseService;

  String get enterLink;

  String get eGHttpsWwwYourlinkCom;

  String daysSelected(String totalDaysCount);

  String get promotionalBannerDetail;

  String get promotionalBanner;

  String promotionalBannerYet(String name);

  String get toSubmitYourBanner;

  String get canTFindRevenuecatProduct;

  String get waitForAWhile;

  String get reason;

  String get type;

  String noRecordsFoundForBanner(String status);

  String get note;

  String get thisServiceIsCurrently;

  String get approved;

  String get noPromotionalBannerYet;

  String get pay;

  String get selecteDateNote;

  String get doWantToDelete;

  String get razorPay;

  String get payPal;

  String get stripe;

  String get payStack;

  String get flutterWave;

  String get wallet;

  String get paytm;

  String get airtelMoney;

  String get cinet;

  String get midtrans;

  String get sadadPayment;

  String get phonePe;

  String get inAppPurchase;

  String get pix;

  String get chooseWithdrawalMethod;
}