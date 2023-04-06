import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/posts/add_post.dart';
import 'package:firebase/utils/utiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
class Postscreen extends StatefulWidget {
  const Postscreen({Key? key}) : super(key: key);

  @override
  State<Postscreen> createState() => _PostscreenState();
}

class _PostscreenState extends State<Postscreen> {
  final auth=FirebaseAuth.instance;
  final ref=FirebaseDatabase.instance.ref('Post');
  final searchFilter=TextEditingController();
  final editController=TextEditingController();
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
        title: Text("Post Screen"),
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
         /* Expanded(       //start                            // This Is Another Method To fetch data with the help of streamBuilder
              child: StreamBuilder(
                stream: ref.onValue,
                builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
                  Map<dynamic ,dynamic> map=snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list=[];
                  list.clear();
                  list=map.values.toList();
                  if(!snapshot.hasData){
                  return  CircularProgressIndicator();
                  }
                  else{
                    return ListView.builder(
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context,index){
                          return ListTile(
                            title: Text(list[index]['title']),
                            subtitle: Text(list[index]['id']),
                          );
                        }
                    );
                  }

                }
              )
          ),*/ //ended
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'Search',suffixStyle: GoogleFonts.lato(),
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),
          SizedBox(height: 30,),
          Expanded(
              child: FirebaseAnimatedList(
                  query:ref,
                  itemBuilder: (context,snapshot,animation,index){
                    final title= snapshot.child('title').value.toString();
                    if(searchFilter.text.isEmpty){
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context)=>[
                            PopupMenuItem(
                              value:1,
                                child:ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    showMyDialog(title,snapshot.child('id').value.toString());
                                  },
                                  leading: Icon(Icons.edit),
                                  title: Text("Edit",style: GoogleFonts.lato(),),
                                )
                            ),
                            PopupMenuItem(
                                value:1,
                                child:ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    ref.child(snapshot.child('id').value.toString()).remove();
                                  },
                                  leading: Icon(Icons.delete),
                                  title: Text("Delete",style: GoogleFonts.lato(),),
                                )
                            ),
                          ],
                        )
                      );
                    }
                    else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    }
                    else{
                     return Container();
                    }
                  }
              )
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(onPressed:(){
       Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
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
                    ref.child(id).update({
                      'title':editController.text.toLowerCase(),
                    }).then((value){
                      Utils().toastMessage("Post Updated Succesfully");
                    }).onError((error, stackTrace){
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text("Update",style: GoogleFonts.lato(),))
            ],
          );
    }
    );
  }
}
