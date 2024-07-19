import 'package:final_project_appdev/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

void main() {
  runApp(const SecondTab(title: 'ClimaTech',));
}

class SecondTab extends StatefulWidget {
  const SecondTab({super.key, required this.title});

  final String title;

  @override
  State<SecondTab> createState() => _SecondTabState();
}
  
class _SecondTabState extends State<SecondTab> {
  final WeatherFactory _weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  List<Weather>? _forecast;

  String capitalize(String? text) {
    if (text == null) return "";
    return text.toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final forecast = await _weatherFactory.fiveDayForecastByCityName("Batangas");
      setState(() {
        _forecast = forecast;
        if (_forecast != null && _forecast!.isNotEmpty) {
          _weather = _forecast![0];
          print("Weather data fetched successfully: $_weather");
        }
      });
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            _buildUI(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUI() {
    return Container(
      padding: const EdgeInsets.all(25.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 29, 3, 45),
            Color.fromARGB(255, 107, 65, 213),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dateTimeInfo(),
          const SizedBox(height: 20),
          Center(child: additionalInfo(_weather)),
        ],
      ),
    );
  }

  Widget dateTimeInfo() {
    DateTime now = DateTime.now();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              DateFormat("h:mm a  |").format(now),
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.calendar_today,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 16,
            ),
            Text(
              "  ${DateFormat("M.d.y").format(now)}",
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 4),
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Manrope',
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget additionalInfo(Weather? weather) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.50,
    width: MediaQuery.of(context).size.width * 0.80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.all(5.0),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_fire_department_outlined, color: Colors.white),
                    Expanded(
                      child: Text(
                        weather != null ? 'Max Temp: ${weather.tempMax?.celsius?.toStringAsFixed(0) ?? '--'}°C' : 'Loading...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.thermostat_outlined, color: Colors.white),
                    Expanded(
                      child: Text(
                        weather != null ? 'Min Temp: ${weather.tempMin?.celsius?.toStringAsFixed(0) ?? '--'}°C' : 'Loading...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.air_outlined, color: Colors.white),
                    Expanded(
                      child: Text(
                        weather != null ? 'Wind Speed: ${weather.windSpeed?.toStringAsFixed(2) ?? '--'} m/s' : 'Loading...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.water_drop_outlined, color: Colors.white),
                    Expanded(
                      child: Text(
                        weather != null ? 'Humidity: ${weather.humidity?.toStringAsFixed(0) ?? '--'}%' : 'Loading...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_tethering_sharp, color: Colors.white),
                    Expanded(
                      child: Text(
                        weather != null ? 'Pressure: ${weather.pressure?.toStringAsFixed(0) ?? '--'} psi' : 'Loading...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.rotate_90_degrees_ccw_sharp, color: Colors.white),
                    Expanded(
                      child: Text(
                        weather != null ? 'Wind Direction: ${weather.windDegree?.toStringAsFixed(0) ?? '--'}°' : 'Loading...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.blur_circular, color: Colors.white),
                    Expanded(
                      child: Text(
                        weather != null ? 'Latitude: ${weather.latitude ?? '--'}°' : 'Loading...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.blur_circular_outlined, color: Colors.white),
                    Expanded(
                      child: Text(
                        weather != null ? 'Longitude: ${weather.longitude ?? '--'}°' : 'Loading...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
