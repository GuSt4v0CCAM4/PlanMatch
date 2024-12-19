import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';

class QuizzScreen extends StatefulWidget {
  const QuizzScreen({super.key});

  @override
  State<QuizzScreen> createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  late Controller controller;
  late List<VideoPlayerController> videoControllers;

  @override
  void initState() {
    controller = Controller()
      ..addListener((event) {
        _handleCallbackEvent(event);
      });

    // Lista de rutas locales para los videos
    final List<String> videoPaths = [
      'videos/video1.mp4',
      'videos/video2.mp4',
      'videos/video3.mp4',
      'videos/video4.mp4',
    ];

    // Inicializa los controladores de video desde las rutas locales
    videoControllers = videoPaths
        .map((path) => VideoPlayerController.asset(path)
      ..initialize().then((_) {
        setState(() {}); // Actualiza el estado cuando los videos estén listos
      }))
        .toList();

    super.initState();
  }

  @override
  void dispose() {
    // Libera los controladores de video al salir de la pantalla
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectate'),
      ),
      body: TikTokStyleFullPageScroller(
        contentSize: videoControllers.length,
        swipePositionThreshold: 0.2,
        swipeVelocityThreshold: 2000,
        animationDuration: const Duration(milliseconds: 400),
        controller: controller,
        builder: (BuildContext context, int index) {
          final videoController = videoControllers[index];

          return Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Video Player
                if (videoController.value.isInitialized)
                  AspectRatio(
                    aspectRatio: videoController.value.aspectRatio,
                    child: VideoPlayer(videoController),
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                // Botón de reproducción/pausa
                Positioned(
                  bottom: 50,
                  child: IconButton(
                    iconSize: 60,
                    color: Colors.white,
                    icon: Icon(
                      videoController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        if (videoController.value.isPlaying) {
                          videoController.pause();
                        } else {
                          videoController.play();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleCallbackEvent(ScrollEvent event) {
    debugPrint(
        "Scroll callback: {direction: ${event.direction}, success: ${event.success}, page: ${event.pageNo ?? 'none'}}");

    // Maneja la reproducción/pausa de los videos al cambiar de página
    for (int i = 0; i < videoControllers.length; i++) {
      if (i == event.pageNo) {
        videoControllers[i].play(); // Reproduce el video actual
      } else {
        videoControllers[i].pause(); // Pausa otros videos
      }
    }
  }
}
