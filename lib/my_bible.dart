import 'package:flutter/material.dart';
import 'package:mybible/side_bar.dart';

class MyBible extends StatelessWidget {
  const MyBible({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFF5F2EA)),
      backgroundColor: Color(0xFFF5F2EA),
      body: Stack(
        children: [
          Center(child: Text("Hello World")),
          Positioned(
            bottom: 50, // Distance from the top of the screen
            left: 40, // Distance from the left of the screen
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(
                  0.7,
                ), // Semi-transparent background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Floating Label",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'MerriweatherSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: SideBar(),
    );
  }
}
