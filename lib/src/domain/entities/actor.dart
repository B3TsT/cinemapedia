class Actor {
  final int id;
  final String name;
  final String profilPath;
  final String? character;

  Actor({
    required this.id,
    required this.name,
    required this.profilPath,
    this.character,
  });
}
