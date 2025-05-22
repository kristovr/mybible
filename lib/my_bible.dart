import 'package:flutter/material.dart';
import 'package:mybible/data/db_conn.dart';
import 'package:mybible/models/book_chapter.dart';
import 'package:mybible/side_bar.dart';
import 'package:mybible/models/bible.dart';
import 'package:mybible/models/book.dart';

class MyBible extends StatefulWidget {
  const MyBible({super.key});

  @override
  State<MyBible> createState() => _MyBibleState();
}

class _MyBibleState extends State<MyBible> {
  int selectedBookId = 1;
  int selectedChapter = 1;
  int? selectedVerse;

  late Future<List<Bible>> chapterScripture;
  late Future<Book> bookName;
  late Future<BookChapter> bookChapter;

  @override
  void initState() {
    super.initState();
    chapterScripture = _loadChapterScripture();
    bookName = _loadBookName();
    bookChapter = _loadBookChapter();
  }

  Future<List<Bible>> _loadChapterScripture() async {
    final db = await openBibleDatabase();
    try {
      final List<Map<String, Object?>> chapterScriptureMap = await db.query(
        'tbl_bible',
        where: 'book_id = ? and chapter = ?',
        whereArgs: [selectedBookId, selectedChapter],
      );

      return [
        for (final {
              'id': id as int,
              'book_id': bookId as int,
              'chapter': chapter as int,
              'verse': verse as int,
              'scripture': scripture as String,
            }
            in chapterScriptureMap)
          Bible(
            id: id,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            scripture: scripture,
          ),
      ];
    } catch (e) {
      rethrow;
    }
  }

  Future<BookChapter> _loadBookChapter() async {
    final db = await openBibleDatabase();

    try {
      final List<Map<String, Object?>> bookChapterMap = await db.query(
        'tbl_bookchapter',
        where: 'book_id = ?',
        whereArgs: [selectedBookId],
        limit: 1,
      );

      if (bookChapterMap.isNotEmpty) {
        final map = bookChapterMap.first;
        return BookChapter(
          id: map['id'] as int,
          bookId: map['book_id'] as int,
          chapters: map['chapters'] as int,
        );
      } else {
        return BookChapter(id: 0, bookId: 0, chapters: 0);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Book> _loadBookName() async {
    final db = await openBibleDatabase();

    try {
      final List<Map<String, Object?>> bookNameMap = await db.query(
        'tbl_book',
        where: 'id = ?',
        whereArgs: [selectedBookId],
        limit: 1,
      ); // returns the entire table

      if (bookNameMap.isNotEmpty) {
        final map = bookNameMap.first;
        return Book(
          id: map['id'] as int,
          name: map['name'] as String,
          abbr: map['abbr'] as String,
        );
      } else {
        return Book(id: 0, name: '', abbr: '');
      }
    } catch (e) {
      rethrow;
    }
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
    double bottomPoint = width * 0.1;

    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFF5F2EA)),
      backgroundColor: Color(0xFFF5F2EA),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: floatingLabelWidth / 2.8,
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: FutureBuilder<List<Bible>>(
                future: chapterScripture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data');
                  } else {
                    final chapterScriptureList = snapshot.data!;
                    return ListView(
                      children:
                          chapterScriptureList.map((scripture) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                "${scripture.verse} ${scripture.scripture}",
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
              child: FutureBuilder<Book>(
                future: bookName,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data');
                  } else {
                    final bookName = snapshot.data!;
                    return Text(
                      "${bookName.name} $selectedChapter",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'MerriweatherSans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            // LEFT
            bottom: bottomPoint * 0.7,
            left: 35,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: FutureBuilder<BookChapter>(
                future: bookChapter,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data');
                  } else {
                    final max = snapshot.data!;
                    return IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFF8E9B6D),
                      ),
                      color: Colors.white,
                      onPressed: () {
                        if (selectedChapter == 1 && selectedBookId == 1) {
                          // if its Genesis 1:1 - do nothing
                          return;
                        } else if (selectedChapter > 1 &&
                            selectedChapter <= max.chapters) {
                          /* if the current chapter is less than
                             or equal to the max chapters of the book */
                          setState(() {
                            selectedChapter -= 1;
                            chapterScripture = _loadChapterScripture();
                            bookName = _loadBookName();
                            bookChapter = _loadBookChapter();
                          });
                        } else if (selectedChapter == 1 && selectedBookId > 1) {
                          /* if the selected chapter is 1 and the selected book
                             is not genesis then reduce the bookId and set
                             selectedchapter to the max chapter of the book
                             before the current.
                          */
                          setState(() {
                            selectedBookId -= 1;
                            bookChapter = _loadBookChapter();
                            bookName = _loadBookName();
                            chapterScripture = _loadChapterScripture();
                            selectedChapter = max.chapters;
                          });
                        }
                      },
                      icon: Icon(Icons.chevron_left_rounded),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            // RIGHT
            bottom: bottomPoint * 0.7,
            right: 35,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: FutureBuilder<BookChapter>(
                future: bookChapter,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data');
                  } else {
                    final max = snapshot.data!;
                    return IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFF8E9B6D),
                      ),
                      color: Colors.white,
                      onPressed: () {
                        if (selectedChapter == max.chapters &&
                            selectedBookId == 66) {
                          // if its Revelations do nothing
                          return;
                        } else if (selectedChapter >= 1 &&
                            selectedChapter < max.chapters) {
                          /* if the current chapter is more than 1
                             and less than or equal to the max chapter */
                          setState(() {
                            selectedChapter += 1;
                            chapterScripture = _loadChapterScripture();
                            bookName = _loadBookName();
                            bookChapter = _loadBookChapter();
                          });
                        } else if (selectedChapter == max.chapters) {
                          /* if the selected chapter is maxxed out and the selected book
                             is not genesis then advance the bookId and set
                             selectedchapter to the first chapter of the next book
                          */
                          setState(() {
                            selectedBookId += 1;
                            selectedChapter = 1;
                            chapterScripture = _loadChapterScripture();
                            bookName = _loadBookName();
                            bookChapter = _loadBookChapter();
                          });
                        }
                      },
                      icon: Icon(Icons.chevron_right_rounded),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      drawer: SideBar(
        selectedBookId: selectedBookId,
        selectedChapter: selectedChapter,
        selectedVerse: selectedVerse,
        onBookIdSelected: (id) {
          setState(() {
            selectedBookId = id;
          });
        },
        onChapterSelected: (chapter) {
          setState(() {
            selectedChapter = chapter;
          });
        },
        onVerseSelected: (verse) {
          setState(() {
            selectedVerse = verse;
            Navigator.of(context).pop();
          });
        },
        /* When the verse is selected
        a callback function runs and this
        future builder is called */
        onLoadChapterScripture: () {
          chapterScripture = _loadChapterScripture();
          bookName = _loadBookName();
        },
      ),
    );
  }
}
