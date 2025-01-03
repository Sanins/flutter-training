import 'package:flutter/material.dart';
import 'package:test_drive/models/item.dart';
import '../../../models/player.dart';
import '../../../models/enemy.dart';

void handleAttack({
  required BuildContext context,
  required Player player,
  required Enemy enemy,
  required Function(double) updateEnemyHealth,
  required Function() onEnemyDefeated,
  required Function() onPlayerDefeated,
}) {
  // Player attacks the enemy
  if (enemy.health > 0) {
    enemy.takeDamage(player.attackPower);
    updateEnemyHealth(enemy.health);

    if (enemy.health <= 0) {
      onEnemyDefeated();
      return;
    }
  }

  // Enemy attacks back
  if (enemy.health > 0) {
    player.takeDamage(enemy.meleeDamage);
    if (player.health <= 0) {
      onPlayerDefeated();
    }
  }
}

void handleItem({
  required BuildContext context,
  required Player player,
  required Item item,
  required Function() onItemUsed,
}) {
  if (item.heal > 0) {
    player.health += item.heal;
    if (player.health > player.maxHealth) {
      player.health = player.maxHealth;
    }
    onItemUsed();
  }
}
