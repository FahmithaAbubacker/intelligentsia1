class TriviaQuestion {
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String difficulty;

  TriviaQuestion({
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.difficulty,
  });

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      category: json['category'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      incorrectAnswers: List<String>.from(json['incorrect_answers']),
      difficulty: json['difficulty'], 
    );
  }
}
