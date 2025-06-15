// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_addon_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ServiceAddonStore on _ServiceAddonStore, Store {
  late final _$selectedServiceAddonAtom =
      Atom(name: '_ServiceAddonStore.selectedServiceAddon', context: context);

  @override
  List<Serviceaddon> get selectedServiceAddon {
    _$selectedServiceAddonAtom.reportRead();
    return super.selectedServiceAddon;
  }

  @override
  set selectedServiceAddon(List<Serviceaddon> value) {
    _$selectedServiceAddonAtom.reportWrite(value, super.selectedServiceAddon,
        () {
      super.selectedServiceAddon = value;
    });
  }

  late final _$_ServiceAddonStoreActionController =
      ActionController(name: '_ServiceAddonStore', context: context);

  @override
  void setSelectedServiceAddon(List<Serviceaddon> value) {
    final _$actionInfo = _$_ServiceAddonStoreActionController.startAction(
        name: '_ServiceAddonStore.setSelectedServiceAddon');
    try {
      return super.setSelectedServiceAddon(value);
    } finally {
      _$_ServiceAddonStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedServiceAddon: ${selectedServiceAddon}
    ''';
  }
}
