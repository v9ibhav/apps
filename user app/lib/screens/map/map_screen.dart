import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/services/location_service.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constant.dart';

class MapScreen extends StatefulWidget {
  final double? latLong;
  final double? latitude;

  MapScreen({this.latLong, this.latitude});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;

  String? mapStyle;

  String _currentAddress = '';

  final destinationAddressController = TextEditingController();
  final destinationAddressFocusNode = FocusNode();

  String _destinationAddress = '';

  Set<Marker> markers = {};

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    if (appStore.isDarkMode) {
      DefaultAssetBundle.of(context).loadString('assets/json/map_style_dark.json').then((value) {
        mapStyle = value;
        setState(() {});
      }).catchError(onError);
    }
    afterBuildCreated(() {
      _getCurrentLocation();
    });
  }

  // Method for retrieving the current location
  void _getCurrentLocation() async {
    appStore.setLoading(true);
    await getUserLocationPosition().then((position) async {
      setAddress();

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18.0),
        ),
      );

      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(_currentAddress),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Start $_currentAddress', snippet: _destinationAddress),
        icon: BitmapDescriptor.defaultMarker,
      ));

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  // Method for retrieving the address
  Future<void> setAddress() async {
    try {
      Position position = await getUserLocationPosition().catchError((e) {
        //
      });

      _currentAddress = await buildFullAddressFromLatLong(position.latitude, position.longitude).catchError((e) {
        log(e);
      });
      destinationAddressController.text = _currentAddress;
      _destinationAddress = _currentAddress;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _handleTap(LatLng point) async {
    appStore.setLoading(true);

    markers.clear();
    markers.add(Marker(
      markerId: MarkerId(point.toString()),
      position: point,
      infoWindow: InfoWindow(),
      icon: BitmapDescriptor.defaultMarker,
    ));

    destinationAddressController.text = await buildFullAddressFromLatLong(point.latitude, point.longitude).catchError((e) {
      log(e);
    });

    _destinationAddress = destinationAddressController.text;

    appStore.setLoading(false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget(
        language.chooseYourLocation,
        backWidget: BackWidget(),
        color: primaryColor,
        elevation: 0,
        textColor: white,
        textSize: APP_BAR_TEXT_SIZE,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.from(markers),
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            style: mapStyle,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) async {
              mapController = controller;
            },
            onTap: _handleTap,
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: context.primaryColor.withValues(alpha:0.2),
                    child: InkWell(
                      splashColor: context.primaryColor.withValues(alpha:0.8),
                      child: SizedBox(width: 50, height: 50, child: Icon(Icons.add)),
                      onTap: () {
                        mapController.animateCamera(CameraUpdate.zoomIn());
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ClipOval(
                  child: Material(
                    color: context.primaryColor.withValues(alpha:0.2),
                    child: InkWell(
                      splashColor: context.primaryColor.withValues(alpha:0.8),
                      child: SizedBox(width: 50, height: 50, child: Icon(Icons.remove)),
                      onTap: () {
                        mapController.animateCamera(CameraUpdate.zoomOut());
                      },
                    ),
                  ),
                ),
              ],
            ).paddingLeft(10),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipOval(
                  child: Material(
                    color: context.primaryColor.withValues(alpha:0.2), // button color
                    child: Icon(Icons.my_location, size: 25).paddingAll(10),
                  ),
                ).paddingRight(8).onTap(() async {
                  appStore.setLoading(true);

                  await getUserLocationPosition().then((value) {
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 18.0),
                      ),
                    );

                    _handleTap(LatLng(value.latitude, value.longitude));
                  }).catchError(onError);

                  appStore.setLoading(false);
                }),
                8.height,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppTextField(
                      textFieldType: TextFieldType.MULTILINE,
                      controller: destinationAddressController,
                      focus: destinationAddressFocusNode,
                      textStyle: primaryTextStyle(color: appStore.isDarkMode ? Colors.white : Colors.black),
                      decoration: inputDecoration(context, labelText: language.hintAddress).copyWith(fillColor: appStore.isDarkMode ? Colors.black54 : Colors.white70),
                    ),
                  ],
                ),
                8.height,
                AppButton(
                  width: context.width(),
                  height: 16,
                  color: primaryColor.withValues(alpha:0.8),
                  text: language.setAddress.toUpperCase(),
                  textStyle: boldTextStyle(color: white, size: 12),
                  onTap: () {
                    if (destinationAddressController.text.isNotEmpty) {
                      finish(context, destinationAddressController.text);
                    } else {
                      toast(language.lblPickAddress);
                    }
                  },
                ),
                8.height,
              ],
            ).paddingAll(16),
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
