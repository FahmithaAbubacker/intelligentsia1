import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelligentsia1/quizapp.dart/database1.dart';

import 'package:intelligentsia1/quizapp.dart/homepage.dart';
import 'package:intelligentsia1/quizapp.dart/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({
    super.key,
  });

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  void _registerDetails() {
    if (_usernameFormKey.currentState!.validate() &&
        _passwordFormKey.currentState!.validate() &&
        _phoneFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully registered")));
    }
  }

  String? verificationid;

  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  bool validatePassword(String pass) {
    String password = pass.trim();
    if (pass_valid.hasMatch(password)) {
      return true;
    } else {
      return false;
    }
  }

  String? _validateMobileNumber(value) {
    if (value!.isEmpty) {
      return 'Please enter Your Mobile Number ';
    }
    if (value.length != 10) {
      return 'Please enter a 10 digit Number';
    } else if (int.tryParse(value) == null) {
      return 'Invalid Number';
    }
    return null;
  }

  final _usernameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  Future<void> storeUsernameToSharedPreferences(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    print('Username stored in SharedPreferences: $username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 192, 207, 178),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 360,
              height: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 172, 188, 172),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _usernameFormKey,
                      child: TextFormField(
                        controller: usernamecontroller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 192, 207, 178),
                          filled: true,
                          labelText: "Username",
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        validator: (value) {
                          if (value == "") {
                            return "This field is Mandatory!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _passwordFormKey,
                      child: TextFormField(
                        controller: passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 192, 207, 178),
                          filled: true,
                          labelText: "Password",
                          hintText: "Enter Your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Password";
                          } else {
                            bool result = validatePassword(value);
                            if (result) {
                              return null;
                            } else {
                              return "Password should contain Capital, small letter & special Characters";
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _phoneFormKey,
                      child: TextFormField(
                        controller: phonecontroller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixText: "+91",
                          labelText: "Mobile Number",
                          fillColor: const Color.fromARGB(255, 192, 207, 178),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        maxLength: 10,
                        validator: _validateMobileNumber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_usernameFormKey.currentState!.validate() &&
                    _passwordFormKey.currentState!.validate() &&
                    _phoneFormKey.currentState!.validate()) {
                  String phoneNumber = "+91${phonecontroller.text}";
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseException ex) {
                      print("Verification failed: ${ex.message}");
                    },
                    codeSent: (String verificationid, int? resendtoken) {
                      setState(() {
                        this.verificationid = verificationid;
                      });
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                    phoneNumber: phoneNumber,
                  );

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("OTP VERIFICATION"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _otpFormKey,
                            child: TextFormField(
                              controller: otpController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: "Enter the 6-digit code",
                                fillColor:
                                    const Color.fromARGB(255, 192, 207, 178),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              maxLength: 6,
                              validator: (value) {
                                if (value!.length != 6) return "Invalid OTP";
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_otpFormKey.currentState!.validate()) {
                                final profile = QuizModel(
                                  mobile:
                                      int.tryParse(phonecontroller.text) ?? 0,
                                  username: usernamecontroller.text,
                                  password: passwordController.text,
                                );

                                await QuizDatabase().sendData(profile);
                                await storeUsernameToSharedPreferences(
                                    usernamecontroller.text);
                                String username =
                                    usernamecontroller.text.trim();
                                bool usernameExists = await ScoreDatabase()
                                    .checkIfUsernameExists(username);
                                if (usernameExists) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Username already exists")));
                                  return;
                                }
                                _registerDetails();
                                try {
                                  PhoneAuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationid!,
                                          smsCode:
                                              otpController.text.toString());
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential)
                                      .then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  HomePage(),
                                      ),
                                    );
                                  });
                                } catch (ex) {
                                  print("Sign in error: $ex");
                                }
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(234, 245, 160, 32),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            child: const Text(
                              "Submit",
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Something went wrong")));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(234, 245, 160, 32),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              child: const Text(
                "Sign Up",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
