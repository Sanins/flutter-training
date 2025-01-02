import 'ability.dart';

class Player {
  String username = ''; // Store username here
  double attackPower = 10.0;
  double damageReduction = 0.0;
  double critChance = 0.05; // 5% base critical hit chance
  double health = 100.0; // Initial health value
  double maxHealth = 100.0; // Maximum health value

  // Constructor for custom initialization
  Player({
    String? username,
    double? attackPower,
    double? damageReduction,
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

  // Method to take damage
  void takeDamage(double damage) {
    final effectiveDamage = damage * (1 - damageReduction);
    health -= effectiveDamage;
    if (health < 0) {
      health = 0; // Prevent negative health
    }
  }

  // Method to heal
  void heal(double amount) {
    health += amount;
    if (health > maxHealth) {
      health = maxHealth; // Cap health at maximum
    }
  }

  void applyAbility(Ability ability) {
    ability.applyEffect(this);
  }
}
