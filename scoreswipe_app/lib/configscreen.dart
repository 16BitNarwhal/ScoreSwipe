import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class Config {
  static late final SharedPreferences prefs;

  static bool invertDirection = false;
  static bool enableTiltTrack = true;
  static double sensitivity = 50;

  static void loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    invertDirection = prefs.getBool('invertDirection') ?? false;
    enableTiltTrack = prefs.getBool('enableTiltTrack') ?? true;
    sensitivity = prefs.getDouble('sensitivity') ?? 50;
  }
}

class _ConfigScreenState extends State<ConfigScreen> {
  late final SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    Config.loadPrefs();
    setState(() {});
  }

  configOption(title, widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title),
        widget,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Config"),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            configOption(
              'Tilt Tracking',
              Switch(
                value: Config.enableTiltTrack,
                onChanged: (bool value) {
                  setState(() {
                    Config.enableTiltTrack = value;
                  });
                },
              ),
            ),
            (Config.enableTiltTrack
                ? configOption(
                    'Invert Direction',
                    Switch(
                      value: Config.invertDirection,
                      onChanged: (bool value) {
                        setState(() {
                          Config.invertDirection = value;
                        });
                      },
                    ),
                  )
                : Container()),
            (Config.enableTiltTrack
                ? configOption(
                    'Sensitivity',
                    Slider(
                      value: Config.sensitivity,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: Config.sensitivity.toStringAsFixed(1),
                      onChanged: (double value) {
                        setState(() {
                          Config.sensitivity = value;
                        });
                      },
                    ),
                  )
                : Container()),
          ],
        ),
      ),
    );
  }
}
