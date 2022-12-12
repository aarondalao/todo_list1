import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

Future main() async {
  // setup
  setUpAll(() {
    // initialize FFI
    sqfliteFfiInit();

    // change default factory
    databaseFactory = databaseFactoryFfi;
  });

  test('test #1 test insertion', () async {
    print("test #1: insert data then verify the inserted data");

    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS todosTest (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, completed INTEGER)');
    });

    print("""
    inserting mock data 1:
      'name': "sampleName",
      'description': "sampleDescription",
      'completed': 0,

      note: id is auto incrementing
    """);

    // insert data
    await db.insert('todosTest', {
      'name': "sampleName",
      'description': "sampleDescription",
      'completed': 0,
    });

    // verify content
    expect(
        await db.query('todosTest'),
        [
          {
            "id": 1,
            'name': "sampleName",
            'description': "sampleDescription",
            'completed': 0,
          }
        ],
        reason: "the expected value should match the actual value");

    // close db
    await db.close();
  });
}
