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
      _generateNearbyEvents(); // Generar puntos cercanos
    });
  }

  // Método para generar eventos cercanos
  void _generateNearbyEvents() {
    const int numberOfEvents = 5; // Número de eventos a generar
    const double maxDistanceInMeters = 5000; // Distancia máxima para los eventos (5 km)
    final random = Random();

    for (int i = 0; i < numberOfEvents; i++) {
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

      // Crear marcador para el evento
      _markers.add(
        Marker(
          markerId: MarkerId("event_$i"),
          position: eventPosition,
          infoWindow: InfoWindow(
            title: "Evento $i",
            snippet: "Distancia: ${distance.toStringAsFixed(2)} metros",
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
        infoWindow: const InfoWindow(title: "Tu ubicación"),
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
        title: const Text('Eventos Cercanos'),
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
