import 'package:final_project_appdev/const.dart';
import 'package:final_project_appdev/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

void main() {
  runApp(const MaterialApp(
    home: SplashScreen()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'ClimaTech'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
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
        }
      });
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_forecast == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchWeather,
      color: Colors.deepPurple,
      backgroundColor: Colors.white,
      child: Container(
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                locationHeader(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.00001,
                ),
                weatherIcon(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                dateTimeInfo(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                forecastContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget locationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _weather?.areaName ?? "",
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Manrope',
            fontSize: 30, // Reduced font size
            fontWeight: FontWeight.w700,
          ),
        ),
        
      ],
    );
  }

  Widget dateTimeInfo() {
    DateTime now = DateTime.now();
    return Column(
      children: [
        Text(
          DateFormat("EEEE").format(now),
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Manrope',
            fontSize: 23, // Reduced font size
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("h:mm a").format(now),
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Manrope',
                fontSize: 15, // Reduced font size
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              "  ${DateFormat("|   M.d.y").format(now)}",
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Manrope',
                fontSize: 15, // Reduced font size
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month,
                color: Color.fromARGB(255, 255, 255, 255), size: 16),
            SizedBox(width: 4),
            Text(
              "7 Days Forecast",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget weatherIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
              ),
            ),
          ),
        ),
        Text(
          "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Manrope',
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          capitalize(_weather?.weatherDescription ?? ""),
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Manrope',
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget forecastContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _forecast!.map((weather) {
        return Center( //To center all teh container
          child: weatherDayContainer(
            DateFormat("EEEE").format(weather.date!),
            DateFormat("h:mm a").format(weather.date!), // Use weather.date for each forecast item
            "${weather.temperature?.celsius?.toStringAsFixed(0)}°C",
            capitalize(weather.weatherDescription ?? ""),
          ),
        );
      }).toList(),
    );
  }

  Widget weatherDayContainer(String day, String time, String temperature, String description) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, //to edit the width of the container
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'Manrope',
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'Manrope',
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              temperature,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'Manrope',
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'Manrope',
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
