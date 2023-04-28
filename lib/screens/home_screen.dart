import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timestop/screens/settings_screen.dart';
import 'package:timestop/widgets/utils/color_options.dart';
import 'package:timestop/widgets/utils/time_format.dart';
import 'package:timestop/widgets/drawer_nav.dart';
import 'package:wakelock/wakelock.dart';
import 'package:sprintf/sprintf.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Configuration Variables
  double drawerPadding = 16;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  String versionInfo = "Version 0.7.7";

  //Stopwatch Variables
  bool lapDisplay = false;
  bool stopwatchRunning = false;
  int milliseconds = 0, seconds = 0, minutes = 0, hours = 0;
  int initialTime = 0;
  List laps = [];
  static const Duration _tenMilliseconds = Duration(milliseconds: 10);
  static const String _doubleDigitFormat = '%02d';
  String digitMilliseconds = "00",
      digitSeconds = "00",
      digitMinutes = "00",
      digitHours = "00";
  Timer? timer;

  //Drawer open/close functions
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  //Start Stopwatch function
  void start() {
    stopwatchRunning = true;
    Wakelock.enable();
    timer = Timer.periodic(_tenMilliseconds, (timer) {
      if (++milliseconds > 99) {
        milliseconds = 0;
        if (++seconds > 59) {
          seconds = 0;
          if (++minutes > 59) {
            minutes = 0;
            if (++hours > 23) {
              hours = 0;
            }
          }
        }
      }
      setState(() {
        digitMilliseconds = sprintf(_doubleDigitFormat, [milliseconds]);
        digitSeconds = sprintf(_doubleDigitFormat, [seconds]);
        digitMinutes = sprintf(_doubleDigitFormat, [minutes]);
        digitHours = sprintf(_doubleDigitFormat, [hours]);
      });
    });
  }

  //Stop Stopwatch function
  void stop() {
    timer?.cancel();
    Wakelock.disable();
    stopwatchRunning = false;
  }

  //Reset Stopwatch function
  void reset() {
    timer?.cancel();
    Wakelock.disable();
    stopwatchRunning = false;
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
    });
  }

  //Lap function
  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds:$digitMilliseconds";
    setState(() {
      lapDisplay = true;
      laps.add(lap);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
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

  //Stopwatch Text
  TextStyle getCustomTextStyle(BuildContext context, bool displayHours) {
    return TextStyle(
      color: Colors.grey[200],
      fontSize: displayHours ? 60.0 : 70.0,
      fontWeight: FontWeight.w600,
    );
  }

  //Visual design
  @override
  Widget build(BuildContext context) {
    final coloroption = context.watch<ColorOptions>();
    final timeoption = context.watch<TimeFormat>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: coloroption.selectedColor,
      drawer: Drawer(
        backgroundColor: coloroption.selectedColor,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(drawerPadding),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  2 * (drawerPadding) -
                  MediaQuery.of(context).padding.top,
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
                            builder: (context) => const SettingsScreen()),
                      );
                    },
                    selected: false,
                  ),
                  const Spacer(),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(
                      versionInfo,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    timeoption.displayHours
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                SizedBox(
                                  width: 70.0,
                                  child: Text(
                                    digitHours,
                                    textAlign: TextAlign.center,
                                    style: getCustomTextStyle(
                                        context, timeoption.displayHours),
                                  ),
                                ),
                                Text(
                                  ":",
                                  textAlign: TextAlign.center,
                                  style: getCustomTextStyle(
                                      context, timeoption.displayHours),
                                ),
                              ])
                        : const SizedBox.shrink(),
                    SizedBox(
                      width: timeoption.displayHours ? 70.0 : 100.0,
                      child: Text(
                        digitMinutes,
                        textAlign: TextAlign.center,
                        style: getCustomTextStyle(
                            context, timeoption.displayHours),
                      ),
                    ),
                    Text(
                      ":",
                      textAlign: TextAlign.center,
                      style:
                          getCustomTextStyle(context, timeoption.displayHours),
                    ),
                    SizedBox(
                      width: timeoption.displayHours ? 70.0 : 100.0,
                      child: Text(
                        digitSeconds,
                        textAlign: TextAlign.center,
                        style: getCustomTextStyle(
                            context, timeoption.displayHours),
                      ),
                    ),
                    Text(
                      ":",
                      textAlign: TextAlign.center,
                      style:
                          getCustomTextStyle(context, timeoption.displayHours),
                    ),
                    SizedBox(
                      width: timeoption.displayHours ? 70.0 : 100.0,
                      child: Text(
                        digitMilliseconds,
                        textAlign: TextAlign.center,
                        style: getCustomTextStyle(
                            context, timeoption.displayHours),
                      ),
                    ),
                  ],
                ),
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
                    controller: _scrollController,
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
                        iconSize: MediaQuery.of(context).size.width * 0.14,
                        color: Colors.blue[200],
                        onPressed: () {
                          addLaps();
                          HapticFeedback.lightImpact();
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
                        iconSize: MediaQuery.of(context).size.width * 0.18,
                        color: (!stopwatchRunning)
                            ? Colors.green[300]
                            : Colors.orange[300],
                        onPressed: () {
                          (!stopwatchRunning) ? start() : stop();
                          HapticFeedback.lightImpact();
                        },
                        icon: Icon(
                          (!stopwatchRunning) ? Icons.play_arrow : Icons.pause,
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
                        iconSize: MediaQuery.of(context).size.width * 0.14,
                        color: Colors.red[300],
                        onPressed: () {
                          reset();
                          laps.clear();
                          HapticFeedback.lightImpact();
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
