import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget{
  const PaymentPage({super.key});

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