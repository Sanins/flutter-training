import 'package:flutter/material.dart';
import 'package:test_drive/features/battle/widgets/stats_drawer.dart';
import 'package:test_drive/features/battle/widgets/boss_details_drawer.dart';
import '../../../models/player.dart';
import '../screens/celebration.screen.dart';

class BattlePage extends StatefulWidget {
  final Player player;

  const BattlePage({super.key, required this.player});

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _playerHealth = 100;
  int _enemyHealth = 100;
  final int _enemyMeleeDamage = 10;

  @override
  void initState() {
    super.initState();
    // You can initialize _playerHealth based on the Player's properties, if necessary
    _playerHealth =
        100; // Set this to your player's initial health if applicable
  }

  void _attack() {
    setState(() {
      // Player attacks the enemy
      if (_enemyHealth > 0) {
        _enemyHealth -= 25; // Simulate player attack damage
        if (_enemyHealth <= 0) {
          _enemyHealth = 0;
          // Navigate to celebration screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CelebrationScreen(player: Player())),
          );
        }
      }

      // Boss attacks back
      if (_playerHealth > 0 && _enemyHealth > 0) {
        final damageTaken =
            (_enemyMeleeDamage * (1 - widget.player.damageReduction)).toInt();
        _playerHealth -= damageTaken; // Simulate boss attack damage
        if (_playerHealth < 0) {
          _playerHealth = 0;
        }
      }
    });
  }

  void _defend() {
    print("Defend action selected");
    // Example of reducing damage using player's attributes
    setState(() {
      widget.player.damageReduction += 0.05; // Increase damage reduction
    });
  }

  void _magic() {
    print("Magic action selected");
    // Example of interacting with the player's crit chance
    setState(() {
      widget.player.critChance += 0.01;
    });
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        bool value = await _onWillPop();
        if (value) {
          navigator.pop(result);
        }
      },
      child: Scaffold(
        key: _scaffoldKey, // Assign the global key
        appBar: AppBar(
          title: const Text('Battle Page'),
          automaticallyImplyLeading: false,
          actions: <Widget>[Container()],
        ),
        body: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Enemy Health: $_enemyHealth HP',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Player Health: $_playerHealth HP',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Attack Power: ${widget.player.attackPower.toStringAsFixed(2)}',
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
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.arrow_forward),
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
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ],
        ),

        drawer: const BossDetailsDrawer(),
        endDrawer: StatsDrawer(
          health: _playerHealth,
          player: widget.player,
        ), // Pass player to the stats drawer
      ),
    );
  }
}
