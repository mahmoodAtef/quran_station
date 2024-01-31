import 'package:flutter/material.dart';

class AudiosMainScreen extends StatelessWidget {
  const AudiosMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصوتيات'),
      ),
      body: const Center(
        child: Text('الصوتيات'),
      ),
    );
  }
}
