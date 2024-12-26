import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _currentLocation; // Ubicación actual del usuario
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Método para obtener la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, habilita los servicios de ubicación.')),
      );
      return;
    }

    // Verificar permisos
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

    // Obtener la ubicación actual
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _generateEvent(); // Generar un punto aleatorio cercano
    });
  }

  // Método para generar un evento cercano
  void _generateEvent() {
    const double maxDistanceInMeters = 2000; // Distancia máxima para el evento (2 km)
    final random = Random();

    final double randomDistance = random.nextDouble() * maxDistanceInMeters;
    final double randomAngle = random.nextDouble() * 2 * pi;

    // Calcular desplazamientos en latitud y longitud
    final double offsetLatitude = randomDistance * cos(randomAngle) / 111320; // 1 grado ≈ 111.32 km
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

    // Calcular el tiempo estimado (asumiendo 5 km/h de velocidad promedio)
    final double timeInHours = distance / 5000; // Tiempo en horas
    final int minutes = (timeInHours * 60).round();

    // Crear marcador para el evento
    _markers.add(
      Marker(
        markerId: const MarkerId("paseoGrupal"),
        position: eventPosition,
        infoWindow: InfoWindow(
          title: "Paseo Grupal",
          snippet: "Distancia: ${distance.toStringAsFixed(2)} metros\n"
              "Tiempo estimado: ${minutes} minutos caminando",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Agregar marcador para la ubicación actual
    _markers.add(
      Marker(
        markerId: const MarkerId("currentLocation"),
        position: _currentLocation!,
        infoWindow: const InfoWindow(title: "Ubicacion de la actividad"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    setState(() {}); // Actualizar UI
  }

  // Método para manejar la creación del mapa
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
      appBar: AppBar(
        title: const Text('Paseo Grupal'),
        backgroundColor: Colors.green[700],
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
        myLocationEnabled: true, // Habilitar indicador de ubicación actual
        myLocationButtonEnabled: true, // Botón para centrar en la ubicación actual
      ),
    );
  }
}
