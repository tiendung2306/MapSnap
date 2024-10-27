import 'package:flutter/material.dart';

class normalForm extends StatelessWidget {
  const normalForm({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: new InputDecoration(
          labelText: this.label,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                  width: 2.0
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                  width: 3.0,
                  color: Colors.lightBlueAccent
              )
          ),
      ),
    );
  }
}



