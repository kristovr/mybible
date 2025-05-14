class BibleBook {
  final int id;
  final String name;
  final String abbr;

  BibleBook({required this.id, required this.name, required this.abbr});

  static final List<BibleBook> bibleBooks = [
    BibleBook(id: 1, name: "Genesis", abbr: "GEN"),
    BibleBook(id: 2, name: "Exodus", abbr: "EXO"),
    BibleBook(id: 3, name: "Leviticus", abbr: "LEV"),
    BibleBook(id: 4, name: "Numbers", abbr: "NUM"),
    BibleBook(id: 4, name: "Numbers", abbr: "DEU"),
    BibleBook(id: 4, name: "Numbers", abbr: "JOS"),
    BibleBook(id: 4, name: "Numbers", abbr: "JUG"),
    BibleBook(id: 4, name: "Numbers", abbr: "RTH"),
    BibleBook(id: 4, name: "Numbers", abbr: "1SA"),
    BibleBook(id: 4, name: "Numbers", abbr: "2SA"),
  ];
}
