import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

//////  Cronometro
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronometer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  
  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;
  late String _currentTime;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    _currentTime = _getCurrentTime();
    super.initState();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hours = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minutes = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'pm' : 'am';
    return "$hours:$minutes $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _currentTime,
                  style: TextStyle(
                    color: widget.mode == WearMode.active
                        ? Colors.white
                        : Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "Cronómetro",
                    style: TextStyle(
                      color: widget.mode == WearMode.active 
                      ? Colors.white 
                      : Colors.white54,
                      fontSize: 15
                      ),
                    ),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Icon( 
                    Icons.timer_outlined, 
                    color: widget.mode == WearMode.active 
                    ? const Color.fromARGB(255, 88, 127, 201) 
                    : const Color.fromARGB(111, 88, 128, 201)
                    ),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Text(
                    _strCount,
                    style: TextStyle(
                      color: widget.mode == WearMode.active
                          ? Colors.white
                          : Colors.white70,
                      fontSize: 25
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                _buildWidgetButton(),
                ],
              ),
            ),
          ]
        )
      ),
    );
  }

  Widget _buildWidgetButton() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (_status == "Start") {
              _startTimer();
            } else if (_status == "Stop") {
              _timer.cancel();
              setState(() {
                _status = "Continue";
              });
            } else if (_status == "Continue") {
              _startTimer();
            }
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(18),
              backgroundColor: widget.mode == WearMode.active
                  ? const Color.fromARGB(255, 88, 127, 201)
                  : const Color.fromARGB(111, 88, 128, 201)
            ),
            child: _status == "Start" || _status == "Continue"
            ? const Icon(
                Icons.play_arrow_rounded, 
                size: 24,
                color: Colors.black,
              ) 
            : const Icon(
                Icons.pause_rounded, 
                size: 24,
                color: Colors.black,
              ),
        ),
        ElevatedButton(
          // color: Colors.blue,
          // textColor: Colors.white,
          onPressed: () {
            // ignore: unnecessary_null_comparison
            if (_timer != null) {
              _timer.cancel();
              setState(() {
                _count = 0;
                _strCount = "00:00:00";
                _status = "Start";
              });
            }
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(18),
              backgroundColor: widget.mode == WearMode.active
                  ? const Color.fromARGB(255, 88, 127, 201)
                  : const Color.fromARGB(111, 88, 128, 201)
            ),
            child: const Icon(
                Icons.restore, 
                size: 24,
                color: Colors.black,
              ),
        ),
      ],
    );
  }

  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}