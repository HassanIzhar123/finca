import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<LatLng> _polygonLatLngs = [];
  Set<Polygon> _polygons = HashSet<Polygon>();
  Set<Marker> _markers = HashSet<Marker>();
  int _polygonIdCounter = 1;
  int _markerIdCounter = 1;
  GoogleMapController? _controller;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
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

  void _setPolygons() {
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
  }

  void _onTap(LatLng point) {
    if (_polygonLatLngs.length < 3) {
      // Add marker for the first three taps
      setState(() {
        _polygonLatLngs.add(point);
        _addMarker(point);
      });
    } else if (_polygonLatLngs.length == 3) {
      // Draw polygon on the fourth tap
      setState(() {
        _polygonLatLngs.add(point);
        _addMarker(point);
        _setPolygons();
        _polygonLatLngs = [];
        _markers.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw '),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(45.521563, -122.677433),
          zoom: 11.0,
        ),
        markers: _markers,
        polygons: _polygons,
        onTap: _onTap,
      ),
    );
  }
}