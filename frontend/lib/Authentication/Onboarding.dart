import 'package:flutter/material.dart';
import 'Onboarding_content_model.dart';
import 'SignUp.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                              image: AssetImage(contents[i].image),
                              height: 300,
                              fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 20),

                        Text(
                          contents[i].title,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          contents[i].discription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                      (index) => buildDot(index, context),
                ),
              ),
            ),
            Container(
              // color: Colors.red,
              height: 60,
              margin: EdgeInsets.all(40),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 20,
                        ),
                    ),
                    onPressed: () {
                      _controller.previousPage(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                  ),
                  TextButton(
                    child: Text(
                        currentIndex == contents.length - 1 ? "Continue" : "Next",
                        style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 20
                        )
                    ),
                    onPressed: () {
                      if (currentIndex == contents.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignUp(),
                          ),
                        );
                      }
                      _controller.nextPage(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.lightBlueAccent,
      ),
    );
  }
}