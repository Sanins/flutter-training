import '../../../models/ability.dart';

final abilitiesWithStats = [
  Ability(
    name: "Spark",
    description: "A weak electrical charge that shocks the enemy.",
    type: "Magic",
    utility: false,
    rarity: 1,
    damage: 10.0, // Low damage
    accuracy: 0.85, // 85% accuracy
  ),
  Ability(
    name: "Ember",
    description: "A flicker of flame that singes the enemy.",
    type: "Magic",
    utility: false,
    rarity: 1,
    damage: 12.0, // Slightly higher damage
    accuracy: 0.80, // 80% accuracy
  ),
];
