import 'package:flutter/material.dart';
import 'package:apk_absen/preference/login.dart';
import 'package:apk_absen/views/login_screen.dart';
import 'package:apk_absen/extension/navigation.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        PreferenceHandler.removeLogin();
        context.pushReplacementNamed(Login.id);
      },
      child: Text("Keluar"),
    );
  }
}