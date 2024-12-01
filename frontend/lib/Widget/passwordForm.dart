import 'package:flutter/material.dart';

class passwordForm extends StatefulWidget {
  const passwordForm({
    super.key,
    required this.label,
    required this.controller,
  });
    
  final String label;
  final TextEditingController controller;

  
  @override
  State<passwordForm> createState() => _passwordFormState();
}

class _passwordFormState extends State<passwordForm> {
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: passwordVisible,
      decoration: new InputDecoration(
          labelText: widget.label,
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
          suffixIcon: IconButton(
            icon: (!passwordVisible ? Image.asset("assets/Login/visibility.png") : Image.asset("assets/Login/visibility_off.png")),
            onPressed: () {
              setState(
                    () {
                  passwordVisible = !passwordVisible;
                },
              );
            },
          )
      ),
    );
  }
}

