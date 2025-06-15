import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:lottie/lottie.dart' as lottie;
import 'package:nb_utils/nb_utils.dart';
import '../../component/base_scaffold_widget.dart';
import '../../main.dart';
import '../../model/update_location_response.dart';
import '../../network/rest_apis.dart';

class TrackLocation extends StatefulWidget {
  final int bookingId;
  final bool isHandyman;

  const TrackLocation({Key? key, required this.bookingId, required this.isHandyman}) : super(key: key);

  @override
  State<TrackLocation> createState() => _TrackLocationState();
}

class _TrackLocationState extends State<TrackLocation> with WidgetsBindingObserver{
  gmaps.CameraPosition _initialLocation = gmaps.CameraPosition(target: gmaps.LatLng(0.0, 0.0));
  UpdateLocationResponse? providerLocation;
  gmaps.GoogleMapController? mapController;
  Set<gmaps.Marker> _markers = {};
  gmaps.BitmapDescriptor? customIcon;
  lottie.LottieComposition? _composition;
  int _frame = 0;
  Timer? _timer;
  List<Uint8List>? _frames;
  StreamSubscription<UpdateLocationResponse>? _locationSubscription;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    allLocation();
    WidgetsBinding.instance.addObserver(this);
  }

  allLocation()async{
   await  _loadCustomIcon();
   await setLocationfuns();
    _startLocationUpdates();
  }



  //region Methods
  void _startLocationUpdates() {
    _locationSubscription = Stream.periodic(Duration(seconds: 30))
        .asyncMap((_) => setLocationfuns())
        .listen((location) async {
      setState((){
      providerLocation =  location;
      });
      _updateMarker();
      setState(() {
        isLoading = false;
      });
    });
  }


  Future<UpdateLocationResponse> setLocationfuns() async {
    setState(() {
      isLoading = true;
    });
    try {
      var value = await getProviderLocation(widget.bookingId);
      setState((){
      providerLocation =  value;
      });
      _updateMarker();
      return value;
    } catch (e) {
      log("Error ==> $e");
      setState(() {
        isLoading = false;
      });
      return UpdateLocationResponse(data: Data());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadCustomIcon() async {
    _composition = await lottie.AssetLottie('assets/lottie/wave_indicator.json').load();
    if (_composition != null) {
      _frames = await _precacheFrames(_composition!, 100, 100);
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_frames != null) {
        _updateMarkerWithFrame(_frame);
        _frame = (_frame + 1) % _frames!.length;
      }
    });
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
    customIcon = gmaps.BitmapDescriptor.fromBytes(iconBytes);
    _updateMarker();
  }

  Future<Uint8List> _captureLottieFrameAsImage(int frame, int width, int height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final drawable = lottie.LottieDrawable(_composition!);
    drawable.setProgress(frame / _composition!.durationFrames);
    drawable.draw(canvas, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  void _updateMarker() {
    if (providerLocation == null || customIcon == null) return;
    log("Updating marker: Lat=${providerLocation?.data.latitude}, Lng=${providerLocation?.data.longitude}");
    setState(() {
      _markers = {
        gmaps.Marker(
          markerId: gmaps.MarkerId('providerLocation'),
          position: gmaps.LatLng(
            double.parse(providerLocation?.data.latitude.toString() ?? "0.0"),
            double.parse(providerLocation?.data.longitude.toString() ?? "0.0"),
          ),
          icon: customIcon!,
        ),
      };
    });
    mapController?.animateCamera(gmaps.CameraUpdate.newLatLngZoom(
      gmaps.LatLng(
        double.parse(providerLocation?.data.latitude.toString() ?? "0.0"),
        double.parse(providerLocation?.data.longitude.toString() ?? "0.0"),
      ),
      14
    ));
  }


  void stopProviderLocation(){
    _timer?.cancel();
    _locationSubscription?.cancel();
    mapController?.dispose();
  }
  //endregion

  //region Closing
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      stopProviderLocation();
    } else if (state == AppLifecycleState.resumed) {
      setLocationfuns();
      _startLocationUpdates();
    }
  }

  @override
  void dispose() {
    stopProviderLocation();
    super.dispose();
  }

  //endregion closing


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.isHandyman ? language.trackHandymanLocation : language.trackProviderLocation,
      child: Stack(
        children: [
          gmaps.GoogleMap(
            mapType: gmaps.MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            markers: _markers,
            initialCameraPosition: _initialLocation,
            gestureRecognizers: Set()
              ..add(Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer()))
              ..add(Factory<PanGestureRecognizer>(
                      () => PanGestureRecognizer()))
              ..add(Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer()))
              ..add(Factory<TapGestureRecognizer>(
                      () => TapGestureRecognizer()))
              ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
            onMapCreated: (controller) => mapController = controller,
          ),
          Positioned(
            left: 10,
            top: 10,
            child: CupertinoActivityIndicator(color: black).visible(isLoading),
          ),
        ],
      ),
    );
  }
}
