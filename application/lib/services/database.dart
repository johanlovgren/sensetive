import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:sensetive/models/reading_models.dart';

/// File routines used for persistent storage
class DatabaseFileRoutines {
  final String uid;

  DatabaseFileRoutines({@required this.uid});

  /// Get the local path to persistent storage
  Future <String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  /// Get the local file containing the stored data
  Future<File> get _localReadingsFile async {
    final path = await _localPath;
    return File('$path/$uid.readings.json');
  }

  /// Get local file containing stored user data
  Future<File> get _localUserFile async {
    final path = await _localPath;
    return File('$path/$uid.user.json');
  }

  void writeProfilePicture(File picture) async {
    final path = await _localPath;
    picture.copy('$path/$uid.png');
  }

  Future<File> readProfilePicture() async {
    // TODO Continue here
  }

  Future<bool> deleteAllData() async {
    throw Exception('Database delete account not implemented');
  }

  /// Get stored user data as JSON
  Future<String> readUserData() async{
    try {
      final file = await _localUserFile;
      if (!file.existsSync()) {
        print('File does not exist: ${file.absolute}');
        await writeUserData('{"name": "","email":"", "profilePicturePath":""}');
      }

      return await file.readAsString();
    } catch (e) {
      print('error readUserData: $e');
      return '';
    }
  }
  /// Write user data to persistent storage
  ///
  /// [json] userdata in JSON format
  Future<File> writeUserData(String json) async {
    final file = await _localUserFile;
    return file.writeAsString('$json');
  }



  /// Get stored readings ([Reading]) as JSON
  Future<String> readReadings() async {
    try {
      final file = await _localReadingsFile;
      if (!file.existsSync()) {
        print('File does not exist: ${file.absolute}');
        await writeReadings('{"readings": []}');
      }

      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print('error readReadings: $e');
      return '';
    }
  }

  /// Write readings ([Reading])to persistent storage
  ///
  /// [json] Readings in JSON format
  Future<File> writeReadings(String json) async{
    final file = await _localReadingsFile;
    return file.writeAsString('$json');
  }
}

/// Create a [ReadingsDatabase] from a JSON
ReadingsDatabase readingsDatabaseFromJson(jsonString) =>
    ReadingsDatabase.fromJson(json.decode(jsonString));

/// Create a [UserDatabase] from JSON
UserDatabase userDatabaseFromJson(jsonString) =>
    UserDatabase.fromJson(json.decode(jsonString));


/// Create a JSON from a [ReadingsDatabase]
String databaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

abstract class Database {
  Map<String, dynamic> toJson();
}

class UserDatabase extends Database {
  String name;
  String email;
  String profilePicturePath;
  UserDatabase({this.name, this.email, this.profilePicturePath});

  factory UserDatabase.fromJson(Map<String, dynamic> json) =>
      UserDatabase(
        name: json['name'],
        email: json['email'],
        profilePicturePath: json['profilePicturePath']
      );

  /// Returns the database as JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'profilePicturePath': profilePicturePath
  };
}


/// Database containing data to be stored in persistent storage
class ReadingsDatabase extends Database {
  List<Reading> readings;
  ReadingsDatabase({this.readings});

  factory ReadingsDatabase.fromJson(Map<String, dynamic> json) =>
      ReadingsDatabase(
          readings: List<Reading>.from(json["readings"].map((x) => Reading.fromJson(x)))
      );

  /// Returns the database as JSON
  Map<String, dynamic> toJson() => {
    "readings": List<dynamic>.from(readings.map((x) => x.toJson()))
  };
}