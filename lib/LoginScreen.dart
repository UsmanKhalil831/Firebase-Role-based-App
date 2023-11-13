import 'package:app/AdminScreen.dart';
import 'package:app/SignUpScreen.dart';
import 'package:app/StudentScreen.dart';
import 'package:app/TeacherScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String Email ='';
  loginUser() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text);
        Email = emailController.text;
        emailController.clear();
        passwordController.clear();
        //print('===== login successfully =====');
        //Fluttertoast.showToast(msg: 'Login Successful',backgroundColor: Colors.blue,gravity: ToastGravity.CENTER);
        
    } catch (e){
      if (e is FirebaseAuthException) {
      if (e.code == 'user-not-found'){
        print('user not found');
        Fluttertoast.showToast(msg: 'User not found',backgroundColor: Colors.blue,gravity: ToastGravity.CENTER);
      }
      else if (e.code == 'wrong-password'){
        print('wrong password');
        Fluttertoast.showToast(msg: 'Wrong password',backgroundColor: Colors.blue,gravity: ToastGravity.CENTER);
      }
      else {
        // Handle other Firebase Authentication exceptions
        print('Error: ${e.message}');
    }
      }
    }
    FirebaseFirestore.instance.collection('school')
  .where('email', isEqualTo: Email) // Example: Query based on email
  .limit(1) // Limit the result to 1 document (you can remove this if you want multiple documents)
  .get()
  .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      var firstDocument = querySnapshot.docs[0];
      var userData = firstDocument.data() as Map<String, dynamic>;

      // Access the map within the document
      var userMap = userData['role']; // Replace 'your_map_field' with the actual field name in your document

      if(userMap == 'student'){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const StudentScreen()));
        }
      else if (userMap == 'teacher'){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeacherScreen()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminScreen()));
      }
      }
    
  });
  

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('login screen'),),
    body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Email Address'),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              hintText: 'Password'
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
            loginUser();
          }, child: const Text('Login')),
          SizedBox(height: 40,),
        Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text('Donot have an account?'),
          SizedBox(width: 10,),
           ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpScreen()));
        }, child: const Text( 'Sign Up'))
        ],),
       
        ],
      ),
    );
  }
}