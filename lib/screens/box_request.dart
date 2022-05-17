import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makati_admin/models/box_submit_model.dart';

class BoxRequests extends StatefulWidget {
  const BoxRequests({Key? key}) : super(key: key);

  @override
  _BoxRequestsState createState() => _BoxRequestsState();
}

class _BoxRequestsState extends State<BoxRequests> {
  List<BoxSubmitModel> countryList = [];
  List<DataRow> widgetList = [];
  void getData() async {
    countryList.clear();
    //use a Async-await function to get the data
    final data = await FirebaseFirestore.instance
        .collection("boxRequests")
        .snapshots()
        .forEach((element) {
      for (var e in element.docs) {
        int i = 0;
        print('adding');
        BoxSubmitModel model = BoxSubmitModel.fromJson(e.data());
        countryList.add(model);
        print(countryList.length);
        setState(() {
          widgetList = countryList
              .map((e) => DataRow(cells: [
                    DataCell(Text('${i = i + 1}')),
                    DataCell(Text(e.customerName)),
                    DataCell(Text(e.mobile)),
                    DataCell(Text(e.email ?? "")),
                    DataCell(Text(e.address ?? "")),
                    DataCell(Text(e.branchId ?? "")),
                    DataCell(Text(model.mapFromEnum(e.cargoType))),
                    DataCell(Text(e.deliveryCountry ?? "")),
                    DataCell(Text(e.deliveryLocation ?? "")),
                    DataCell(Text(e.noBoxes.toString())),
                    DataCell(Text(e.totalWeight.toString())),
                    DataCell(Text(e.note ?? "")),
                    DataCell(Text(e.date.toString() ?? "")),
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
      body: widgetList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      'Box Requests ',
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
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Customer Name',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Phone No',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Email Id',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Address',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Branch Name',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Cargo Type',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Delivery Country',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Delivery Location',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('No Of Boxes',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Total Weight',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Note',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Date',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                ], rows: widgetList),
              ]),
            ),
    );
  }
}
