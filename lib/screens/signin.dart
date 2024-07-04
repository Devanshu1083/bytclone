import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Session? currentSession;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Container(
            height: 768,
            width: 375,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        height: 587,
                        width: 375,
                        margin: const EdgeInsets.only(top: 68, bottom: 113),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 100.0,
                              ),
                              Container(
                                  height: 34,
                                  width: 264,
                                  margin: const EdgeInsets.only(left: 15, right: 16,),
                                  child: const Text(
                                      "LOGIN",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26))
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 100.0,
                                child: Image.asset('assets/logo.png'),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, top: 28, right: 16,),
                                child: Container(
                                  width: 343,
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(5,),
                                    border: Border.all(
                                      color: Colors.blue.shade50,
                                      width: 1,),
                                  ),
                                  child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        hintText: "Enter your email",
                                        hintStyle: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.blueGrey.shade300),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5,),
                                          borderSide: const BorderSide(color: Colors.white70),),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5,),
                                          borderSide: const BorderSide(color: Colors.blueGrey),),
                                        prefixIcon: const Padding(padding: EdgeInsets.all(15,),
                                          child: Icon(Icons.email_outlined),),
                                        filled: true,
                                        fillColor: Colors.white),
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade300,
                                        fontSize: 14.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400),),),
                              ),
                              Container(
                                width: 343,
                                height: 48,
                                margin: const EdgeInsets.only(left: 16, top: 8, right: 16,),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(5,),
                                  border: Border.all(color: Colors.blue.shade50, width: 1,),
                                ),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Enter Password",
                                      hintStyle: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.blueGrey.shade300),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5,),
                                        borderSide: const BorderSide(color: Colors.white70),),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5,),
                                        borderSide: const BorderSide(color: Colors.blueGrey),),
                                      prefixIcon: const Padding(padding: EdgeInsets.all(10,),
                                        child: Icon(Icons.lock_outline_rounded),),
                                      filled: true,
                                      fillColor: Colors.white),
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade300,
                                      fontSize: 14.0,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400),),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool isSigned = await onTapBtnSignIn();
                                  if(isSigned==true){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen(session: currentSession!)),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16, top: 18, right: 16,),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF000B49),
                                      borderRadius: BorderRadius.circular(5,),
                                      border: Border.all(color: Colors.white, width: 1,),
                                    ),
                                    alignment: Alignment.center,
                                    height: 57,
                                    width: 343,
                                    child: const Text("Sign In",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),),),),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, '/signup');
                                },
                                child: Container(
                                  width: 212,
                                  margin: const EdgeInsets.only(left: 81, top: 8, right: 82,),
                                  child: RichText(
                                      text: TextSpan(children: <InlineSpan>[
                                        TextSpan(
                                          text: "Not registered?",
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade300,
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400),
                                        ),
                                        TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              color: Colors.indigo.shade300,
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(
                                          text: "SignUp",
                                          style: TextStyle(
                                              color: Colors.lightBlue.shade300,
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700),
                                        )
                                      ]),
                                      textAlign: TextAlign.center),
                                ),)]),),),)
                ]),
          ),
        ),
      ),
    );
  }

  Future<bool> onTapBtnSignIn() async{
    try{
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (response.user != null) {
        currentSession = response.session;
        final snackBar = const SnackBar(
          content: Text('Success! User signed in.'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await Future.delayed(Duration(seconds: 1));
        return true;
      } else {
        final snackBar = const SnackBar(
          content: Text('An unknown error occurred'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    }
    on AuthException catch (e) {
        // Handle other errors
        final snackBar = SnackBar(
          content: Text('${e.message}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
    }
  }
}