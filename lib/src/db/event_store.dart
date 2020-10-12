import 'package:background_blue/src/db/db.dart';
import 'package:background_blue/src/models/evento-model.dart';
import 'package:sembast/sembast.dart';

class EventStore {
  EventStore._internal();

  static EventStore _instance = EventStore._internal();
  static EventStore get instance => _instance;

  final Database _db = DB.instance.database;
  final StoreRef<String, Map> _store = StoreRef<String, Map>('empleado');

  Future<List<Evento>> getData() async {
    final snapshots = await _store.find(_db);
    print(snapshots);

    List<Evento> result = [];
    snapshots.map((e) {
      return Evento.fromJson(e.value);
    }).toList();

    print('[EVENTO_STORE] GetWeek List -> $result ');
    return result;
  }

  Future<void> add(Evento evento) async {
    final data = evento.toJson();
    return await _store.add(_db, data);
  }
}
