import 'package:favourite_places/models/favourite_location_model.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, required this.location});
  final FavouriteLocation location;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location')),
      body: Image.network(
        'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=${location.location.longitude},${location.location.latitude}&size=650,450&z=17&l=map&pt=${location.location.longitude},${location.location.latitude},pm2rdl',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
