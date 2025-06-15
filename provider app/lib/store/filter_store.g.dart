// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilterStore on FilterStoreBase, Store {
  late final _$serviceIdAtom =
      Atom(name: 'FilterStoreBase.serviceId', context: context);

  @override
  List<int> get serviceId {
    _$serviceIdAtom.reportRead();
    return super.serviceId;
  }

  @override
  set serviceId(List<int> value) {
    _$serviceIdAtom.reportWrite(value, super.serviceId, () {
      super.serviceId = value;
    });
  }

  late final _$customerIdAtom =
      Atom(name: 'FilterStoreBase.customerId', context: context);

  @override
  List<int> get customerId {
    _$customerIdAtom.reportRead();
    return super.customerId;
  }

  @override
  set customerId(List<int> value) {
    _$customerIdAtom.reportWrite(value, super.customerId, () {
      super.customerId = value;
    });
  }

  late final _$providerIdAtom =
      Atom(name: 'FilterStoreBase.providerId', context: context);

  @override
  List<int> get providerId {
    _$providerIdAtom.reportRead();
    return super.providerId;
  }

  @override
  set providerId(List<int> value) {
    _$providerIdAtom.reportWrite(value, super.providerId, () {
      super.providerId = value;
    });
  }

  late final _$handymanIdAtom =
      Atom(name: 'FilterStoreBase.handymanId', context: context);

  @override
  List<int> get handymanId {
    _$handymanIdAtom.reportRead();
    return super.handymanId;
  }

  @override
  set handymanId(List<int> value) {
    _$handymanIdAtom.reportWrite(value, super.handymanId, () {
      super.handymanId = value;
    });
  }

  late final _$bookingStatusAtom =
      Atom(name: 'FilterStoreBase.bookingStatus', context: context);

  @override
  List<String> get bookingStatus {
    _$bookingStatusAtom.reportRead();
    return super.bookingStatus;
  }

  @override
  set bookingStatus(List<String> value) {
    _$bookingStatusAtom.reportWrite(value, super.bookingStatus, () {
      super.bookingStatus = value;
    });
  }

  late final _$paymentStatusAtom =
      Atom(name: 'FilterStoreBase.paymentStatus', context: context);

  @override
  List<String> get paymentStatus {
    _$paymentStatusAtom.reportRead();
    return super.paymentStatus;
  }

  @override
  set paymentStatus(List<String> value) {
    _$paymentStatusAtom.reportWrite(value, super.paymentStatus, () {
      super.paymentStatus = value;
    });
  }

  late final _$paymentTypeAtom =
      Atom(name: 'FilterStoreBase.paymentType', context: context);

  @override
  List<String> get paymentType {
    _$paymentTypeAtom.reportRead();
    return super.paymentType;
  }

  @override
  set paymentType(List<String> value) {
    _$paymentTypeAtom.reportWrite(value, super.paymentType, () {
      super.paymentType = value;
    });
  }

  late final _$startDateAtom =
      Atom(name: 'FilterStoreBase.startDate', context: context);

  @override
  String get startDate {
    _$startDateAtom.reportRead();
    return super.startDate;
  }

  @override
  set startDate(String value) {
    _$startDateAtom.reportWrite(value, super.startDate, () {
      super.startDate = value;
    });
  }

  late final _$endDateAtom =
      Atom(name: 'FilterStoreBase.endDate', context: context);

  @override
  String get endDate {
    _$endDateAtom.reportRead();
    return super.endDate;
  }

  @override
  set endDate(String value) {
    _$endDateAtom.reportWrite(value, super.endDate, () {
      super.endDate = value;
    });
  }

  late final _$isAnyFilterAppliedAtom =
      Atom(name: 'FilterStoreBase.isAnyFilterApplied', context: context);

  @override
  bool get isAnyFilterApplied {
    _$isAnyFilterAppliedAtom.reportRead();
    return super.isAnyFilterApplied;
  }

  @override
  set isAnyFilterApplied(bool value) {
    _$isAnyFilterAppliedAtom.reportWrite(value, super.isAnyFilterApplied, () {
      super.isAnyFilterApplied = value;
    });
  }

  late final _$addToServiceListAsyncAction =
      AsyncAction('FilterStoreBase.addToServiceList', context: context);

  @override
  Future<void> addToServiceList({required int serId}) {
    return _$addToServiceListAsyncAction
        .run(() => super.addToServiceList(serId: serId));
  }

  late final _$removeFromServiceListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromServiceList', context: context);

  @override
  Future<void> removeFromServiceList({required int serId}) {
    return _$removeFromServiceListAsyncAction
        .run(() => super.removeFromServiceList(serId: serId));
  }

  late final _$addToCustomerListAsyncAction =
      AsyncAction('FilterStoreBase.addToCustomerList', context: context);

  @override
  Future<void> addToCustomerList({required int cusId}) {
    return _$addToCustomerListAsyncAction
        .run(() => super.addToCustomerList(cusId: cusId));
  }

  late final _$removeFromCustomerListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromCustomerList', context: context);

  @override
  Future<void> removeFromCustomerList({required int cusId}) {
    return _$removeFromCustomerListAsyncAction
        .run(() => super.removeFromCustomerList(cusId: cusId));
  }

  late final _$addToProviderListAsyncAction =
      AsyncAction('FilterStoreBase.addToProviderList', context: context);

  @override
  Future<void> addToProviderList({required int prodId}) {
    return _$addToProviderListAsyncAction
        .run(() => super.addToProviderList(prodId: prodId));
  }

  late final _$removeFromProviderListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromProviderList', context: context);

  @override
  Future<void> removeFromProviderList({required int prodId}) {
    return _$removeFromProviderListAsyncAction
        .run(() => super.removeFromProviderList(prodId: prodId));
  }

  late final _$addToHandymanListAsyncAction =
      AsyncAction('FilterStoreBase.addToHandymanList', context: context);

  @override
  Future<void> addToHandymanList({required int handyId}) {
    return _$addToHandymanListAsyncAction
        .run(() => super.addToHandymanList(handyId: handyId));
  }

  late final _$removeFromHandymanListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromHandymanList', context: context);

  @override
  Future<void> removeFromHandymanList({required int handyId}) {
    return _$removeFromHandymanListAsyncAction
        .run(() => super.removeFromHandymanList(handyId: handyId));
  }

  late final _$addToBookingStatusListAsyncAction =
      AsyncAction('FilterStoreBase.addToBookingStatusList', context: context);

  @override
  Future<void> addToBookingStatusList({required String bookingStatusList}) {
    return _$addToBookingStatusListAsyncAction.run(() =>
        super.addToBookingStatusList(bookingStatusList: bookingStatusList));
  }

  late final _$removeFromBookingStatusListAsyncAction = AsyncAction(
      'FilterStoreBase.removeFromBookingStatusList',
      context: context);

  @override
  Future<void> removeFromBookingStatusList(
      {required String bookingStatusList}) {
    return _$removeFromBookingStatusListAsyncAction.run(() => super
        .removeFromBookingStatusList(bookingStatusList: bookingStatusList));
  }

  late final _$addToPaymentStatusListAsyncAction =
      AsyncAction('FilterStoreBase.addToPaymentStatusList', context: context);

  @override
  Future<void> addToPaymentStatusList({required String paymentStatusList}) {
    return _$addToPaymentStatusListAsyncAction.run(() =>
        super.addToPaymentStatusList(paymentStatusList: paymentStatusList));
  }

  late final _$removeFromPaymentStatusListAsyncAction = AsyncAction(
      'FilterStoreBase.removeFromPaymentStatusList',
      context: context);

  @override
  Future<void> removeFromPaymentStatusList(
      {required String paymentStatusList}) {
    return _$removeFromPaymentStatusListAsyncAction.run(() => super
        .removeFromPaymentStatusList(paymentStatusList: paymentStatusList));
  }

  late final _$addToPaymentTypeListAsyncAction =
      AsyncAction('FilterStoreBase.addToPaymentTypeList', context: context);

  @override
  Future<void> addToPaymentTypeList({required String paymentTypeList}) {
    return _$addToPaymentTypeListAsyncAction.run(
        () => super.addToPaymentTypeList(paymentTypeList: paymentTypeList));
  }

  late final _$removeFromPaymentTypeListAsyncAction = AsyncAction(
      'FilterStoreBase.removeFromPaymentTypeList',
      context: context);

  @override
  Future<void> removeFromPaymentTypeList({required String paymentTypeList}) {
    return _$removeFromPaymentTypeListAsyncAction.run(() =>
        super.removeFromPaymentTypeList(paymentTypeList: paymentTypeList));
  }

  late final _$clearFiltersAsyncAction =
      AsyncAction('FilterStoreBase.clearFilters', context: context);

  @override
  Future<void> clearFilters() {
    return _$clearFiltersAsyncAction.run(() => super.clearFilters());
  }

  late final _$FilterStoreBaseActionController =
      ActionController(name: 'FilterStoreBase', context: context);

  @override
  void setStartDate(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setStartDate');
    try {
      return super.setStartDate(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEndDate(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setEndDate');
    try {
      return super.setEndDate(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateFilterFlag() {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.updateFilterFlag');
    try {
      return super.updateFilterFlag();
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
serviceId: ${serviceId},
customerId: ${customerId},
providerId: ${providerId},
handymanId: ${handymanId},
bookingStatus: ${bookingStatus},
paymentStatus: ${paymentStatus},
paymentType: ${paymentType},
startDate: ${startDate},
endDate: ${endDate},
isAnyFilterApplied: ${isAnyFilterApplied}
    ''';
  }
}
