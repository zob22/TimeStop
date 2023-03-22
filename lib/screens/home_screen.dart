import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timestop/screens/settings_screen.dart';
import 'package:timestop/widgets/background.dart';
import 'package:timestop/widgets/drawer_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialize with default value
  //Business logic
  int milliseconds = 0, seconds = 0, minutes = 0, hours = 0;
  String digitMilliseconds = "00",
      digitSeconds = "00",
      digitMinutes = "00",
      digitHours = "00";
  Timer? timer;
  bool started = false;
  bool lapDisplay = false;
  List laps = [];
  var startTime = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Drawer open/close functions
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  // void _closeDrawer() {
  //   Navigator.of(context).pop();
  // }

  //Stop timer function
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  //Reset timer function
  void reset() {
    if (timer != null) {
      timer!.cancel();
    }
    setState(() {
      lapDisplay = false;
      milliseconds = 0;
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitMilliseconds = "00";
      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
    });
  }

//Lap orientation
  double lapView() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return 350.0;
    } else {
      return 100.0;
    }
  }

  double timeView() {
    if (MediaQuery.of(context).orientation == Orientation.portrait &&
        !lapDisplay) {
      return 175.0;
    } else {
      return 0.0;
    }
  }

  //Lap function
  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds:$digitMilliseconds";
    setState(() {
      lapDisplay = true;
      laps.add(lap);
    });
  }

  //Lap difference
  String lapDiff(laps, index) {
    var currentLap = laps[index].replaceAll(RegExp('[^0-9]'), '');
    var previousLap = laps[index - 1].replaceAll(RegExp('[^0-9]'), '');
    var diffLap = int.parse(currentLap) - int.parse(previousLap);
    var padLap = diffLap.toString().padLeft(8, '0');
    var result =
        '${padLap.substring(0, 2)}:${padLap.substring(2, 4)}:${padLap.substring(4, 6)}:${padLap.substring(6, 8)}';

    return result;
  }

  //Start timer function
  void start() {
    started = true;
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      int localMilliseconds = milliseconds + 1;
      int localSeconds = seconds;
      int localMinutes = minutes;
      int localHours = hours;

      if (localMilliseconds > 99) {
        if (localSeconds > 59) {
          if (localMinutes > 59) {
            localHours++;
            localMinutes = 0;
          } else {
            localMinutes++;
            localSeconds = 0;
          }
        } else {
          localSeconds++;
          localMilliseconds = 0;
        }
      }

      setState(() {
        milliseconds = localMilliseconds;
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitMilliseconds =
            (milliseconds >= 10) ? "$milliseconds" : "0$milliseconds";
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  //Visual design
  @override
  Widget build(BuildContext context) {
    final background = context.watch<Background>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: background.selectedColor,
      drawer: Drawer(
        backgroundColor: background.selectedColor,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                DrawerNavigationItem(
                  iconData: Icons.schedule,
                  title: "Stopwatch",
                  onTap: () {},
                  selected: true,
                ),
                const Divider(
                  thickness: 1.0,
                ),
                DrawerNavigationItem(
                  iconData: Icons.settings,
                  title: "Settings",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                              selectedColor: background.selectedColor)),
                    );
                  },
                  selected: false,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Appbar
              Row(
                children: [
                  IconButton(
                    iconSize: 25.0,
                    color: Colors.grey[200],
                    onPressed: () {
                      _openDrawer();
                    },
                    icon: const Icon(
                      Icons.density_medium,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Stopwatch",
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              //Spacer
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: timeView(),
              ),
              //Stopwatch Time
              Center(
                child: Text(
                    "$digitHours:$digitMinutes:$digitSeconds:$digitMilliseconds",
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 50.0,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              //Lap display
              if (lapDisplay)
                (Container(
                  height: lapView(),
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    itemCount: laps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#${index + 1}",
                              style: TextStyle(
                                color: Colors.grey[200],
                                fontSize: 16.0,
                              ),
                            ),
                            (index < 1)
                                ? Text(
                                    "${laps[index]}",
                                    style: TextStyle(
                                      color: Colors.grey[200],
                                      fontSize: 16.0,
                                    ),
                                  )
                                : Text(
                                    lapDiff(laps, index),
                                    style: TextStyle(
                                      color: Colors.grey[200],
                                      fontSize: 16.0,
                                    ),
                                  ),
                            Text(
                              "${laps[index]}",
                              style: TextStyle(
                                color: Colors.grey[200],
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ))
              else
                (SizedBox(
                  height: timeView(),
                )),

              const SizedBox(
                height: 40.0,
              ),
              //Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Lap Button
                  Expanded(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        iconSize: 50.0,
                        color: Colors.blue[200],
                        onPressed: () {
                          addLaps();
                        },
                        icon: const Icon(Icons.flag),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  //Play / Pause button
                  Expanded(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        iconSize: 70.0,
                        color:
                            (!started) ? Colors.green[300] : Colors.orange[300],
                        onPressed: () {
                          (!started) ? start() : stop();
                        },
                        icon: Icon(
                          (!started) ? Icons.play_arrow : Icons.pause,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  //Reset Button
                  Expanded(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        iconSize: 50.0,
                        color: Colors.red[300],
                        onPressed: () {
                          reset();
                          laps.clear();
                        },
                        icon: const Icon(
                          Icons.replay,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //Spacer
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
