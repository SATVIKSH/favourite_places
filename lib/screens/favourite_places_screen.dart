import 'package:favourite_places/favourite_location_model.dart';
import 'package:favourite_places/providers/location_provider.dart';
import 'package:favourite_places/screens/add_location_screen.dart';
import 'package:favourite_places/screens/locationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritePlacesScreen extends ConsumerWidget {
  void changeScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const AddLocationScreen();
        },
      ),
    );
  }

  void locationScreen(BuildContext context, FavouriteLocation location) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return LocationScreen(location: location);
    }));
  }

  const FavouritePlacesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locations = ref.watch(locationProvider);
    Widget content = Center(
      child: Text(
        'No places added yet!',
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
    if (locations.isNotEmpty) {
      content = ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                locationScreen(context, locations[index]);
              },
              child: ListTile(
                leading: Hero(
                  tag: locations[index].image,
                  child: CircleAvatar(
                    radius: 26,
                    backgroundImage: FileImage(locations[index].image),
                  ),
                ),
                title: Text(
                  locations[index].title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ),
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              changeScreen(context);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
