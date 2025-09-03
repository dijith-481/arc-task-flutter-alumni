import 'dart:ui';
import 'package:alumni_app/pages/alumni_search_page.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/alumni.dart';
import '../widgets/alumni_card.dart';
import './alumni_profile_page.dart';

class AlumniListPage extends StatefulWidget {
  const AlumniListPage({super.key});
  @override
  State<AlumniListPage> createState() => _AlumniListPageState();
}

class _AlumniListPageState extends State<AlumniListPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<Alumni>> _alumniFuture;
  List<Alumni> _allAlumni = [];
  String _selectedBranch = 'All';

  @override
  void initState() {
    super.initState();
    _alumniFuture = _firestoreService.getAlumni().then((alumni) {
      if (mounted) {
        setState(() {
          _allAlumni = alumni;
        });
      }
      return alumni;
    });
  }

  List<Alumni> get _filteredBranchAlumni {
    if (_selectedBranch == 'All') return _allAlumni;
    return _allAlumni
        .where((alumni) => alumni.branch == _selectedBranch)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // --- START OF FIX ---
        // We replace the Stack with a Column to control the layout vertically.
        child: Column(
          children: [
            // This Expanded widget tells the FutureBuilder (and its ListView)
            // to take up all the available vertical space ABOVE the search bar.
            Expanded(
              child: FutureBuilder<List<Alumni>>(
                future: _alumniFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('An error occurred: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No alumni found.'));
                  }

                  final list = _filteredBranchAlumni;
                  return ListView.builder(
                    // reverse: true now works as expected within this defined space.
                    reverse: true,
                    // We add top padding to prevent the last item from being hidden
                    // by the status bar when scrolling to the very end.
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final alumni = list[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 40 * (1 - value)),
                            child: Opacity(opacity: value, child: child!),
                          );
                        },
                        child: AlumniCard(
                          alumni: alumni,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  AlumniProfilePage(alumni: alumni),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // The search bar is now the second item in the Column,
            // neatly placed at the bottom.
            _buildBottomSearchAndFilter(context),
          ],
        ),
        // --- END OF FIX ---
      ),
    );
  }

  Widget _buildBottomSearchAndFilter(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          padding: const EdgeInsets.only(top: 8),
          color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildBranchFilters(), _buildSearchTrigger(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildBranchFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 6.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.start, // Or center, end, etc.
          children:
              [
                    'All',
                    'Computer Engineering',
                    'Mechanical Engineering',
                    'Electrical Engineering',
                  ]
                  .map(
                    (branch) => FilterChip(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(branch),
                      selected: _selectedBranch == branch,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedBranch = branch);
                      },
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildSearchTrigger(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AlumniSearchPage(allAlumni: _allAlumni),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.secondaryContainer.withAlpha(60),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Icon(Icons.search),
              const SizedBox(width: 16),
              Text(
                'Search alumni',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
