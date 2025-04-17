import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(AQIApp());
}

class AQIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(bodyLarge: TextStyle(fontFamily: 'Montserrat')),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(bodyLarge: TextStyle(fontFamily: 'Montserrat')),
      ),
      themeMode: ThemeMode.system,
      home: AQIScreen(),
    );
  }
}

class AQIScreen extends StatefulWidget {
  @override
  _AQIScreenState createState() => _AQIScreenState();
}

class _AQIScreenState extends State<AQIScreen> {
  int? aqi;
  String status = "Enter a city to check AQI";
  Color statusColor = Colors.grey;
  TextEditingController cityController = TextEditingController();
  bool isLoading = false;

  Future<void> fetchAQI(String city) async {
    setState(() {
      isLoading = true;
      aqi = null;
      status = "Fetching AQI for $city...";
    });

    final response = await http.get(Uri.parse(
        "https://api.waqi.info/feed/$city/?token=158077:f5a31762-e440-4ddb-8a9a-27aed3c1d2d6"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["status"] == "ok") {
        setState(() {
          aqi = data['data']['aqi'];
          _updateStatus();
        });
      } else {
        setState(() {
          status = "City not found or AQI data unavailable.";
          statusColor = Colors.red;
        });
      }
    } else {
      setState(() {
        status = "Error fetching data";
        statusColor = Colors.red;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _updateStatus() {
    if (aqi == null) return;

    if (aqi! <= 50) {
      status = "Good";
      statusColor = Colors.green;
    } else if (aqi! <= 100) {
      status = "Moderate";
      statusColor = Colors.yellow;
    } else if (aqi! <= 150) {
      status = "Unhealthy for Sensitive Groups";
      statusColor = Colors.orange;
    } else if (aqi! <= 200) {
      status = "Unhealthy";
      statusColor = Colors.red;
    } else {
      status = "Hazardous";
      statusColor = Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Air Quality Index (AQI)")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: "Enter City Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String city = cityController.text.trim();
                if (city.isNotEmpty) fetchAQI(city);
              },
              child: Text("Get AQI"),
            ),
            SizedBox(height: 30),
            if (isLoading)
              CircularProgressIndicator()
            else ...[
              Text(
                aqi != null ? "AQI: $aqi" : "",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                status,
                style: TextStyle(fontSize: 20, color: statusColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

