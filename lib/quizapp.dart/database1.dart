import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class QuizModel {
  QuizModel({this.key, this.username, this.password, this.mobile});
  String? key;
  String? username;
  String? password;
  int? mobile;

  Map<String, dynamic> toMap() => {
        'USERNAME': username,
        'PASSWORD': password,
        'MOBILE': mobile,
      };
}

class QuizDatabase {
  DatabaseReference database() => FirebaseDatabase.instance.ref().child('Quiz Database');

  Future<void> sendData(QuizModel enrollment) async {
    try {
      final key = database().push().key!;
      await database().child(key).set(enrollment.toMap());
      if (kDebugMode) print("Data added successfully with key: $key");
    } catch (error) {
      if (kDebugMode) print("Error adding data: $error");
    }
  }

  Future<List<QuizModel>> getData() async {
    try {
      var db = await database().once();
      if (db.snapshot.value == null || !(db.snapshot.value is Map<dynamic, dynamic>)) return [];

      Map<dynamic, dynamic> items = db.snapshot.value as Map<dynamic, dynamic>;
      return items.entries.map((entry) => QuizModel(
        key: entry.key,
        mobile: entry.value['MOBILE'],
        username: entry.value['USERNAME'],
        password: entry.value['PASSWORD'],
      )).toList();
    } catch (error) {
      if (kDebugMode) print("Error getting data: $error");
      return [];
    }
  }

  Future<bool> authenticateUser(String username, String password) async {
    List<QuizModel> enrollments = await getData();
    return enrollments.any((enrollment) => enrollment.username == username && enrollment.password == password);
  }

  Future<void> updateScore(String username, int newScore) async {
    try {
      var snapshotEvent = await database().orderByChild('USERNAME').equalTo(username).once();

      if (snapshotEvent.snapshot.value != null) {
        var values = snapshotEvent.snapshot.value as Map<dynamic, dynamic>?;
        if (values != null) {
          var key = values.keys.first;
          await database().child(key).update({'SCORE': newScore});
          if (kDebugMode) print("Score updated successfully for user $username");
        }
      }
    } catch (error) {
      if (kDebugMode) print("Error updating score: $error");
    }
  }
}


class ScoreModel {
  int? score;
  String? username;
  String? level;

  ScoreModel({this.username, this.score, this.level});

  Map<String, dynamic> toMap() => {'USERNAME': username, 'SCORE': score, 'LEVEL': level};
}

class ScoreDatabase {
  DatabaseReference database() => FirebaseDatabase.instance.ref().child('ScoreDatabase');

  Future<void> sendData(ScoreModel scoreList) async {
    try {
      final key = database().push().key!;
      await database().child(key).set(scoreList.toMap());
      if (kDebugMode) print("Data added successfully with key: $key");
    } catch (error) {
      if (kDebugMode) print("Error adding data: $error");
    }
  }

  Future<void> updateScore(String username, int newScore, String level) async {
    try {
      var db = await database().orderByChild('USERNAME').equalTo(username).once();
      if (db.snapshot.value != null && db.snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> items = db.snapshot.value as Map<dynamic, dynamic>;
        bool updated = false;
        items.forEach((key, value) async {
          int? previousScore = value['SCORE'] as int?;
          if (previousScore != null && newScore > previousScore) {
            await database().child(key).update({'SCORE': newScore, 'LEVEL': level});
            updated = true;
            return;
          }
        });
        if (!updated && kDebugMode) print('User not found or new score is not higher');
      } else if (kDebugMode) print('User not found');
    } catch (error) {
      if (kDebugMode) print("Error updating score: $error");
    }
  }

  Future<List<ScoreModel>> getData() async {
    try {
      var db = await database().once();
      if (db.snapshot.value == null || !(db.snapshot.value is Map<dynamic, dynamic>)) return [];
      List<ScoreModel> scoreList = [];
      (db.snapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
        scoreList.add(ScoreModel(username: value['USERNAME'], score: value['SCORE'], level: value['LEVEL']));
      });
      return scoreList;
    } catch (error) {
      print("Error getting data: $error");
      return [];
    }
  }

  Future<bool> checkIfUsernameExists(String username) async {
    try {
      var db = await database().orderByChild('USERNAME').equalTo(username).once();
      return db.snapshot.value != null && db.snapshot.value is Map<dynamic, dynamic>;
    } catch (error) {
      print("Error checking username existence: $error");
      return false;
    }
  }
}

