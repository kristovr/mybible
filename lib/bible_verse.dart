import 'package:flutter/material.dart';

class BibleVerse extends StatefulWidget {
  // final VoidCallback onBack;

  const BibleVerse({super.key});

  @override
  State<BibleVerse> createState() => _BibleVerseState();
}

class _BibleVerseState extends State<BibleVerse> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 2.0,
        children: [
          for (var i = 1; i < 20; i++)
            Container(
              color: Color(0xFF8E9B6D),
              child: GridTile(
                child: InkWell(
                  onTap: () {
                    print(i);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        i.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MerriweatherSans',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
