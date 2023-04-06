import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/utils/utiles.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey=GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController =TextEditingController();
  FirebaseAuth auth= FirebaseAuth.instance;
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SignUp Page",style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController ,
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefix: Icon(Icons.email)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter Email';
                        }
                        else{
                          return null;
                        }
                      }
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      controller: passwordController ,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefix: Icon(Icons.lock),


                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Password';
                        }
                        else {
                          return null;
                        }
                      }

                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
            RoundButton(
              title: "Sign Up",
              loading: loading,
              onTap: () {
                if(_formKey.currentState!.validate()){
                  setState(() {
                    loading =true;
                  });
                  auth.createUserWithEmailAndPassword(
                      email: emailController.text.toString(),
                      password: passwordController.text.toString()).then((value){
                       setState(() {
                         loading =false;
                       });
                  }).onError((error, stackTrace){
                   Utils().toastMessage(error.toString());
                   debugPrint(error.toString());
                   setState(() {
                     loading =false;
                   });
                  });
                }
              },
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>LoginScreen())
                  );
                }, child: Text("Login"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
