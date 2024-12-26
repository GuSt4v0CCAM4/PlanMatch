import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:circle_ui_navigator/circle_ui_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_match/view/Backpack_Screen.dart';
import 'package:plan_match/view/Chat_Screen.dart';
import 'package:plan_match/view/Map_Screen.dart';
import 'package:plan_match/view/Quizz_Screen.dart';
import 'package:plan_match/view/Roulette_Screen.dart';
import '../const.dart';
import 'Visit_Screen.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:plan_match/view/menu/Profile_Screen.dart';
import 'package:plan_match/view/menu/Add_Screen.dart';
import 'package:plan_match/view/menu/Location_Screen.dart';
import 'package:plan_match/view/menu/Favorites_Screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _page = 2;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repite la animación de forma continua
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void CircularMenu(BuildContext context) {
    bool _isOpeningAnimation = true;
    bool _isClosingAnimation = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Mensaje de completar tareas
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Completa estas pre-tareas para conocer mas sobre la actividad",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Menú circular
                      CircleNavigatorConfig(
                        config: Config(
                          center: Point(200, 300),
                          animatedRippleColor:
                          const Color(0xFFA9E190).withOpacity(0.7),
                          filledCircleColor:
                          const Color(0xFFDBF4AD).withOpacity(0.7),
                          isOpeningAnimation: _isOpeningAnimation,
                          onOpenAnimationComplete: () {
                            setState(() {
                              _isOpeningAnimation = false;
                            });
                          },
                          isClosingAnimation: _isClosingAnimation,
                          onCloseAnimationComplete: () {
                            setState(() {
                              _isClosingAnimation = false;
                            });
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context); // Solo cerrar el diálogo
                            }
                          },
                          iconSize: 48.0,
                          actionIcons: [
                            TappableIconData(
                              assetPath: 'images/backpack.svg',
                              color: Colors.green,
                              tappedColor: Colors.grey,
                              onTap: () {
                                Get.off(BackpackScreen());
                              },
                              outerBorderColor: Colors.white,
                              outerBorderSize: 10,
                              innerBorderColor: Colors.white,
                            ),
                            TappableIconData(
                              assetPath: 'images/gps.svg',
                              color: Colors.purple,
                              tappedColor: Colors.grey,
                              onTap: () {
                                Get.off(const MapScreen());
                              },
                              outerBorderColor: Colors.white,
                              outerBorderSize: 10,
                              innerBorderColor: Colors.white,
                            ),
                            TappableIconData(
                              assetPath: 'images/chat.svg',
                              color: Colors.orange.shade700,
                              tappedColor: Colors.grey,
                              onTap: () {
                                Get.off(const ChatScreen());
                              },
                              outerBorderColor: Colors.white,
                              outerBorderSize: 10,
                              innerBorderColor: Colors.white,
                            ),
                            TappableIconData(
                              assetPath: 'images/social.svg',
                              color: Colors.red.shade700,
                              tappedColor: Colors.grey,
                              onTap: () {
                                Get.off(const QuizzScreen());
                              },
                              outerBorderColor: Colors.white,
                              outerBorderSize: 10,
                              innerBorderColor: Colors.white,
                            ),
                            TappableIconData(
                              assetPath: 'images/ruleta.svg',
                              color: Colors.yellow.shade800,
                              tappedColor: Colors.grey,
                              onTap: () {
                                Get.off(const RouletteScreen());
                              },
                              outerBorderColor: Colors.white,
                              outerBorderSize: 10,
                              innerBorderColor: Colors.white,
                            ),
                          ],
                          closeIcon: TappableIconData(
                            color: const Color(0xFF767522),
                            assetPath: 'assets/images/close.svg',
                            tappedColor:
                            const Color(0xFF767522).withOpacity(0.5),
                            onTap: () {
                              setState(() {
                                _isClosingAnimation = true;
                              });
                            },
                            outerBorderColor: Colors.white54,
                            outerBorderSize: 12,
                            innerBorderColor: Colors.white,
                          ),
                        ),
                        child: const CircleNavigator(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Bottom Navigation Bar
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 2,
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
        animationDuration: Duration(milliseconds: 500),
        onTap: (index) {
          // Navegación basada en el índice del ícono seleccionado
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()), // Reemplaza con tu pantalla
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddScreen()), // Reemplaza con tu pantalla
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()), // Reemplaza con tu pantalla
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()), // Reemplaza con tu pantalla
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationScreen()), // Reemplaza con tu pantalla
              );
              break;
          }
        },
        letIndexChange: (index) => true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            offset: Offset(
                              4,
                              8,
                            ), // Shadow position
                          ),
                        ]),
                    child: const Icon(Icons.menu_open_sharp),
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.location_on,
                        color: Colors.orange,
                      ),
                      Text(
                        'Arequipa, Peru',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      )
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            offset: Offset(
                              4,
                              8,
                            ), // Shadow position
                          ),
                        ]),
                    child: const Icon(Icons.search),
                  ),
                ],
              ),
              SizedBox(
                height: 60.0,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: SuggestList.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
                              offset: Offset(
                                4,
                                8,
                              ), // Shadow position
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            SuggestList[index],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ))
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 350, // Altura ajustada para las tarjetas
                child: CardSwiper(
                  cardsCount: ImagesList.length,
                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                    return Container(
                      margin: const EdgeInsets.all(10), // Espacio alrededor del contenedor
                      decoration: BoxDecoration(
                        color: Colors.white, // Fondo blanco para todo el contenedor
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => VistiScreen()),
                              );
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(ImagesList[index]),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10), // Espaciado interno para la descripción
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      CityList[index],
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    ScaleTransition(
                                      scale: Tween(begin: 1.0, end: 1.2).animate(
                                        CurvedAnimation(
                                          parent: _controller,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Llama a tu función aquí
                                          CircularMenu(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle, // Forma circular
                                            color: Colors.orange,   // Fondo naranja
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange.withOpacity(0.5),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(10), // Espaciado interno para el ícono
                                          child: const Icon(
                                            Icons.menu_rounded,
                                            color: Colors.white,  // Color del ícono
                                            size: 30,             // Tamaño del ícono
                                          ),
                                        ),
                                      ),

                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.star,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    SizedBox(width: 5),
                                    Text('4.5'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
