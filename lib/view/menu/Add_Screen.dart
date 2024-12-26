import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() =>
      _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  LatLng? _selectedLocation; // Ubicación seleccionada en el mapa
  final TextEditingController _activityNameController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedImage;

  // Método para seleccionar una ubicación en el mapa
  void _onMapTapped(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  // Método para mostrar el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Método para seleccionar una foto usando ImagePicker
  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Método para guardar la actividad
  void _saveActivity() {
    if (_selectedLocation == null ||
        _activityNameController.text.isEmpty ||
        _selectedDate == null ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos.'),
        ),
      );
      return;
    }

    // Lógica para guardar la actividad (enviar a base de datos o similar)

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Actividad guardada con éxito!'),
      ),
    );

    // Opcional: Limpieza de los campos después de guardar
    setState(() {
      _selectedLocation = null;
      _activityNameController.clear();
      _selectedDate = null;
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Actividad'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona un lugar:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 300,
                child: GoogleMap(
                  onTap: _onMapTapped,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(19.4326, -99.1332), // Ubicación inicial (Ciudad de México)
                    zoom: 10.0,
                  ),
                  markers: _selectedLocation == null
                      ? {}
                      : {
                    Marker(
                      markerId: const MarkerId('selected-location'),
                      position: _selectedLocation!,
                    ),
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _activityNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la actividad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Fecha: No seleccionada'
                        : 'Fecha: ${_selectedDate!.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Seleccionar Fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _selectedImage == null
                      ? const Text('No se ha seleccionado una foto')
                      : Image.file(
                    _selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _selectImage,
                    child: const Text('Subir Foto'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Guardar Actividad',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
