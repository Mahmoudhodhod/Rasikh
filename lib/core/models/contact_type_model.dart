class ContactType {
  final int id;
  final String name;

  ContactType({required this.id, required this.name});

  factory ContactType.fromJson(Map<String, dynamic> json) {
    return ContactType(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
