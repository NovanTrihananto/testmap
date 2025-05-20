import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFromDb extends StatefulWidget {
  final String lokasiId;

  MapFromDb({required this.lokasiId});

  @override
  _MapFromDbState createState() => _MapFromDbState();
}

class _MapFromDbState extends State<MapFromDb> {
  LatLng? lokasi;
  String? namaLokasi;
  int? radius;

  Future<void> fetchLokasi() async {
    final url = 'http://10.0.2.2:3000/lokasi/${widget.lokasiId}'; // IP buat emulator
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        namaLokasi = data['nama'];
        lokasi = LatLng(
          double.parse(data['latitude'].toString()),
          double.parse(data['longitude'].toString()),
        );
        radius = data['radius'];
      });
    } else {
      print('Gagal fetch data lokasi');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLokasi();
  }

  @override
  Widget build(BuildContext context) {
    if (lokasi == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(namaLokasi ?? 'Lokasi')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: lokasi!, zoom: 16),
        markers: {
          Marker(markerId: MarkerId('lokasi'), position: lokasi!),
        },
        circles: {
          Circle(
            circleId: CircleId('zonaBahaya'),
            center: lokasi!,
            radius: radius?.toDouble() ?? 100,
            fillColor: Colors.red.withOpacity(0.4),
            strokeColor: Colors.red,
            strokeWidth: 2,
          ),
        },
      ),
    );
  }
}
