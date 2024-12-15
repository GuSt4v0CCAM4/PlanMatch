import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class BackpackScreen extends StatefulWidget {
  const BackpackScreen({super.key});

  @override
  State<BackpackScreen> createState() => _BackpackScreen();
}

class _BackpackScreen extends State<BackpackScreen> {
  late CameraController _controller;
  late ObjectDetector _objectDetector;
  bool _isDetecting = false;
  List<DetectedObject> _detectedObjects = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeObjectDetector();
  }

  // Inicialización de la cámara
  void _initializeCamera() async {
    final cameraList = await availableCameras();
    _controller = CameraController(cameraList.first, ResolutionPreset.medium,
        enableAudio: false, imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _controller.startImageStream(_processCameraImage);
    });
  }

  // Inicialización del detector de objetos
  void _initializeObjectDetector() {
    final options = ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
  }

  // Procesar las imágenes de la cámara para detectar objetos
  void _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    final inputImage = _convertToInputImage(image);
    final objects = await _objectDetector.processImage(inputImage);
    setState(() {
      _detectedObjects = objects;
    });
    _isDetecting = false;
  }

  // Convertir la imagen de la cámara a un formato adecuado para la detección
  InputImage _convertToInputImage(CameraImage image) {
    var sensorOrientation = _controller.description.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = 0;
      if (_controller.description.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    final format = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation!,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  // Liberar los recursos cuando la pantalla se descarte
  @override
  void dispose() {
    _controller.dispose();
    _objectDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Object Detection')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Backpack Screen')),
      body: Stack(
        children: [
          CameraPreview(_controller),
          _buildBoundingBoxes(),
        ],
      ),
    );
  }

  // Dibujar los cuadros delimitadores y etiquetas de los objetos detectados
  Widget _buildBoundingBoxes() {
    return CustomPaint(
      painter: BoxPainter(objects: _detectedObjects),
    );
  }
}

// Clase para pintar los cuadros delimitadores y las etiquetas
class BoxPainter extends CustomPainter {
  final List<DetectedObject> objects;
  BoxPainter({required this.objects});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    for (var object in objects) {
      final rect = object.boundingBox;
      canvas.drawRect(
        Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right,
          rect.bottom,
        ),
        paint,
      );
      TextStyle textStyle = const TextStyle(
        color: Colors.purpleAccent,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );
      TextSpan textSpan = TextSpan(
        text: object.labels.isEmpty ? 'No name' : object.labels.first.text,
        style: textStyle,
      );
      TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();
      double dx = rect.left + (rect.width - textPainter.width) / 2;
      double dy = rect.top + (rect.height - textPainter.height) / 2;
      Offset offset = Offset(dx, dy);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
