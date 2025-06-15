import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get walkTitle1;

  String get walkTitle2;

  String get walkTitle3;

  String get getStarted;

  String get signIn;

  String get signUp;

  String get hintFirstNameTxt;

  String get hintLastNameTxt;

  String get hintContactNumberTxt;

  String get hintEmailAddressTxt;

  String get hintUserNameTxt;

  String get hintPasswordTxt;

  String get hintReenterPasswordTxt;

  String get confirm;

  String get hintEmailTxt;

  String get forgotPassword;

  String get alreadyHaveAccountTxt;

  String get rememberMe;

  String get resetPassword;

  String get dashboard;

  String get camera;

  String get language;

  String get appTheme;

  String get bookingHistory;

  String get rateUs;

  String get termsCondition;

  String get helpSupport;

  String get privacyPolicy;

  String get about;

  String get changePassword;

  String get logout;

  String get editProfile;

  String get chooseTheme;

  String get selectCountry;

  String get selectState;

  String get selectCity;

  String get passwordNotMatch;

  String get doNotHaveAccount;

  String get hintOldPasswordTxt;

  String get hintNewPasswordTxt;

  String get hintAddress;

  String get hintDescription;

  String get lblGallery;

  String get yourReview;

  String get review;

  String get lblApply;

  String get bookTheService;

  String get contactAdmin;

  String get allServices;

  String get duration;

  String get hourly;

  String get payment;

  String get done;

  String get totalAmount;

  String get priceDetail;

  String get home;

  String get category;

  String get booking;

  String get profile;

  String get lblAlertBooking;

  String get applyCoupon;

  String get serviceName;

  String get service;

  String get lblCancelReason;

  String get enterReason;

  String get noDataAvailable;

  String get lblOk;

  String get paymentDetail;

  String get paymentStatus;

  String get viewDetail;

  String get appThemeLight;

  String get appThemeDark;

  String get appThemeDefault;

  String get markAsRead;

  String get lblYes;

  String get lblNo;

  String get btnRate;

  String get btnSubmit;

  String get walkThrough1;

  String get walkThrough2;

  String get walkThrough3;

  String get lblNotification;

  String get lblUnAuthorized;

  String get btnNext;

  String get lblViewAll;

  String get notAvailable;

  String get lblFavorite;

  String get lblChat;

  String get getLocation;

  String get setAddress;

  String get requiredText;

  String get phnRequiredText;

  String get lblCall;

  String get lblRateHandyman;

  String get msgForLocationOn;

  String get msgForLocationOff;

  String get lblEnterPhnNumber;

  String get btnSendOtp;

  String get lblLocationOff;

  String get lblAppSetting;

  String get lblSubTotal;

  String get lblImage;

  String get lblVideo;

  String get lblAudio;

  String get lblChangePwdTitle;

  String get lblForgotPwdSubtitle;

  String get lblLoginTitle;

  String get lblLoginSubTitle;

  String get lblOrContinueWith;

  String get lblHelloUser;

  String get lblSignUpSubTitle;

  String get lblStepper1Title;

  String get lblDateAndTime;

  String get chooseDateAndTime;

  String get lblYourAddress;

  String get lblEnterYourAddress;

  String get lblUseCurrentLocation;

  String get lblEnterDescription;

  String get lblPrice;

  String get lblTax;

  String get lblDiscount;

  String get lblAvailableCoupons;

  String get lblPrevious;

  String get lblCoupon;

  String get lblEditYourReview;

  String get lblTime;

  String get textProvider;

  String get lblConfirmBooking;

  String get lblConfirmMsg;

  String get lblCancel;

  String get lblExpiryDate;

  String get lblRemoveCoupon;

  String get lblNoCouponsAvailable;

  String get lblStep1;

  String get lblStep2;

  String get lblBookingID;

  String get lblDate;

  String get lblAboutHandyman;

  String get lblAboutProvider;

  String get lblNotRatedYet;

  String get lblDeleteReview;

  String get lblConfirmReviewSubTitle;

  String get lblConfirmService;

  String get lblConFirmResumeService;

  String get lblEndServicesMsg;

  String get lblCancelBooking;

  String get lblStart;

  String get lblHold;

  String get lblResume;

  String get lblPayNow;

  String get lblCheckStatus;

  String get lblID;

  String get lblNoBookingsFound;

  String get lblCategory;

  String get lblYourComment;

  String get lblIntroducingCustomerRating;

  String get lblSeeYourRatings;

  String get lblFeatured;

  String get lblNoServicesFound;

  String get lblGENERAL;

  String get lblAboutApp;

  String get lblPurchaseCode;

  String get lblNoRateYet;

  String get lblMemberSince;

  String get lblFilterBy;

  String get lblClearFilter;

  String get lblNoReviews;

  String get lblUnreadNotification;

  String get lblChoosePaymentMethod;

  String get lblNoPayments;

  String get lblPayWith;

  String get payWith;

  String get lblYourRating;

  String get lblEnterReview;

  String get lblDelete;

  String get lblDeleteRatingMsg;

  String get lblSelectRating;

  String get lblNoServiceRatings;

  String get lblSearchFor;

  String get lblRating;

  String get lblAvailableAt;

  String get lblRelatedServices;

  String get lblBookNow;

  String get lblWelcomeToHandyman;

  String get lblWalkThroughSubTitle;

  String get textHandyman;

  String get lblChooseFromMap;

  String get lblDeleteAddress;

  String get lblDeleteSunTitle;

  String get lblFaq;

  String get lblServiceFaq;

  String get lblLogoutTitle;

  String get lblLogoutSubTitle;

  String get lblFeaturedProduct;

  String get lblAlert;

  String get lblOnBase;

  String get lblInvalidCoupon;

  String get lblSelectCode;

  String get lblBackPressMsg;

  String get lblHour;

  String get lblHr;

  String get lblOff;

  String get lblHelplineNumber;

  String get lblSubcategories;

  String get lblAgree;

  String get lblTermsOfService;

  String get lblWalkThrough0;

  String get lblServiceTotalTime;

  String get lblDateTimeUpdated;

  String get lblSelectDate;

  String get lblReasonCancelling;

  String get lblReasonRejecting;

  String get lblFailed;

  String get lblNotDescription;

  String get lblMaterialTheme;

  String get lblServiceProof;

  String get lblAndroid12Support;

  String get lblSignInWithGoogle;

  String get lblSignInWithOTP;

  String get lblDangerZone;

  String get lblDeleteAccount;

  String get lblUnderMaintenance;

  String get lblCatchUpAfterAWhile;

  String get lblId;

  String get lblMethod;

  String get lblStatus;

  String get lblPending;

  String get confirmationRequestTxt;

  String get lblDeleteAccountConformation;

  String get lblAutoSliderStatus;

  String get lblPickAddress;

  String get lblUpdateDateAndTime;

  String get lblRecheck;

  String get lblLoginAgain;

  String get lblUpdate;

  String get lblNewUpdate;

  String get lblOptionalUpdateNotify;

  String get lblAnUpdateTo;

  String get lblIsAvailableWouldYouLike;

  String get lblRegisterAsPartner;

  String get lblSignInWithApple;

  String get lblWaitingForProviderApproval;

  String get lblFree;

  String get lblAppleSignInNotAvailable;

  String get lblTotalExtraCharges;

  String get lblWaitingForResponse;

  String get lblAll;

  String get noConversation;

  String get noConversationSubTitle;

  String get noBookingSubTitle;

  String get myReviews;

  String get noCategoryFound;

  String get noProviderFound;

  String get createServiceRequest;

  String get chooseImages;

  String get serviceDescription;

  String get addNewService;

  String get newPostJobRequest;

  String get postJobTitle;

  String get postJobDescription;

  String get services;

  String get myPostJobList;

  String get requestNewJob;

  String get noNotifications;

  String get noNotificationsSubTitle;

  String get noFavouriteSubTitle;

  String get termsConditionsAccept;

  String get disclaimer;

  String get disclaimerContent;

  String get inputMustBeNumberOrDigit;

  String get requiredAfterCountryCode;

  String get selectedOtherBookingTime;

  String get myServices;

  String get doYouWantToAssign;

  String get bidPrice;

  String get accept;

  String get price;

  String get remove;

  String get add;

  String get save;

  String get createPostJobWithoutSelectService;

  String get selectCategory;

  String get pleaseAddImage;

  String get selectedBookingTimeIsAlreadyPassed;

  String get jobPrice;

  String get estimatedPrice;

  String get bidder;

  String get assignedProvider;

  String get myPostDetail;

  String get thankYou;

  String get bookingConfirmedMsg;

  String get goToHome;

  String get goToReview;

  String get noServiceAdded;

  String get noPostJobFound;

  String get noPostJobFoundSubtitle;

  String get pleaseEnterValidOTP;

  String get confirmOTP;

  String get sendingOTP;

  String get pleaseSelectDifferentSlotThenPrevious;

  String get pleaseSelectTheSlotsFirst;

  String get editTimeSlotsBooking;

  String get availableSlots;

  String get noTimeSlots;

  String get bookingDateAndSlot;

  String get extraCharges;

  String get chatCleared;

  String get clearChat;

  String get jobRequestSubtitle;

  String get verified;

  String get theEnteredCodeIsInvalidPleaseTryAgain;

  String get otpCodeIsSentToYourMobileNumber;

  String get yourPaymentFailedPleaseTryAgain;

  String get yourPaymentHasBeenMadeSuccessfully;

  String get transactionFailed;

  String get lblStep3;

  String get lblAvailableOnTheseDays;

  String get internetNotAvailable;

  String get pleaseTryAgain;

  String get somethingWentWrong;

  String get postJob;

  String get package;

  String get frequentlyBoughtTogether;

  String get endOn;

  String get buy;

  String get includedServices;

  String get includedInThisPackage;

  String get lblInvalidTransaction;

  String get getTheseServiceWithThisPackage;

  String get lblNotValidUser;

  String get lblSkip;

  String get lblChangeCountry;

  String get lblTimeSlotNotAvailable;

  String get lblAdd;

  String get lblThisService;

  String get lblYourCurrenciesNotSupport;

  String get lblSignInFailed;

  String get lblUserCancelled;

  String get lblTransactionCancelled;

  String get lblExample;

  String get lblCheckOutWithCinetPay;

  String get lblLocationPermissionDenied;

  String get lblLocationPermissionDeniedPermanently;

  String get lblEnableLocation;

  String get lblNoUserFound;

  String get lblUserNotCreated;

  String get lblTokenExpired;

  String get lblConfirmationForDeleteMsg;

  String get favouriteProvider;

  String get noProviderFoundMessage;

  String get personalInfo;

  String get essentialSkills;

  String get knownLanguages;

  String get authorBy;

  String get views;

  String get blogs;

  String get noBlogsFound;

  String get requestInvoice;

  String get invoiceSubTitle;

  String get sentInvoiceText;

  String get send;

  String get published;

  String get clearChatMessage;

  String get deleteMessage;

  String get accepted;

  String get onGoing;

  String get inProgress;

  String get cancelled;

  String get rejected;

  String get failed;

  String get completed;

  String get pendingApproval;

  String get waiting;

  String get paid;

  String get advancePaid;

  String get insufficientBalanceMessage;

  String get cinetPayNotSupportedMessage;

  String get loading;

  String get walletBalance;

  String get payAdvance;

  String get advancePaymentMessage;

  String get advancePayAmount;

  String get remainingAmount;

  String get advancePayment;

  String get withExtraAndAdvanceCharge;

  String get withExtraCharge;

  String get min;

  String get hour;

  String get customerRatingMessage;

  String get paymentHistory;

  String get message;

  String get wallet;

  String get payWithFlutterWave;

  String get goodMorning;

  String get goodAfternoon;

  String get goodEvening;

  String get invalidURL;

  String get use24HourFormat;

  String get email;

  String get badRequest;

  String get forbidden;

  String get pageNotFound;

  String get tooManyRequests;

  String get internalServerError;

  String get badGateway;

  String get serviceUnavailable;

  String get gatewayTimeout;

  String get pleaseWait;

  String get externalWallet;

  String get userNotFound;

  String get requested;

  String get assigned;

  String get reload;

  String get lblStripeTestCredential;

  String get noDataFoundInFilter;

  String get addYourCountryCode;

  String get help;

  String get couponCantApplied;

  String get priceAmountValidationMessage;

  String get pleaseWaitWhileWeLoadChatDetails;

  String get isNotAvailableForChat;

  String get connectWithFirebaseForChat;

  String get closeApp;

  String get providerAddedToFavourite;

  String get providerRemovedFromFavourite;

  String get provideValidCurrentPasswordMessage;

  String get copied;

  String get copyMessage;

  String get messageDelete;

  String get pleaseChooseAnyOnePayment;

  String get myWallet;

  String get balance;

  String get topUpWallet;

  String get topUpAmountQuestion;

  String get paymentMethod;

  String get selectYourPaymentMethodToAddBalance;

  String get proceedToTopUp;

  String get serviceAddedToFavourite;

  String get serviceRemovedFromFavourite;

  String get firebaseRemoteCannotBe;

  String get search;

  String get close;

  String get totalAmountShouldBeMoreThan;

  String get totalAmountShouldBeLessThan;

  String get doYouWantToTopUpYourWallet;

  String get chooseYourLocation;

  String get connect;

  String get transactionId;

  String get at;

  String get appliedTaxes;

  String get accessDeniedContactYourAdmin;

  String get yourWalletIsUpdated;

  String get by;

  String get noPaymentMethodFound;

  String get theAmountShouldBeEntered;

  String get walletHistory;

  String get debit;

  String get credit;

  String get youCannotApplyThisCoupon;

  String get basedOn;

  String get serviceStatusPicMessage;

  String get clearFilter;

  String get bookingStatus;

  String get addOns;

  String get serviceAddOns;

  String get turnOn;

  String get turnOff;

  String get serviceVisitType;

  String get thisServiceIsOnlineRemote;

  String get deleteMessageForAddOnService;

  String get confirmation;

  String get pleaseNoteThatAllServiceMarkedCompleted;

  String get writeHere;

  String get isAvailableGoTo;

  String get later;

  String get whyChooseMe;

  String get useThisCodeToGet;

  String get off;

  String get applied;

  String get coupons;

  String get handymanList;

  String get noHandymanFound;

  String get back;

  String get team;

  String get whyChooseMeAs;

  String get reason;

  String get pleaseEnterAddressAnd;

  String get pleaseEnterYourAddress;

  String get pleaseSelectBookingDate;

  String get doYouWantTo;

  String get chooseDateTime;

  String get airtelMoneyPayment;

  String get recommendedForYou;

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

  String get verifyEmail;

  String get minRead;

  String get loadingChats;

  String get monthly;

  String get noCouponsAvailableMsg;

  String get refundPolicy;

  String get chooseAnyOnePayment;

  String get january;

  String get february;

  String get march;

  String get april;

  String get may;

  String get june;

  String get july;

  String get august;

  String get september;

  String get october;

  String get november;

  String get december;

  String get monthName;

  String get mon;

  String get tue;

  String get wed;

  String get thu;

  String get fri;

  String get sat;

  String get sun;

  String get weekName;

  String get removeThisFile;

  String get areYouSureWantToRemoveThisFile;

  String get sendMessage;

  String get youAreNotConnectedWithChatServer;

  String get NotConnectedWithChatServerMessage;

  String get sentYouAMessage;

  String get pushNotification;

  String get yourBooking;

  String get featuredServices;

  String get postYourRequestAnd;

  String get newRequest;

  String get upcomingBooking;

  String get theUserHasDenied;

  String get helloGuest;

  String get eGCleaningPlumberPest;

  String get ifYouDidnTFind;

  String get popularServices;

  String get canTFindYourServices;

  String get trackProviderLocation;

  String get trackHandymanLocation;

  String get handymanLocation;

  String get providerLocation;

  String get lastUpdatedAt;

  String get track;

  String get handymanReached;

  String get providerReached;

  String get lblBankDetails;

  String get addBank;

  String get bankList;

  String get lbldefault;

  String get setAsDefault;

  String get aadharNumber;

  String get panNumber;

  String get lblPleaseEnterAccountNumber;

  String get lblAccountNumberMustContainOnlyDigits;

  String get lblAccountNumberMustBetween11And16Digits;

  String get noBankDataTitle;

  String get noBankDataSubTitle;

  String get active;

  String get inactive;

  String get deleteBankTitle;

  String get lblEdit;

  String get iFSCCode;

  String get accountNumber;

  String get bankName;

  String get withdraw;

  String get availableBalance;

  String get successful;

  String get yourWithdrawalRequestHasBeenSuccessfullySubmitted;

  String get eg3000;

  String get chooseBank;

  String get egCentralNationalBank;

  String get withdrawRequest;

  String get lblEnterAmount;

  String get pleaseAddLessThanOrEqualTo;

  String get topUp;

  String get btnSave;

  String get fullNameOnBankAccount;

  String get packageIsExpired;

  String get bookPackage;

  String get packageDescription;

  String get packagePrice;

  String get online;

  String get noteAddressIsNot;

  String get wouldYouLikeTo;

  String get packageName;

  String get feeAppliesForCancellations;

  String get a;

  String get byConfirmingYouAgree;

  String get and;

  String get areYouSureYou;

  String get totalCancellationFee;

  String get goBack;

  String get bookingCancelled;

  String get yourBookingHasBeen;

  String get noteCheckYourBooking;

  String get cancelledReason;

  String get refundPaymentDetails;

  String get refundOf;

  String get refundAmount;

  String get cancellationFee;

  String get advancedPayment;

  String get hoursOfTheScheduled;

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

  String get yesterday;

  String get chooseAction;

  String get chooseImage;

  String get noteYouCanUpload;

  String get removeImage;

  String get advancedRefund;

  String get lblService;

  String get dateRange;

  String get paymentType;

  String get reset;

  String get noStatusFound;

  String get selectStartDateEndDate;

  String get handymanNotFound;

  String get providerNotFound;

  String get rateYourExperience;

  String get weValueYourFeedback;

  String get viewStatus;

  String get paymentInfo;

  String get mobile;

  String get to;

  String get chooseYourDateRange;

  String get asHandyman;

  String get passwordLengthShouldBe;

  String get cash;

  String get bank;

  String get razorPay;

  String get payPal;

  String get stripe;

  String get payStack;

  String get flutterWave;

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