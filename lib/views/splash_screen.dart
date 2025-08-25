import 'package:flutter/material.dart';
import 'package:apk_absen/dashboard/buttom_nav.dart';
import 'package:apk_absen/preference/login.dart';
import 'package:apk_absen/utils/app_image.dart';
import 'package:apk_absen/views/login_screen.dart';
import 'package:apk_absen/extension/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      print(isLogin);
      if (isLogin == true) {
        context.pushReplacementNamed(ButtomNav.id);
      } else {
        context.push(Login());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(AppImage.logo),
            ),
            SizedBox(height: 20),
            Text("Welcome"),
          ],
        ),
      ),
    );
  }
}
