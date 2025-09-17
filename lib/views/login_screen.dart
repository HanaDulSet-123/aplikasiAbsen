// // import 'package:apk_absen/views/register_screen.dart';
// import 'package:apk_absen/views/auth/register.dart';
// import 'package:apk_absen/views/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//   static String id = "login_screen";
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _rememberMe = false;
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       // Simulate login process
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Login berhasil untuk ${_emailController.text}'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.light,
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xFF1976D2), Color(0xFF42A5F5), Color(0xFF90CAF9)],
//             ),
//           ),
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Selamat Datang',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Silakan masuk ke akun Anda',
//                   style: TextStyle(color: Colors.white70, fontSize: 18),
//                 ),
//                 const SizedBox(height: 40),
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             prefixIcon: const Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Email tidak boleh kosong';
//                             }
//                             if (!value.contains('@')) {
//                               return 'Email tidak valid';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: _obscurePassword,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             prefixIcon: const Icon(Icons.lock),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscurePassword = !_obscurePassword;
//                                 });
//                               },
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Password tidak boleh kosong';
//                             }
//                             if (value.length < 6) {
//                               return 'Password minimal 6 karakter';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         Row(
//                           children: [
//                             Checkbox(
//                               value: _rememberMe,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _rememberMe = value!;
//                                 });
//                               },
//                             ),
//                             const Text('Ingat saya'),
//                             SizedBox(width: 20),
//                             TextButton(
//                               onPressed: () {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Fitur lupa password diklik'),
//                                   ),
//                                 );
//                               },
//                               child: const Text('Lupa Password?'),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 // Jalankan logika login di sini
//                                 // contoh: panggil API login()

//                                 // kalau login berhasil, pindah ke Dashboard
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const DashboardScreen(),
//                                   ),
//                                 );
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: const Text(
//                               'MASUK',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 20),
//                         const Text('Atau masuk dengan'),
//                         const SizedBox(height: 15),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             IconButton(
//                               icon: Image.asset(
//                                 'assets/image/google.png',
//                                 height: 40,
//                               ),
//                               onPressed: () {},
//                             ),
//                             const SizedBox(width: 20),
//                             // IconButton(
//                             //   icon: Image.asset(
//                             //     'assets/images/facebook.png',
//                             //     height: 40,
//                             //   ),
//                             //   onPressed: () {},
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Belum punya akun?',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RegisterScreen(),
//                           ),
//                         );
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Fitur daftar diklik')),
//                         );
//                       },
//                       child: const Text(
//                         'Daftar Sekarang',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
