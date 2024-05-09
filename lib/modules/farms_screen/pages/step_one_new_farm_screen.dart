import 'dart:async';
import 'dart:convert';
import 'dart:developer' as logger;
import 'dart:math' as math;
import 'dart:ui';
import 'package:finca/assets/assets.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/pages/step_two_new_farm_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:finca/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart' as offline_location;

class StepOneNewFarmScreen extends StatefulWidget {
  final bool? isUpdating;
  final FarmModel? farm;

  const StepOneNewFarmScreen({
    super.key,
    this.isUpdating = false,
    this.farm,
  });

  @override
  State<StepOneNewFarmScreen> createState() => _StepOneNewFarmScreenState();
}

class _StepOneNewFarmScreenState extends State<StepOneNewFarmScreen> {
  bool _isPolygonCompleted = false;
  final TextEditingController _locationTextFieldController = TextEditingController();
  final GlobalKey _screenshotKey = GlobalKey();
  MapboxMapController? controller;
  final List<LatLng> _markerCoordinates = [];
  final List<Line> _addedLines = [];
  final List<Symbol> _addedSymbols = [];
  bool isLocationSearch = false;
  Future<Position?>? location;
  offline_location.Location offlineLocation = offline_location.Location();
  bool isCurrentLocationMarkerAdded = false;
  double _currentZoom = 15.0;

