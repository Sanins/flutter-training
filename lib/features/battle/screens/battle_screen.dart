import 'package:flutter/material.dart';
import 'package:test_drive/features/battle/widgets/stats_drawer.dart';
import 'package:test_drive/features/battle/widgets/boss_details_drawer.dart';
import '../../../models/player.dart';
import '../screens/celebration.screen.dart';
import './defeat_screen.dart';
import '../utils/battle_actions.dart';

class BattlePage extends StatefulWidget {
  final Player player;

  const BattlePage({super.key, required this.player});

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _enemyHealth = 100;
  final int _enemyMeleeDamage = 10;

  void _attack() {
    handleAttack(
      context: context,
      player: widget.player,
      enemyHealth: _enemyHealth,
      enemyMeleeDamage: _enemyMeleeDamage,
      updateEnemyHealth: (newHealth) {
        setState(() {
          _enemyHealth = newHealth;
        });
      },
      onEnemyDefeated: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CelebrationScreen(player: widget.player),
          ),
        );
      },
      onPlayerDefeated: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DefeatScreen()),
        );
      },
    );
  }

  void _defend() {
    setState(() {
      widget.player.damageReduction += 0.05;
    });
  }

  void _magic() {
    setState(() {
      widget.player.critChance += 0.01;
    });
  }

  void _item() {
    setState(() {
      widget.player.heal(20.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Battle Page'),
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Enemy Health: $_enemyHealth HP',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  'Player Health: ${widget.player.health.toStringAsFixed(1)} HP',
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
        health: widget.player.health.toInt(),
        player: widget.player,
      ), // Pass player to the stats drawer
    );
  }
}
