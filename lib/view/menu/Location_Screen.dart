import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:plan_match/view/menu/Profile_Screen.dart';
import 'package:plan_match/view/menu/Add_Screen.dart';
import 'package:plan_match/view/menu/Favorites_Screen.dart';
import 'package:plan_match/view/Home_Screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int _page = 4; // Página inicial seleccionada
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  late GoogleMapController mapController;
  LatLng? _currentLocation;
  final Set<Marker> _markers = {};
  final List<LatLng> _routePoints = []; // Puntos de la ruta seleccionada
  String _distance = "";
  String _duration = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, habilita los servicios de ubicación.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación permanentemente denegado.')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _generateNearbyEvents();
    });
  }

  void _generateNearbyEvents() {
    const int numberOfEvents = 5;
    const double maxDistanceInMeters = 5000;
    final random = Random();
    // Lista de nombres de eventos
    const List<String> eventNames = [
      "Caminata grupal",
      "Yoga al aire libre",
      "Bicicleteada",
      "Picnic en el parque",
      "Clase de baile",
      "Taller de fotografía",
      "Paseo con mascotas",
      "Karaoke",
      "Competencia de pintura",
      "Mercado local"
    ];

    for (int i = 0; i < numberOfEvents; i++) {
      final double randomDistance = random.nextDouble() * maxDistanceInMeters;
      final double randomAngle = random.nextDouble() * 2 * pi;

      final double offsetLatitude = randomDistance * cos(randomAngle) / 111320;
      final double offsetLongitude = randomDistance * sin(randomAngle) /
          (111320 * cos(_currentLocation!.latitude * pi / 180));

      final LatLng eventPosition = LatLng(
        _currentLocation!.latitude + offsetLatitude,
        _currentLocation!.longitude + offsetLongitude,
      );

      final double distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        eventPosition.latitude,
        eventPosition.longitude,
      );

      // Seleccionar un nombre aleatorio para el evento
      final String eventName = eventNames[random.nextInt(eventNames.length)];

      // Crear marcador para el evento
      _markers.add(
        Marker(
          markerId: MarkerId("event_$i"),
          position: eventPosition,
          infoWindow: InfoWindow(
            title: eventName,
            snippet: "Distancia: ${distance.toStringAsFixed(2)} metros",
            onTap: () => _getDirections(eventPosition),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    // Agregar marcador para la ubicación actual
    _markers.add(
    Marker(
    markerId: const MarkerId("currentLocation"),
    position: _currentLocation!,
    infoWindow: const InfoWindow(title: "Cerca de ti"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
    );


    setState(() {});
  }

  Future<void> _getDirections(LatLng destination) async {
    final String apiKey = 'AIzaSyDDGoDvMhcY33yvylJJHkSfTLms-Ddh98k';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'].isNotEmpty) {
        final points = _decodePolyline(data['routes'][0]['overview_polyline']['points']);
        final distance = data['routes'][0]['legs'][0]['distance']['text'];
        final duration = data['routes'][0]['legs'][0]['duration']['text'];

        setState(() {
          _routePoints.clear();
          _routePoints.addAll(points);
          _distance = distance;
          _duration = duration;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Distancia: $_distance, Tiempo: $_duration'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudieron obtener las direcciones.')),
      );
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int deltaLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += deltaLat;

      shift = 0;
      result = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int deltaLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += deltaLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.perm_identity, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.favorite, size: 30),
          Icon(Icons.location_on, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.orangeAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen()));
              break;
            case 4:
              Navigator.push(context, MaterialPageRoute(builder: (context) => LocationScreen()));
              break;
          }
        },
        letIndexChange: (index) => true,
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 14.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: _routePoints,
            color: Colors.blue,
            width: 5,
          ),
        },
      ),
    );
  }
}
