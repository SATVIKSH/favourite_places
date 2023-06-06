import 'dart:io';
import 'package:favourite_places/favourite_location_model.dart';
import 'package:favourite_places/providers/location_provider.dart';
import 'package:favourite_places/widgets/add_image.dart';
import 'package:favourite_places/widgets/get_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddLocationScreen extends ConsumerStatefulWidget {
  const AddLocationScreen({super.key});

  @override
  ConsumerState<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends ConsumerState<AddLocationScreen> {
  final formKey = GlobalKey<FormState>();
  File? imageFile;
  String title = '';
  void addLocation() {
    if (imageFile == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Select Image!'),
        duration: Duration(seconds: 1),
      ));
      return;
    }
    if (formKey.currentState!.validate() && imageFile != null) {
      formKey.currentState!.save();
      ref
          .read(locationProvider.notifier)
          .addLocation(FavouriteLocation(title: title, image: imageFile!));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                    label: Text(
                      'Title',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  onSaved: (newValue) {
                    title = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                AddImage(
                  getImage: (image) {
                    imageFile = image;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                const GetLocation(),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      addLocation();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Place'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
