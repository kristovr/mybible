// Creates a model for the BookChapter Database table

class BookChapter {
  final int id;
  final int bookId;
  final int chapters;

  const BookChapter({
    required this.id,
    required this.bookId,
    required this.chapters,
  });
}
