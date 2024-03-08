import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'package:finca/assets/assets.dart';
import 'package:finca/modules/farms_screen/pages/step_two_new_farm_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class StepOneNewFarmScreen extends StatefulWidget {
  const StepOneNewFarmScreen({super.key});

  @override
  State<StepOneNewFarmScreen> createState() => _StepOneNewFarmScreenState();
}

class _StepOneNewFarmScreenState extends State<StepOneNewFarmScreen> {
  final List<LatLng> _polygonLatLngs = [];
  final Set<Polygon> _polygons = HashSet<Polygon>();
  final Set<Marker> _markers = HashSet<Marker>();
  int _polygonIdCounter = 1;
  int _markerIdCounter = 1;
  bool _isPolygonCompleted = false;
  final TextEditingController _locationController = TextEditingController();
  GoogleMapController? _mapController;
  GlobalKey _screenshotKey = GlobalKey();

  Future<LatLng> _searchLocation(String location) async {
    const apiKey = 'AIzaSyC5OI76CdPB1YkSlMsSpxjwA0BUaOJROxU';
    final endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=$location&key=$apiKey';
    final response = await http.get(Uri.parse(endpoint));
    log('response.statusCode: ${response.statusCode}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final results = data['results'];
      if (results.isNotEmpty) {
        log('results: ${results[0]['geometry']['location']}');
        final location = results[0]['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        return LatLng(lat, lng);
      }
    }

    return const LatLng(0, 0); // Return default location if not found
  }

  void _addMarker(LatLng point) {
    final String markerIdVal = 'marker_$_markerIdCounter';
    _markers.add(
      Marker(
        markerId: MarkerId(markerIdVal),
        position: point,
      ),
    );
    _markerIdCounter++;
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: _polygonLatLngs,
        strokeWidth: 2,
        strokeColor: Colors.green,
        fillColor: Colors.green.withOpacity(0.5),
      ),
    );
    _polygonIdCounter++;
    _isPolygonCompleted = true;
  }

  void _onTap(LatLng point) {
    if (!_isPolygonCompleted) {
      if (_polygonLatLngs.isEmpty) {
        setState(() {
          _polygonLatLngs.add(point);
          _addMarker(point);
        });
      } else if (_polygonLatLngs.length < 4) {
        setState(() {
          _polygonLatLngs.add(point);
          _addMarker(point);
        });

        if (_polygonLatLngs.length == 4) {
          _setPolygon();
        }
      }
    }
  }

  void _undoLastPoint() {
    if (!_isPolygonCompleted && _polygonLatLngs.isNotEmpty) {
      setState(() {
        _polygonLatLngs.removeLast();
        _markers.remove(_markers.last);
      });
    }
  }

  void _deletePolygon() {
    if (_polygons.isNotEmpty) {
      setState(() {
        _polygons.clear();
        _markers.clear();
        _polygonLatLngs.clear();
        _isPolygonCompleted = false;
      });
    }
  }

  Future<Uint8List?> _captureScreenshot(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary = _screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print('Error capturing screenshot: $e');
      return null;
    }
  }

  Future<void> _uploadScreenshot(Uint8List imageBytes) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StepTwoNewFarmScreen(
          selectedPolygons: _polygons,
          polygonImage: imageBytes,
        ),
      ),
    );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       content: Image.memory(imageBytes),
    //     );
    //   },
    // );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
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
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(45.521563, -122.677433),
                  zoom: 11.0,
                ),
                markers: _markers,
                polygons: _polygons,
                onTap: _onTap,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
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
                              'New Farm',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                                fontFamily: 'Rubik',
                              ),
                            ),
                            Text(
                              'Step 1 of 4',
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
                              'Select the location of the farm',
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
                      controller: _locationController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Find Location',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            final location = await _searchLocation(_locationController.text);
                            _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 12.0));
                          },
                        ),
                      ),
                      onSubmitted: (value) async {
                        final location = await _searchLocation(_locationController.text);
                        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 12.0));
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
                        _undoLastPoint();
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
                        _deletePolygon();
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
                        log("selectedPolygons: ${_polygons.toList().toString()}");
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
}
