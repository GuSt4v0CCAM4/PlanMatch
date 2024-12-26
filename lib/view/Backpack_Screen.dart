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

  // Lista para almacenar los objetos detectados y su estado (marcado o no)
  List<Map<String, dynamic>> _detectedObjectsWithState = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeObjectDetector();
  }

  void _initializeCamera() async {
    final cameraList = await availableCameras();
    _controller = CameraController(cameraList.first, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup:
        Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _controller.startImageStream(_processCameraImage);
    });
  }

  void _initializeObjectDetector() {
    final options = ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
  }

  void _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    final inputImage = _convertToInputImage(image);
    final detectedObjects = await _objectDetector.processImage(inputImage);

    setState(() {
      _updateDetectedObjects(detectedObjects);
    });
    _isDetecting = false;
  }

  void _updateDetectedObjects(List<DetectedObject> detectedObjects) {
    _detectedObjectsWithState = detectedObjects.map((object) {
      final label = object.labels.isNotEmpty ? object.labels.first.text : 'No name';
      return {
        'label': label,
        'checked': false,
        'boundingBox': object.boundingBox,
      };
    }).toList();
  }

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
      appBar: AppBar(title: const Text('Apunta las cosas que llevarás')),
      body: Stack(
        children: [
          CameraPreview(_controller),
          _buildBoundingBoxes(),
          _buildObjectChecklist(),
        ],
      ),
    );
  }

  Widget _buildBoundingBoxes() {
    return CustomPaint(
      painter: BoxPainter(objects: _detectedObjectsWithState),
    );
  }

  Widget _buildObjectChecklist() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _detectedObjectsWithState.length,
          itemBuilder: (context, index) {
            final object = _detectedObjectsWithState[index];
            return CheckboxListTile(
              title: Text(object['label']),
              value: object['checked'],
              onChanged: (value) {
                setState(() {
                  _detectedObjectsWithState[index]['checked'] = value ?? false;
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class BoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> objects;

  BoxPainter({required this.objects});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    for (var object in objects) {
      final rect = object['boundingBox'];
      canvas.drawRect(
        Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right,
          rect.bottom,
        ),
        paint,
      );
      final text = object['label'];
      final textStyle = const TextStyle(
        color: Colors.purpleAccent,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );
      final textSpan = TextSpan(
        text: text,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();
      double dx = rect.left + (rect.width - textPainter.width) / 2;
      double dy = rect.top + (rect.height - textPainter.height) / 2;
      final offset = Offset(dx, dy);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
