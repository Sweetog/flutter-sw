import 'dart:async';
import 'dart:collection';
import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/models/inlet_model.dart';
import 'package:app/screens/loading.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'dart:io' show Platform;

const DEFAULT_ZOOM = 55.0;

class MapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final List<InletModel> inlets;
  final int currentIndex;

  MapView(
      {required this.latitude,
      required this.longitude,
      required this.inlets,
      required this.currentIndex});

  @override
  _MapViewState createState() => _MapViewState(
      this.latitude, this.longitude, this.inlets, this.currentIndex);
}

class _MapViewState extends State<MapView> {
  final Logger _lg = Logger();
  final double _latitude;
  final double _longitude;
  final List<InletModel> _inlets;
  final int _currentIndex;

  CameraPosition? _currentCameraPosition;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _MapViewState(
      this._latitude, this._longitude, this._inlets, this._currentIndex);

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: SdAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Jobs),
    );
  }

  Widget _buildBody() {
    if (_currentCameraPosition == null) {
      return Loading();
    }

    return _buildMap();
  }

  Widget _buildMap() {
    return GoogleMap(
      mapType: MapType.hybrid,
      markers: _markers,
      initialCameraPosition: _currentCameraPosition!,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Future<void> _initData() async {
    try {
      String iconMarkerPeripheralUrl =
          'assets/images/3.0x/icon-marker-peripheral.png';
      if (Platform.isIOS) {
        iconMarkerPeripheralUrl =
            'assets/images/icon-marker-peripheral.png'; //ios simulator
      }

      BitmapDescriptor iconMarkerPeripheral =
          await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(12, 12)), //size file is ignored
              iconMarkerPeripheralUrl);
      LatLng currentPosition = LatLng(_latitude, _longitude);
      MarkerId currentMarkerId = MarkerId('$_latitude:$_longitude');
      Marker currentMarker = Marker(
        markerId: currentMarkerId,
        position: currentPosition,
        infoWindow: InfoWindow(title: 'Current: ${_currentIndex + 1}'),
      );
      _markers.add(currentMarker);

      for (var i = 0; i < _inlets.length; i++) {
        InletModel inlet = _inlets[i];
        MarkerId mId =
            MarkerId('${inlet.location.latitude}:${inlet.location.longitude}');
        if (currentMarkerId != mId) {
          Marker m = Marker(
            markerId: mId,
            position: LatLng(inlet.location.latitude, inlet.location.longitude),
            infoWindow: InfoWindow(title: '${i + 1}, Not Clean'),
            icon: iconMarkerPeripheral,
          );
          _markers.add(m);
        }
      }
      setState(() {
        _currentCameraPosition = CameraPosition(
          target: currentPosition,
          zoom: DEFAULT_ZOOM,
        );
      });
    } catch (e) {
      _lg.d('_initData exception');
      _lg.d(e);
    }
  }
}
