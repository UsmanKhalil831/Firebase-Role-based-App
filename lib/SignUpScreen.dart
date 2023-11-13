import 'package:app/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Biodata.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController typeController = TextEditingController();
   var Email = '';
   var Role = '';
  SignUpUser() async{
    UserCredential? credential;
    try{
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      Email = emailController.text.trim();
      Role = typeController.text.trim();
      emailController.clear();
      passwordController.clear();
      typeController.clear();
    }
    on FirebaseAuthException catch (e){
      if(e.code == 'weak-password'){
        print('weak password');
        Fluttertoast.showToast(msg: 'weak password',backgroundColor: Colors.blue,gravity: ToastGravity.CENTER);
        emailController.clear();
      passwordController.clear();
      typeController.clear();
      }
      else if (e.code == 'email-already-in-use'){
        print('email already in use');
        Fluttertoast.showToast(msg: 'email already in use',backgroundColor: Colors.blue,gravity: ToastGravity.CENTER);
        emailController.clear();
      passwordController.clear();
      typeController.clear();
      }
      
    } catch (e){
      print(e);
    }
    if(credential != null){
      String usid = credential.user!.uid;
      Biodata bio = Biodata(email:Email, role: Role, useruid: usid);
      await FirebaseFirestore.instance.collection('school').doc(usid).set(bio.toMap()).then((value) => print('Sign Up completed'));
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up Screen'),),
      body: Column(children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(hintText: 'Email Address'),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(hintText: 'Password'),
        ),
        TextField(
          controller: typeController,
          decoration: const InputDecoration(hintText: 'Type'),
        ),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: (){
          SignUpUser();
        }, child: const Text('Register')),
        SizedBox(height: 40,),
        Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text('Already have an account?'),
          SizedBox(width: 10,),
          ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
        }, child: const Text( 'Login here'))
        ],),
        
      ],),
    );
  }
}