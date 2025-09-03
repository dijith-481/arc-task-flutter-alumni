// lib/models/alumni_details.dart
class AlumniDetails {
  final String description;
  final String email;
  final Map<String, String> socials; // e.g., {'linkedin': 'url', 'github': 'url'}

  AlumniDetails({
    required this.description,
    required this.email,
    required this.socials,
  });
}
