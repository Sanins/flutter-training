class Item {
  final String title;
  final String description;
  final int heal;
  final int magic;
  final int stamina;

  Item({
    required this.title,
    required this.description,
    this.heal = 0,
    this.magic = 0,
    this.stamina = 0,
  });

  void use() {
    print('Using $title');
    if (heal > 0) {
      print('Restores $heal health');
    }
    if (magic > 0) {
      print('Restores $magic magic');
    }
    if (stamina > 0) {
      print('Restores $stamina stamina');
    }
  }
}
