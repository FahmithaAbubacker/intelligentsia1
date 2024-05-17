import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligentsia1/quizapp.dart/successfulpage.dart';


class QuizScreen extends StatefulWidget {
  final String categoryUrl;
  final String level;

  const QuizScreen({Key? key, required this.categoryUrl, required this.level})
      : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> _questions;
  int _currentIndex = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  String? _selectedAnswer;
  String? _correctAnswer;
  bool _optionSelected = false;

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    _questions = fetchQuestions();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 15))
      ..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        nextQuestion();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await http.get(Uri.parse(widget.categoryUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> questions = List<Map<String, dynamic>>.from(data['results']);

      questions.forEach((question) {
        List<dynamic> options = [
          ...question['incorrect_answers'].cast<String>(),
          question['correct_answer']
        ];
        options.shuffle();
        question['options'] = options;
      });

      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void checkAnswer(String selectedAnswer) async {
    List<Map<String, dynamic>> questions = await _questions;
    dynamic correctAnswer = questions[_currentIndex]['correct_answer'];

    setState(() {
      if (!_optionSelected) {
        _optionSelected = true;
        _selectedAnswer = selectedAnswer;
        _correctAnswer = correctAnswer.toString();
        if (selectedAnswer == _correctAnswer) {
          _correctAnswers++;
        } else {
          _wrongAnswers++;
        }
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void nextQuestion() async {
    List<Map<String, dynamic>> questions = await _questions;
    setState(() {
      if (_currentIndex + 1 < questions.length) {
        _currentIndex++;
        _optionSelected = false;
        _selectedAnswer = null;
        _correctAnswer = null;
        controller.reset();
        controller.forward();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizSuccessPage(
              totalQuestions: questions.length,
              currentscore: _correctAnswers,
              wrongAnswers: _wrongAnswers,
              level: widget.level,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 192, 207, 178),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 192, 207, 178),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _questions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var questionData = snapshot.data![_currentIndex];
                    List<String> options = List<String>.from(questionData['options']);
                    return Column(
                      children: [
                        Text(
                          "Question ${_currentIndex + 1}/${snapshot.data!.length}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: LinearProgressIndicator(
                            value: controller.value,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation(
                              Color.fromARGB(234, 245, 160, 32),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           
                              Text(
                                questionData['question'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 15),
                              ...options.map((option) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (!_optionSelected) {
                                            checkAnswer(option);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: BeveledRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          backgroundColor: _optionSelected
                                              ? (option == _correctAnswer
                                                  ? Colors.green
                                                  : option == _selectedAnswer
                                                      ? Colors.red
                                                      : Colors.white)
                                              : Colors.white,
                                          side: BorderSide(
                                            strokeAlign: BorderSide.strokeAlignOutside,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Text(
                                          option,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 15),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(234, 245, 160, 32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (!_optionSelected) {
                                      nextQuestion();
                                    }
                                  },
                                  child: Text(
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      ],
                    );
                  } else {
                    return Center(child: Text('No questions found'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
