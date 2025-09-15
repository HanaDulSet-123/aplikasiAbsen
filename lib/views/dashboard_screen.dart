import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const DashboardScreen());
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Absensi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const AttendanceDashboard(),
    );
  }
}

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  int _currentIndex = 0;
  final DateTime _selectedDate = DateTime.now();
  final List<Map<String, dynamic>> _attendanceData = [
    {
      'date': '2023-10-01',
      'check_in': '08:00',
      'check_out': '17:00',
      'status': 'Hadir',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Absensi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            onPressed: () {},
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan info user dan tanggal
            _buildHeader(),
            const SizedBox(height: 24),

            // Card statistik absensi
            _buildStatsCard(),
            const SizedBox(height: 24),

            // Card untuk check-in/check-out
            _buildCheckInOutCard(),
            const SizedBox(height: 24),

            // Riwayat absensi
            _buildAttendanceHistory(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action untuk absensi
          _showAttendanceDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.fingerprint, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // const CircleAvatar(
        //   radius: 30,
        //   backgroundImage: NetworkImage(
        //     'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=80',
        //   ),
        // ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, d MMMM y').format(_selectedDate),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Hadir', '', Colors.green),
              _buildStatItem('Terlambat', '', Colors.orange),
              _buildStatItem('Absen', '', Colors.red),
              _buildStatItem('Libur', '', Colors.blue),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.85,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kehadiran Bulan Ini',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const Text(
                '85%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildCheckInOutCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeCard('Check-in', '07:45', Colors.blue),
              _buildTimeCard('Check-out', '17:15', Colors.purple),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showAttendanceDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'ABSEN SEKARANG',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(String title, String time, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Absensi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _attendanceData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final attendance = _attendanceData[index];
            return _buildAttendanceItem(
              attendance['date'],
              attendance['check_in'],
              attendance['check_out'],
              attendance['status'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAttendanceItem(
    String date,
    String checkIn,
    String checkOut,
    String status,
  ) {
    Color statusColor;
    switch (status) {
      case 'Hadir':
        statusColor = Colors.green;
        break;
      case 'Terlambat':
        statusColor = Colors.orange;
        break;
      case 'Pulang Cepat':
        statusColor = Colors.orange;
        break;
      case 'Libur':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('d MMM').format(DateTime.parse(date)),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('EEEE').format(DateTime.parse(date)),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.login, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(checkIn, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 12),
                  const Icon(Icons.logout, size: 14, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(checkOut, style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BottomAppBar _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: _currentIndex == 1 ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
          const SizedBox(width: 40), // Space for the FAB
          IconButton(
            icon: Icon(
              Icons.bar_chart,
              color: _currentIndex == 2 ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 3 ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 3;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fingerprint, size: 50, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Absensi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE, d MMMM y').format(DateTime.now()),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Text(
                  DateFormat('HH:mm:ss').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Absensi berhasil dicatat'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Konfirmasi'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
