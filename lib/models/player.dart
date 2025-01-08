import 'dart:math';

import 'ability.dart';

class Player {
  String username = ''; // Store username here
  double attackPower = 10.0;
  double damageReduction = 0.0;
  double defence = 0.0;
  double magicDefence = 0.0;
  double speed = 0.0;
  double critChance = 0.05; // 5% base critical hit chance
  double health = 100.0; // Initial health value
  double maxHealth = 100.0; // Maximum health value
  List<Ability> abilities = [];

  Player({
    String? username,
    double? attackPower,
    double? damageReduction,
    double? defence,
    double? magicDefence,
    double? speed,
    double? critChance,
    double? health,
    double? maxHealth,
  }) {
    this.username = username ?? this.username;
    this.attackPower = attackPower ?? this.attackPower;
    this.damageReduction = damageReduction ?? this.damageReduction;
    this.critChance = critChance ?? this.critChance;
    this.health = health ?? this.health;
    this.maxHealth = maxHealth ?? this.maxHealth;
  }

  /// Generate stats randomly with no specific focus
  void generateStats({required int bst}) {
    final rng = Random();

    // Number of stats to distribute BST among
    const int numStats =
        5; // attackPower, defence, magicDefence, speed, and health

    // Generate random weights for each stat
    final weights = List.generate(numStats, (_) => rng.nextDouble());

    // Normalize weights so their sum equals 1
    final totalWeight = weights.reduce((a, b) => a + b);
    final normalizedWeights = weights.map((w) => w / totalWeight).toList();

    // Distribute BST based on normalized weights
    attackPower = (bst * normalizedWeights[0]).roundToDouble();
    defence = (bst * normalizedWeights[1]).roundToDouble();
    magicDefence = (bst * normalizedWeights[2]).roundToDouble();
    speed = (bst * normalizedWeights[3]).roundToDouble();
    health = maxHealth = (bst * normalizedWeights[4]).roundToDouble();

    // Add randomness to damage reduction
    damageReduction = rng.nextDouble() * 0.2; // Cap at 20% reduction
  }

  void takeDamage(double damage) {
    final effectiveDamage = damage * (1 - damageReduction);
    health -= effectiveDamage;
    if (health < 0) {
      health = 0; // Prevent negative health
    }
  }

  void heal(double amount) {
    health += amount;
    if (health > maxHealth) {
      health = maxHealth; // Cap health at maximum
    }
  }

  void applyAbility(Ability ability) {
    abilities.add(ability); // Add ability to the player's list
  }
}
