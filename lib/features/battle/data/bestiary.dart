import '../../../models/EnemyEntity.dart';

final bestiary = [
  EnemyEntity(
    name: "Goblin",
    description: "freaky little green guy",
    bst: 100,
    timesSeen: 0,
    rarity: 1,
    drops: [Drop.healthPotion],
    type: 'Goblin',
    isBoss: false,
  ),
];
