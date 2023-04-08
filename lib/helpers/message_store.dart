import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:use/models/message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

enum DBTables { messages }

class MessageDatabase with ChangeNotifier {
  // Properties

  static final MessageDatabase instance = MessageDatabase._init();

  static Database? _database;

  MessageDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('messages.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE messages (
      ${MessageFields.id} $idType, 
      ${MessageFields.model} $textType,
      ${MessageFields.message} $textType,
      ${MessageFields.isGPT} $boolType,
      ${MessageFields.showPremiumTag} $boolType,
      ${MessageFields.createdAt} $textType
    )
    ''');
  }

  Future<Message> create(Message message) async {
    final db = await instance.database;

    final id = await db.insert('messages', message.toJson());

    final messages = await readAllMessages();

    return message.copy(id: id);
  }

  Future<Message> readMessage(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'messages',
      columns: MessageFields.values,
      where: '${MessageFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Message.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Message>> readAllMessages() async {
    final database = await instance.database;

    final orderBy = '${MessageFields.createdAt} ASC';
    final result = await database.query('messages', orderBy: orderBy);

    return result.map((json) => Message.fromJson(json)).toList();
  }

  Future<int> update(Message message) async {
    final database = await instance.database;

    return database.update('messages', message.toJson(),
        where: '${MessageFields.id} = ?', whereArgs: [message.id]);
  }

  Future<int> delete(int id) async {
    final database = await instance.database;

    return await database
        .delete('messages', where: '${MessageFields.id} = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final database = await instance.database;
    await database.close();
  }
}
