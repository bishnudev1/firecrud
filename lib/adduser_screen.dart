import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firecrud/user_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';


class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {

    final firestore = FirebaseFirestore.instance.collection('users');

  var _formkey = GlobalKey<FormState>();

  String name = "";
  String email = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD USER'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  return value!.isEmpty ? 'Enter your name' : null;
                },
                decoration: InputDecoration(
                    hintText: 'Enter name...',
                    labelText: 'Name',
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  return value!.isEmpty ? 'Enter your email' : null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Enter email...',
                    labelText: 'Email',
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (_formkey.currentState!.validate()) {

                    String id = DateTime.now().millisecondsSinceEpoch.toString();

                    try {
                      firestore.doc(id).set({
                        'name': nameController.text,
                        'email': emailController.text,
                        'id':id
                      }).then((value) {
                        showToast('Your data has been added');
                        setState(() {
                          nameController.text = "";
                          emailController.text = "";
                        });
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserScreen()));
                      }).onError((error, stackTrace) {
                        showToast(error.toString());
                      });
                    } catch (e) {
                      showToast(e.toString());
                    }
                  } else {
                    showToast('Provide details correctly');
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      //border: Border.all(color: Colors.blue,width: 3),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: Text(
                      'Add Data',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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