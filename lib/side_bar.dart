import 'package:flutter/material.dart';
import 'package:mybible/bible_books.dart';
import 'package:mybible/bible_chapter.dart';
import 'package:mybible/bible_verse.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool showBibleChapter = false;
  bool showBibleVerse = false;
  bool showBackButton = false;

  /* Need to pass the book id that was selected to the bible chapter widget */

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
                        onShowBibleVerseChange: (value) {
                          setState(() {
                            showBibleChapter = !value;
                            showBackButton = value;
                            showBibleVerse = value;
                          });
                        },
                      )
                      : showBibleVerse
                      ? BibleVerse()
                      : BibleBooks(
                        showBibleChapter: showBibleChapter,
                        onShowBibleChapterChange: (value) {
                          setState(() {
                            showBibleChapter = value;
                            showBackButton = value;
                            showBibleVerse = !value;
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
