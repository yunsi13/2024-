import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'Place.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('다중 위치 표시')),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(37.7749, -122.4194),  // 초기 지도 중심
          zoom: 5.0,
        ),
        children: <Widget>[
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: places.map((place) => Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(place.latitude, place.longitude),
              builder: (ctx) => Container(
                child: Icon(Icons.location_on, color: Colors.red, size: 40.0),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
