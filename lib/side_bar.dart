import 'package:flutter/material.dart';
import 'package:mybible/bible_books.dart';
import 'package:mybible/bible_chapter.dart';
import 'package:mybible/bible_verse.dart';

class SideBar extends StatefulWidget {
  // all state is lifted up to my_bible
  final int? selectedBookId;
  final int? selectedChapter;
  final int? selectedVerse;
  final ValueChanged<int> onBookIdSelected;
  final ValueChanged<int> onChapterSelected;
  final ValueChanged<int> onVerseSelected;
  final Function onLoadChapterScripture;

  const SideBar({
    super.key,
    required this.selectedBookId,
    required this.selectedChapter,
    required this.selectedVerse,
    required this.onBookIdSelected,
    required this.onChapterSelected,
    required this.onVerseSelected,
    required this.onLoadChapterScripture,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool showBibleChapter = false;
  bool showBibleVerse = false;
  bool showBackButton = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF5F2EA),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 120,
            child: DrawerHeader(
              // showing the back button and different headers
              child: Row(
                children: [
                  if (showBackButton)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (showBibleVerse) {
                            // show the chapter screen
                            // back button will still be true
                            showBibleVerse = false;
                            showBibleChapter = true;
                          } else {
                            // show the books of the bible
                            showBibleChapter = false;
                            showBackButton = false;
                          }
                        });
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  Text(
                    showBibleChapter
                        ? "Select Chapter"
                        : showBibleVerse
                        ? "Select Verse"
                        : "Bible",
                    style: TextStyle(fontFamily: 'MerriweatherSans'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child:
                  showBibleChapter
                      ? BibleChapter(
                        onChapterSelected: (chapter) {
                          widget.onChapterSelected(
                            chapter,
                          ); // passing the chapter from bible chapter widget
                        },
                        bookId:
                            widget
                                .selectedBookId!, // passing the book id to the bible chapter
                        onShowBibleVerseChange: (value) {
                          setState(() {
                            showBibleChapter = !value;
                            showBackButton = value;
                            showBibleVerse = value;
                          });
                        },
                      )
                      : showBibleVerse
                      ? BibleVerse(
                        bookId: widget.selectedBookId,
                        chapterNum: widget.selectedChapter,
                        // lift state up to my_bible
                        onLoadChapterScripture: widget.onLoadChapterScripture,
                        onVerseSelected: (verse) {
                          setState(() {
                            widget.onVerseSelected(verse);
                          });
                        },
                      )
                      : BibleBooks(
                        showBibleChapter: showBibleChapter,
                        onShowBibleChapterChange: (value) {
                          setState(() {
                            showBibleChapter = value;
                            showBackButton = value;
                            showBibleVerse = !value;
                          });
                        },
                        onBookIdSelected: (id) {
                          setState(() {
                            // setting the id based on the callback
                            widget.onBookIdSelected(id);
                          });
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
