import 'package:flutter/material.dart';
import 'package:mybible/models/book.dart';
import 'package:mybible/data/db_conn.dart';

class BibleBooks extends StatefulWidget {
  final bool showBibleChapter;
  final ValueChanged<bool> onShowBibleChapterChange;
  final ValueChanged<int>
  onBookIdSelected; // callback to update the id of the book selected

  const BibleBooks({
    super.key,
    required this.showBibleChapter,
    required this.onShowBibleChapterChange,
    required this.onBookIdSelected,
  });

  @override
  State<BibleBooks> createState() => _BibleBooksState();
}

class _BibleBooksState extends State<BibleBooks> {
  late Future<List<Book>> biblebooks;

  @override
  void initState() {
    super.initState();
    biblebooks = loadBooks();
  }

  Future<List<Book>> loadBooks() async {
    final db = await openBibleDatabase();

    final List<Map<String, Object?>> bookMaps = await db.query(
      'tbl_book',
    ); // returns the entire table

    db.close();

    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'abbr': abbr as String,
          }
          in bookMaps)
        Book(id: id, name: name, abbr: abbr),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: biblebooks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No books found'));
        } else {
          final booksList = snapshot.data!;
          return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
            childAspectRatio: 1.5,
            children:
                booksList.map((book) {
                  return GridTile(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.onShowBibleChapterChange(true);
                          widget.onBookIdSelected(book.id); // pass the id
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
                }).toList(),
          );
        }
      },
    );
  }
}
