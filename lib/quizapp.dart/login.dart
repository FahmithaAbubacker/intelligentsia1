import 'package:flutter/material.dart';
import 'package:intelligentsia1/quizapp.dart/database1.dart';
import 'package:intelligentsia1/quizapp.dart/homepage.dart';
import 'package:intelligentsia1/quizapp.dart/mobileno.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final QuizDatabase _quizDatabase = QuizDatabase();
  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passFormKey = GlobalKey<FormState>();
  final RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  bool validatePassword(String pass) => passValid.hasMatch(pass.trim());

  Future<void> _login() async {
    final username = userController.text.trim();
    final password = passController.text.trim();

    final isAuthenticated =
        await _quizDatabase.authenticateUser(username, password);
    isAuthenticated
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  HomePage()))
        : ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")));
  }

  Future<void> saveUsernameToSharedPreferences(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 192, 207, 178),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: userFormKey,
                child: TextFormField(
                  controller: userController,
                  decoration:  InputDecoration(
                    labelText: "Username",
                    hintText: "Enter Your username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60)),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "This field is Mandatory" : null,
                  onChanged: (_) => userFormKey.currentState!.validate(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: passFormKey,
                child: TextFormField(
                  controller: passController,
                  decoration:  InputDecoration(
                    labelText: "Password",
                    hintText: "Enter Your Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Password";
                    } else {
                      return validatePassword(value)
                          ? null
                          : "Password should contain Capital, small letter & special Characters";
                    }
                  },
                  onChanged: (_) => passFormKey.currentState!.validate(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (userFormKey.currentState!.validate() &&
                    passFormKey.currentState!.validate()) {
                  _login();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(234, 245, 160, 32),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MobileScreen()));
                  },
                  child: const Text("Signup"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
