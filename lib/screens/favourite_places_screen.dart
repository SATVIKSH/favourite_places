import 'package:favourite_places/models/favourite_location_model.dart';
import 'package:favourite_places/providers/location_provider.dart';
import 'package:favourite_places/screens/add_location_screen.dart';
import 'package:favourite_places/screens/locationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritePlacesScreen extends ConsumerStatefulWidget {
  const FavouritePlacesScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FavouritePlacesScreen();
  }
}

class _FavouritePlacesScreen extends ConsumerState<FavouritePlacesScreen> {
  late Future<void> loadData;
  void changeScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const AddLocationScreen();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData = ref.read(locationProvider.notifier).loadData();
  }

  void locationScreen(BuildContext context, FavouriteLocation location) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return LocationScreen(location: location);
    }));
  }

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: Colors.transparent,
                  ),
                ),
                title: Text(locations[index].title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground)),
                subtitle: Text(locations[index].location.name,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground)),
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
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return content;
            }
          }),
    );
  }
}
