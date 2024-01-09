import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.foregroundColor,
    this.backgroundColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor:
            foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
      child: Text(text),
    );
  }
}
