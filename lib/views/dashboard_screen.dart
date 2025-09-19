// import 'package:apk_absen/api/register_user.dart';
// import 'package:flutter/material.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   Map<String, dynamic>? profile;
//   Map<String, dynamic>? today;
//   Map<String, dynamic>? stats;
//   List<dynamic> history = [];
//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     setState(() => loading = true);

//     try {
//       // Panggil API sesuai dokumentasi
//       profile = await AuthenticationAPI.getProfile();
//       today = await AttendanceAPI.getToday();
//       stats = await AttendanceAPI.getStats();
//       history = await AttendanceAPI.getHistory();
//     } catch (e) {
//       debugPrint("Error load data: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F6),
//       appBar: AppBar(
//         title: const Text("Dashboard Absensi"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.red),
//             onPressed: () async {
//               await AuthenticationAPI.logout();
//               if (context.mounted) {
//                 Navigator.pushReplacementNamed(context, "/login");
//               }
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadData,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildProfileCard(),
//               const SizedBox(height: 16),
//               _buildTodayCard(),
//               const SizedBox(height: 16),
//               _buildStatsCard(),
//               const SizedBox(height: 16),
//               _buildHistoryList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _boxDecoration(),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundImage: profile?['profilePhotoUrl'] != null
//                 ? NetworkImage(profile!['profilePhotoUrl'])
//                 : null,
//             child: profile?['profilePhotoUrl'] == null
//                 ? const Icon(Icons.person, size: 30)
//                 : null,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   profile?['name'] ?? "-",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Text(
//                   profile?['email'] ?? "-",
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTodayCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _boxDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Absensi Hari Ini",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Text("Check In: ${today?['check_in'] ?? '-'}"),
//           Text("Check Out: ${today?['check_out'] ?? '-'}"),
//           Text("Status: ${today?['status'] ?? '-'}"),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     await AttendanceAPI.checkIn();
//                     _loadData();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                   ),
//                   child: const Text("Check In"),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     await AttendanceAPI.checkOut();
//                     _loadData();
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   child: const Text("Check Out"),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _boxDecoration(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _statItem("Hadir", stats?['hadir'] ?? 0, Colors.green),
//           _statItem("Terlambat", stats?['terlambat'] ?? 0, Colors.orange),
//           _statItem("Izin", stats?['izin'] ?? 0, Colors.blue),
//           _statItem("Alpa", stats?['alpa'] ?? 0, Colors.red),
//         ],
//       ),
//     );
//   }

//   Widget _statItem(String label, int value, Color color) {
//     return Column(
//       children: [
//         Text(
//           "$value",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildHistoryList() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _boxDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Riwayat Absensi",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: history.length,
//             separatorBuilder: (context, index) =>
//                 const Divider(height: 16, color: Colors.grey),
//             itemBuilder: (context, index) {
//               final h = history[index];
//               return ListTile(
//                 leading: const Icon(Icons.calendar_today, size: 20),
//                 title: Text(h['date'] ?? "-"),
//                 subtitle: Text("In: ${h['check_in']} | Out: ${h['check_out']}"),
//                 trailing: Text(h['status'] ?? "-"),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   BoxDecoration _boxDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 5,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     );
//   }
// }
