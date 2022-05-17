import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makati_admin/models/country_model.dart';

class UploadCountry extends StatefulWidget {
  const UploadCountry({Key? key}) : super(key: key);

  @override
  State<UploadCountry> createState() => _UploadCountryState();
}

class _UploadCountryState extends State<UploadCountry> {
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: 'Country Name', labelText: 'Country Name'),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_form.currentState!.validate()) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ));
                    await FirebaseFirestore.instance
                        .collection('Country')
                        .add(CountryModel(name: nameController.text).toJson());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
