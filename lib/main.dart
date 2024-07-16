import 'package:final_project_appdev/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

  class _MyWidgetState extends State<HomePage> {
  final WeatherFactory _weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);
  
  Weather? _weather;

  String capitalize(String? text) {
  if (text == null) return "";
  return text.toUpperCase();
}

  @override
  void initState(){
    super.initState();
    _weatherFactory.currentWeatherByCityName("Batangas").then((weather) {
      setState(() {
        _weather = weather;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 29, 3, 45), // Dark blue/purple
            Color.fromARGB(255, 107, 65, 213), // Lighter purple
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            locationHeader(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.01,
            ),
            weatherIcon(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.025,
            ),
            dateTimeInfo(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.09,
            ),
          ],
        ),
      ),
    );
  }

  Widget locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Manrope',
        fontSize: 40,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget dateTimeInfo() {
    DateTime current = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("EEEE").format(current),
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Manrope',
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("h:mm a").format(current),
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              "  ${DateFormat("|   M.d.y").format(current)}",
                style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w300,
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
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
              ),
            ),
          ),
        ),
        Text(capitalize(_weather?.weatherDescription ?? ""),
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
}
