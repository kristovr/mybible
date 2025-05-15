import 'package:flutter/material.dart';
import 'package:mybible/data/bible_books.dart';

class BibleBooks extends StatefulWidget {
  final bool showBibleChapter;
  final ValueChanged<bool> onShowBibleChapterChange;

  const BibleBooks({
    super.key,
    required this.showBibleChapter,
    required this.onShowBibleChapterChange,
  });

  @override
  State<BibleBooks> createState() => _BibleBooksState();
}

class _BibleBooksState extends State<BibleBooks> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: 2.0,
      children: [
        ...BibleBook.bibleBooks.map((book) {
          return GridTile(
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.onShowBibleChapterChange(true);
                  print(book.abbr);
                });
              },
              child: Container(
                color: Color(0xFF8E9B6D),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      book.abbr,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MerriweatherSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
