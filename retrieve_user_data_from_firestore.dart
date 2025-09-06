import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thirteen_firestore_database/screens/getUserName.dart';

class AddUserMangement extends StatefulWidget {
  const AddUserMangement({super.key});

  @override
  State<AddUserMangement> createState() => _AddUserMangementState();
}

class _AddUserMangementState extends State<AddUserMangement> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isUpdate = false;
  String docID = ''; // Store Document ID for updating

  addUser() {
    if (nameController.text.isEmpty ||
        contactController.text.isEmpty ||
        emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Fields can't be empty!");
      return;
    }
    FirebaseFirestore.instance.collection("users").add({
      "first_name": nameController.text,
      "contact": contactController.text,
      "email": emailController.text,
    }).then((_) {
      Fluttertoast.showToast(
          msg: "User Added Successfully", backgroundColor: Colors.green);
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error: $error", backgroundColor: Colors.red);
    });
    nameController.clear();
    contactController.clear();
    emailController.clear();
    Navigator.pop(context);
  }

  updateUser() {
    if (nameController.text.isEmpty ||
        contactController.text.isEmpty ||
        emailController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Fields cannot be empty!", backgroundColor: Colors.red);
      return;
    }

    FirebaseFirestore.instance.collection("users").doc(docID).update({
      'first_name': nameController.text,
      'contact': contactController.text,
      'email': emailController.text,
    }).then((_) {
      Fluttertoast.showToast(
          msg: "User Updated Successfully!", backgroundColor: Colors.green);
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error: $error", backgroundColor: Colors.red);
    });

    nameController.clear();
    contactController.clear();
    emailController.clear();
    Navigator.pop(context);
  }

  void deleteUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(docID)
        .delete()
        .then((_) async {
      await FirebaseAuth.instance.currentUser?.delete();
      Fluttertoast.showToast(
          msg: "User Deleted Successfully!", backgroundColor: Colors.red);
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error: $error", backgroundColor: Colors.red);
    });
  }

  customModalBottomSheetWidget() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 10.0,
              right: 10.0,
              top: 10.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name")),
                TextField(
                    controller: contactController,
                    decoration: const InputDecoration(labelText: "Contact")),
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      if (isUpdate) {
                        updateUser();
                      } else {
                        addUser();
                      }
                    },
                    child: Text(isUpdate ? "Update" : "Add"))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isUpdate = false;
              nameController.clear();
              contactController.clear();
              emailController.clear();
            });
            customModalBottomSheetWidget();
          },
          child: const Icon((Icons.add)),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot abc = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 30,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("UID: ${abc.id}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                Text("Name: ${abc['first_name']}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Text("Email: ${abc['email']}",
                                    style: const TextStyle(fontSize: 14)),
                                Text("Contact: ${abc['contact']}",
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      isUpdate = true;
                                      nameController.text = abc['first_name'];
                                      contactController.text = abc['contact'];
                                      emailController.text = abc['email'];
                                      docID = abc.id;
                                      customModalBottomSheetWidget();
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue)),
                                IconButton(
                                    onPressed: () {
                                      docID = abc.id;
                                      deleteUser();
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red))
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GetUserName(documentId: abc.id),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
