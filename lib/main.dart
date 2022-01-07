import 'package:flutter/material.dart';

import 'views/add.dart';
import 'views/deck.dart';
import 'views/home.dart';

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _bottomNavState = 0;
  final List<Widget> _pages = [const Home(), const Add(), const Deck()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flash Clouds'),
        ),
        body: SafeArea(
          child: _pages[_bottomNavState],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add_outlined),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.reorder),
              label: 'Deck',
            ),
          ],
          currentIndex: _bottomNavState,
          selectedItemColor: Colors.amber[800],
          onTap: _updateBottomNavState,
        ),
      ),
    );
  }

  void _updateBottomNavState(int index) {
    setState(() {
      _bottomNavState = index;
    });
  }
}
