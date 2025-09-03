import 'package:alumni_app/models/alumni_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alumni.dart';

class FirestoreService {
  FirestoreService._internal();

  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  final _alumniCollection = FirebaseFirestore.instance.collection('alumni');
  final _alumniDetailsCollection = FirebaseFirestore.instance.collection(
    'alumni_details',
  ); // Add this

  final Map<String, AlumniDetails> _detailsCache = {};

  Future<List<Alumni>> getAlumni() async {
    try {
      final snapshot = await _alumniCollection.get();
      final alumniList = snapshot.docs
          .map((doc) => Alumni.fromFirestore(doc.data(), doc.id))
          .toList();
      return alumniList;
    } catch (e) {
      return [
        Alumni(
          id: '1',
          name: 'Error',
          batch: 'Error',
          branch: 'Error',
          company: 'Error',
          role: 'Error',
          imageUrl: 'https://i.pravatar.cc/800',
          linkedinUrl: 'https://www.linkedin.com/in/error',
        ),
      ];
    }
  }

  Future<AlumniDetails> getAlumniDetails(String alumniId) async {
    if (_detailsCache.containsKey(alumniId)) {
      return _detailsCache[alumniId]!;
    }

    try {
      final docSnapshot = await _alumniDetailsCollection.doc(alumniId).get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        throw Exception("Alumni details not found for ID: $alumniId");
      }

      final data = docSnapshot.data()!;
      final details = AlumniDetails(
        description: data['description'] ?? 'No description available.',
        email: data['email'] ?? 'No email available.',
        socials: Map<String, String>.from(data['socials'] ?? {}),
      );

      _detailsCache[alumniId] = details;
      return details;
    } catch (e) {
      return AlumniDetails(
        description: "Failed to load details.",
        email: "error@example.com",
        socials: {},
      );
    }
  }
}
