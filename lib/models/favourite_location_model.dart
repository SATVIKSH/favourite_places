import 'dart:io';

import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class CurrentLocation {
  CurrentLocation(
      {required this.name, required this.latitude, required this.longitude});
  final String name;
  final double latitude;
  final double longitude;
}

class FavouriteLocation {
  FavouriteLocation(
      {id, required this.title, required this.image, required this.location})
      : id = id ?? uuid.v4();
  String? id;
  final String title;
  File image;
  final CurrentLocation location;
}
