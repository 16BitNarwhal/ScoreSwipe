import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class Config {
  static SharedPreferences? prefs;

  static bool invertDirection = false;
  static bool enableTiltTrack = true;
  static double sensitivity = 50;

  static Future<void> loadPrefs({Function? callback}) async {
    if (prefs != null) return;
    prefs = await SharedPreferences.getInstance();
    enableTiltTrack = prefs!.getBool('enableTiltTrack') ?? enableTiltTrack;
    invertDirection = prefs!.getBool('invertDirection') ?? invertDirection;
    sensitivity = prefs!.getDouble('sensitivity') ?? sensitivity;
    callback?.call();
  }
}

class _ConfigScreenState extends State<ConfigScreen> {
  final gap = const SizedBox(height: 16);

  @override
  void initState() {
    super.initState();
    Config.loadPrefs(callback: () => setState(() {}));
  }

  configOption(title, widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title, style: const TextStyle(fontSize: 18)),
        widget,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
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
                    Config.prefs!.setBool('enableTiltTrack', value);
                  });
                },
              ),
            ),
            gap,
            (Config.enableTiltTrack
                ? configOption(
                    'Invert Direction',
                    Switch(
                      value: Config.invertDirection,
                      onChanged: (bool value) {
                        setState(() {
                          Config.invertDirection = value;
                          Config.prefs!.setBool('invertDirection', value);
                        });
                      },
                    ),
                  )
                : Container()),
            gap,
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
                          Config.prefs!.setDouble('sensitivity', value);
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
