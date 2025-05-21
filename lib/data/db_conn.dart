import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

Future<Database> openBibleDatabase() async {
  final documentsDirectory =
      await getApplicationDocumentsDirectory(); // find the place where the databases are stored
  final dbPath = p.join(documentsDirectory.path, 'bible.db');

  if (!await File(dbPath).exists()) {
    // remove this when I have an updated Bible db
    ByteData data = await rootBundle.load('assets/bible.db');
    List<int> bytes = data.buffer.asInt8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await File(dbPath).writeAsBytes(bytes, flush: true);
  }

  return openDatabase(dbPath);
}
