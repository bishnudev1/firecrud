import 'package:firecrud/adduser_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  TextEditingController newNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FIRE USERS'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddUserScreen(),
                ));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Some error has occured');
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    height: 200,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: newNameController,
                                          decoration: InputDecoration(
                                              hintText: 'Enter new name',
                                              labelText: 'New Name',
                                              border: OutlineInputBorder()),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        MaterialButton(
                                          color: Colors.teal,
                                          onPressed: () {
                                            ref
                                                .doc(snapshot
                                                    .data!.docs[index]["id"]
                                                    .toString())
                                                .update(
                                                    {"name": newNameController.text}).then(
                                              (value) {
                                                showToast(
                                                    'Data has been updated');
                                              },
                                            ).catchError((error) {
                                              showToast(error.toString());
                                            });
                                            setState(() {
                                              newNameController.text = "";
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Update'),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        onLongPress: () {
                          ref
                              .doc(snapshot.data!.docs[index]["id"].toString())
                              .delete();
                          showToast('Data has been deleted');
                        },
                        title:
                            Text(snapshot.data!.docs[index]["name"].toString()),
                        subtitle: Text(
                            snapshot.data!.docs[index]["email"].toString()),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.blue,
      fontSize: 16.0,
    );
  }
}
