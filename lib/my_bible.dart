import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybible/side_bar.dart';

class MyBible extends StatefulWidget {
  const MyBible({super.key});

  @override
  State<MyBible> createState() => _MyBibleState();
}

class _MyBibleState extends State<MyBible> {
  late Future<List<Map<String, dynamic>>> scriptures;

  @override
  void initState() {
    super.initState();
    scriptures = loadScriptures();
  }

  Future<List<Map<String, dynamic>>> loadScriptures() async {
    final String response = await rootBundle.loadString(
      'assets/bible_dummy_data.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width; // get the screen size
    double midPointWidth = width / 2; // divide it in half
    const double floatingLabelWidth = 200; // set the floating label width
    /*
      The floating label starts at the point you set it at
      to get it to be centered you need to minus half of the
      floating label's width from the midPoint width and the
      lable will be centered. Okay so ... this doesnt work

      TO FIX
     */
    double floatingLabelLeftStart = midPointWidth - (floatingLabelWidth / 2);
    const double bottomPoint = 80;

    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFF5F2EA)),
      backgroundColor: Color(0xFFF5F2EA),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: floatingLabelWidth / 2,
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: FutureBuilder(
                future: scriptures,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data');
                  } else {
                    return ListView(
                      children:
                          snapshot.data!.map<Widget>((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                '${item['verse']} ${item['scripture']}',
                                style: const TextStyle(
                                  fontFamily: 'Merriweather',
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            width: floatingLabelWidth,
            bottom: bottomPoint, // Distance from the top of the screen
            left:
                floatingLabelLeftStart, // Distance from the left of the screen
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF8E9B6D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Genesis 1",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'MerriweatherSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 66,
            left: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Color(0xFF8E9B6D)),
                color: Colors.white,
                onPressed: () {},
                icon: Icon(Icons.chevron_left_rounded),
              ),
            ),
          ),
          Positioned(
            bottom: 66,
            right: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Color(0xFF8E9B6D)),
                color: Colors.white,
                onPressed: () {},
                icon: Icon(Icons.chevron_right_rounded),
              ),
            ),
          ),
        ],
      ),
      drawer: SideBar(),
    );
  }
}
