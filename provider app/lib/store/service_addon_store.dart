import 'package:mobx/mobx.dart';

import '../models/booking_detail_response.dart';

part 'service_addon_store.g.dart';

class ServiceAddonStore = _ServiceAddonStore with _$ServiceAddonStore;

abstract class _ServiceAddonStore with Store {
  @observable
  List<ServiceAddon> selectedServiceAddon = ObservableList();

  @action
  void setSelectedServiceAddon(List<ServiceAddon> value) {
    selectedServiceAddon = ObservableList.of(value);
  }
}
