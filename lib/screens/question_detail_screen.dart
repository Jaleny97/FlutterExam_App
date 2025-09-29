import 'package:exam_app/services/db_helper.dart';
import 'package:exam_app/services/service_http.dart';
import 'package:flutter/material.dart';

class QuestionDetailScreen extends StatefulWidget {
  const QuestionDetailScreen({super.key});

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  bool isLoading = true;
  Map paperDetail = {};
  List questions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final paperId = ModalRoute.of(context)!.settings.arguments as int;
    fetchDetails(paperId);
  }

  Future<void> fetchDetails(int paperId) async {
    try {
      final data = await ApiServiceHttp().fetchPaperDetail(paperId);
      setState(() {
        paperDetail = data;
        questions = data['questions'];
        isLoading = false;
      });

      // Save to local cache
      await DBHelper.saveLastViewedPaper(paperId, data['title']);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching questions')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(paperDetail['title'] ?? 'Questions')),
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
                    'Loading questions...',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                return ExpansionTile(
                  title: Text(q['text']),
                  children: (q['answers'] as List)
                      .map((a) => ListTile(title: Text(a['text'])))
                      .toList(),
                );
              },
            ),
    );
  }
}
