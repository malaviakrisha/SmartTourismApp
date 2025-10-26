import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget{
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itienary'),
      ),
      body: const Center(child: Text('Itienary')),
    );
  }
}