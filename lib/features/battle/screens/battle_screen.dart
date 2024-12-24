import 'package:flutter/material.dart';
import 'package:test_drive/features/battle/widgets/stats_drawer.dart';
import 'package:test_drive/features/battle/widgets/boss_details_drawer.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _health = 100;

  void _attack() {
    setState(() {
      if (_health > 0) {
        _health -= 25;
        if (_health < 0) {
          _health = 0;
        }
      }
    });
  }

  void _defend() {
    print("Defend action selected");
  }

  void _magic() {
    print("Magic action selected");
  }

  void _item() {
    print("Item action selected");
  }

  Future<bool> _onWillPop() async {
    if (_scaffoldKey.currentState?.isDrawerOpen == true ||
        _scaffoldKey.currentState?.isEndDrawerOpen == true) {
      Navigator.of(context).pop(); // Close any open drawer
      return false; // Prevent further popping
    }
    return true; // Allow default behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle the back navigation
      child: Scaffold(
        key: _scaffoldKey, // Assign the global key
        appBar: AppBar(
          title: const Text('Battle Page'),
        ),
        body: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Health: $_health HP',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 40),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: const EdgeInsets.all(16),
                    children: [
                      ElevatedButton(
                        onPressed: _attack,
                        child: const Text('Attack'),
                      ),
                      ElevatedButton(
                        onPressed: _defend,
                        child: const Text('Defend'),
                      ),
                      ElevatedButton(
                        onPressed: _magic,
                        child: const Text('Magic'),
                      ),
                      ElevatedButton(
                        onPressed: _item,
                        child: const Text('Item'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Floating action button to open stats drawer
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _scaffoldKey.currentState
                        ?.openEndDrawer(); // Open stats drawer
                  },
                  child: const Icon(Icons.arrow_forward),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),

            // Floating action button to open boss details drawer
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _scaffoldKey.currentState
                        ?.openDrawer(); // Open boss details drawer
                  },
                  child: const Icon(Icons.arrow_back),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),

        drawer: const BossDetailsDrawer(),
        endDrawer: StatsDrawer(health: _health),
      ),
    );
  }
}
