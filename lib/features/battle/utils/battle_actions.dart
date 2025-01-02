import 'package:flutter/material.dart';
import '../../../models/player.dart';

void handleAttack({
  required BuildContext context,
  required Player player,
  required int enemyHealth,
  required int enemyMeleeDamage,
  required Function(int) updateEnemyHealth,
  required Function() onEnemyDefeated,
  required Function() onPlayerDefeated,
}) {
  int updatedEnemyHealth = enemyHealth;

  // Player attacks the enemy
  if (updatedEnemyHealth > 0) {
    updatedEnemyHealth -= 25; // Simulate player attack damage
    if (updatedEnemyHealth <= 0) {
      updatedEnemyHealth = 0;
      onEnemyDefeated(); // Callback for enemy defeated
      return;
    }
  }

  // Enemy attacks back
  if (updatedEnemyHealth > 0) {
    final damageTaken =
        (enemyMeleeDamage * (1 - player.damageReduction)).toDouble();
    player.takeDamage(damageTaken);
    if (player.health <= 0) {
      onPlayerDefeated(); // Callback for player defeated
    }
  }

  updateEnemyHealth(updatedEnemyHealth); // Update enemy health
}
