import 'package:apk_absen/dashboard/buttom_nav.dart';
import 'package:apk_absen/extension/navigation.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  int _selectedIndexDrawer = 0;
  // static const List<Widget> _widgetOptions = <Widget>[
  //   SizedBox(),
  //   CheckBoxPage(),
  //   SwitchPage(),
  //   DropdownPage(),
  //   DatepickerPage(),
  //   TimepickerPage(),
  //   ListVoucher(),
  // ];
  void onItemTap(int index) {
    setState(() {
      _selectedIndexDrawer = index;
    });
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage('assets/images/sekulbg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              'Hadir',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6B240C),
                fontSize: 30,
                fontFamily: "Lobster",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              context.push(ButtomNav());
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.list),
          //   title: Text("Kehadiran"),
          //   onTap: () {
          //     context.push(ListKehadiran());
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.report),
          //   title: Text("Laporan"),
          //   onTap: () {
          //     context.push(LaporanScreen());
          //   },
          // ),
        ],
      ),
    );
  }
}
