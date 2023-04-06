import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/utiles.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({Key? key}) : super(key: key);

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  final postController=TextEditingController();
  bool loading =false;
  final fireStore=FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add FireStore Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                hintText: "What is your name?",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: "Add",
                loading: loading,
                onTap:(){
                  setState(() {
                    loading=true;
                  });
                  String id=DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                   "title" : postController.text.toString(),
                    "id" : id,
                  }).then((value){
                    setState(() {
                      loading=false;
                    });
                    Utils().toastMessage("Post Added");
                  }).onError((error, stackTrace){
                    setState(() {
                      loading=false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
