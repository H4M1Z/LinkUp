import 'dart:developer';

import 'package:gossip_go/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static DBHelper? _object;
  static Database? _db;
  static const _dbName = 'Users database';
  static const _dbVersion = 6;
  DBHelper._();

  factory DBHelper() => _object ??= DBHelper._();

  Future<Database> get _database async => _db ??= await openDatabase(
        join(
          await getDatabasesPath(),
          _dbName,
        ),
        onCreate: (db, version) {
          db.execute(UserModel.createTable).then(
                (value) => log('table created'),
              );
        },
        onUpgrade: (db, oldVersion, newVersion) {
          if (oldVersion != newVersion) {
            db.execute(UserModel.dropTable).then(
                  (value) => log('table dropped'),
                );
            db.execute(UserModel.createTable).then(
                  (value) => log('new table created'),
                );
          }
        },
        version: _dbVersion,
      );

  Future<bool> insertUsers(List<UserModel> users) async {
    var db = await _database;
    db.getVersion().then(
          (value) => log('db version in insert : $value'),
        );
    int rowAffectedNumber = 0;
    try {
      for (var i = 0; i < users.length; i++) {
        rowAffectedNumber =
            await db.insert(UserModel.tableName, users[i].toLocalDbMap());
      }
    } catch (e) {
      log(e.toString());
    }
    return rowAffectedNumber > 0;
  }

  Future<List<UserModel>> getAppUsers() async {
    var db = await _database;
    db.getVersion().then(
          (value) => log('db version in fetch : $value'),
        );
    var appUsers = await db.query(UserModel.tableName);
    return appUsers
        .map(
          (map) => UserModel.fromLocalDbMap(map),
        )
        .toList();
  }

  Future<bool> clearTable() async {
    var db = await _database;
    var appUsers = await getAppUsers();
    int rowAffectedNumber = 0;
    for (var i = 0; i < appUsers.length; i++) {
      rowAffectedNumber = await db.delete(UserModel.tableName,
          where: '${UserModel.coluid}= ?', whereArgs: [appUsers[i].uid]);
    }
    return rowAffectedNumber <= 0;
  }
}
