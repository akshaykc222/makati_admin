import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  String image = "";
  Future<void> pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      // Upload file
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Uploading .....')));
      await FirebaseStorage.instance
          .ref('uploads/$fileName')
          .putData(fileBytes!)
          .then((p0) async {
        final imgUrl = await p0.ref.getDownloadURL();
        FirebaseFirestore.instance.collection('offers').add({'offers': imgUrl});
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File uploaded successfully')));
      });
    }
  }

  getPreviousImage() {
    FirebaseFirestore.instance
        .collection('offers')
        .snapshots()
        .last
        .then((value) {
      setState(() {
        if (value.docs.first.data() != null &&
            value.docs.first.data().containsKey('offers')) {
          image = value.docs.first.get('offers');
        }
      });
    });
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data?.docs
        .map((doc) => SizedBox(
              width: double.infinity,
              height: 200,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(
                    //   width: 200,
                    //   child: CachedNetworkImage(
                    //     imageUrl: doc['offers'],
                    //   ),
                    // ),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          style: TextStyle(color: Colors.blue),
                          text: "To View "),
                      TextSpan(
                          style: const TextStyle(color: Colors.blue),
                          text: "Click here",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              var url = doc['offers'];
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }),
                    ])),
                    InkWell(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection('offers')
                              .doc(doc.id)
                              .delete();
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 30,
                        ))
                  ],
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image == ""
              ? Container()
              : Image.network(
                  image,
                  width: 200,
                  height: 2000,
                ),
          InkWell(
              onTap: () {
                pickFiles();
              },
              child: const Icon(
                Icons.add,
                size: 50,
              )),
          const Text('Upload file'),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('offers').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return !snapshot.hasData
                  ? const Center(
                      child: Text('no offers'),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: getExpenseItems(snapshot),
                    );
            },
          )
        ],
      ),
    );
  }
}
