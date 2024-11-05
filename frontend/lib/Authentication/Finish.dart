import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Screen/settingScreen.dart';

class Finish extends StatelessWidget {
  const Finish({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Login/Background.png"),
              fit: BoxFit.cover,
            ),
          ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: AssetImage("assets/Login/Finish.png"),
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Account setup complete!",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Enjoy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                  child: Container(
                        //null
                  )
              ),
              ElevatedButton(
                onPressed: () {
                  // Xử lý đăng ký
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => settingScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.lightBlueAccent
                ),
                child: Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

