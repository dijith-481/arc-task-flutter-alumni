import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/alumni.dart';
import '../models/alumni_details.dart';
import '../services/firestore_service.dart';

class AlumniProfilePage extends StatefulWidget {
  final Alumni alumni;
  const AlumniProfilePage({super.key, required this.alumni});

  @override
  State<AlumniProfilePage> createState() => _AlumniProfilePageState();
}

class _AlumniProfilePageState extends State<AlumniProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<AlumniDetails> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _firestoreService.getAlumniDetails(widget.alumni.id);
  }

  IconData _getSocialIcon(String key) {
    if (key.contains('linkedin')) return Icons.work_outline;
    if (key.contains('github')) return Icons.code;
    if (key.contains('twitter')) return Icons.message_outlined;
    return Icons.link;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.secondaryContainer,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.alumni.imageUrl ?? 'https://i.pravatar.cc/800',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  height: size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.secondaryContainer.withAlpha(160),
                        theme.colorScheme.secondaryContainer,
                      ],
                      stops: const [0.05, 0.5, 0.95],
                    ),
                  ),
                ),

                SizedBox(
                  height: size.height * 0.5,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.alumni.name,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.alumni.role} at ${widget.alumni.company}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.secondary,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${widget.alumni.batch} - ${widget.alumni.branch}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FutureBuilder<AlumniDetails>(
                future: _detailsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Text("Couldn't load details."));
                  }
                  final details = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        details.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer
                              .withAlpha(220),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildActionButtons(context, details),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AlumniDetails details) {
    final theme = Theme.of(context);
    final linkedinUrl = details.socials['linkedin'];
    final otherSocials = Map<String, String>.from(details.socials);
    otherSocials.remove('linkedin');

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                icon: const Icon(Icons.email_outlined),
                label: const Text('Email'),
                onPressed: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: details.email,
                  );
                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                  }
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (linkedinUrl != null) ...[
              const SizedBox(width: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.work_outline, size: 18),
                label: const Text('LinkedIn'),
                onPressed: () async {
                  final Uri url = Uri.parse(linkedinUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (otherSocials.isNotEmpty) ...[
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: otherSocials.entries.map((social) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.onSecondary),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _getSocialIcon(social.key),
                      size: 20,
                      color: theme.colorScheme.onSecondary,
                    ),
                    onPressed: () async {
                      final Uri url = Uri.parse(social.value);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
