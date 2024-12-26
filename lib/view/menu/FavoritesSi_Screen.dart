import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:plan_match/view/menu/Profile_Screen.dart';
import 'package:plan_match/view/menu/Add_Screen.dart';
import 'package:plan_match/view/menu/Location_Screen.dart';
import 'package:plan_match/view/menu/Favorites_Screen.dart';
import 'package:plan_match/view/Home_Screen.dart';

class FavoritesSiScreen extends StatefulWidget {
  final String title;
  final String image;
  const FavoritesSiScreen ({super.key,
    required this.title,
    required this.image,});

  @override
  State<FavoritesSiScreen> createState() => _FavoritesSiScreen();
}

class _FavoritesSiScreen extends State<FavoritesSiScreen> {
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
        backgroundColor: Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.asset(
                  widget.image,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
