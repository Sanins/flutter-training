import 'package:flutter/material.dart';
import '../../../models/player.dart';
import './choose_ability_screen.dart';

class GeneratePlayerScreen extends StatefulWidget {
  const GeneratePlayerScreen({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  _GeneratePlayerScreenState createState() => _GeneratePlayerScreenState();
}

class _GeneratePlayerScreenState extends State<GeneratePlayerScreen> {
  bool statsGenerated = false;

  void generateStats() {
    setState(() {
      widget.player.generateStats(bst: 300);
      statsGenerated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Your Player Stats'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!statsGenerated) ...[
              const Text(
                'Generate Your Player Stats!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: generateStats,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text(
                  'Generate Stats!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            const SizedBox(height: 40),
            if (statsGenerated) ...[
              const Text(
                'Your Player Stats:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildStatsDisplay(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseAbilityScreen(
                        player: widget.player,
                        battleNumber: 1,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Choose Starting Abilities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow('Attack Power', widget.player.attackPower),
        _buildStatRow('Defense', widget.player.defence),
        _buildStatRow('Magic Defense', widget.player.magicDefence),
        _buildStatRow('Speed', widget.player.speed),
        _buildStatRow('Health', widget.player.health),
        _buildStatRow('Critical Chance', widget.player.critChance * 100),
      ],
    );
  }

  Widget _buildStatRow(String statName, double statValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$statName: ${statValue.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
