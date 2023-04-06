import 'package:firebase/ui/firestore/firestore_screen.dart';
import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase/utils/utiles.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class VerifyScreen extends StatefulWidget {
  final verificationId;
  const VerifyScreen({Key? key,required this.verificationId }) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool loading=false;
  final verificationCodeController = TextEditingController();
  final auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Verifing"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              controller: verificationCodeController,
              decoration: InputDecoration(
                  hintText: "Enter 6 Digit code",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(title: "Verify",loading: loading, onTap: () async{
              setState(() {
                loading=true;
              });
              final credential=PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verificationCodeController.text.toString()
              );
             try{
               await auth.signInWithCredential(credential);
               Navigator.push(context, MaterialPageRoute(builder: (context)=>FireStoreScreen()));
             }
             catch(e){
                setState(() {
                  loading=false;
                });
                Utils().toastMessage(e.toString());
             }
            }),
          ],
        ),
      ),
    );
  }
}