  @override
  void initState() {
    Utils().checkIfInternetIsAvailable().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        location = Geolocator.getCurrentPosition();
        logger.log('lastKnownPosition: $location');
      } else {
        final currentLocationData = await getCurrentLocation();
        location = Future.value(
          Position.fromMap(
            {
              'latitude': currentLocationData?.latitude ?? 3.0136,
              'longitude': currentLocationData?.longitude ?? -76.4844,
            },
          ),
        );
        logger.log('lastKnownPosition1: $location');
      }
      setState(() {});
    });
    super.initState();
  }

  Future<offline_location.LocationData?> getCurrentLocation() async {
    final serviceEnabled = await offlineLocation.serviceEnabled();
    if (serviceEnabled) {
      final result = await offlineLocation.requestService();
      if (result == true) {
        final locationData = await offlineLocation.getLocation();
        logger.log('Service has been enabled');
        return locationData;
      } else {
        logger.log('Service has not been enabled');
      }
    }
    return null;
  }

  void _onCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    controller?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), _currentZoom));
  }

  void _zoomIn() {
    setState(() {
      _currentZoom++;
    });
    controller?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    setState(() {
      _currentZoom--;
    });
    controller?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            RepaintBoundary(
              key: _screenshotKey,
              child: FutureBuilder(
                future: location,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  logger.log('positioncheck: ${snapshot.data?.latitude} ${snapshot.data?.longitude}');
                  return MapboxMap(
                    accessToken:
                        'sk.eyJ1IjoiZmluY2FzIiwiYSI6ImNsdWg4a2VvYzE1dGwyanJvYzVkdHdqcG8ifQ.jU1rupSVjgFgObCOj-9eWg',
                    onMapCreated: (controller) {
                      this.controller = controller;
                    },
                    onMapIdle: () {
                      onMapIdle(snapshot);
                    },
                    onMapClick: _onMapTapCallback,
                    styleString: 'mapbox://styles/mapbox/satellite-streets-v12',
                    initialCameraPosition: CameraPosition(
                      target: LatLng(snapshot.data?.latitude ?? 3.0136, snapshot.data?.longitude ?? -76.4844),
                      zoom: 15,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 100.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "current_location",
                    onPressed: _onCurrentLocation,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.my_location, size: 36.0),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    heroTag: "zoom_in",
                    onPressed: _zoomIn,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.add, size: 36.0),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    heroTag: "zoom_out",
                    onPressed: _zoomOut,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.remove, size: 36.0),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 15,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Icon(
                                Icons.arrow_back_ios_sharp,
                                size: 20,
                                color: AppColors.greenColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nueva Granja',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                                fontFamily: 'Rubik',
                              ),
                            ),
                            Text(
                              'Paso 1 de 4',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontFamily: 'Rubik',
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Selecciona la ubicación de la finca',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                                fontFamily: 'Rubik',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _locationTextFieldController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Buscar ubicación',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            await Utils().checkIfInternetIsAvailable().then((isInternetAvailable) {
                              if (isInternetAvailable) {
                                _searchLocation(_locationTextFieldController.text).then((location) {
                                  controller?.animateCamera(
                                    CameraUpdate.newLatLngZoom(location, 16.0),
                                  );
                                  saveToSharedPreference(location);
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No internet connection'),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                      ),
                      onSubmitted: (value) async {
                        await Utils().checkIfInternetIsAvailable().then((isInternetAvailable) {
                          if (isInternetAvailable) {
                            _searchLocation(value).then((location) {
                              controller?.animateCamera(
                                CameraUpdate.newLatLngZoom(location, 16.0),
                              );
                              saveToSharedPreference(location);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No internet connection'),
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 27,
                      right: 27,
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF4F4F4),
                    ),
                    child: InkWell(
                      onTap: () {
                        _undo();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(Assets.undo),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            AppStrings.undo,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGrey,
                              fontFamily: Assets.rubik,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 27,
                      right: 27,
                      top: 12,
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF4F4F4),
                    ),
                    child: InkWell(
                      onTap: () {
                        _clearLines();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(Assets.delete),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            AppStrings.delete,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGrey,
                              fontFamily: Assets.rubik,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_isPolygonCompleted) {
                        // log("selectedPolygons: ${_polygons.toList().toString()}");
                        Uint8List? imageBytes = await _captureScreenshot(context);
                        if (imageBytes != null) {
                          await _uploadScreenshot(imageBytes);
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _isPolygonCompleted ? const Color(0xFFF4F4F4) : Colors.grey,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(Assets.closeForm),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            AppStrings.closeForm,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGrey,
                              fontFamily: Assets.rubik,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapTapCallback(math.Point<double> point, LatLng coordinates) {
    if (!_isPolygonCompleted) {
      _addMarker(coordinates);
    }
  }

  void _addMarker(LatLng coordinates) async {
    final symbolOptions = SymbolOptions(
      geometry: coordinates,
      iconImage: "assets/svg/green_circle.png",
    );
    final symbol = await controller!.addSymbol(symbolOptions);
    _markerCoordinates.add(coordinates);
    _addedSymbols.add(symbol);
    if (_markerCoordinates.length == 4) {
      _createSquare(_markerCoordinates);
      setState(() {
        _isPolygonCompleted = true;
      });
    }
  }

  void _createSquare(var markerCoordinates) async {
    final lines = <Line>[];
    lines.add(await _addLine(markerCoordinates[0], markerCoordinates[1]));
    lines.add(await _addLine(markerCoordinates[1], markerCoordinates[2]));
    lines.add(await _addLine(markerCoordinates[2], markerCoordinates[3]));
    lines.add(await _addLine(markerCoordinates[3], markerCoordinates[0]));
    _addedLines.addAll(lines);
  }

  Future<Line> _addLine(LatLng point1, LatLng point2) async {
    final lineOptions = LineOptions(
      geometry: [point1, point2],
      lineColor: "#ff0000",
      lineWidth: 4.0,
    );
    return await controller!.addLine(lineOptions);
  }

  void _clearLines() {
    _markerCoordinates.clear();
    setState(() {
      _isPolygonCompleted = false;
    });
    for (var symbol in _addedSymbols) {
      controller!.removeSymbol(symbol);
    }
    for (var line in _addedLines) {
      controller!.removeLine(line);
    }
    _addedSymbols.clear();
    _addedLines.clear();
  }

  void _undo() {
    if (_addedSymbols.isNotEmpty) {
      final removedSymbol = _addedSymbols.removeLast();
      _markerCoordinates.removeLast();
      controller!.removeSymbol(removedSymbol);
    }
    if (_addedLines.isNotEmpty) {
      final removedLine = _addedLines.removeLast();
      controller!.removeLine(removedLine);
    }
    if (_markerCoordinates.length < 4) {
      setState(() {
        _isPolygonCompleted = false;
      });
    }
  }

  Future<LatLng> _searchLocation(String location) async {
    const apiKey = 'AIzaSyC5OI76CdPB1YkSlMsSpxjwA0BUaOJROxU';
    final endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=$location&key=$apiKey';
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final results = data['results'];
      if (results.isNotEmpty) {
        final location = results[0]['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        return LatLng(lat, lng);
      }
    }
    return const LatLng(0, 0);
  }

  Future<Uint8List?> _captureScreenshot(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary = _screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      logger.log('Error capturing screenshot: $e');
      return null;
    }
  }

  Future<void> _uploadScreenshot(Uint8List imageBytes) async {
    List<LatLng> polygonPoints = [];
    for (var i = 0; i < _markerCoordinates.length; i++) {
      polygonPoints.add(_markerCoordinates[i]);
    }
    logger.log('polygonPoints: ${polygonPoints.toString()}');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StepTwoNewFarmScreen(
          selectedPolygons: polygonPoints,
          polygonImage: imageBytes,
          isUpdating: widget.isUpdating,
          farm: widget.farm,
        ),
      ),
    );
  }

  void saveToSharedPreference(LatLng location) {
    //save only if internet is available
    UserPreferences().setString('last_known_latitude', location.latitude.toString());
    UserPreferences().setString('last_known_longitude', location.longitude.toString());
  }

  void _adjustZoom(markerCoordinates) {
    if (controller == null || markerCoordinates.isEmpty) return;

    double minLat = markerCoordinates.first.latitude;
    double maxLat = markerCoordinates.first.latitude;
    double minLng = markerCoordinates.first.longitude;
    double maxLng = markerCoordinates.first.longitude;

    for (LatLng marker in markerCoordinates) {
      if (marker.latitude < minLat) minLat = marker.latitude;
      if (marker.latitude > maxLat) maxLat = marker.latitude;
      if (marker.longitude < minLng) minLng = marker.longitude;
      if (marker.longitude > maxLng) maxLng = marker.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    controller?.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        left: 50,
        right: 50,
        top: 50,
        bottom: 50,
      ),
    );
  }

  void onMapIdle(AsyncSnapshot<Position?> snapshot) async {
    if (!isCurrentLocationMarkerAdded) {
      await controller?.addSymbol(
        SymbolOptions(
          geometry: LatLng(snapshot.data?.latitude ?? 3.0136, snapshot.data?.longitude ?? -76.4844),
          iconImage: "assets/svg/current_location.png",
          iconSize: 3,
        ),
      );
      final List<LatLng> calculateCoordinates = [];
      for (int i = 0; i < ((widget.farm?.location.length) ?? 0); i++) {
        LatLng latLng = LatLng(widget.farm?.location[i]['latitude'] ?? 0, widget.farm?.location[i]['longitude'] ?? 0);
        calculateCoordinates.add(latLng);
        _addMarker(latLng);
        if (i == (widget.farm?.location.length ?? 0) - 1) {
          _createSquare(calculateCoordinates);
          setState(() {
            _isPolygonCompleted = true;
          });
          _adjustZoom(calculateCoordinates);
        }
      }
      isCurrentLocationMarkerAdded = true;
    }
  }
}
