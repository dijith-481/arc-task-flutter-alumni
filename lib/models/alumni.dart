class Alumni {
  final String id;
  final String name;
  final String batch;
  final String branch;
  final String company;
  final String role;
  final String? imageUrl;
  final String? linkedinUrl;

  const Alumni({
    required this.id,
    required this.name,
    required this.batch,
    required this.branch,
    required this.company,
    required this.role,
    this.imageUrl,
    this.linkedinUrl,
  });

  factory Alumni.fromFirestore(Map<String, dynamic> data, String id) {
    return Alumni(
      id: id,
      name: data['name'] ?? '',
      batch: data['batch'] ?? '',
      branch: data['branch'] ?? '',
      company: data['company'] ?? '',
      role: data['role'] ?? '',
      imageUrl: data['imageUrl'],
      linkedinUrl: data['linkedinUrl'],
    );
  }
}
