import 'package:flutter/material.dart';
import 'package:exam_app/services/db_helper.dart';
import '../services/service_http.dart';

class PaperListScreen extends StatefulWidget {
  @override
  PaperListScreenState createState() => PaperListScreenState();
}

class PaperListScreenState extends State<PaperListScreen> {
  final api = ApiServiceHttp();
  final TextEditingController searchController = TextEditingController();

  List papers = [];
  List filteredPapers = [];
  bool isLoading = true;
  Map<String, dynamic>? lastViewed;
  String query = '';

  @override
  void initState() {
    super.initState();
    fetchPapers();
    fetchLastViewed();
  }

  Future<void> fetchPapers() async {
    try {
      final data = await api.fetchPapers();
      setState(() {
        papers = data;
        filteredPapers = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching papers')));
    }
  }

  Future<void> fetchLastViewed() async {
    final data = await DBHelper.getLastViewedPaper();
    setState(() => lastViewed = data);
  }

  void filterPapers(String input) {
    setState(() {
      query = input;
      if (input.isEmpty) {
        filteredPapers = papers;
      } else {
        filteredPapers = papers.where((paper) {
          final title = paper['title'].toLowerCase();
          return title.contains(input.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Papers')),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple,
                    ),
                    strokeWidth: 4.5,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fetching legacy...',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: filterPapers,
                    decoration: InputDecoration(
                      hintText: 'Search papers...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                if (lastViewed != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.history),
                      label: Text('Resume: ${lastViewed!['title']}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/questions',
                          arguments: lastViewed!['id'],
                        );
                      },
                    ),
                  ),
                Expanded(
                  child: filteredPapers.isEmpty
                      ? Center(
                          child: Text(
                            'No papers match your search.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredPapers.length,
                          itemBuilder: (context, index) {
                            final paper = filteredPapers[index];
                            return ListTile(
                              title: Text(paper['title']),
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/questions',
                                arguments: paper['id'],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
