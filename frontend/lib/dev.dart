import 'package:flutter/material.dart';
import 'Services/APIService.dart';

class DevScreen extends StatefulWidget {
  const DevScreen({super.key});

  @override
  State<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  final  _apiService = ApiService();

  void test() async{
    _apiService.GetJourney('673a12ecbd6c5308f8788ab7');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button in Center'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            test();

          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: const Text(
            'Bấm vào đây',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}