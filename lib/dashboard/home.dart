import 'package:apk_absen/dashboard/drawer.dart';
import 'package:apk_absen/preference/login.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const id = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> titles = ['Hadir', 'Izin', 'Sakit', 'Alpha'];
  List<Color> colors = [
    const Color.fromARGB(255, 4, 39, 235),
    Colors.amber,
    Colors.green,
    Colors.red,
  ];
  List<double> values = [0, 0, 0, 0]; // default kosong dulu
  String? userName;
  int isSelectedIdx = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
    // _loadUserData();
  }

  Future<void> _loadData() async {
    final userId = await PreferenceHandler.getUserId();
    if (userId == null) return;
  }


  

  Future<void> _loadUserData() async {
    final nama = await PreferenceHandler.getNama();
    setState(() {
      userName = nama ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Gilroy_Regular",
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF3338A0),
        centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Selamat Datang, ",
                style: TextStyle(fontFamily: "Gilroy_Bold", fontSize: 20),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 150,
                width: 350,
                child: Card(
                  color: const Color(0xFF4B70F5),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/uniform.jpg"),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? "Loading...", // Tampilkan NAMA user
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Gilroy_Bold",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Siswa",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Gilroy_Bold",
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 250,
                width: 350,
                child: Card(
                  color: const Color(0xFF4B70F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Pie Chart
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 30,
                            pieTouchData: PieTouchData(
                              enabled: true,
                              touchCallback: (event, response) {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.touchedSection == null) {
                                  setState(() {
                                    isSelectedIdx = -1;
                                  });
                                  return;
                                }
                                setState(() {
                                  isSelectedIdx = response
                                      .touchedSection!
                                      .touchedSectionIndex;
                                });
                              },
                            ),
                            sections: List.generate(titles.length, (index) {
                              bool isSelected = index == isSelectedIdx;
                              return PieChartSectionData(
                                title: titles[index],
                                value: values[index],
                                color: colors[index],
                                radius: isSelected ? 70 : 50,
                              );
                            }),
                          ),
                        ),
                      ),

                      // Keterangan
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(titles.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: colors[index],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${titles[index]}: ${values[index].toInt()}",
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
