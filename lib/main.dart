import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'infra/data_structures/cards_list.dart';
import 'infra/views/add.dart';
import 'infra/views/cards_manager.dart';
import 'infra/views/learn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _bottomNavState = 0;
  final List<Widget> _pages = [
    const CardsManager(),
    const Add(),
    const Learn()
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CardsList>(
      create: (BuildContext context) => CardsList(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flash Clouds'),
          ),
          body: SafeArea(
            child: _pages[_bottomNavState],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Cards',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add_outlined),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Learn',
        ),
      ],
      currentIndex: _bottomNavState,
      selectedItemColor: Colors.amber[800],
      onTap: _updateBottomNavState,
    );
  }

  void _updateBottomNavState(int index) {
    setState(() {
      _bottomNavState = index;
    });
  }
}
