import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModelHistory {
  final String id;
  final DateTime date;
  final TimeOfDay checkIn;
  final TimeOfDay? checkOut;
  final String status;
  final String location;
  final String? notes;

  ModelHistory({
    required this.id,
    required this.date,
    required this.checkIn,
    this.checkOut,
    required this.status,
    required this.location,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'checkIn': '${checkIn.hour}:${checkIn.minute}',
      'checkOut': checkOut != null
          ? '${checkOut!.hour}:${checkOut!.minute}'
          : null,
      'status': status,
      'location': location,
      'notes': notes,
    };
  }

  factory ModelHistory.fromMap(Map<String, dynamic> map) {
    return ModelHistory(
      id: map['id'],
      date: DateTime.parse(map['date']),
      checkIn: _parseTime(map['checkIn']),
      checkOut: map['checkOut'] != null ? _parseTime(map['checkOut']) : null,
      status: map['status'],
      location: map['location'],
      notes: map['notes'],
    );
  }

  static TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

class HistoryScreen {
  static const String _attendanceKey = 'attendance_history';

  static Future<void> saveAttendance(ModelHistory attendance) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> attendanceList =
        prefs.getStringList(_attendanceKey) ?? [];

    attendanceList.add(attendance.toMap().toString());
    await prefs.setStringList(_attendanceKey, attendanceList);
  }

  static Future<List<ModelHistory>> getAttendanceHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> attendanceList =
        prefs.getStringList(_attendanceKey) ?? [];

    return attendanceList.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return ModelHistory.fromMap(map);
    }).toList();
  }

  static Future<List<ModelHistory>> getAttendanceByMonth(DateTime month) async {
    final allAttendance = await getAttendanceHistory();
    return allAttendance.where((attendance) {
      return attendance.date.year == month.year &&
          attendance.date.month == month.month;
    }).toList();
  }

  static Future<void> deleteAttendance(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> attendanceList =
        prefs.getStringList(_attendanceKey) ?? [];

    attendanceList.removeWhere((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return map['id'] == id;
    });

    await prefs.setStringList(_attendanceKey, attendanceList);
  }
}

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  _AttendanceHistoryScreenState createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  List<ModelHistory> _attendanceList = [];
  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendanceHistory();
  }

  Future<void> _loadAttendanceHistory() async {
    setState(() => _isLoading = true);
    final ModelHistory = await HistoryScreen.getAttendanceByMonth(
      _selectedMonth,
    );
    setState(() {
      _attendanceList = ModelHistory;
      _isLoading = false;
    });
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => _selectedMonth = picked);
      _loadAttendanceHistory();
    }
  }

  Widget _buildAttendanceCard(ModelHistory attendance) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(attendance.status),
          child: Icon(_getStatusIcon(attendance.status), color: Colors.white),
        ),
        title: Text(
          '${attendance.date.day}/${attendance.date.month}/${attendance.date.year}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check-in: ${attendance.checkIn.format(context)}'),
            if (attendance.checkOut != null)
              Text('Check-out: ${attendance.checkOut!.format(context)}'),
            Text('Status: ${attendance.status}'),
            if (attendance.notes != null) Text('Catatan: ${attendance.notes}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to detail page
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Colors.green;
      case 'terlambat':
        return Colors.orange;
      case 'izin':
        return Colors.blue;
      case 'sakit':
        return Colors.purple;
      case 'alfa':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Icons.check_circle;
      case 'terlambat':
        return Icons.access_time;
      case 'izin':
        return Icons.beach_access;
      case 'sakit':
        return Icons.local_hospital;
      case 'alfa':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HistoryScreen Kehadiran'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectMonth(context),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _attendanceList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Tidak ada data kehadiran'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                return _buildAttendanceCard(_attendanceList[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to attendance form
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AttendanceStats extends StatelessWidget {
  final List<ModelHistory> attendanceList;

  const AttendanceStats({super.key, required this.attendanceList});

  Map<String, int> _calculateStats() {
    final stats = {
      'Hadir': 0,
      'Terlambat': 0,
      'Izin': 0,
      'Sakit': 0,
      'Alfa': 0,
    };

    for (var attendance in attendanceList) {
      final status = attendance.status.toLowerCase();
      if (stats.containsKey(status)) {
        stats[status] = stats[status]! + 1;
      }
    }

    return stats;
  }

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();
    final total = attendanceList.length;

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistik Kehadiran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...stats.entries.map(
              (entry) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(entry.key)),
                    Text('${entry.value}'),
                    SizedBox(width: 8),
                    Text(
                      '(${total > 0 ? ((entry.value / total) * 100).toStringAsFixed(1) : 0}%)',
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text('$total', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
