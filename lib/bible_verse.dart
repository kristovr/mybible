import 'package:flutter/material.dart';
import 'package:mybible/data/db_conn.dart';
import 'package:mybible/models/book_chapter_verse.dart';

class BibleVerse extends StatefulWidget {
  final int? bookId;
  final int? chapterNum;
  final ValueChanged<int> onVerseSelected;
  final Function onLoadChapterScripture;

  const BibleVerse({
    super.key,
    required this.bookId,
    required this.chapterNum,
    required this.onVerseSelected,
    required this.onLoadChapterScripture,
  });

  @override
  State<BibleVerse> createState() => _BibleVerseState();
}

class _BibleVerseState extends State<BibleVerse> {
  late Future<BookChapterVerse> bookChapterVerse;
  @override
  void initState() {
    super.initState();
    bookChapterVerse = loadBookChapterVerse();
  }

  Future<BookChapterVerse> loadBookChapterVerse() async {
    final db = await openBibleDatabase();
    final List<Map<String, Object?>> chapterVerseMap = await db.query(
      'tbl_bookchapterverse',
      where: 'book_id = ? and chapter = ?',
      whereArgs: [widget.bookId, widget.chapterNum],
      limit: 1,
    );

    db.close();

    if (chapterVerseMap.isNotEmpty) {
      final map = chapterVerseMap.first;
      return BookChapterVerse(
        id: map['id'] as int,
        bookId: map['book_id'] as int,
        chapter: map['chapter'] as int,
        verses: map['verses'] as int,
      );
    } else {
      return BookChapterVerse(id: 0, bookId: 0, chapter: 0, verses: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookChapterVerse>(
      future: bookChapterVerse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No verses found'));
        } else {
          final bibleChapterVerseRecord = snapshot.data!;
          return Center(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 2.0,
              children: [
                for (var i = 1; i <= bibleChapterVerseRecord.verses; i++)
                  Container(
                    color: Color(0xFF8E9B6D),
                    child: GridTile(
                      child: InkWell(
                        onTap: () {
                          widget.onVerseSelected(i);
                          // send a callback to run the future builder
                          widget.onLoadChapterScripture();
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
      },
    );
  }
}
