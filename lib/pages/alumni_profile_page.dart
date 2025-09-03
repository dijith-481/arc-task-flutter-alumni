import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/alumni.dart';
import '../models/alumni_details.dart';
import '../services/firestore_service.dart';
import '../theme/nord_theme.dart';

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
    _detailsFuture = _firestoreService.getAlumniDetails(widget.alumni.name);
  }

  IconData _getSocialIcon(String key) {
    if (key.contains('linkedin')) return Icons.work_outline;
    if (key.contains('github')) return Icons.code;
    if (key.contains('twitter')) return Icons.message_outlined;
    return Icons.link;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: FutureBuilder<AlumniDetails>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildProfileContent(context, null, isLoading: true);
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _buildProfileContent(context, null, hasError: true);
          }

          return _buildProfileContent(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    AlumniDetails? details, {
    bool isLoading = false,
    bool hasError = false,
  }) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    
    
    return Stack(
      children: [
        
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  widget.alumni.imageUrl ?? 'https://i.pravatar.cc/800'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
        
        Container(
          width: size.width,
          height: size.height,
          color: NordColors.polarNight0.withOpacity(0.4),
        ),
        
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.4, 1.0],
              colors: [
                Colors.transparent,
                theme.scaffoldBackgroundColor.withOpacity(0.1),
                theme.scaffoldBackgroundColor,
              ],
            ),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.95),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.dividerColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 40),

                          
                          Row(
                            children: [
                              
                              
                              Hero(
                                tag: 'avatar-${widget.alumni.name}',
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          theme.dividerColor.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      widget.alumni.imageUrl ??
                                          'https://i.pravatar.cc/150',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),

                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.alumni.name,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${widget.alumni.batch} - ${widget.alumni.branch}',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isLoading)
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(40.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  if (hasError)
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(40.0),
                                        child: Text("Couldn't load details."),
                                      ),
                                    ),
                                  if (details != null) ...[
                                    
                                    Text(
                                      "About",
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      details.description,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        height: 1.5,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    
                                    
                                    Row(
                                      children: [
                                        Expanded(
                                          child: FilledButton.icon(
                                            icon:
                                                const Icon(Icons.email_outlined),
                                            label: const Text('Email'),
                                            onPressed: () async {
                                              final Uri emailLaunchUri = Uri(
                                                scheme: 'mailto',
                                                path: details.email,
                                              );
                                              if (await canLaunchUrl(
                                                  emailLaunchUri)) {
                                                await launchUrl(emailLaunchUri);
                                              }
                                            },
                                            style: FilledButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    
                                    if (details.socials.isNotEmpty) ...[
                                      const SizedBox(height: 24),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: details.socials.entries
                                            .map((social) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: theme.dividerColor
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                _getSocialIcon(social.key),
                                                size: 20,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                              onPressed: () async {
                                                final Uri url =
                                                    Uri.parse(social.value);
                                                if (await canLaunchUrl(url)) {
                                                  await launchUrl(
                                                    url,
                                                    mode: LaunchMode
                                                        .externalApplication,
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
