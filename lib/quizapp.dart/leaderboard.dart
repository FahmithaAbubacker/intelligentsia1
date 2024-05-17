import 'package:flutter/material.dart';
import 'package:intelligentsia1/quizapp.dart/database1.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<ScoreModel> _scores = [];

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    List<ScoreModel> scores = await ScoreDatabase().getData();

    scores.sort((a, b) => b.score!.compareTo(a.score!));

    Set<String> uniqueScores = scores.map((score) => '${score.username}_${score.level}').toSet();

    setState(() {
      _scores = uniqueScores.map((key) {
        List<String> keyParts = key.split('_');
        return ScoreModel(
          username: keyParts[0],
          level: keyParts[1],
          score: scores.firstWhere((score) => score.username == keyParts[0] && score.level == keyParts[1]).score,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 192, 207, 178),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 192, 207, 178),
        title: const Text('Leaderboard', style: TextStyle(color: Colors.white)),
      ),
      body: _scores.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _scores.length,
              itemBuilder: (context, index) {
                final score = _scores[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      title: Text('${score.username ?? ''} - ${score.level ?? ''}'),
                      subtitle: Text('Score: ${score.score}'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
