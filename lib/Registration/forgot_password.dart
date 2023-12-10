import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/Main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:page_transition/page_transition.dart';
import '../Constraints.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _email=TextEditingController();
  final auth =FirebaseAuth.instance;
  final _textStyle = GoogleFonts.alegreya(fontSize: 28, fontWeight: FontWeight.w900,color: Colors.white54,
    shadows: <Shadow>[
      const Shadow(
        offset: Offset(1, 1),
        color: Colors.black,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color:Colors.grey[800],
        child: Padding(
            padding: EdgeInsets.fromLTRB(size.width * 0.3,
          size.height*0.02, size.width * 0.3, size.height*0.02),
          child: Card(           
            shadowColor: Color.fromARGB(255, 255, 255, 255),
            elevation:30,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height:size.height * 0.05,
                ),
                Container(
                height:size.height*0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Regcon,
                        border: Border.all(color: Colors.black),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 60,
                              blurStyle: BlurStyle.outer,
                              color: Colors.black54,
                              offset: Offset(1, 1))
                        ],
                        image: const DecorationImage(
                            image: AssetImage("assets/icon/icon.png")),
                      ),
                      height: size.height*0.1,
                      width: size.height*0.1,
                    ),
                    SizedBox(
                      width:size.width*0.005,
                    ),
                    AutoSizeText(
                      'CampusLink',style: GoogleFonts.lora(
                        fontSize:size.width*0.02,
                        fontWeight:FontWeight.w900,
                        color:Colors.black,
                        )
                    )
                  ],
                ),
              ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.06,
                ),
                AutoSizeText(
                  "Forgot your password?",
                  style:TextStyle(fontSize: MediaQuery.of(context).size.width*0.018,
                  fontWeight:FontWeight.w900,
                  color:Color.fromARGB(255, 9, 30, 48),
                  )
                ),
                SizedBox(
                  height:size.height*0.01,
                ),
                AutoSizeText(
                  "Your password will be reset by email.",
                  style:TextStyle(fontSize: MediaQuery.of(context).size.width*0.008,
                  fontWeight:FontWeight.w500,
                  color:Colors.black,
                  )
                ),
                SizedBox(
                  height:size.height*0.06,
                ),
                Row(
                  children: [
                    SizedBox(
                      width:size.width*0.05,
                    ),
                    AutoSizeText(
                          "Enter your email address",
                          style:TextStyle(fontSize: size.width*0.01,
                          fontWeight:FontWeight.w900,
                          color:Colors.black,
                          )
                        ),
                  ],
                ),
                SizedBox(
                  height:size.height*0.02,
                ),
                Form(
                  key: _key,
                    child: Column(
                      children: [
                        Container(
                          width:size.width*0.3,
                          height: size.height*0.06,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.black,),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.outer,
                                  color: Colors.black54,
                                  offset: Offset(1, 1)
                              )
                            ],
                          ),
                          child: TextFormField(
                              validator: (value) {
                                if (value!.contains('@')) {
                                  return null;
                                } else {
                                  return 'Please enter a valid email address';
                                }
                              },
                              controller: _email,
                              obscureText: false,
                              enableSuggestions: true,
                              autocorrect: true,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        _email.clear();
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.clear_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Colors.black,
                                  ),
                                  label: const Text("Email address",style:TextStyle(fontWeight:FontWeight.bold)),
                                  labelStyle: TextStyle(
                                      color: Colors.black26.withOpacity(0.7)),
                                  filled: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none)
                                  )
                              ),
                              keyboardType: TextInputType.emailAddress),
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.03,
                        ),
                ],
                    )
                ),
                SizedBox(
                  height:MediaQuery.of(context).size.height*0.05
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.3,
                  height: MediaQuery.of(context).size.height*0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black54,width: 2),
                  ),
                  child: Material(
                    shadowColor: Colors.blue,
                    elevation:10,
                    shape: OutlineInputBorder( borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      dense:true,
                      contentPadding: EdgeInsets.symmetric(vertical:0),
                      shape: OutlineInputBorder( borderRadius: BorderRadius.circular(30)),
                      tileColor: Color.fromARGB(255, 9, 30, 48),
                      onTap: () async{
                        if (_key.currentState!.validate())
                        {
                          String test=await forgot(_email.text.trim());
                          if(!mounted) return;
                          if(test=="1"){
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: const SignInScreen(),
                                    type: PageTransitionType.scale,
                                    duration: const Duration(milliseconds: 400),
                                    alignment: Alignment.bottomCenter),
                            );
                          }
                          else{
                            InAppNotifications.instance
                              ..titleFontSize = 14.0
                              ..descriptionFontSize = 14.0
                              ..textColor = Colors.black
                              ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                              ..shadow = true
                              ..animationStyle = InAppNotificationsAnimationStyle.scale;
                            InAppNotifications.show(
                                title: 'Failed',
                                duration: const Duration(seconds: 2),
                                description: test,
                                leading: const Icon(
                                  Icons.error_outline_outlined,
                                  color: Colors.red,
                                  size: 55,
                                )
                            );
                          }
                        }
                      },
                      title: const AutoSizeText("Reset Password", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                          ),
                          textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                ),
                    Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Go to Sign In Page ?", style: TextStyle(
                color: Colors.black,
              fontWeight: FontWeight.w400)
                ,),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, PageTransition(child: const MainPage(), type: PageTransitionType.leftToRight,duration: const Duration(milliseconds: 400),childCurrent: const ForgotPassword())
                  );
                  //Navigator.pop(context);
                },
                child: const Text("Sign In", style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    shadows: [
                    Shadow(
                    blurRadius: 30,
                    offset: Offset(3, 3),
                    color: Colors.black54
                )
                    ]
                )
            
                ),
              )
            ],
                    ),
            
              ],
            ),
          ),
        ),

    ));
  }



  Future<String> forgot(String email) async {
    try {
      await  auth.sendPasswordResetEmail(email: email);
      return "1";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.toString().split(']')[1].trim();
    }
  }
}
