import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:circle_ui_navigator/circle_ui_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_match/view/Backpack_Screen.dart';
import 'package:plan_match/view/Map_Screen.dart';
import '../const.dart';
import 'Visit_Screen.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  void CircularMenu(BuildContext context){
    bool _isOpeningAnimation = true;
    bool _isClosingAnimation = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CircleNavigatorConfig(
              config: Config(
                center: Point(200, 300),
                animatedRippleColor: const Color(0xFF66A0FE).withOpacity(0.7),
                filledCircleColor: const Color(0xFFB4D8FF).withOpacity(0.7),
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

                  /// Add navigation call based on your navigation setup.
                  /// This one is tested only on Android and iOS.
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);  // Solo cerrar el diálogo
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
                    assetPath: 'assets/images/restaurant.svg',
                    color: Colors.orange.shade700,
                    tappedColor: Colors.grey,
                    onTap: () {
                      /// Add navigation call based on your navigation setup.
                    },
                    outerBorderColor: Colors.white,
                    outerBorderSize: 10,
                    innerBorderColor: Colors.white,
                  ),
                  TappableIconData(
                    assetPath: 'assets/images/baby_changing_station.svg',
                    color: Colors.red.shade700,
                    tappedColor: Colors.grey,
                    onTap: () {
                      /// Add navigation call based on your navigation setup.
                    },
                    outerBorderColor: Colors.white,
                    outerBorderSize: 10,
                    innerBorderColor: Colors.white,
                  ),
                  TappableIconData(
                    assetPath: 'assets/images/construction.svg',
                    color: Colors.yellow.shade800,
                    tappedColor: Colors.grey,
                    onTap: () {
                      /// Add navigation call based on your navigation setup.
                    },
                    outerBorderColor: Colors.white,
                    outerBorderSize: 10,
                    innerBorderColor: Colors.white,
                  ),
                ],
                closeIcon: TappableIconData(
                  color: const Color(0xFF3678D0),
                  assetPath: 'assets/images/close.svg',
                  tappedColor: const Color(0xFF3678D0).withOpacity(0.5),
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
          setState(() {
            _page = index;
          });
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
                height: 250.0,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: ImagesList.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(ImagesList[index]),
                            fit: BoxFit.cover,
                          )),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(
                                Icons.map,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                CityList[index],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      )),
                ),
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
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ImagesList.length,
                    itemBuilder: ((context, index) => Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => VistiScreen()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(ImagesList[index]),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    CityList[index],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Llama a tu función aquí
                                      CircularMenu(context);
                                    },
                                    child: const Icon(Icons.menu_rounded),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.star,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  Text('4.5')
                                ],
                              ),
                            )
                          ],
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
