import 'package:firebase/ui/auth/login_with_phone.dart';
import 'package:firebase/ui/auth/signup_screen.dart';
import 'package:firebase/ui/auth/verify_screen.dart';
import 'package:firebase/ui/forgot_password_screen.dart';
import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase/utils/utiles.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = true;
  final _formKey=GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController =TextEditingController();
  final _auth=FirebaseAuth.instance;

  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void login(){
    setState(() {
      loading =true;
    });
    _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString()).then((value){
        Utils().toastMessage(value.user!.email.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Postscreen()));
        setState(() {
          loading =true;
        });
    }).onError((error, stackTrace){
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading =false;
      });
    });
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
          title: Text("Login Page",style: GoogleFonts.lato(fontWeight: FontWeight.bold),
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
                 title: "Login",
                 onTap: () {
                   if(_formKey.currentState!.validate()){
                     login();
                   }

                 },
               ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>ForgotPassword())
                  );
                }, child: Text("Forgot Password",style: GoogleFonts.lato(),)),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",),
                  TextButton(onPressed: (){
                     Navigator.push(context,
                       MaterialPageRoute(builder: (context)=>SignUpScreen())
                     );
                  }, child: Text("Sign Up"))
                ],
              ),
              const SizedBox(height: 30,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithPhoneNumber()));
                },
                child: Container(
                  height: 50,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.deepPurple,
                    )
                  ),
                  child: Center(

                    child: Text("Login with Phone ",style: GoogleFonts.lato(),),

                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
