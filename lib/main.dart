import 'package:flutter/material.dart';
import 'package:mybible/data/bible_books.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyBible(),
      theme: ThemeData(fontFamily: 'Merriweather'),
    );
  }
}

class MyBible extends StatefulWidget {
  const MyBible({super.key});

  @override
  State<StatefulWidget> createState() => _MyBibleState();
}

class _MyBibleState extends State<MyBible> {
  bool showBibleChapter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFF5F2EA)),
      backgroundColor: Color(0xFFF5F2EA),
      body: Center(child: Text("Hello World")),
      drawer: Drawer(
        backgroundColor: Color(0xFFF5F2EA),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 120,
              child: const DrawerHeader(
                child: Text(
                  "Bible",
                  style: TextStyle(fontFamily: 'MerriweatherSans'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child:
                    showBibleChapter
                        ? BibleChapter(
                          onBack: () {
                            setState(() {
                              showBibleChapter = false;
                            });
                          },
                        )
                        : BibleBooks(
                          showBibleChapter: showBibleChapter,
                          onShowBibleChapterChange: (value) {
                            setState(() {
                              showBibleChapter = value;
                            });
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class BibleChapter extends StatelessWidget {
  final VoidCallback onBack;
  const BibleChapter({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("New Screen"),
          ElevatedButton(onPressed: onBack, child: Text("Back")),
        ],
      ),
    );
  }
}
