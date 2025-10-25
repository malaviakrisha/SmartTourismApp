import 'package:flutter/material.dart';

class ArtistHomePage extends StatelessWidget{
  const ArtistHomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Home Page'),
      ),
      body: const Center(
        child: Text('Welcome to Artist Home Page'),
      ),
    );
  }
}