import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import '../const.dart'; // Si tienes constantes globales definidas aquí
import 'Home_Screen.dart'; // Tu pantalla principal

class RouletteScreen extends StatefulWidget {
  const RouletteScreen({super.key});

  @override
  State<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen> {
  static final _random = Random();

  final _controller = RouletteController();
  bool _clockwise = true;

  final colors = <Color>[
    Colors.red.withAlpha(50),
    Colors.green.withAlpha(30),
    Colors.blue.withAlpha(70),
    Colors.yellow.withAlpha(90),
    Colors.amber.withAlpha(50),
    Colors.indigo.withAlpha(70),
  ];

  final images = <ImageProvider>[
    const ExactAssetImage("images/gradient.jpg"),
    const ExactAssetImage("images/gradient.jpg"),
    const ExactAssetImage("images/gradient.jpg"),
    const ExactAssetImage("images/gradient.jpg"),
    const ExactAssetImage("images/gradient.jpg"),
    const ExactAssetImage("images/gradient.jpg"),
  ];

  final descriptions = [
    "El Cuenta Cuentos: Comparte historias divertidas o curiosas durante la caminata, haciendo que el recorrido sea más entretenido y lleno de anécdotas",
    "DJ: Se encarga de poner música para animar la caminata, ya sea con un altavoz o cantando alguna canción para todos.",
    "Explorador de Tesoros: Busca objetos curiosos o inusuales en la naturaleza y hace que el grupo participe en búsquedas pequeñas, como encontrar una hoja con un color especial",
    "Se dedica a tomar selfies grupales o fotos espontáneas para capturar momentos divertidos que todos puedan recordar.",
    "Cheff: Lleva algunos bocadillos o bebidas, y hace pequeñas paradas para compartir algo de comida con el grupo.",
    "Escritor: El encargado de escribir reseñas de la caminata, o plasmar en texto de las anecdotas.",
  ];

  String? selectedDescription;

  late final group = RouletteGroup.uniformImages(
    colors.length,
    colorBuilder: (index) => colors[index],
    imageBuilder: (index) => images[index],
    textBuilder: (index) {
      if (index == 0) return 'Cuenta Cuentos';
      if (index == 1) return 'DJ';
      if (index == 2) return 'Explorador de Tesoros';
      if (index == 3) return 'Fotógrafo';
      if (index == 4) return 'Cheff';
      if (index == 5) return 'Escritor';
      return '';
    },
    styleBuilder: (index) {
      return const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conoce tu rol!')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              MyRoulette(
                group: group,
                controller: _controller,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Clockwise: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Checkbox(
                    value: _clockwise,
                    onChanged: (onChanged) {
                      setState(() {
                        _controller.resetAnimation();
                        _clockwise = !_clockwise;
                      });
                    },
                  ),
                ],
              ),
              FilledButton(
                onPressed: () async {
                  final selectedIndex = _random.nextInt(descriptions.length);
                  final completed = await _controller.rollTo(
                    selectedIndex,
                    clockwise: _clockwise,
                    offset: _random.nextDouble(),
                  );

                  if (completed) {
                    setState(() {
                      selectedDescription = descriptions[selectedIndex];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('¡La ruleta se detuvo!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Animación cancelada')),
                    );
                  }
                },
                child: const Text('Girar'),
              ),
              FilledButton(
                onPressed: () {
                  _controller.stop();
                },
                child: const Text('Cancelar'),
              ),
              const SizedBox(height: 20),
              if (selectedDescription != null)
                Text(
                  selectedDescription!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.1),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class MyRoulette extends StatelessWidget {
  const MyRoulette({
    Key? key,
    required this.controller,
    required this.group,
  }) : super(key: key);

  final RouletteGroup group;
  final RouletteController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Roulette(
              group: group,
              controller: controller,
              style: const RouletteStyle(
                dividerThickness: 0.0,
                dividerColor: Colors.black,
                centerStickSizePercent: 0.05,
                centerStickerColor: Colors.black,
              ),
            ),
          ),
        ),
        const Arrow(),
      ],
    );
  }
}

class Arrow extends StatelessWidget {
  const Arrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_drop_down,
      size: 40,
      color: Colors.black,
    );
  }
}
