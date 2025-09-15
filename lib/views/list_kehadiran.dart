// import 'package:apk_absen/dashboard/drawer.dart';
// import 'package:apk_absen/models/kehadiran.dart';
// import 'package:apk_absen/preference/login.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class ListKehadiran extends StatefulWidget {
//   const ListKehadiran({super.key});

//   @override
//   State<ListKehadiran> createState() => _ListKehadiranState();
// }

// class _ListKehadiranState extends State<ListKehadiran> {
//   List<Kehadiran> kehadiran = [];

//   @override
//   void initState() {
//     super.initState();
//     // _loadKehadiran();
//   }

//   // Future<void> _loadKehadiran() async {
//   //   final userId = await PreferenceHandler.getUserId();
//   //   if (userId == null) return;

//   //   final data = await DbHelper.getKehadiranByUser(userId);
//   //   setState(() {
//   //     kehadiran = data;
//   //   });
//   // }

//   // Future<void> _deleteKehadiran(int id) async {
//   //   await DbHelper.deleteKehadiran(id);
//   //   _loadKehadiran();
//   // }

//   Future<void> _confirmDelete(int id) async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Konfirmasi Hapus"),
//           content: const Text("Apakah kamu yakin ingin menghapus data ini?"),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Batal"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 // await _deleteKehadiran(id);
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               child: const Text("Hapus"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Kehadiran",
//           style: TextStyle(
//             fontFamily: "Gilroy_Regular",
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: const Color(0xFF3338A0),
//         centerTitle: true,
//       ),
//       drawer: DrawerMenu(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   TambahKehadiranPage(onKehadiranAdded: _loadKehadiran),
//             ),
//           );
//         },
//         backgroundColor: const Color(0xFF3338A0),
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Container(
//               height: 150,
//               width: 382,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF3338A0),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   left: 120,
//                   top: 55,
//                   bottom: 50,
//                   right: 50,
//                 ),
//                 child: Text(
//                   "Absen Yuk!",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: "Gilroy_Regular",
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: kehadiran.length,
//               itemBuilder: (context, index) {
//                 final data = kehadiran[index];
//                 return Card(
//                   margin: EdgeInsets.all(8),
//                   child: ListTile(
//                     leading: Icon(
//                       Icons.person,
//                       color: const Color.fromARGB(255, 15, 216, 166),
//                     ),
//                     title: Text(data.nama, style: TextStyle(fontSize: 18)),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(data.kelas, style: TextStyle(fontSize: 14)),
//                         Text(data.tanggal, style: TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(data.status!, style: TextStyle(fontSize: 18)),
//                         SizedBox(width: 10),
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => EditKehadiranPage(
//                                   kehadiran: data,
//                                   onKehadiranUpdated: _loadKehadiran,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _confirmDelete(data.idKehadiran!),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Halaman untuk menambah kehadiran
// class TambahKehadiranPage extends StatefulWidget {
//   final VoidCallback onKehadiranAdded;

//   const TambahKehadiranPage({super.key, required this.onKehadiranAdded});

//   @override
//   State<TambahKehadiranPage> createState() => _TambahKehadiranPageState();
// }

// class _TambahKehadiranPageState extends State<TambahKehadiranPage> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? selectedDate;

//   final TextEditingController _namaController = TextEditingController();
//   final TextEditingController _tanggalController = TextEditingController();
//   final TextEditingController _kelasController = TextEditingController();
//   final TextEditingController _statusController = TextEditingController();

//   Future<void> _pilihTanggal(BuildContext context) async {
//     final DateTime? pickerDate = await showDatePicker(
//       context: context,
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//       initialDate: DateTime.now(),
//       locale: const Locale('id', 'ID'),
//     );
//     if (pickerDate != null) {
//       setState(() {
//         selectedDate = pickerDate;
//         _tanggalController.text = DateFormat(
//           'dd-MM-yyyy',
//           'id',
//         ).format(pickerDate);
//       });
//     }
//   }

//   Future<void> _simpanKehadiran() async {
//     if (_formKey.currentState!.validate()) {
//       final userId = await PreferenceHandler.getUserId();
//       Kehadiran kehadiranData = Kehadiran(
//         userId: userId ?? 0,
//         nama: _namaController.text,
//         tanggal: _tanggalController.text,
//         kelas: _kelasController.text,
//         status: _statusController.text,
//       );

//       // await DbHelper.registerKehadiran(kehadiranData);


      

//       widget.onKehadiranAdded();
//       Navigator.pop(context);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Data kehadiran berhasil ditambahkan')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Tambah Kehadiran",
//           style: TextStyle(
//             fontFamily: "Gilroy_Regular",
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: const Color(0xFF3338A0),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _namaController,
//                   decoration: InputDecoration(
//                     labelText: "Nama Siswa",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Nama tidak boleh kosong";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _tanggalController,
//                   decoration: InputDecoration(
//                     labelText: 'Pilih Tanggal',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.calendar_month),
//                       onPressed: () => _pilihTanggal(context),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Tanggal tidak boleh kosong";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _kelasController,
//                   decoration: InputDecoration(
//                     labelText: "Kelas Siswa",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Kelas tidak boleh kosong";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     labelText: "Status Kehadiran",
//                   ),
//                   value: _statusController.text.isEmpty
//                       ? null
//                       : _statusController.text,
//                   hint: Text("Pilih Status Kehadiran"),
//                   items: ["Hadir", "Izin", "Sakit", "Alpha"].map((
//                     String value,
//                   ) {
//                     return DropdownMenuItem(value: value, child: Text(value));
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       _statusController.text = newValue!;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Status kehadiran tidak boleh kosong";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _simpanKehadiran,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF3338A0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       "Simpan",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Halaman untuk edit kehadiran
// class EditKehadiranPage extends StatefulWidget {
//   final Kehadiran kehadiran;
//   final VoidCallback onKehadiranUpdated;

//   const EditKehadiranPage({
//     super.key,
//     required this.kehadiran,
//     required this.onKehadiranUpdated,
//   });

//   @override
//   State<EditKehadiranPage> createState() => _EditKehadiranPageState();
// }

// class _EditKehadiranPageState extends State<EditKehadiranPage> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? selectedDate;

//   final TextEditingController _namaController = TextEditingController();
//   final TextEditingController _tanggalController = TextEditingController();
//   final TextEditingController _kelasController = TextEditingController();
//   final TextEditingController _statusController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _namaController.text = widget.kehadiran.nama;
//     _tanggalController.text = widget.kehadiran.tanggal;
//     _kelasController.text = widget.kehadiran.kelas;
//     _statusController.text = widget.kehadiran.status ?? "";
//   }

//   Future<void> _pilihTanggal(BuildContext context) async {
//     final DateTime? pickerDate = await showDatePicker(
//       context: context,
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//       initialDate: DateTime.now(),
//       locale: const Locale('id', 'ID'),
//     );
//     if (pickerDate != null) {
//       setState(() {
//         selectedDate = pickerDate;
//         _tanggalController.text = DateFormat(
//           'dd-MM-yyyy',
//           'id',
//         ).format(pickerDate);
//       });
//     }
//   }

//   Future<void> _updateKehadiran() async {
//     if (_formKey.currentState!.validate()) {
//       final updatedKehadiran = Kehadiran(
//         idKehadiran: widget.kehadiran.idKehadiran,
//         userId: widget.kehadiran.userId,
//         nama: _namaController.text,
//         tanggal: _tanggalController.text,
//         kelas: _kelasController.text,
//         status: _statusController.text,
//       );

//       await DbHelper.registerKehadiran(updatedKehadiran);

//       widget.onKehadiranUpdated();
//       Navigator.pop(context);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Data kehadiran berhasil diupdate')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Edit Kehadiran",
//           style: TextStyle(
//             fontFamily: "Gilroy_Regular",
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 15, 216, 166),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _namaController,
//                   decoration: InputDecoration(
//                     labelText: "Nama Siswa",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Nama tidak boleh kosong";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _tanggalController,
//                   decoration: InputDecoration(
//                     labelText: 'Pilih Tanggal',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.calendar_month),
//                       onPressed: () => _pilihTanggal(context),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Tanggal tidak boleh kosong";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _kelasController,
//                   decoration: InputDecoration(
//                     labelText: "Kelas Siswa",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Kelas tidak boleh kosong";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     labelText: "Status Kehadiran",
//                   ),
//                   value: _statusController.text,
//                   items: ["Hadir", "Izin", "Sakit", "Alpha"].map((
//                     String value,
//                   ) {
//                     return DropdownMenuItem(value: value, child: Text(value));
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       _statusController.text = newValue!;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Status kehadiran tidak boleh kosong";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _updateKehadiran,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 15, 216, 166),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       "Update",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
