import 'ability.dart';

class Player {
  String username = ''; // Store username here
  double attackPower = 10.0;
  double damageReduction = 0.0;
  double critChance = 0.05; // 5% base critical hit chance

  void applyAbility(Ability ability) {
    ability.applyEffect(this);
  }

  // Optionally, add a method to update the username
  void setUsername(String newUsername) {
    username = newUsername;
  }
}
