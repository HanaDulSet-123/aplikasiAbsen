import 'dart:io';

import 'package:apk_absen/api/batch_api.dart';
import 'package:apk_absen/api/register_user.dart';
import 'package:apk_absen/api/training_service.dart';
import 'package:apk_absen/models/list_batch_model.dart' as batch_model;
import 'package:apk_absen/models/list_training_model.dart' as training_model;
import 'package:apk_absen/models/register_user_model.dart';
import 'package:apk_absen/preference/login.dart';
import 'package:apk_absen/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const id = "/register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isVisibility = false;
  bool isLoading = false;
  RegisterUserModel? user;
  String? errorMessage;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  String? _selectedJk; // Untuk menampung 'L' atau 'P'

  List<batch_model.Datum> _batches = [];
  int? _selectedBatchId;
  bool _isBatchesLoading = true;

  List<training_model.TrainingData> _trainings = [];
  int? _selectedTrainingId;
  bool _isTrainingsLoading = true;

  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman dimuat
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _loadBatches();
    _loadTrainings();
  }

  Future<void> _loadBatches() async {
    try {
      final batches = await BatchService.fetchbatch();
      if (mounted) {
        setState(() {
          _batches = batches;
          _isBatchesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBatchesLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat data batch: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _loadTrainings() async {
    try {
      final trainings = await TrainingService.fetchtinemas();
      if (mounted) {
        setState(() {
          _trainings = trainings;
          _isTrainingsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTrainingsLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memuat data training: ${e.toString()}"),
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    // source: ImageSource.camera
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    // Validasi input
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nama, Email, dan Password tidak boleh kosong"),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    if (_selectedJk == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih Jenis Kelamin")),
      );
      setState(() => isLoading = false);
      return;
    }

    if (_selectedTrainingId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Silakan pilih Training")));
      setState(() => isLoading = false);
      return;
    }

    if (_selectedBatchId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Silakan pilih Batch")));
      setState(() => isLoading = false);
      return;
    }

    try {
      final result = await AuthenticationAPI.registerUser(
        email: email,
        password: password,
        name: name,
        jk: _selectedJk!,
        batchID: _selectedBatchId!,
        trainingID: _selectedTrainingId!,
        imageFile: _selectedImage,
      );
      setState(() => user = result);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pendaftaran berhasil")));
      PreferenceHandler.saveToken(user?.data?.token.toString() ?? "");
      print(user?.toJson());
    } catch (e) {
      print(e);
      setState(() => errorMessage = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              // Background
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
                            controller: nameController,
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
                          // Pilih Gambar
                          _selectedImage != null
                              ? Column(
                                  children: [
                                    Image.file(_selectedImage!, height: 150),
                                    TextButton.icon(
                                      onPressed: _pickImage,
                                      icon: const Icon(Icons.image),
                                      label: const Text("Ganti Gambar"),
                                    ),
                                  ],
                                )
                              : TextButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.image),
                                  label: const Text("Pilih Gambar"),
                                ),
                          const Text(
                            "Jenis Kelamin",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Laki-laki"),
                                  value: "L",
                                  groupValue: _selectedJk,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedJk = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Perempuan"),
                                  value: "P",
                                  groupValue: _selectedJk,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedJk = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // Input Training ID
                          DropdownButtonFormField<int>(
                            value: _selectedTrainingId,
                            isExpanded: true,
                            hint: Text(
                              _isTrainingsLoading
                                  ? "Memuat..."
                                  : "Pilih Training",
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            items: _trainings.map((
                              training_model.TrainingData training,
                            ) {
                              // <-- Ubah tipenya di sini
                              return DropdownMenuItem<int>(
                                value: training.id,
                                child: Text(training.title ?? "Tanpa Nama"),
                              );
                            }).toList(),
                            onChanged: _isTrainingsLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedTrainingId = value;
                                    });
                                  },
                          ),
                          const SizedBox(height: 15),

                          // Input Batch ID
                          DropdownButtonFormField<int>(
                            value: _selectedBatchId,
                            isExpanded: true,
                            hint: Text(
                              _isBatchesLoading ? "Memuat..." : "Pilih Batch",
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            items: _batches.map((batch_model.Datum batch) {
                              return DropdownMenuItem<int>(
                                value: batch.id,
                                child: Text(batch.batchKe ?? "Tanpa Nama"),
                              );
                            }).toList(),
                            onChanged: _isBatchesLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedBatchId = value;
                                    });
                                  },
                          ),
                          const SizedBox(height: 20),
                          height(32),
                          // Tombol daftar
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF347338,
                                ), // Hijau utama
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isLoading ? null : registerUser,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "DAFTAR SEKARANG",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 15),
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
                                      builder: (context) => const LoginPage(),
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
      ),
    );
  }

  // void registerUser() async {
  //   setState(() => isLoading = true);

  //   final nama = nameController.text.trim();
  //   final email = emailController.text.trim();
  //   final password = passwordController.text.trim();

  //   if (nama.isEmpty || email.isEmpty || password.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Nama, Email, dan Password tidak boleh kosong"),
  //       ),
  //     );
  //     setState(() => isLoading = false);
  //     return;
  //   }

  //   final user = User(nama: nama, email: email, password: password);
  //   // await DbHelper.registerUser(user);

  //   Future.delayed(const Duration(seconds: 1)).then((value) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("Pendaftaran berhasil")));
  //     setState(() => isLoading = false);
  //     Navigator.pushReplacementNamed(context, "/login");
  //   });
  // }

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
