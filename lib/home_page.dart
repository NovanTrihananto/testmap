import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'map_from_db.dart';  // import halaman peta

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> lokasiList = [];
  bool loading = true;

 Future<void> fetchLokasiList() async {
  final url = 'http://10.0.2.2:3000/lokasi'; // IP emulator Android
  try {
    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        lokasiList = data.cast<Map<String, dynamic>>();
        loading = false;
      });
    } else {
      print('Error mengambil data lokasi');
      setState(() => loading = false);
    }
  } catch (e) {
    print('Exception: $e');
    setState(() => loading = false);
  }
}

  @override
  void initState() {
    super.initState();
    fetchLokasiList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Lokasi'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: lokasiList.length,
              itemBuilder: (context, index) {
                final lokasi = lokasiList[index];
                return ListTile(
                  title: Text(lokasi['nama'] ?? 'Tidak ada nama'),
                  subtitle: Text('ID: ${lokasi['id']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapFromDb(lokasiId: lokasi['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
