import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fuzzy/data/result.dart';
import 'package:fuzzy/fuzzy.dart';
import '../models/alumni.dart';
import '../widgets/alumni_card.dart';
import 'alumni_profile_page.dart';

enum SearchFilter { all, name, branch, company, role }

class AlumniSearchPage extends StatefulWidget {
  final List<Alumni> allAlumni;
  const AlumniSearchPage({super.key, required this.allAlumni});
  @override
  State<AlumniSearchPage> createState() => _AlumniSearchPageState();
}

class _AlumniSearchPageState extends State<AlumniSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Result<Alumni>> _filteredResults = [];
  SearchFilter _currentFilter = SearchFilter.all;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_runSearch);
  }

  @override
  void dispose() {
    _controller.removeListener(_runSearch);
    _controller.dispose();
    super.dispose();
  }

  void _runSearch() {
    final query = _controller.text;
    if (query.isEmpty) {
      setState(() => _filteredResults = []);
      return;
    }

    final keysToSearch = <WeightedKey<Alumni>>[];
    if (_currentFilter == SearchFilter.all) {
      keysToSearch.addAll([
        WeightedKey<Alumni>(name: 'name', weight: 0.5, getter: (a) => a.name),
        WeightedKey<Alumni>(name: 'role', weight: 0.2, getter: (a) => a.role),
        WeightedKey<Alumni>(
          name: 'company',
          weight: 0.2,
          getter: (a) => a.company,
        ),
        WeightedKey<Alumni>(
          name: 'branch',
          weight: 0.1,
          getter: (a) => a.branch,
        ),
      ]);
    } else {
      keysToSearch.add(
        WeightedKey<Alumni>(
          name: _currentFilter.toString().split('.').last,
          weight: 1,
          getter: (a) {
            switch (_currentFilter) {
              case SearchFilter.name:
                return a.name;
              case SearchFilter.branch:
                return a.branch;
              case SearchFilter.company:
                return a.company;
              case SearchFilter.role:
                return a.role;
              default:
                return a.name;
            }
          },
        ),
      );
    }
    final searcher = Fuzzy<Alumni>(
      widget.allAlumni,
      
      options: FuzzyOptions(keys: keysToSearch, threshold: 0.5),
    );
    setState(() {
      _filteredResults = searcher.search(query);
    });
  }

  
  List<int> getManualMatches(String text, String query) {
    final List<int> indices = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    
    final queryChars = lowerQuery.replaceAll(' ', '').split('').toSet();

    for (int i = 0; i < lowerText.length; i++) {
      if (queryChars.contains(lowerText[i])) {
        indices.add(i);
      }
    }
    return indices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredResults.length,
                itemBuilder: (context, index) {
                  final result = _filteredResults[index];
                  final alumni = result.item;
                  final query = _controller.text;

                  return AlumniCard(
                    alumni: alumni,
                    
                    nameMatches: getManualMatches(alumni.name, query),
                    roleMatches: getManualMatches(alumni.role, query),
                    companyMatches: getManualMatches(alumni.company, query),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => AlumniProfilePage(alumni: alumni),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            _buildFilterChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filterOptions = {
      SearchFilter.all: 'All',
      SearchFilter.name: 'Name',
      SearchFilter.branch: 'Branch',
      SearchFilter.company: 'Company',
      SearchFilter.role: 'Role',
    };
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Wrap(
        spacing: 8.0,
        alignment: WrapAlignment.center,
        children: filterOptions.entries.map((entry) {
          return FilterChip(
            label: Text(entry.value),
            selected: _currentFilter == entry.key,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _currentFilter = entry.key;
                  _runSearch();
                });
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
