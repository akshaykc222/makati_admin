import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makati_admin/models/country_model.dart';

class ListCountries extends StatefulWidget {
  const ListCountries({Key? key}) : super(key: key);

  @override
  State<ListCountries> createState() => _ListCountriesState();
}

class _ListCountriesState extends State<ListCountries> {
  List<CountryModel> countryList = [];
  List<DataRow> widgetList = [];

  void getData() async {
    countryList.clear();
    //use a Async-await function to get the data
    final data = await FirebaseFirestore.instance
        .collection("Country")
        .snapshots()
        .forEach((element) {
      for (var e in element.docs) {
        int i = 0;
        print('adding');
        CountryModel model = CountryModel.fromJson(e.data());
        countryList.add(model);
        print(countryList.length);
        setState(() {
          widgetList = countryList
              .map((e) => DataRow(cells: [
                    DataCell(Text('${i = i + 1}')),
                    DataCell(Text(e.name)),
                  ]))
              .toList();
        });
      }
    });
    //get the data
  }

  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  showAddAlert() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 150, vertical: 150),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ADD COUNTRY",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 25),
                      child: SizedBox(
                        width: 400,
                        height: 50,
                        child: TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              hintText: 'Country Name',
                              labelText: 'Country Name'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
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
                                  .add(CountryModel(name: nameController.text)
                                      .toJson());
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Save')),
                    )
                  ],
                ),
              ),
            ));
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
            showAddAlert();
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
                      'Country List',
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
                ], rows: widgetList),
              ]));
  }
}
