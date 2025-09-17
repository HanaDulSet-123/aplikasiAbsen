import 'package:apk_absen/extension/navigation.dart';
import 'package:apk_absen/preference/login.dart';
import 'package:apk_absen/views/auth/login.dart';
import 'package:flutter/material.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        PreferenceHandler.removeLogin();
        context.push(LoginPage());
      },
      child: Text("Keluar"),
    );
  }
}
