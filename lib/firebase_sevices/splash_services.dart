import 'dart:async';

import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/firestore/firestore_screen.dart';
import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase/ui/upload_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices{
  void Islogin(BuildContext context){
    final auth=FirebaseAuth.instance;
    final user =auth.currentUser;
    if(user!=null){
      Timer(Duration(seconds: 3),()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>Postscreen())));
    }
    else{
      Timer(Duration(seconds: 3),()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen())));
    }
  }

}