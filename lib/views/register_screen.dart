import 'package:apk_absen/models/user.dart';
import 'package:apk_absen/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const id = "/register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisibility = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            buildBackground(),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xCC1976D2),
                    Color(0xCC42A5F5),
                    Color(0xCC90CAF9),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 6,
                                color: Colors.black.withOpacity(0.7),
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        height(24),
                        buildTextField(
                          hintText: "Nama Lengkap",
                          controller: namaController,
                        ),
                        height(16),
                        buildTextField(
                          hintText: "Email",
                          controller: emailController,
                        ),
                        height(16),
                        buildTextField(
                          hintText: "Password",
                          controller: passwordController,
                          isPassword: true,
                        ),
                        height(32),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: registerUser,
                            child: const Text(
                              "Daftar",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        height(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sudah punya akun?",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void registerUser() async {
    setState(() => isLoading = true);

    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nama, Email, dan Password tidak boleh kosong"),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    final user = User(nama: nama, email: email, password: password);
    // await DbHelper.registerUser(user);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pendaftaran berhasil")));
      setState(() => isLoading = false);
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Image.asset(
          "assets/image/hadir.png",
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  TextField buildTextField({
    String? hintText,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ),
    );
  }

  SizedBox height(double h) => SizedBox(height: h);
  SizedBox width(double w) => SizedBox(width: w);
}
