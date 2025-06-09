import 'package:enchere_app/UI/HomePage.dart';
import 'package:enchere_app/UI/mesEnchere.dart';
import 'package:flutter/material.dart';
import 'package:enchere_app/UI/Profile.dart';

class Root extends StatefulWidget {
  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  static int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return Profile();
      case 1:
        return HomePage();
      case 2:
        return MesEncheres();
      default:
        return Center(child: Text('Page inconnue'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 0, 132, 162),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 18,
        selectedIconTheme: IconThemeData(size: 35),
        unselectedIconTheme: IconThemeData(size: 25),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Page d\'accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books),
            label: 'Mes enchères',
          ),
        ],
      ),
    );
  }
}
