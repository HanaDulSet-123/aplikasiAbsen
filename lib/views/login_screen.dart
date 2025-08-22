import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:apk_absen/dashboard/buttom_nav.dart';
import 'package:apk_absen/preference/login.dart';
import 'package:apk_absen/sqflite/db_helper.dart';
import 'package:apk_absen/views/register_screen.dart';
import 'package:apk_absen/extension/navigation.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const id = "/login";

  @override
  State<Login> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
      setState(() => isLoading = false);
      return;
    }
    
    final userData = await DbHelper.loginUser(email, password);
    if (userData != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selamat datang, ${userData.nama}")),
      );
      PreferenceHandler.saveLogin(userData.id!, userData.email, userData.nama);
      Navigator.pushReplacementNamed(context, ButtomNav.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email atau Password salah")),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              color: const Color.fromARGB(255, 150, 144, 144),
              alignment: Alignment.center,
              child: const Text(
                'MyAbsence',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 17),
                  const Text(
                    'Login Account',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Hello, you must login first to be able to use the application and enjoy all the features in MyAbsence',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 71, 73, 75),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(width: double.infinity),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              hintText: "Masukan Email",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email tidak boleh kosong";
                              }
                              if (!value.contains("@")) {
                                return "Email tidak valid";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 9),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              hintText: "Masukkan Password",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password tidak boleh kosong";
                              } else if (value.length < 6) {
                                return "Password minimal 6 karakter";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 1),
                          Padding(
                            padding: const EdgeInsets.only(left: 210),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.deepOrange[700]),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  Colors.deepOrange,
                                side: const BorderSide(
                                  color: Colors.orangeAccent,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: login,
                              child: isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: RichText(
                              text: const TextSpan(
                                text: "Or Sign In with",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.g_mobiledata,
                                  color: Color.fromARGB(255, 156, 51, 51),
                                ),
                                label: const Text("Google"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    243,
                                    240,
                                    240,
                                  ),
                                ),
                                onPressed: () {
                                  // Google sign in logic
                                },
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Facebook sign in logic
                                },
                                icon: const Icon(
                                  Icons.facebook,
                                  color: Color.fromARGB(255, 33, 135, 202),
                                ),
                                label: const Text("Facebook"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    243,
                                    240,
                                    240,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: const Color.fromARGB(182, 100, 100, 106),
                                  fontFamily: "Poppins_Regular",
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.push(RegisterScreen());
                                      },
                                    text: " Register",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: const Color.fromARGB(255, 11, 39, 164),
                                      fontFamily: "Poppins_Bold",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}