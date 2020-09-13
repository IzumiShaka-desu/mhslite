import 'package:mhslite/model/login.dart';
import 'package:sqflite/sqflite.dart';
import '../model/mahasiswa.dart';

class DbHelper {
  Database db;

  Future openDb() async {
    var dbPath = await getDatabasesPath();
    db = await openDatabase(dbPath+"mhs.db", version: 1, onCreate: (db, version) async {
      db.execute('''
        CREATE table $TABLE_MHS_NAME (
       $COLLUMN_ID integer primary key autoincrement,
       $COLLUMN_NPM integer not null,
       $COLLUMN_NAME text not null,
       $COLLUMN_GENDER text not null,
       $COLLUMN_ADDRESS text not null,
       $COLLUMN_YEARIN integer not null
        )
        ''');
      db.execute('''
        CREATE table $TABLE_LOGIN_NAME (
       $COLLUMN_ID integer primary key autoincrement,
       $COLLUMN_EMAIL text not null,
       $COLLUMN_FULLNAME text not null,
       $COLLUMN_PASSWORD text not null
        )
        ''');
    });
  }

  Future<UserLogin> login(String email, String password) async {
    List<Map<String, dynamic>> listUsr = await db.rawQuery('''
        SELECT * from $TABLE_LOGIN_NAME
         where $COLLUMN_PASSWORD=\'$password\' AND
          $COLLUMN_EMAIL=\'$email\' 
          ''');
    if (listUsr.length > 0) {
      return UserLogin.fromMap(listUsr.first);
    }
    return null;
  }

  Future<int> register(String email, String password, String fullname) async {
    return await db.rawInsert('''
          INSERT INTO `userLogin` (`id`, `fullname`, `email`, `password`) 
        VALUES (NULL, '$fullname', '$email',  '$password')
      ''');
  }

  Future<List<Mahasiswa>> getListMahasiswa() async {
    List<Mahasiswa> list = [];
    List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM $TABLE_MHS_NAME');
    if (maps.length > 0) {
      maps.forEach((element) {
        list.add(Mahasiswa.fromMap(element));
      });
    }
    return list;
  }

  Future<Mahasiswa> getDetailMahasiswa(int id) async {
    List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM $TABLE_MHS_NAME WHERE $COLLUMN_ID = $id');
    if (maps.length > 0) {
      return Mahasiswa.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> deleteMahasiswa(int id) async {
    int result = await db.delete(TABLE_MHS_NAME,where:'$COLLUMN_ID = ?',whereArgs: [id]);
    if (result > 0) {
      return true;
    }
    return false;
  }

  Future<int> insert(Mahasiswa mhs) async =>
      await db.insert(TABLE_MHS_NAME, mhs.toMap());



  Future<int> update(Mahasiswa mhs) async => await db.update(TABLE_MHS_NAME, mhs.toMap(),
        where: '$COLLUMN_ID = ?', whereArgs: [mhs.id]);
  

  Future close() async => db.close();
}
