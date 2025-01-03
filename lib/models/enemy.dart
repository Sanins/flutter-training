class Enemy {
  String name;
  double health;
  double maxHealth;
  double meleeDamage;

  Enemy({
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.meleeDamage,
  });

  // Method to take damage
  void takeDamage(double damage) {
    health -= damage;
    if (health < 0) {
      health = 0; // Prevent negative health
    }
  }

  // Method to heal
  void heal(double amount) {
    health += amount;
    if (health > maxHealth) {
      health = maxHealth; // Cap health at maxHealth
    }
  }
}
