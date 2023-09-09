import 'dart:io';
import 'package:flutter/material.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool invertDirection = false;
  bool enableTiltTrack = true;
  double sensitivity = 0.5;

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
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            configOption(
              'Tilt Tracking',
              Switch(
                value: enableTiltTrack,
                onChanged: (bool value) {
                  setState(() {
                    enableTiltTrack = value;
                  });
                },
              ),
            ),
            (enableTiltTrack
                ? configOption(
                    'Invert Direction',
                    Switch(
                      value: invertDirection,
                      onChanged: (bool value) {
                        setState(() {
                          invertDirection = value;
                        });
                      },
                    ),
                  )
                : Container()),
            (enableTiltTrack
                ? configOption(
                    'Sensitivity',
                    Slider(
                      value: sensitivity,
                      min: 0,
                      max: 1,
                      divisions: 10,
                      label: sensitivity.toStringAsFixed(1),
                      onChanged: (double value) {
                        setState(() {
                          sensitivity = value;
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
