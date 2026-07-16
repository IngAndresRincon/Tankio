import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/map.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final CameraPosition initLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    loadCurrentLocation();
    super.initState();
  }

  Future<void> loadCurrentLocation() async {
    await Future.microtask(() async {
      await ref.read(mapProvider).requestPermission().then((value) async {
        if (value) {
          await ref.read(mapProvider).getAvailableStationLocations();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final map = ref.watch(mapProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            l10n.nearbyStationsTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: size.width * 0.044,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          leading: const SizedBox(),
        ),
        body: Column(
          children: [
            const SizedBox(width: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: map.controllerStationName,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.grey.shade800,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        labelText: l10n.enterStationNameLabel,
                        labelStyle: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.grey.shade700,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w300,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            map.controllerStationName.clear();
                            await map.filterStationName();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            size: size.width * 0.05,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE9EAEB)),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await map.filterStationName();
                      },
                      icon: Icon(
                        Icons.find_replace_rounded,
                        size: size.width * 0.08,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 20),
            //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(60),
            //     color: const Color(0xFFF9F9F9),
            //   ),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     mainAxisSize: MainAxisSize.max,
            //     children: [
            //       TextButton(
            //         onPressed: () async {
            //           await map.filterMarkers(filterId: 0);
            //         },
            //         child: Text(
            //           "All",
            //           style: TextStyle(
            //             fontFamily: 'Nunito',
            //             fontSize: size.width * 0.036,
            //             fontWeight: FontWeight.w800,
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () async {
            //           await map.filterMarkers(filterId: 1);
            //         },
            //         child: Text(
            //           "Fuel",
            //           style: TextStyle(
            //             fontFamily: 'Nunito',
            //             fontSize: size.width * 0.036,
            //             fontWeight: FontWeight.w800,
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () async {
            //           await map.filterMarkers(filterId: 2);
            //         },
            //         child: Text(
            //           "EV",
            //           style: TextStyle(
            //             fontFamily: 'Nunito',
            //             fontSize: size.width * 0.036,
            //             fontWeight: FontWeight.w800,
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () async {
            //           await map.filterMarkers(filterId: 3);
            //         },
            //         child: Text(
            //           "More",
            //           style: TextStyle(
            //             fontFamily: 'Nunito',
            //             fontSize: size.width * 0.036,
            //             fontWeight: FontWeight.w800,
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: const Color(0xFFF9F9F9),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: map.markerFilterOptions.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextButton(
                          onPressed: () async {
                            await map.filterMarkers(filterId: e['id']);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            decoration: e['active']
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 2,
                                        blurStyle: BlurStyle.normal,
                                        color: Colors.black12,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  )
                                : const BoxDecoration(),
                            child: Text(
                              e['label'],
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: size.width * 0.036,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: initLocation,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  markers: map.markers,
                  onMapCreated: (GoogleMapController controller) {
                    map.controllerMap = controller;
                  },
                  padding: EdgeInsets.only(
                    top: size.height * 0.18,
                    bottom: size.height * 0.22,
                  ),
                  mapToolbarEnabled: false,
                  indoorViewEnabled: false,
                  zoomControlsEnabled: false,
                  buildingsEnabled: true,
                  onCameraMove: (position) {
                    //LoggerService.debug('$position');
                  },
                  fortyFiveDegreeImageryEnabled: false,
                  rotateGesturesEnabled: false,
                  trafficEnabled: false,
                  tiltGesturesEnabled: true,
                  webCameraControlEnabled: true,
                  onTap: (LatLng pos) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
