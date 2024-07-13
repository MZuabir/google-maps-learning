import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp().then((value) {
      debugPrint('firebase initialized successfully');
    });
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.430253, 70.3454636),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final List<Marker> markers = [];
  final List<Marker> myMarkers = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(28.430253, 70.3454636),
      infoWindow: InfoWindow(title: 'MyLocation', snippet: 'Hi'),
    ),
    const Marker(
      markerId: MarkerId('2'),
      position: LatLng(30.430253, 70.3454636),
      infoWindow: InfoWindow(title: 'somewhere in world', snippet: 'Hi'),
    )
  ];
  @override
  void initState() {
    markers.addAll(myMarkers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: _kGooglePlex,
        compassEnabled: false,
        myLocationButtonEnabled: true,
        buildingsEnabled: true,
        mapToolbarEnabled: true,
        mapType: MapType.normal,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        indoorViewEnabled: true,
        trafficEnabled: true,
        markers: Set<Marker>.of(markers),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              const CameraPosition(target: LatLng(30.430253, 70.3454636), zoom: 14)));
        },
        child: const Icon(Icons.local_activity),
      ),
    );
  }
}
