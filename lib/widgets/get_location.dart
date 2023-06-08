import 'dart:convert';

import 'package:favourite_places/models/favourite_location_model.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class GetLocation extends StatefulWidget {
  const GetLocation({super.key, required this.getLocation});
  final void Function(CurrentLocation) getLocation;
  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  ImageProvider? image;
  bool isLoading = false;
  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isLoading = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;
    final url = Uri.parse(
        'https://geocode-maps.yandex.ru/1.x?format=json&lang=en_US&geocode=$long,$lat&apikey=28b45cc2-91e3-4683-b8c6-491e47f95776');
    final response = await http.get(url);
    final Map<String, dynamic> resData = jsonDecode(response.body);

    final imgResponse = NetworkImage(
        'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=$long,$lat&size=650,450&z=17&l=map&pt=$long,$lat,pm2rdl');
    setState(() {
      isLoading = false;
      image = imgResponse;
    });
    // print(resData.entries);
    // print(resData['response']['GeoObjectCollection']['featureMember'][0]
    //         ['GeoObject']['metaDataProperty']['GeocoderMetaData']['Address']
    //     ['formatted']);

    widget.getLocation(CurrentLocation(
        name: resData['response']['GeoObjectCollection']['featureMember'][0]
                ['GeoObject']['metaDataProperty']['GeocoderMetaData']['Address']
            ['formatted'],
        latitude: lat!,
        longitude: long!));
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'Choose a Location!',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (isLoading == true) {
      previewContent = const CircularProgressIndicator();
    }
    if (image != null && isLoading == false) {
      previewContent = Image(
        image: image!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 170,
          decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: getCurrentLocation,
              icon: const Icon(Icons.location_on),
              color: Theme.of(context).colorScheme.onBackground,
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Center(child: Text('Not implemented yet!')),
                  duration: Duration(seconds: 2),
                ));
              },
              icon: const Icon(Icons.map),
              color: Theme.of(context).colorScheme.onBackground,
            )
          ],
        ),
      ],
    );
  }
}
