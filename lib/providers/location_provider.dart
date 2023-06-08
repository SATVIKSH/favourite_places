import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/models/favourite_location_model.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class LocationNotifier extends StateNotifier<List<FavouriteLocation>> {
  LocationNotifier() : super([]);
  Future<Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT , image TEXT, location_name TEXT,lat REAL, long REAL)');
    }, version: 1);
    return db;
  }

  Future<void> loadData() async {
    final db = await getDatabase();
    final data = await db.query('user_places');
    final listData = data
        .map((row) => FavouriteLocation(
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: CurrentLocation(
                name: row['location_name'] as String,
                latitude: row['lat'] as double,
                longitude: row['long'] as double)))
        .toList();
    state = listData;
  }

  void addLocation(FavouriteLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(location.image.path);
    location.image = await location.image.copy('${appDir.path}/$fileName');
    final db = await getDatabase();
    await db.insert('user_places', {
      'id': location.id,
      'title': location.title,
      'image': location.image.path,
      'location_name': location.location.name,
      'lat': location.location.latitude,
      'long': location.location.longitude
    });

    state = [location, ...state];
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, List<FavouriteLocation>>(
        (ref) => LocationNotifier());
