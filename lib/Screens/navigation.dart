import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/service/notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:campus_link_student/Database/database.dart';
import 'package:campus_link_student/Registration/registration.dart';
import 'package:campus_link_student/Screens/Achievements/achievement_page.dart';
import 'package:campus_link_student/Screens/psycoTest.dart';
import 'package:campus_link_student/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'Assignment/assignment.dart';
import 'Leader_board/Leader_Board.dart';
import 'Profile_Page/profile_page.dart';
import 'Sessional Marks/View Marks.dart';
import 'attendance.dart';
import 'Chat_tiles/chat_list.dart';
import 'feedbackScreen.dart';
import 'Notes/notes.dart';
import 'Perfomance/performance.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  List<Widget>All_Pages=[const Assignment(),const Notes(),NewPost(),const OverAllLeaderBoard(), Performance()];
  PageController page_controller=PageController();
  List<String>cuu_title=["Assignments","Notes","Feed","Leaderboard","Performance"];
  var curr_index=0;
  bool profile_update=false;


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
          // image: DecorationImage(image: AssetImage("assets/images/bg-image.png"),fit: BoxFit.fill
          color:Colors.white,
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          actions: [
            Container(
              width:size.width*0.18,
              height:size.height*0.08,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                              radius: size.height*0.03,
                              backgroundImage:usermodel["Profile_URL"]!=null?
                              NetworkImage(usermodel["Profile_URL"])
                                  :
                              null,
                              // backgroundColor: Colors.teal.shade300,
                              child:usermodel["Profile_URL"]==null?
                              AutoSizeText(
                                usermodel["Name"].toString().substring(0, 1),
                                style: GoogleFonts.exo(
                                    fontSize: size.height * 0.05,
                                    fontWeight: FontWeight.w600),
                              )
                                  :
                              profile_update?
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                              )
                                  :
                              null
                          ),
                          Positioned(
                              top: 0,
                              left: 0,
                              child: IconButton(
                                  icon: Icon(Icons.camera_enhance,size:size.height*0.025 ,color: Colors.black,),
                                  onPressed: () async {

                                    ImagePicker imagePicker=ImagePicker();
                                    print(imagePicker);
                                    XFile? file=await imagePicker.pickImage(source: ImageSource.gallery);
                                    print(file?.path);

                                    if(file!.path.isNotEmpty)
                                    {
                                      setState(() {
                                        profile_update=true;
                                      });
                                      // Create reference of Firebase Storage

                                      Reference reference=FirebaseStorage.instance.ref();

                                      // Create Directory into Firebase Storage

                                      Reference image_directory=reference.child("User_profile");


                                      Reference image_folder=image_directory.child("${usermodel["Email"]}");

                                      await image_folder.putFile(File(file!.path)).whenComplete(() async {


                                        String download_url=await image_folder.getDownloadURL();
                                        print("uploaded");
                                        print(download_url);
                                        await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email).update({
                                          "Profile_URL":download_url,
                                        }).whenComplete(() async {
                                          await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).get().then((value){

                                            setState(() {
                                              usermodel=value.data()!;
                                            });
                                          }).whenComplete(() {
                                            setState(() {
                                              profile_update=false;
                                            });
                                          });

                                        });
                                        setState(() {
                                          profile_update=false;
                                        });
                                      },
                                      );
                                    }

                                  }
                              )
                          )
                        ],
                      ),
                      SizedBox(
                        width:size.width*0.01,
                      ),
                      AutoSizeText(
                        usermodel["Name"],
                        style: GoogleFonts.exo(
                            color:Colors.white,
                            fontSize: size.height * 0.022,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // StreamBuilder(
            //   stream: FirebaseFirestore.instance.collection("Messages").where(usermodel["Email"].toString().split("@")[0],isNull: false).snapshots(),
            //   builder: (context, snapshot) {
            //     int count=0;
            //
            //     int end=snapshot.hasData ? snapshot.data!.docs.length : 0;
            //     print(end);
            //   for(int i=0;i<end; i++){
            //     print(i);
            //       int read=snapshot.data?.docs[i].data()[usermodel["Email"].toString().split("@")[0]]["Read_Count"];
            //       int len=snapshot.data?.docs[i].data()["Messages"].length;
            //       print("${len-read}");
            //       count+=len-read;
            //   }
            //
            //   return snapshot.hasData
            //     ?
            //     Stack(
            //     children: <Widget>[
            //       IconButton(
            //       onPressed: () {
            //     List<dynamic>subject=usermodel["Subject"];
            //     if(subject.isEmpty)
            //     {
            //       setState(() {
            //         no_subjects=true;
            //       });
            //     }
            //     else{
            //       setState(() {
            //         no_subjects=false;
            //       });
            //     }
            //
            //     Navigator.push(
            //       context,
            //       PageTransition(
            //         child: const chatsystem(),
            //         type: PageTransitionType.rightToLeftJoined,
            //         duration: const Duration(milliseconds: 350),
            //         childCurrent: const Navigation(),
            //       ),
            //     );
            //   },
            //       icon: const Icon(
            //           Icons.send_outlined,
            //           color:Colors.white
            //       ),
            //       ),
            //       count>0
            //           ?
            //       Positioned(
            //         right: size.width*0.006,
            //         child: Container(
            //           width: size.width*0.01,
            //           height: size.width*0.01,
            //           padding: const EdgeInsets.all(2),
            //           decoration: BoxDecoration(
            //             color: Colors.green.shade700,
            //             shape:BoxShape.circle,
            //           ),
            //
            //           child: Center(
            //             child: SizedBox(
            //               width: size.width*0.01,
            //               child: AutoSizeText(
            //                 '$count',
            //                 style: GoogleFonts.exo(
            //                   color: Colors.black,
            //                   fontSize: size.height*0.02,
            //                   fontWeight: FontWeight.w600
            //                 ),
            //                 maxLines: 1,
            //                 minFontSize: 8,
            //                 textAlign: TextAlign.center,
            //
            //               ),
            //             ),
            //           ),
            //         ),
            //       )
            //           :
            //           const SizedBox()
            //     ],
            //     )
            //   :
            //   IconButton(
            //     onPressed: () {
            //       List<dynamic>subject=usermodel["Subject"];
            //       if(subject.isEmpty)
            //       {
            //         setState(() {
            //           no_subjects=true;
            //         });
            //       }
            //       else{
            //         setState(() {
            //           no_subjects=false;
            //         });
            //       }
            //
            //       Navigator.push(
            //         context,
            //         PageTransition(
            //           child: const chatsystem(),
            //           type: PageTransitionType.rightToLeftJoined,
            //           duration: const Duration(milliseconds: 350),
            //           childCurrent: const Navigation(),
            //         ),
            //       );
            //     },
            //     icon: const Icon(
            //         Icons.send_outlined,
            //         color:Colors.white
            //     ),
            //   );
            // },)
          ],
          toolbarHeight: size.height*0.08,
          backgroundColor: Color.fromRGBO(43,43,43,1),
          title:  SizedBox(
            width:size.width*0.8,
            height: size.height*0.08,
            child: Row(
                    children: [
                      SizedBox(
                        width:size.width*0.21,
                      ),
                      GestureDetector(
                          onTap:(){
                            setState(() {
                              curr_index=0;
                              page_controller.animateToPage(curr_index,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.linear);
                              },
                            );
                            print(curr_index);
                          },
                          child: Container(
                            height: size.height*0.08,
                            width: size.width*0.1,
                            color: curr_index ==0 ? Colors.white : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              SizedBox(
                                height:size.height*0.05,
                                width:size.width*0.02,
                                child:Image.asset("assets/images/assignment_icon.png"),
                              ),
                              AutoSizeText(
                              'Assignment',
                              style: GoogleFonts.tiltNeon(
                                color: curr_index ==0 ? Colors.black : Colors.white,
                                fontSize:size.width*0.013,
                                fontWeight:FontWeight.w900,
                              )
                                                          ),]
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            curr_index=1;
                            page_controller.animateToPage(curr_index,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear);
                                  },
                          );
                          print(curr_index);
                        },
                        child: Container(
                          width:size.width*0.08,
                          height: size.height*0.08,
                          color: curr_index ==1 ? Colors.white : Colors.transparent,
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:size.height*0.05,
                                width:size.width*0.02,
                                child:Image.asset("assets/images/notes_icon.png"),
                              ),
                              AutoSizeText(
                                  'Notes',
                                  style:GoogleFonts.tiltNeon(
                                    color: curr_index ==1 ? Colors.black : Colors.white,
                                    fontSize:size.width*0.013,
                                    fontWeight:FontWeight.w900,
                                  )
                                ),
                            ]
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            curr_index=2;
                            page_controller.animateToPage(curr_index,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear);
                                  },
                          );
                          print(curr_index);
                        },
                        child: Container(
                          width:size.width*0.11,
                          height: size.height*0.08,
                          color: curr_index ==2 ? Colors.white : Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:size.height*0.05,
                                width:size.width*0.02,
                                child:Image.asset("assets/images/attendance_icon.png"),
                              ),
                              AutoSizeText(
                                  'Achievements',
                                  style:GoogleFonts.tiltNeon(
                                    color: curr_index ==2 ? Colors.black : Colors.white,
                                    fontSize:size.width*0.013,
                                    fontWeight:FontWeight.w900,
                                  )
                                ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            curr_index=3;
                            page_controller.animateToPage(curr_index,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear);
                                  },
                          );
                          print(curr_index);
                        },
                        child: Container(
                          width:size.width*0.115,
                          height: size.height*0.08,
                          color: curr_index ==3 ? Colors.white : Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:size.height*0.05,
                                width:size.width*0.02,
                                child:Image.asset("assets/images/mark_icon.png"),
                              ),
                              AutoSizeText(
                                  'Leaderboard',
                                  style:GoogleFonts.tiltNeon(
                                    color: curr_index ==3 ? Colors.black : Colors.white,
                                    fontSize:size.width*0.013,
                                    fontWeight:FontWeight.w900,
                                  )
                                ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            curr_index=4;
                            page_controller.animateToPage(curr_index,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear);
                                  },
                          );
                          print(curr_index);
                        },
                        child: Container(
                          width:size.width*0.11,
                          height: size.height*0.08,
                          color: curr_index ==4 ? Colors.white : Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:size.height*0.05,
                                width:size.width*0.02,
                                child:Image.asset("assets/images/performance_icon.png"),
                              ),
                              AutoSizeText(
                                  'Performance',
                                  style:GoogleFonts.tiltNeon(
                                    color: curr_index ==4 ? Colors.black : Colors.white,
                                    fontSize:size.width*0.013,
                                    fontWeight:FontWeight.w900,
                                  )
                                ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
          ),
          //centerTitle: true,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width:size.width*0.26,
              color:Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width:size.width*0.238,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: <Widget>[
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: const Icon(Icons.home,color: Colors.black,),
                            title: const Text("Home"),
                            onTap: () {
                              //Navigator.pop(context);
                            },
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: const Icon(Icons.account_box_outlined,color: Colors.black,),
                            title: const Text("My Profile"),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: const Profile_page(),
                                  type: PageTransitionType.rightToLeftJoined,
                                  duration: const Duration(milliseconds: 350),
                                  childCurrent: const Navigation(),
                                ),
                              );

                            },
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: const Icon(Icons.add,color: Colors.black,),
                            title: const Text("Add Subjects"),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: const StudentDetails(),
                                  type: PageTransitionType.rightToLeftJoined,
                                  duration: const Duration(milliseconds: 350),
                                  childCurrent: const Navigation(),
                                ),
                              );

                            },
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: const Icon(Icons.feedback_outlined,color: Colors.black,),
                            title: const Text("Feedback"),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: const feedbackQuiz(),
                                  type: PageTransitionType.rightToLeftJoined,
                                  duration: const Duration(milliseconds: 350),
                                  childCurrent: const Navigation(),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: const Icon(Icons.add,color: Colors.black,),
                            title: const Text("Sessional Marks"),
                            onTap: () {
                              if(usermodel["Subject"] != null){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const ViewMarks();
                                    },
                                  ),
                                );
                              }
                              else{
                                InAppNotifications.instance
                                  ..titleFontSize = 35.0
                                  ..descriptionFontSize = 20.0
                                  ..textColor = Colors.black
                                  ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                  ..shadow = true
                                  ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                InAppNotifications.show(
                                    title: 'Error',
                                    duration: const Duration(seconds: 2),
                                    description: "Please add the subjects first",
                                    leading: const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                      size: 30,
                                    ));
                              }

                            },
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: SizedBox(
                                width: size.width*0.025,
                                child: Image.asset("assets/images/psychometric.png",fit: BoxFit.contain,)
                            ),
                            title: const Text("Psychometric"),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   PageTransition(
                              //     child: const PsychometricTest(),
                              //     type: PageTransitionType.rightToLeftJoined,
                              //     duration: const Duration(milliseconds: 350),
                              //     childCurrent: const Navigation(),
                              //   ),
                              // );
                              showDialog(
                                context: context,
                                builder: (context){
                                  return const PsychometricTest();
                                }
                              );
                            },
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: SizedBox(
                                width: size.width*0.025,
                                child: Image.asset("assets/images/psychometric.png",fit: BoxFit.contain,)
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Study Time'),
                                Text('${usermodel['Study_hours']} : ${usermodel['Study_minute']} ${usermodel['Study_section']}',style: const TextStyle(color: Colors.black45,)),
                              ],
                            ),
                            onTap: () async{
                              var studyTime= (await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ))!;

                              //
                              //  print("Work-manager initializing");
                              //  Workmanager().initialize(callbackDispatcherforreminder);
                              //  print("Work-manager initialized");
                              //  print("Canceling task 404");
                              // // Workmanager().cancelByUniqueName("404");
                              //  print("Canceled task 404");
                              //  print("Work-manager initializing periodic task 405");
                              //  await Workmanager().registerPeriodicTask(
                              //      "405",
                              //      "405",
                              //      frequency: const Duration(days: 1),
                              //      inputData: {
                              //        "Hour" : studyTime.hour,
                              //        "Minute" : studyTime.minute
                              //      }
                              //  );
                              //  print("Work-manager initialized periodic task 405");
                              await FirebaseFirestore.instance.collection('Students').doc(usermodel['Email']).update({'Study_hours': studyTime.hour,'Study_minute':studyTime.minute,'Study_section' : studyTime.period.toString().split('.')[1]});
                              await database().fetchuser().whenComplete(() => setState(() {
                              }));

                            },
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: const Icon(Icons.settings,color: Colors.black),
                            title: const Text("Settings"),
                            onTap: () {},
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: const Icon(Icons.contacts,color: Colors.black),
                            title: const Text("Contact Us"),
                            onTap: () {},
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: const Icon(Icons.logout,color: Colors.black),
                            title: const Text("Logout"),
                            onTap: () async {
                              final token = Platform.isIOS ? await FirebaseMessaging.instance.getAPNSToken() : await FirebaseMessaging.instance.getToken();
                              String? userId = FirebaseAuth.instance.currentUser?.email;




                              if(usermodel["Message_channels"]!=null)
                              {
                                List<dynamic> channels= usermodel["Message_channels"];

                                for(var channel in channels){
                                  await FirebaseFirestore.instance.collection("Messages")
                                      .doc(channel).update(
                                      {
                                        "${usermodel["Email"].toString().split("@")[0]}.Token" : FieldValue.arrayRemove([token])
                                      }
                                  );
                                }
                                await FirebaseFirestore.instance.collection("Students").doc(usermodel["Email"]).update({
                                  "Token" : ""
                                });
                                await FirebaseAuth.instance.signOut();
                              }
                              else{
                                await FirebaseAuth.instance.signOut();
                              }
                            },
                          ),
                        ),
                        Container(
                          height:size.height*0.07,
                          child: ListTile(
                            leading: const Icon(Icons.logout,color: Colors.black),
                            title: const Text("Alarm"),
                            onTap:  () async {
                              await Alarm.init(showDebugLogs: true);
                              //     AlarmNotification.instance.scheduleAlarmNotif(id: 1, dateTime: DateTime.now(), title: "dgsd", body: "Zgzx", fullScreenIntent: true);
                              print("Alarm initialized");
                              print("setting alarm");
                              final alarmSettings = AlarmSettings(
                                id: 42,
                                dateTime: DateTime.now(),
                                assetAudioPath: 'assets/ringtones/male version.mp3',
                                loopAudio: false,
                                vibrate: true,
                                volumeMax: true,
                                fadeDuration: 3.0,
                                stopOnNotificationOpen: true,
                                androidFullScreenIntent: true,
                                notificationTitle: 'This is the title',
                                notificationBody: 'This is the body',
                                enableNotificationOnKill: true,

                              );
                              print("launching alarm");
                              Future(()=> Alarm.set(alarmSettings: alarmSettings));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    color:Colors.black,
                    thickness: 2,
                  ),

                ],
              ),
            ),
            Container(
              width:size.width*0.4,
              child: PageView(
                controller: page_controller,
                onPageChanged: (index){
                  setState(() {
                    curr_index=index;
                  });
                },
                children: [
                  const Assignment(),
                  const Notes(),
                  const NewPost(),
                  const OverAllLeaderBoard(),
                  Performance(),
                ],
              ),
            ),
            Container(
                color:Colors.grey[300],
                width:size.width*0.265,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    VerticalDivider(
                      color:Colors.black,
                      thickness:2,
                    ),
                    SizedBox(
                      width:size.width*0.25,
                        child: chatsystem()
                    ),
                  ],
                )
            ),
          ],
        ),
      )
      );
  }
}