import '../../../models/enemy.dart';

Enemy generateEnemy(int battleNumber) {
  return Enemy(
    name: 'Enemy #$battleNumber',
    health: 100.0 + (battleNumber * 10),
    maxHealth: 100.0 + (battleNumber * 10),
    meleeDamage: 10.0 + (battleNumber * 2),
  );
}
