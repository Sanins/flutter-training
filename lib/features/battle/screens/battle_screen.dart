import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/features/battle/widgets/stats_drawer.dart';
import 'package:test_drive/features/battle/widgets/boss_details_drawer.dart';
import '../../../models/player.dart';
import '../../../models/enemy.dart';
import '../utils/battle_actions.dart';
import '../screens/celebration.screen.dart';
import './defeat_screen.dart';
import '../utils/enemy_factory.dart';
import '../../../providers/item_provider.dart';
import '../../../models/item.dart';

// Example action lists
final List<String> attackStyles = ["Sword Strike", "Power Slash", "Quick Jab"];
final List<String> magicSpells = ["Fireball", "Ice Blast", "Healing Light"];

class BattlePage extends StatefulWidget {
  final Player player;
  final int battleNumber;

  const BattlePage({
    super.key,
    required this.player,
    required this.battleNumber,
  });

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Enemy enemy;
  String selectedAction = 'Attack';

  @override
  void initState() {
    super.initState();
    enemy = generateEnemy(widget.battleNumber);
  }

  void _useItem(Item item) {
    handleItem(
      context: context,
      player: widget.player,
      item: item,
      onItemUsed: () {
        context.read<ItemProvider>().removeItem(item);

        setState(() {});
      },
    );
  }

  void _attack() {
    handleAttack(
      context: context,
      player: widget.player,
      enemy: enemy,
      updateEnemyHealth: (newHealth) {
        setState(() {
          enemy.health = newHealth;
        });
      },
      onEnemyDefeated: () {
        _goToCelebrationScreen();
      },
      onPlayerDefeated: () {
        _goToDefeatScreen();
      },
    );
  }

  void _goToCelebrationScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CelebrationScreen(
          player: widget.player,
          battleNumber: widget.battleNumber + 1,
        ),
      ),
    );
  }

  void _goToDefeatScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DefeatScreen(),
      ),
    );
  }

  void _chat() {}

  void _showAttackStyles() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Attack Style"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: attackStyles
                .map((style) => ListTile(
                      title: Text(style),
                      onTap: () {
                        setState(() {
                          selectedAction = style;
                        });
                        Navigator.pop(context);
                        _attack();
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  void _showMagicSpells() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Magic Spell"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: magicSpells
                .map((spell) => ListTile(
                      title: Text(spell),
                      onTap: () {
                        setState(() {
                          selectedAction = spell;
                        });
                        Navigator.pop(context);
                        _attack();
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  void _showItems(List<Item> items) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map((item) => ListTile(
                      title: Text(item.title),
                      onTap: () {
                        Navigator.pop(context);
                        _useItem(item);
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Battle Page'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${enemy.name} Health: ${enemy.health.toStringAsFixed(1)} HP',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  'Player Health: ${widget.player.health.toStringAsFixed(1)} HP',
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
                      onPressed: _showAttackStyles, // Show attack styles
                      child: const Text('Attack'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.player.damageReduction += 0.05;
                        });
                      },
                      child: const Text('Defend'),
                    ),
                    ElevatedButton(
                      onPressed: _showMagicSpells, // Show magic spells
                      child: const Text('Magic'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final items = context.read<ItemProvider>().items;
                        _showItems(items); // Show the items from the provider
                      },
                      child: const Text('Item'),
                    ),
                    ElevatedButton(
                      onPressed: _chat, // Show items
                      child: const Text('Chat'),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      drawer:
          const BossDetailsDrawer(), // This is the drawer that should show the boss details
      endDrawer: StatsDrawer(
        health: widget.player.health.toInt(),
        player: widget.player,
      ),
    );
  }
}
