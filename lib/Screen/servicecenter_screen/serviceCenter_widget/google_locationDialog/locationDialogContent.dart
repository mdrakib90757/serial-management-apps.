import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/color.dart';
import '../google_map_service/google_map_service.dart';

class LocationPickerDialogContent extends StatefulWidget {
  final Function(LatLng) onLocationSelected;
  final LatLng? newLocationToDisplay;
  const LocationPickerDialogContent({
    super.key,
    required this.onLocationSelected,
    this.newLocationToDisplay,
  });

  @override
  State<LocationPickerDialogContent> createState() =>
      _LocationPickerDialogContentState();
}

class _LocationPickerDialogContentState
    extends State<LocationPickerDialogContent> {
  final Completer<GoogleMapController> _controller = Completer();

  // Initial camera position (Dhaka)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 12.0,
  );

  final Set<Marker> _markers = {};
  LatLng? _selectedLocation;
  Suggestion? _selectedPlace;
  final Set<Polyline> _polylines = {};
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addMarkerOnTap(_initialPosition.target);
    _onMapTypeButtonPressed();
    _addInitialMarkers();
  }

  @override
  void didUpdateWidget(covariant LocationPickerDialogContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.newLocationToDisplay != null &&
        widget.newLocationToDisplay != oldWidget.newLocationToDisplay) {
      _updateMapLocation(widget.newLocationToDisplay!);
    }
  }

  void _updateMapLocation(LatLng position) {
    _moveCamera(position);
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(markerId: const MarkerId("selected"), position: position),
      );
    });
  }

  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15.0),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Location permissions are permanently denied, we cannot request permissions.",
      );
    }
    return await Geolocator.getCurrentPosition();
  }

  void _addInitialMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("dhaka_medical"),
          position: LatLng(23.7250, 90.3995),
          infoWindow: InfoWindow(
            title: "Dhaka Medical College",
            snippet: "A major public hospital",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("hatirjheel"),
          position: LatLng(23.7667, 90.4028),
          infoWindow: InfoWindow(
            title: "Hatirjheel",
            snippet: "A populer recreational spot",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
      _polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          points: [LatLng(23.7250, 90.3995), LatLng(23.7667, 90.4028)],
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  Future<void> _getToPosition(Position position) async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition newPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 16,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("_currentLocation"),
          infoWindow: InfoWindow(title: "My Current Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        ),
      );
    });
  }

  void _addMarkerOnTap(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(markerId: const MarkerId("selected"), position: position),
      );
      // _selectedLocation = position;
      widget.onLocationSelected(position);
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _initialPosition,
                    markers: _markers,
                    polylines: _polylines,
                    onMapCreated: (c) => _controller.complete(c),
                    onTap: _addMarkerOnTap,
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          FloatingActionButton.small(
                            onPressed: _onMapTypeButtonPressed,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: AppColor().primariColor,
                            heroTag: 'map_type_button',
                            child: Icon(
                              Icons.map,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          FloatingActionButton.small(
                            onPressed: () async {
                              try {
                                final position = await _determinePosition();
                                _getToPosition(position);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.blue,
                            heroTag: 'my_location_button',
                            child: const Icon(
                              Icons.my_location,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
