import 'dart:convert';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makati_admin/models/register_model.dart';

class UserReport extends StatefulWidget {
  const UserReport({Key? key}) : super(key: key);

  @override
  State<UserReport> createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  List<RegisterModel> usersList = [];
  List<DataRow> widgetList = [];
  int i = 0;
  void getData() async {
    usersList.clear();
    //use a Async-await function to get the data
    final data = await FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .forEach((element) {
      for (var e in element.docs) {
        print('adding');
        RegisterModel model = RegisterModel.fromJson(e.data());
        usersList.add(model);
        print(usersList.length);
        setState(() {
          widgetList = usersList
              .map((e) => DataRow(cells: [
                    DataCell(Text('${i = i + 1}')),
                    DataCell(Text(e.name)),
                    DataCell(Text(e.email)),
                    DataCell(Text(e.phone)),
                    DataCell(Text(e.country)),
                  ]))
              .toList();
        });
      }
    });
    //get the data
  }

  Future<void> createExcel() async {
    String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
    String fileName = "userlist";
    var excel = Excel.createExcel();

    Sheet sheetObject = excel[fileName];
    excel.delete('sheet1');
    // CellStyle cellStyle = CellStyle(
    //     backgroundColorHex: "#1AFF1A",
    //     fontFamily: getFontFamily(FontFamily.Calibri));
    List<String> dataList = [
      "SlNO",
      "Name",
      "Phone",
      "Email",
      "Country",
    ];
    int i = 0;
    sheetObject.insertRow(0);

    sheetObject.insertRowIterables(dataList, 0);
    for (var element in usersList) {
      List<dynamic> dataList = [
        i = i = 1,
        (element.name),
        (element.phone),
        (element.email),
        (element.country)
      ];
      sheetObject.appendRow(dataList);
    }
    excel.encode().then((onValue) {
      AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(onValue)}")
        ..setAttribute("download", "output.xlsx")
        ..click();
    });
    // var fileBytes = excel.save(fileName: "My_Excel_File_Name.xlsx");
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
            : ListView(children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Users Report',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepOrange)),
                        onPressed: () {
                          createExcel();
                        },
                        child: const Text('Download as excel'))
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
                      label: Text('Name',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Email',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Phone',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Country',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ], rows: widgetList),
              ]));
  }
}
