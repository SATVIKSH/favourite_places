import 'dart:io';

import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class FavouriteLocation {
  FavouriteLocation({required this.title, required this.image})
      : id = uuid.v4();
  String? id;
  final String title;
  final File image;
}
