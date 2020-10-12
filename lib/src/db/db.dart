import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DB {
  DB._internal();
  static DB _instance = DB._internal();
  static DB get instance => _instance;

  Database _database;
  Database get database => _database;

  Future<void> init() async {
    final String dbName = 'blue_events.db';
    final String dbDir = (await getApplicationDocumentsDirectory()).path;
    final String dbPath = join(dbDir, dbName);

    _database = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<void> close() async {
    await _database.close();
  }
}
