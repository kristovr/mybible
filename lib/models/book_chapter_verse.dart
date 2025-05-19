// Creates a model for the BookChapterVerse Database table

class BookChapterVerse {
  final int id;
  final int bookId;
  final int chapter;
  final int verses;

  const BookChapterVerse({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.verses,
  });
}
