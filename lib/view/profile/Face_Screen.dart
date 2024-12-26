import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceScreen extends StatefulWidget {
  const FaceScreen({super.key});

  @override
  State<FaceScreen> createState() => _FaceScreenState();
}

class _FaceScreenState extends State<FaceScreen> {
  File? _image; // Para almacenar la imagen seleccionada
  ui.Image? _imageSize; // Para almacenar el tamaño de la imagen
  List<Face> _faces = []; // Lista de rostros detectados
  bool _isProcessing = false; // Para mostrar un indicador de carga
  final ImagePicker _picker = ImagePicker(); // Instancia del selector de imágenes
  final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector(); // Detector de rostros

  // Método para capturar o seleccionar una imagen
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: source);

      if (pickedImage != null) {
        final File imageFile = File(pickedImage.path);
        final ui.Image imageSize = await _getImageSize(imageFile);

        setState(() {
          _image = imageFile;
          _imageSize = imageSize;
          _isProcessing = true;
        });

        // Detectar rostros
        await _detectFaces(_image!);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // Método para obtener el tamaño de la imagen
  Future<ui.Image> _getImageSize(File imageFile) async {
    final Completer<ui.Image> completer = Completer();
    final ImageStream stream = FileImage(imageFile).resolve(const ImageConfiguration());
    stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
    return completer.future;
  }

  // Método para detectar rostros
  Future<void> _detectFaces(File image) async {
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final faces = await _faceDetector.processImage(inputImage);

      setState(() {
        _faces = faces;
        _isProcessing = false;
      });
      // Mostrar mensaje si se detectó al menos un rostro
      if (_faces.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Rostro verificado correctamente! Se detectaron ${_faces.length} rostro(s).'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error detecting faces: $e');
    }
  }

  @override
  void dispose() {
    _faceDetector.close(); // Liberar recursos del detector de rostros
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detección de Rostros"),
      ),
      body: Column(
        children: [
          if (_isProcessing)
            const Center(child: CircularProgressIndicator())
          else if (_image != null)
            Expanded(
              child: Stack(
                children: [
                  // Mostrar la imagen seleccionada
                  Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Dibujar límites de los rostros detectados
                  if (_faces.isNotEmpty && _imageSize != null)
                    CustomPaint(
                      painter: FacePainter(
                        _faces,
                        Size(_imageSize!.width.toDouble(), _imageSize!.height.toDouble()), // Tamaño original de la imagen
                        Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height), // Tamaño del widget
                      ),
                    ),
                ],
              ),
            )
          else
            const Center(child: Text("Selecciona una imagen para comenzar")),
          // Botones para capturar o seleccionar una imagen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera),
                label: const Text("Cámara"),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo),
                label: const Text("Galería"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Clase para dibujar límites alrededor de los rostros detectados
class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final Size widgetSize;

  FacePainter(this.faces, this.imageSize, this.widgetSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    // Calcula los factores de escala
    final scaleX = widgetSize.width / imageSize.width;
    final scaleY = widgetSize.height / imageSize.height;

    for (Face face in faces) {
      // Escala las coordenadas del bounding box
      final rect = Rect.fromLTRB(
        face.boundingBox.left * scaleX,
        face.boundingBox.top * scaleY,
        face.boundingBox.right * scaleX,
        face.boundingBox.bottom * scaleY,
      );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}