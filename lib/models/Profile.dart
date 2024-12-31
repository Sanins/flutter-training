class Profile {
  String username;

  Profile({
    required this.username,
  });

  // Add methods specific to profile management
  void updateUsername(String newUsername) {
    username = newUsername;
  }
}
