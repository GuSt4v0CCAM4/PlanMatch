import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:plan_match/view/menu/Profile_Screen.dart';
import 'package:plan_match/view/menu/Add_Screen.dart';
import 'package:plan_match/view/menu/Location_Screen.dart';
import 'package:plan_match/view/menu/Favorites_Screen.dart';
import 'package:plan_match/view/Home_Screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreen();
}

class _FavoritesScreen extends State<FavoritesScreen> {
  int _page = 3; // Página inicial seleccionada
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
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
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
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
      body: Center(
        child: Text(
          '¡Aqui apareceran las actvidades apuntadas!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
