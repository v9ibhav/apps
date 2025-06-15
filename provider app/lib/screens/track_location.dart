import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../models/update_location_response.dart';
import '../networks/rest_apis.dart';

class TrackLocation extends StatefulWidget {
  final int bookingId;

  const TrackLocation({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<TrackLocation> createState() => _TrackLocationState();
}

class _TrackLocationState extends State<TrackLocation> {
  late gmaps.GoogleMapController mapController;
  Set<gmaps.Marker> _markers = {};
  gmaps.BitmapDescriptor? customIcon;
  lottie.LottieComposition? _composition;
  int _frame = 0;
  Timer? _timer;
  List<Uint8List>? _frames;
  UpdateLocationResponse? handymanLocation;
  StreamSubscription<UpdateLocationResponse>? _locationSubscription;
  bool isLoading = false;

    @override
  void initState() {
    super.initState();
    allLocation();
  }

  allLocation()async{
    setState(() {
        isLoading = true;
      });
   await  _loadCustomIcon();
   await setLocationfun();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _locationSubscription?.cancel();
    mapController.dispose();
    super.dispose();
  }

  void _startLocationUpdates() {
    _locationSubscription = Stream.periodic(Duration(seconds: 30))
        .asyncMap((_) => setLocationfun())
        .listen((location) {
      setState(() {
        handymanLocation = location;
      });
      _updateMarker();
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<UpdateLocationResponse> setLocationfun() async {
  return setLocationfuns();
}

  setLocationfuns() {
    setState(() {
      isLoading = true;
    });
    getHandymanLocation(
      widget.bookingId,
    ).then((value) async {
      setState(() {
        handymanLocation = value;
      });
      return value;
    }).catchError((e) {
      log("Error ==>$e");
      setState(() {
        isLoading = false;
      });
      return UpdateLocationResponse(data: Data());
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }
  Future<void> _loadCustomIcon() async {
    _composition = await AssetLottie('assets/lottie/wave_indicator.json').load();
    if (_composition != null) {
      _frames = await _precacheFrames(_composition!, 100, 100);
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer = Timer.periodic(
      Duration(milliseconds: 100),
      (timer) {
        if (_frames != null) {
          _updateMarkerWithFrame(_frame);
          _frame = (_frame + 1) % _frames!.length;
        }
      },
    );
  }

  Future<List<Uint8List>> _precacheFrames(lottie.LottieComposition composition, int width, int height) async {
    List<Uint8List> frames = [];
    int frameCount = composition.durationFrames.toInt();

    for (int i = 0; i < frameCount; i++) {
      final frameData = await _captureLottieFrameAsImage(i, width, height);
      frames.add(frameData);
    }

    return frames;
  }

  Future<void> _updateMarkerWithFrame(int frame) async {
    if (_frames == null) return;

    final iconBytes = _frames![frame];
    customIcon = gmaps.BitmapDescriptor.bytes(iconBytes);
    _updateMarker();
  }

  Future<Uint8List> _captureLottieFrameAsImage(int frame, int width, int height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final drawable = LottieDrawable(_composition!);
    drawable.setProgress(frame / _composition!.durationFrames);
    drawable.draw(canvas, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  void _updateMarker() {
    if (handymanLocation == null || customIcon == null) return;

    setState(() {
      _markers = {
        gmaps.Marker(
          markerId: gmaps.MarkerId('currentLocation'),
          position: gmaps.LatLng(
            double.parse(handymanLocation?.data.latitude.toString() ?? "0.0"),
            double.parse(handymanLocation?.data.longitude.toString() ?? "0.0"),
          ),
          icon: customIcon!,
        ),
      };
    });

    mapController.animateCamera(gmaps.CameraUpdate.newLatLngZoom(
      gmaps.LatLng(
        double.parse(handymanLocation?.data.latitude.toString() ?? "0.0"),
        double.parse(handymanLocation?.data.longitude.toString() ?? "0.0"),
      ),
      14
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.trackHandymanLocation,
      body: Stack(
        children: [
          gmaps.GoogleMap(
            compassEnabled: true,
            mapType: gmaps.MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => mapController = controller,
            markers: _markers,
            initialCameraPosition: CameraPosition(
            target:  gmaps.LatLng(
            double.parse(handymanLocation?.data.latitude.toString() ?? "0.0"),
            double.parse(handymanLocation?.data.longitude.toString() ?? "0.0"),
          ),
            zoom: 14.0,
          ),
          ),
           Positioned(
                left:10,
                top:10,
                child: CupertinoActivityIndicator(color: black).visible(isLoading),),
        ],
      ),
    );
  }
}
