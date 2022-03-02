import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:makati_admin/models/notification_model.dart';

import '../models/register_model.dart';

class SendNotification extends StatefulWidget {
  const SendNotification({Key? key}) : super(key: key);

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  final _formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final message = TextEditingController();
  List<NotificationModel> notiList = [];
  List<DataRow> widgetList = [];
  int i = 0;
  getData() async {
    final data = await FirebaseFirestore.instance
        .collection("notification")
        .snapshots()
        .forEach((element) {
      for (var e in element.docs) {
        print('adding');
        NotificationModel model = NotificationModel.fromJson(e.data());
        notiList.add(model);
        print(notiList.length);
        setState(() {
          widgetList = notiList
              .map((e) => DataRow(cells: [
                    DataCell(Text('${i = i + 1}')),
                    DataCell(Text(e.title)),
                    DataCell(Text(e.message)),
                    // DataCell(e.image == null || e.image == ""
                    //     ? Container()
                    //     : Image.network(e.image!)),
                  ]))
              .toList();
        });
      }
    });
  }

  Future<int> senTOAllUsers(String message, String title) async {
    //use a Async-await function to get the data
    final data = await FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .forEach((element) async {
      for (var e in element.docs) {
        print('adding');
        RegisterModel model = RegisterModel.fromJson(e.data());
        if (model.token != null) {
          await sendPushMessage(model.token!, message, title);
        }
      }
    });
    //get the data
    return 1;
  }

  Future<int> sendPushMessage(
      String token, String message, String title) async {
    var headers = {
      'Authorization':
          'Key=AAAAe30npQc:APA91bFJFzuvAc2uXVPFG8GD4pw2wIJK91A4FaDXQQLJeRY5Z1z9Gv5pia8AJiBhapj7aH5-NtH_0WJ0jfWTT3xyudQNGE1Rxj0S8QfFUqOc-CFDJueMtlafrUksjwBU-vqE56SxgjNp',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "notification": {"title": message, "body": title},
      "to": token
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    return 1;
  }

  Future<void> pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      // Upload file
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('uploading ..... ')));
      await FirebaseStorage.instance
          .ref('uploads/$fileName.png')
          .putData(fileBytes!)
          .then((p0) async {
        final imgUrl = await p0.ref.getDownloadURL();
        FirebaseFirestore.instance.collection('notification').add(
            {'image': imgUrl, 'title': title.text, 'message': message.text});
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('file uploaded')));
      });
    }
  }

  _upload() async {
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Sending ....')));
    FirebaseFirestore.instance
        .collection('notification')
        .add({'title': title.text, 'message': message.text});
    await senTOAllUsers(title.text, message.text);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Sent successfully')));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Notification Report',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepOrange)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Dialog(
                          child: Form(
                            key: _formKey,
                            child: SizedBox(
                              width: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Send Notification',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: title,
                                      validator: (val) {
                                        if (val == "") {
                                          return "enter title";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'title',
                                        labelText: 'Enter title',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: message,
                                      validator: (val) {
                                        if (val == "") {
                                          return "enter message";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'title',
                                        labelText: 'Enter message',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       if (_formKey.currentState!.validate()) {
                                  //         pickFiles();
                                  //       }
                                  //     },
                                  //     child: TextFormField(
                                  //       enabled: false,
                                  //       decoration: InputDecoration(
                                  //         hintText: 'Image',
                                  //         labelText: 'select Image',
                                  //         border: OutlineInputBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(20)),
                                  //         enabledBorder: OutlineInputBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(20)),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.deepOrange)),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _upload();
                                            }
                                          },
                                          child: const Center(
                                              child: Text('Send'))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: const Text('Send notification'))
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      DataTable(columns: const [
        DataColumn(
            label: Text('SlNo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('Message',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        // DataColumn(
        //     label: Text('Image',
        //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      ], rows: widgetList),
    ]));
  }
}
