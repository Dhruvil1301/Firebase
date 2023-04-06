import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/ui/firestore/add_firestore_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/posts/add_post.dart';
import 'package:firebase/utils/utiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth=FirebaseAuth.instance;
  final editController=TextEditingController();
  final fireStore=FirebaseFirestore.instance.collection("users").snapshots();
  CollectionReference ref=FirebaseFirestore.instance.collection("users");
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text("FireStore"),
            actions: [
              IconButton(onPressed:(){
                auth.signOut().then((value){
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>LoginScreen()));
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                });
              },
                icon: Icon(Icons.logout),),
              SizedBox(width: 20,)
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              SizedBox(height: 30,),
              StreamBuilder<QuerySnapshot>(
                stream: fireStore,
                  builder:(BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.connectionState==ConnectionState.waiting){
                            return CircularProgressIndicator();
                          }
                          else if(snapshot.hasError){
                            return Text("Something Went Worng");
                          }
                              return   Expanded(
                              child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context,index) {
                              return ListTile(
                                onTap: (){
                                  // ref.doc(snapshot.data!.docs[index]['id'].toString()).update(
                                  //     {
                                  //       "title": "I am Dhruvil agrahari"
                                  //     }).then((value){
                                  //       Utils().toastMessage("Updated");        //For Updated
                                  // }).onError((error, stackTrace){
                                  //   Utils().toastMessage(error.toString());
                                  // });

                                  ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();

                                },
                               title: Text(snapshot.data!.docs[index]['title'].toString()),
                                subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                          );
                        } ),
                  );
                  }
              ),

            ],
          ),

          floatingActionButton: FloatingActionButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFirestoreData()));
          },
            child: Icon(Icons.add),
          ),
        )
    );
  }
  Future<void> showMyDialog(String title,id)async{
    editController.text=title;
    return showDialog(
        context: context,
        builder:(BuildContext context){
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                    hintText: 'edit'
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",style: GoogleFonts.lato(),)),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Update",style: GoogleFonts.lato(),))
            ],
          );
        }
    );
  }
}

