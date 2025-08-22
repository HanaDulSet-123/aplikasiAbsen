import 'package:flutter/material.dart';
import 'package:apk_absen/dashboard/drawer.dart';
import 'package:apk_absen/models/kehadiran.dart';
import 'package:apk_absen/sqflite/db_helper.dart';
import 'package:apk_absen/preference/login.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final List<String> bulan = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Laporan",
          style: TextStyle(
            fontFamily: "Gilroy_Regular",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 15, 216, 166),
        centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Pilih Bulan untuk Melihat Laporan:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          ...bulan.asMap().entries.map((entry) {
            int index = entry.key;
            String namaBulan = entry.value;
            String bulanParam = (index + 1).toString().padLeft(2, "0");

            return _BulanListItem(bulan: namaBulan, bulanParam: bulanParam);
          }).toList(),
        ],
      ),
    );
  }
}

class _BulanListItem extends StatelessWidget {
  final String bulan;
  final String bulanParam;

  const _BulanListItem({required this.bulan, required this.bulanParam});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          bulan,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailLaporanPage(bulan: bulan, bulanParam: bulanParam),
            ),
          );
        },
      ),
    );
  }
}

class DetailLaporanPage extends StatefulWidget {
  final String bulan;
  final String bulanParam;

  const DetailLaporanPage({
    super.key,
    required this.bulan,
    required this.bulanParam,
  });

  @override
  State<DetailLaporanPage> createState() => _DetailLaporanPageState();
}

class _DetailLaporanPageState extends State<DetailLaporanPage> {
  List<Kehadiran> laporan = [];
  int totalHadir = 0;
  int totalSakit = 0;
  int totalIzin = 0;
  int totalAlpha = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLaporan();
  }

  Future<void> _loadLaporan() async {
    final userId = await PreferenceHandler.getUserId();
    if (userId == null) return;

    final data = await DbHelper.getKehadiranByUserAndMonth(
      userId,
      widget.bulanParam,
    );

    int hadir = 0;
    int sakit = 0;
    int izin = 0;
    int alpha = 0;

    for (var d in data) {
      switch (d.status) {
        case "Hadir":
          hadir++;
          break;
        case "Sakit":
          sakit++;
          break;
        case "Izin":
          izin++;
          break;
        case "Alpha":
          alpha++;
          break;
      }
    }

    setState(() {
      laporan = data;
      totalHadir = hadir;
      totalSakit = sakit;
      totalIzin = izin;
      totalAlpha = alpha;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laporan ${widget.bulan}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 15, 216, 166),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Card rekap statistik
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    color: Colors.greenAccent,
                    child: SizedBox(
                      height: 200,
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rekap Kehadiran",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("Total Hadir: $totalHadir"),
                          Text("Total Sakit: $totalSakit"),
                          Text("Total Izin: $totalIzin"),
                          Text("Total Alpha: $totalAlpha"),
                        ],
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
    );
  }
}
