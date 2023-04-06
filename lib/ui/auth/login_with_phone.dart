import 'package:firebase/ui/auth/verify_screen.dart';
import 'package:firebase/utils/utiles.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading=false;
  final phoneNumberController = TextEditingController();
  final auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Phone Number"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/welcome_img.png",fit: BoxFit.cover,height: 250,
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: "+1 234 5678 89",
                  prefix: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            RoundButton(title: "Enter",loading: loading, onTap: (){
              setState(() {
                loading=true;
              });
             auth.verifyPhoneNumber(
                 phoneNumber: phoneNumberController.text,
                 verificationCompleted: (_){
                   setState(() {
                     loading=false;
                   });
                 },
                 verificationFailed:(e){
                   loading =false;
                   Utils().toastMessage(e.toString());
                 },
                 codeSent:(String verificationId,int? token) {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyScreen(verificationId: verificationId,)));
                   setState(() {
                     loading=false;
                   });
                 },
                 codeAutoRetrievalTimeout:(e){
                   Utils().toastMessage(e.toString());
                 });
            }),
          ],
        ),
      ),
    );
  }
}
