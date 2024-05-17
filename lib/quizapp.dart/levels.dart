import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intelligentsia1/quizapp.dart/questionspage.dart';

class DifficultyLevels extends StatelessWidget {
  final String categoryId;

  DifficultyLevels({required this.categoryId});
  final List<Color> colors = [
    const Color.fromARGB(255, 192, 207, 178),
    Colors.blue.shade100,
    const Color.fromARGB(255, 155, 122, 72),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _getUrl(String difficulty, int amount) =>
        'https://opentdb.com/api.php?amount=$amount&category=$categoryId&difficulty=$difficulty&type=multiple';
    Widget _buildDifficultyCard(
            String difficulty, int amount, Color color, IconData icon) =>
        SizedBox(
          height: 180,
          width: 100,
          child: Card(
            color: Colors.white,
            
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    trailing: Icon(
                      FontAwesomeIcons.starHalfStroke,
                      color: Colors.yellow,
                    ),
                  ),
                  SizedBox(height: 100,
                  
                    child: Card(
                      color: color,
                      child: ListTile(
                        title: Text(
                          difficulty,
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                      categoryUrl: _getUrl(
                                          difficulty.toLowerCase(), amount),
                                      level: difficulty)));
                        },
                      ),
                    ),
                  ),
                ],
              
            ),
          
        ));

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height / 2,
            width: size.width,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 192, 207, 178),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("pictures/qq.png",
                  fit: BoxFit.cover, height: 200, width: 100),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 520,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 80),
                    child: _buildDifficultyCard(
                      'Easy',
                      10,
                      colors[0],FontAwesomeIcons.star
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildDifficultyCard(
                      'Medium',
                      12,
                      colors[1],FontAwesomeIcons.star
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildDifficultyCard(
                      'Hard',
                      15,
                      colors[2],FontAwesomeIcons.star
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
