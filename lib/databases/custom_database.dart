import 'dart:convert';

import 'package:agendamento_covid19/failures/cpf_failures.dart';
import 'package:agendamento_covid19/failures/database_failures.dart';
import 'package:agendamento_covid19/failures/failure.dart';
import 'package:agendamento_covid19/failures/gender_failures.dart';
import 'package:agendamento_covid19/failures/schedule_failure.dart';
import 'package:agendamento_covid19/models/schedule.dart';
import 'package:agendamento_covid19/models/user.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CustomDatabase {
  static final CustomDatabase instance = CustomDatabase._init();

  static Database? _database;

  CustomDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filePath);

    print('DEBUG: ABRINDO BANCO DE DADOS...');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // ======================================================================
  // FUNÇÕES DE DEBUG

  // void getAllUsers() async {
  //   final db = await instance.database;
  //   try {
  //     var allUsers = await db.rawQuery('''SELECT * FROM users''');

  //     print(allUsers[allUsers.length - 1]);
  //     print(allUsers[allUsers.length - 2]);
  //   } catch (e) {}
  // }

  // void deleteUsersTable() async {
  //   final db = await instance.database;
  //   print('DEBUG: DELETANDO TABELA users...');
  //   await db.execute('''DROP TABLE IF EXISTS users''');
  // }

  // void createUsersTable() async {
  //   final db = await instance.database;
  //   print('DEBUG: CRIANDO TABELA users...');
  //   await db.execute('''
  //   CREATE TABLE IF NOT EXISTS users (
  //     cpf TEXT PRIMARY KEY,
  //     age INTEGER NOT NULL,
  //     gender TEXT NOT NULL,
  //     name TEXT NOT NULL,
  //     password TEXT NOT NULL,
  //     email TEXT,
  //     phone TEXT
  //   );
  //   ''');
  // }

  // void getAllSchedules() async {
  //   final db = await instance.database;
  //   try {
  //     print(await db.rawQuery('''SELECT * FROM schedules'''));
  //   } catch (e) {}
  // }

  // void deleteSchedulesTable() async {
  //   final db = await instance.database;
  //   print('DEBUG: DELETANDO TABELA schedules...');
  //   await db.execute('''DROP TABLE IF EXISTS schedules''');
  // }

  // void createSchedulesTable() async {
  //   final db = await instance.database;
  //   print('DEBUG: CRIANDO TABELA schedules...');
  //   await db.execute('''
  //   CREATE TABLE IF NOT EXISTS schedules (
  //       _id INTEGER PRIMARY KEY,
  //       user_cpf TEXT NOT NULL,
  //       cep TEXT NOT NULL,
  //       st INTEGER NOT NULL,
  //       sd TEXT NOT NULL,
  //       FOREIGN KEY (user_cpf) REFERENCES users(cpf) ON DELETE SET NULL
  //   );
  //   ''');
  // }

  // END DEBUG FUNCTIONS
  // ========================================================

  Future _createDB(Database db, int version) async {
    print('DEBUG: CRIANDO BANCO DE DADOS...');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      cpf TEXT PRIMARY KEY,
      age INTEGER NOT NULL,
      gender TEXT NOT NULL,
      name TEXT NOT NULL,
      password TEXT NOT NULL,
      email TEXT,
      phone TEXT
    );
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS schedules (
        _id INTEGER PRIMARY KEY,
        user_cpf TEXT NOT NULL,
        cep TEXT NOT NULL,
        st INTEGER NOT NULL,
        sd TEXT NOT NULL,
        FOREIGN KEY (user_cpf) REFERENCES users(cpf) ON DELETE SET NULL
    );
    ''');
  }

  Future<Failure?> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;

    if (user['gender'] == null || user['gender'] == '')
      return EmptyGenderFailure();

    var copied = Map<String, dynamic>.from(user);

    var bytes = utf8.encode(copied['password']);
    var digest = sha1.convert(bytes);

    copied['password'] = digest.toString();

    try {
      await db.insert('users', copied);
    } catch (error) {
      return DuplicateCPFFailure();
    }
  }

  Future<Failure?> insertSchedule(Map<String, dynamic> schedule) async {
    final db = await instance.database;

    try {
      var result = await db.rawQuery('''
      SELECT _id from schedules
      WHERE cep = "${schedule['cep']}" AND sd = "${schedule['sd']}" AND st = ${schedule['st']};
      ''');

      if (result.isNotEmpty) return ScheduleConflictFailure();
    } catch (e) {
      print(e);
    }

    try {
      await db.rawQuery('''
      INSERT INTO schedules (user_cpf, cep, st, sd)
      VALUES ("${schedule['user_cpf']}", "${schedule['cep']}", ${schedule['st']}, "${schedule['sd']}");
      ''');
      print('DEBUG: AGENDAMENTO CONCLUÍDO!');
    } catch (error) {
      print(error);
      return DuplicateCPFFailure();
    }
  }

  void delete(int id) async {
    final db = await instance.database;

    try {
      await db.rawQuery('''
      DELETE FROM schedules WHERE _id = $id;
      ''');
    } catch (e) {}
  }

  Future<Failure?> updateUser(Map<String, dynamic> user) async {
    final db = await instance.database;

    try {
      String complement = '';

      if (!user.containsKey('email') || user['email'] == '')
        complement += ', email=NULL';
      else
        complement += ', email="${user["email"]}"';

      if (!user.containsKey('phone') || user['phone'] == '')
        complement += ', phone=NULL';
      else
        complement += ', phone="${user["phone"]}"';

      await db.rawQuery('''
      UPDATE users
      SET name="${user['name']}", age=${user['age']}, gender="${user['gender']}"${complement}
      WHERE cpf = ${user['cpf']};
      ''');

      // getAllUsers();

      // await db.update('users', user, where: 'cpf = ?', whereArgs: user['cpf']);
      // '''
      // UPDATE users
      // SET name=${user['name']}, age=${user['age']}, gender=${user['gender']}
      // WHERE cpf = ${user['cpf']};
      // '''
    } catch (e) {}
  }

  Future<Either<User, Failure>> retrieveUser(String cpf) async {
    final db = await instance.database;

    // print(await db.rawQuery('SELECT * FROM users'));

    final result = await db.rawQuery('''
    SELECT cpf, age, gender, name, email, phone
    FROM users
    WHERE users.cpf = "$cpf";
    ''');

    if (result.isEmpty)
      return Right(CPFNotFoundFailure());
    else
      return Left(User.fromJson(result[0]));
  }

  Future<List<Schedule>> retrieveSchedules(String cpf) async {
    final db = await instance.database;

    List<Schedule> schedules = [];

    final result = await db.rawQuery('''
    SELECT *
    FROM schedules
    WHERE user_cpf = "$cpf";
    ''');

    result.forEach((element) => schedules.add(Schedule.fromJson(element)));
    return schedules;
  }

  Future<Either<String, Failure>> retrievePassword(String cpf) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT password FROM users WHERE users.cpf = "$cpf";
    ''');

    if (result.isEmpty)
      return Right(CPFNotFoundFailure());
    else
      return Left(result[0]['password'].toString());
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
