import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makati_admin/models/service_location.dart';
import 'package:makati_admin/screens/service_locations.dart';

import '../models/country_model.dart';

class LocationList extends StatefulWidget {
  const LocationList({Key? key}) : super(key: key);

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  List<ServiceLocations> countryList = [];
  List<DataRow> widgetList = [];
  void getData() async {
    countryList.clear();
    //use a Async-await function to get the data
    final data = await FirebaseFirestore.instance
        .collection("locations")
        .snapshots()
        .forEach((element) async {
      for (var e in element.docs) {
        int i = 0;
        String country = "";
        print('adding ${e.data()}');
        ServiceLocations model = ServiceLocations.fromJson(e.data());
        print('country id ${model.country.trim()}');
        var d = await FirebaseFirestore.instance
            .collection("Country")
            .doc(model.country.trim())
            .get();

        print(d);
        CountryModel m =
            CountryModel.fromJson(d.data() as Map<String, dynamic>);
        countryList.add(model);
        print(countryList.length);
        setState(() {
          widgetList = countryList
              .map((e) => DataRow(cells: [
                    DataCell(Text('${i = i + 1}')),
                    DataCell(Text(m.name)),
                    DataCell(Text(e.location)),
                  ]))
              .toList();
        });
      }
    });
    //get the data
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ServiceLocationsAdd()));
          },
          child: const Icon(Icons.add),
        ),
        body: widgetList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      'Service Location List',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                DataTable(columns: const [
                  DataColumn(
                      label: Text('SlNo',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Country Name',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Location Name',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ], rows: widgetList),
              ]));
  }
}
