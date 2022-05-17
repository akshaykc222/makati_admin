import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makati_admin/models/service_location.dart';

class ServiceLocationsAdd extends StatefulWidget {
  const ServiceLocationsAdd({Key? key}) : super(key: key);

  @override
  State<ServiceLocationsAdd> createState() => _ServiceLocationsAddState();
}

class _ServiceLocationsAddState extends State<ServiceLocationsAdd> {
  final _form = GlobalKey<FormState>();
  final countryController = TextEditingController();
  final locationController = TextEditingController();
  String selectedCountry = "";
  showCountryList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('country').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Expanded(
            child: ListView(
          children: snapshot.data!.docs.map((e) {
            final dat = e.data() as Map<dynamic, dynamic>;
            return ListTile(
              onTap: () {
                setState(() {
                  selectedCountry = e.id;
                  countryController.text = dat['name'];
                });
                Navigator.pop(context);
              },
              title: Text(dat['name']),
            );
          }).toList(),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                showCountryList();
              },
              child: TextFormField(
                controller: locationController,
                enabled: false,
                decoration: const InputDecoration(
                    hintText: 'Country ', labelText: 'Country'),
              ),
            ),
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                  hintText: 'Service Location', labelText: 'Service Location'),
            ),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                            child: CircularProgressIndicator(),
                          ));
                  FirebaseFirestore.instance.collection('locations').add(
                      ServiceLocations(
                              country: selectedCountry,
                              location: locationController.text)
                          .toJson());
                  Navigator.pop(context);
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
