import 'package:flash_clouds_app/infra/data_structures/random_card.dart';
import 'package:flash_clouds_app/style/fc_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'infra/data_structures/cards_list.dart';
import 'infra/views/add_cards.dart';
import 'infra/views/all_cards.dart';
import 'infra/views/learn.dart';

void main() async {
  // required by the local storage pkg
  WidgetsFlutterBinding.ensureInitialized();

  // [FN] lock orientation to portrait mode only for now
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _bottomNavState = 0;
  final List<Widget> _pages = [
    const Learn(),
    const AllCards(),
    const AddCards(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CardsList>(
            create: (BuildContext context) => CardsList()),
        ChangeNotifierProvider<RandomCard>(
            create: (BuildContext context) => RandomCard())
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flash Clouds v0.0.1'),
            backgroundColor: FcStyle.main,
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
          icon: Icon(Icons.school),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'All Cards',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add_outlined),
          label: 'Add New',
        ),
      ],
      currentIndex: _bottomNavState,
      selectedItemColor: FcStyle.select,
      unselectedItemColor: FcStyle.bg,
      backgroundColor: FcStyle.main,
      onTap: _updateBottomNavState,
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
    );
  }

  void _updateBottomNavState(int index) {
    setState(() {
      _bottomNavState = index;
    });
  }
}
