import 'package:apk_absen/dashboard/drawer.dart';
import 'package:apk_absen/extension/navigation.dart';
import 'package:apk_absen/models/user.dart';
import 'package:apk_absen/preference/login.dart';
import 'package:apk_absen/textForm/text_form.dart';
import 'package:apk_absen/views/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const id = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> getCurrentUser() async {
    final userId = await PreferenceHandler.getUserId();
    final userEmail = await PreferenceHandler.getEmail();
    final userName = await PreferenceHandler.getNama();

    // if (userId != null) {
    //   final allUsers = await DbHelper.getAllUser();
    //   final userFromDb = allUsers.firstWhere(
    //     (user) => user.id == userId,
    //     orElse: () => User(id: -1, nama: '', email: ''),
    //   );
    //   if (userFromDb.id != -1) {
    //     setState(() {
    //       currentUser = userFromDb;
    //       isLoading = false;
    //     });
    //   } else {
    //     setState(() {
    //       currentUser = User(
    //         id: userId,
    //         nama: userName ?? 'User',
    //         email: userEmail ?? 'No Email',
    //       );
    //       isLoading = false;
    //     });
    //   }
    // } else {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  Future<void> _updateUser() async {
    if (currentUser == null) return;

    final updatedUser = User(
      id: currentUser!.id,
      nama: namaController.text,
      email: emailController.text,
      password: currentUser!.password,
    );
// 
    // await DbHelper.updateUser(updatedUser);

    // Update juga di shared preferences menggunakan PreferenceHandler
    await PreferenceHandler.setNama(updatedUser.nama);
    await PreferenceHandler.setEmail(updatedUser.email);

    setState(() {
      currentUser = updatedUser;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profile berhasil diupdate')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3338A0),
      ),
      drawer: DrawerMenu(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : currentUser == null
          ? Center(child: Text('User tidak ditemukan'))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Card
                Card(
                  margin: EdgeInsets.all(16),
                  color: const Color(0xFF3338A0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            "assets/images/uniform.jpg",
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          currentUser!.nama,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          currentUser!.email,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Edit Form
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormConst(
                          controller: namaController..text = currentUser!.nama,
                          hintText: 'Nama',
                        ),
                        SizedBox(height: 12),
                        TextFormConst(
                          controller: emailController
                            ..text = currentUser!.email,
                          hintText: 'Email',
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updateUser,
                          child: Text('Update Profile'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      PreferenceHandler.removeLogin();
                      context.push(LoginScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 94, 86, 85),
                    ),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 243, 237, 237),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
