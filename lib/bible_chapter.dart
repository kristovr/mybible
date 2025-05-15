import 'package:flutter/material.dart';

class BibleChapter extends StatefulWidget {
  // final VoidCallback onBack;
  final ValueChanged<bool> onShowBibleVerseChange;
  const BibleChapter({super.key, required this.onShowBibleVerseChange});

  @override
  State<BibleChapter> createState() => _BibleChapterState();
}

class _BibleChapterState extends State<BibleChapter> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 2.0,
        children: [
          for (var i = 1; i < 10; i++)
            Container(
              color: Color(0xFF8E9B6D),
              child: GridTile(
                child: InkWell(
                  onTap: () {
                    widget.onShowBibleVerseChange(true);
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
