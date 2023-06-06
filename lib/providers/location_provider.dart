import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/favourite_location_model.dart';

class LocationNotifier extends StateNotifier<List<FavouriteLocation>> {
  LocationNotifier() : super([]);
  void addLocation(FavouriteLocation location) {
    state = [location, ...state];
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, List<FavouriteLocation>>(
        (ref) => LocationNotifier());
