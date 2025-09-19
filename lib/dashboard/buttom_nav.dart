// import 'package:apk_absen/views/dashboard_screen.dart';
// import 'package:apk_absen/views/profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';

// class ButtomNav extends StatefulWidget {
//   static String id = 'buttomnav';
//   const ButtomNav({super.key});

//   @override
//   State<ButtomNav> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<ButtomNav> {
//   int _selectedIndex = 0;
//   final LocalAuthentication _localAuth = LocalAuthentication();
//   bool _isAuthenticated = false;

//   final List<Widget> _pages = [
//     DashboardScreen(),
//     const Center(child: Text("Kalender")),
//     // const Center(child: Text("Statistik")),
//     ProfilePage(),
//   ];

//   Future<void> _authenticate() async {
//     try {
//       final bool didAuthenticate = await _localAuth.authenticate(
//         localizedReason: 'Scan sidik jari untuk autentikasi',
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );

//       setState(() {
//         _isAuthenticated = didAuthenticate;
//       });

//       if (didAuthenticate) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Autentikasi berhasil!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } on PlatformException catch (e) {
//       print("Error during authentication: $e");
//     }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: _pages[_selectedIndex],
//       floatingActionButton: Container(
//         width: 65,
//         height: 65,
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.fingerprint, color: Colors.white, size: 32),
//           onPressed: _authenticate,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 10,
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.home,
//                   color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
//                 ),
//                 onPressed: () => _onItemTapped(0),
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.calendar_today,
//                   color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
//                 ),
//                 onPressed: () => _onItemTapped(1),
//               ),
//               const SizedBox(width: 40),
//               IconButton(
//                 icon: Icon(
//                   Icons.bar_chart,
//                   color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
//                 ),
//                 onPressed: () => _onItemTapped(2),
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.person,
//                   color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
//                 ),
//                 onPressed: () => _onItemTapped(3),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
