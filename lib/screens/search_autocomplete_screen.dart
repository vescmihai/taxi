import 'package:uagrm_app/screens/drive_screen.dart';
import 'package:uagrm_app/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchAutoCompleteScreen extends StatefulWidget {
  final TextEditingController controller;
  SearchAutoCompleteScreen(this.controller);

  _SearchAutoCompleteScreenState createState() =>
      _SearchAutoCompleteScreenState();
}

class _SearchAutoCompleteScreenState extends State<SearchAutoCompleteScreen> {
  int searchResultsLength = 0;
  List<dynamic> searchResultsList = [];

  void setSearchResults(String value) async {
    var results = await LocationService().getSearchResults(value);
    setState(() {
      searchResultsLength = results["length"];
      searchResultsList = results["results"];
    });
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF1522),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              controller: widget.controller,
              onChanged: (value) {
                setSearchResults(value);
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      widget.controller.clear();
                      setSearchResults(widget.controller.value.text);
                    },
                  ),
                  hintText: 'Buscar',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: searchResultsLength + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index >= searchResultsLength || searchResultsLength == 0) {
              return Column(children: [
                searchResultsLength == 0
                    ? ListTile(
                        leading: Icon(
                          Icons.location_searching,
                          size: 30,
                        ),
                        title: Text('Ubicación actual'),
                        onTap: () async {
  // Solicita el permiso de ubicación
  PermissionStatus status = await Permission.location.request();

  if (status.isGranted) {
    try {
        Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

        List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

        Placemark place = placemarks[0];

        setState(() {
            widget.controller.text = '${place.locality}, ${place.country}';
            widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length)
            );
        });
        Navigator.of(context).pop();
    } catch (e) {
    }
}



                        })
                    : Container(),
              ]);
            } else {
              return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    size: 30,
                  ),
                  title: Text(
                      '${searchResultsList[index]["description"]} ${index}'),
                  onTap: () async {
                    setState(() {
                      widget.controller.text =
                          searchResultsList[index]["description"];

                      widget.controller.selection =
                          TextSelection.fromPosition(TextPosition(offset: 0));
                    });
                    Navigator.of(context).pop();
                  });
            }
          }),
    );
  }
}
