import 'package:flutter/material.dart';

class PageAlertDialog extends StatefulWidget {
  final String message;

  const PageAlertDialog({Key? key, required this.message}) : super(key: key);

  @override
  State<PageAlertDialog> createState() => _PageAlertDialogState();
}

class _PageAlertDialogState extends State<PageAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnimation = Tween(begin: 1.0, end: 1.5).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pop(); // auto close when fade out complete
        }
      });
    _controller.forward(); // start the fade out
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 24.0,
        title: const Icon(Icons.info_outline, size: 28, color: Colors.blue),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.message,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
      ),
    );
  }
}
