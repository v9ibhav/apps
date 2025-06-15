import 'package:mobx/mobx.dart';

import '../model/service_detail_response.dart';

part 'service_addon_store.g.dart';

class ServiceAddonStore = _ServiceAddonStore with _$ServiceAddonStore;

abstract class _ServiceAddonStore with Store {
  @observable
  List<Serviceaddon> selectedServiceAddon = ObservableList();

  @action
  void setSelectedServiceAddon(List<Serviceaddon> value) {
    selectedServiceAddon = ObservableList.of(value);
  }
}
