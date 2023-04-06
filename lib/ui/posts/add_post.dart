import 'package:firebase/utils/utiles.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postController=TextEditingController();
  bool loading =false;
  final databaseRef=FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Post"),
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
              databaseRef.child(id).set({
                'id': id,
                'title' : postController.text.toString()
              }).then((value)  {
                Utils().toastMessage('Post Added');
                setState(() {
                  loading=false;
                });
              }).onError((error, stackTrace)  {
                Utils().toastMessage(error.toString());
                setState(() {
                  loading=false;
                });
              });
            })
          ],
        ),
      ),
    );
  }
}
