import 'package:flutter/material.dart';
import 'package:mybible/data/db_conn.dart';
import 'package:mybible/models/book_chapter.dart';

class BibleChapter extends StatefulWidget {
  // final VoidCallback onBack;
  final int bookId;
  final ValueChanged<bool> onShowBibleVerseChange;
  final ValueChanged<int> onChapterSelected;

  const BibleChapter({
    super.key,
    required this.onShowBibleVerseChange,
    required this.bookId,
    required this.onChapterSelected,
  });

  @override
  State<BibleChapter> createState() => _BibleChapterState();
}

class _BibleChapterState extends State<BibleChapter> {
  late Future<BookChapter> bookChapter;

  @override
  void initState() {
    super.initState();
    bookChapter = loadChapter();
  }

  Future<BookChapter> loadChapter() async {
    final db = await openBibleDatabase();
    final List<Map<String, Object?>> chapterMap = await db.query(
      'tbl_bookchapter',
      where: 'id = ?',
      whereArgs: [widget.bookId],
      limit: 1,
    );

    db.close();

    if (chapterMap.isNotEmpty) {
      final map = chapterMap.first;
      return BookChapter(
        id: map['id'] as int,
        bookId: map['book_id'] as int,
        chapters: map['chapters'] as int,
      );
    } else {
      return BookChapter(id: 0, bookId: 0, chapters: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookChapter>(
      future: bookChapter,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No chapter found'));
        } else {
          final bibleChapterRecord = snapshot.data!;
          return Center(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 2.0,
              children: [
                for (var i = 1; i <= bibleChapterRecord.chapters; i++)
                  Container(
                    color: Color(0xFF8E9B6D),
                    child: GridTile(
                      child: InkWell(
                        onTap: () {
                          widget.onShowBibleVerseChange(true);
                          widget.onChapterSelected(i);
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
