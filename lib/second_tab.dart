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

class _SecondTabState extends State<SecondTab> with SingleTickerProviderStateMixin {
  final WeatherFactory _weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  List<Weather>? _forecast;
  List<Weather>? _hourlyForecast;

  String capitalize(String? text) {
    if (text == null) return "";
    return text.toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
      _topAlignmentAnimation = TweenSequence<Alignment>(
        [
          TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
            weight: 1,
          ),
          TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
            weight: 1,
          ),
          TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
            weight: 1,
          ),
          TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
            weight: 1,
          ),
        ]
      ).animate(_controller);

      _bottomAlignmentAnimation = TweenSequence<Alignment>(
        [
          TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
            weight: 1,
          ),
          TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
            weight: 1,
          ),
          TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
            weight: 1,
          ),
          TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
            weight: 1,
          ),
        ]
      ).animate(_controller);

      _controller.repeat();
      _fetchWeather();
    }

  Future<void> _fetchWeather() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final forecast = await _weatherFactory.fiveDayForecastByCityName("Batangas");
      final hourlyForecast = await _weatherFactory.fiveDayForecastByCityName("Batangas");

      setState(() {
        _forecast = forecast;
        _hourlyForecast = hourlyForecast;
        if (_forecast != null && _forecast!.isNotEmpty) {
          _weather = _forecast![0];
          print("Weather data fetched successfully: $_weather");
        }
      });
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  Future<void> _refreshWeather() async {
    await _fetchWeather();
  }

  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshWeather,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return _buildUI();
          },
        ),
      ),
    ),
  );
}


  Widget _buildUI() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color.fromARGB(255, 37, 15, 65),
            Color.fromARGB(255, 129, 19, 198),
          ],
            begin: _topAlignmentAnimation.value,
            end: _bottomAlignmentAnimation.value,
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            dateTimeInfo(),
            const SizedBox(height: 35),
            hourlyForecastWidget(),
            const SizedBox(height: 35),
            Center(child: additionalInfo(_weather)),
          ],
        ),
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

  Widget hourlyForecastWidget() {
    return _hourlyForecast == null
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _hourlyForecast!.length,
              itemBuilder: (context, index) {
                final weather = _hourlyForecast![index];
                return hourlyForecastTile(weather);
              },
            ),
          );
  }

  Widget hourlyForecastTile(Weather weather) {
  String iconUrl = 'http://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png';

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 7.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateFormat("EEE").format(weather.date!), // Day of the week
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Manrope',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          DateFormat("h a").format(weather.date!), // Time
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Manrope',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Image.network(
          iconUrl,
          width: 40,
          height: 40,
        ),
        const SizedBox(height: 5),
        Text(
          '${weather.temperature?.celsius?.toStringAsFixed(0) ?? '--'}°C',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Manrope',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
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
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
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
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
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
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
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
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
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
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
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
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
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
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
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
                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
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
