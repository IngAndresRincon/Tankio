import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tankio/main.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/services/station_service.dart';
import 'package:tankio/widget/modal/station_detail_modal.dart';

class MapProvider extends ChangeNotifier {
  final Ref ref;

  MapProvider({required this.ref});

  LoadingNotifier get _loading => ref.read(loadingProvider.notifier);
  StationService get _station => ref.read(stationServiceProvider);

  Set<Marker> markers = {};
  List<dynamic> stationPoints = [];
  GoogleMapController? controllerMap;
  Marker userMarker = Marker(markerId: MarkerId("0"));
  final controllerStationName = TextEditingController();
  bool _stationModalOpen = false;

  List<Map<String, dynamic>> markerFilterOptions = [
    {"id": 0, "label": "All", "active": true},
    {"id": 1, "label": "Fuel", "active": false},
    {"id": 2, "label": "EV", "active": false},
    {"id": 3, "label": "More", "active": false},
  ];

  Future<bool> requestPermission() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      return true;
    }
    if (status != PermissionStatus.granted) {
      debugPrint("Permisos de localización no acepatos");
      return false;
    }

    return false;
  }

  Future<bool> getCurrentLocation() async {
    _loading.show();
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final LatLng myPos = LatLng(position.latitude, position.longitude);

      debugPrint('Ubicación: ${position.latitude}, ${position.longitude}');

      // ######## NUEVO: AGREGAR MARCADOR DE MI UBICACIÓN ########

      BitmapDescriptor userMaker = await BitmapDescriptor.asset(
        const ImageConfiguration(),
        "assets/car_marker.png",
        width: 44,
        height: 44,
      );

      userMarker = Marker(
        markerId: const MarkerId("mi_ubicacion"),
        position: myPos,
        infoWindow: const InfoWindow(title: "Mi ubicación actual"),
        icon: userMaker,
        onTap: () {},
      );

      markers.clear();
      markers.add(userMarker);

      // ######## MOVER LA CÁMARA ########
      final CameraPosition cam = CameraPosition(
        target: myPos,
        zoom: 14,
        tilt: 50,
        bearing: 0,
      );

      _goToMyGPS(cam);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      _loading.hide();
      notifyListeners();
    }
  }

  Future<void> getAvailableStationLocations() async {
    _loading.show();
    try {
      stationPoints.clear();
      final response = await _station.stations();
      if (response.statusCode == 200) {
        stationPoints = response.data['data'];
        if (stationPoints.isNotEmpty) {
          await getCurrentLocation();
          for (dynamic e in stationPoints) {
            await addMarkerLocation(e);
          }
        }

        debugPrint(jsonEncode(stationPoints));
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
  }

  String getAssetsImageByStationId({required int id}) {
    switch (id) {
      case 1:
        return 'assets/fuel-station-marker.png';
      case 2:
        return 'assets/ev-station-marker.png';
      default:
        return 'assets/home_marker.png';
    }
  }

  Future<void> addMarkerLocation(Map<String, dynamic> market) async {
    try {
      final image = getAssetsImageByStationId(id: market['station_type_id']);

      BitmapDescriptor stationMarkerIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(),
        image,
        width: 44,
        height: 44,
      );

      final marker = Marker(
        flat: false,
        markerId: MarkerId(market['station_id'].toString()),
        position: LatLng((market['latitude']), (market['longitude'])),
        icon: stationMarkerIcon,
        // infoWindow: InfoWindow(
        //   title: market['nombre'].toString().toUpperCase(),
        // ),
        infoWindow: InfoWindow(
          title: market['station_name'].toString().toUpperCase(),
          snippet: "${market['address']}",
          onTap: () {
            // showCupertinoModalPopup(
            //   context: navigatorKey.currentContext!,
            //   builder: (context) {
            //     return MarkerInformationModal(infoLocation: location);
            //   },
            // );
          },
        ),
        draggable: true,

        onTap: () {
          _showStationDetailModal(market);
        },
      );

      markers.add(marker);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> _showStationDetailModal(Map<String, dynamic> station) async {
    final context = navigatorKey.currentContext;
    if (context == null || _stationModalOpen) {
      return;
    }

    _stationModalOpen = true;
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (_) => StationDetailModal(station: station),
      );
    } finally {
      _stationModalOpen = false;
    }
  }

  Future<void> filterMarkers({required int filterId}) async {
    _loading.show();
    try {
      List<dynamic> filterStations = [];
      if (filterId != 0) {
        filterStations = stationPoints
            .where((e) => e['station_type_id'] == filterId)
            .toList();
      } else {
        filterStations = stationPoints;
      }

      if (filterStations.isNotEmpty) {
        markers.clear();
        markers.add(userMarker);
        for (dynamic e in filterStations) {
          await addMarkerLocation(e);
        }
      }

      for (var i = 0; i < markerFilterOptions.length; i++) {
        markerFilterOptions[i]['active'] = false;
        if (markerFilterOptions[i]['id'] == filterId) {
          markerFilterOptions[i]['active'] = true;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
  }

  Future<void> filterStationName() async {
    _loading.show();
    try {
      List<dynamic> filterStations = [];
      final query = controllerStationName.text.trim().toLowerCase();
      filterStations = stationPoints.where((e) {
        final name = (e['station_name'] ?? '').toString().toLowerCase();
        return name.contains(query);
      }).toList();

      if (filterStations.isNotEmpty) {
        markers.clear();
        markers.add(userMarker);
        for (dynamic e in filterStations) {
          await addMarkerLocation(e);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading.hide();
    }
  }

  Future<void> _goToMyGPS(CameraPosition cam) async {
    try {
      if (controllerMap == null) return;

      await controllerMap!.animateCamera(CameraUpdate.newCameraPosition(cam));
      // final GoogleMapController controller = await controllerMap.future;
      // await controller.animateCamera(CameraUpdate.newCameraPosition(cam));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

final mapProvider = ChangeNotifierProvider<MapProvider>(
  (ref) => MapProvider(ref: ref),
);
