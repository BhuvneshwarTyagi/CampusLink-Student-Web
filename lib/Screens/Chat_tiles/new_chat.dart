import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Constraints.dart';
import 'package:campus_link_student/Screens/Chat_tiles/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_list.dart';

class ChatSection extends StatefulWidget {
  const ChatSection({super.key, required this.channel});
  final String channel;
  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  String channel="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      channel=widget.channel;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children:[
          Container(
              color:Colors.grey[300],
              width:size.width*0.265,
              child: SizedBox(
                  width:size.width*0.25,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Students").doc(usermodel["Email"]).snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                      ?
                      ListView.builder(
                        itemCount: snapshot.data!.data()?["Message_channels"].length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: size.height*0.11,
                            width: size.width*0.25,
                            child: StreamBuilder(
                                stream: FirebaseFirestore
                                    .instance
                                    .collection("Messages")
                                    .doc(usermodel["Message_channels"][index])
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  print(">>>>>>>>>>>>>>>>>>>>>chat list");
                                  int readCount=0;
                                  int count=0;
                                  String Name='',profileUrl="";
                                  if(snapshot.hasData){

                                    readCount= snapshot.data?.data()!["Messages"].length;
                                    count= int.parse("${snapshot.data?.data()![usermodel["Email"].toString().split("@")[0]]["Read_Count"]}");
                                    if(snapshot.data!.data()!["Type"] == "Personal"){
                                      if(snapshot.data!.data()!["Members"][0]==usermodel["Email"]){
                                        Name=snapshot.data!.data()![snapshot.data!.data()!["Members"][1].toString().split("@")[0]]["Name"];
                                        profileUrl=snapshot.data!.data()![snapshot.data!.data()!["Members"][1].toString().split("@")[0]]["Profile_URL"].toString();
                                      }
                                      else{
                                        Name=snapshot.data!.data()![snapshot.data!.data()!["Members"][0].toString().split("@")[0]]["Name"];
                                        profileUrl=snapshot.data!.data()![snapshot.data!.data()!["Members"][0].toString().split("@")[0]]["Profile_URL"] ?? "";
                                      }
                                    }
                                  }
                                  return snapshot.hasData
                                      ?
                                  snapshot.data!.data()!["Type"] == "Personal"
                                      ?
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        usermodel["Message_channels"][index];
                                      });
                                    },
                                    child: SizedBox(
                                        height: size.height*0.11,
                                        child:  Card(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width:size.width*0.005,
                                              ),
                                              CircleAvatar(
                                                backgroundColor: const Color.fromRGBO(86, 149, 178, 1),
                                                radius: size.width*0.015,
                                                backgroundImage: (profileUrl != "null" || profileUrl!="") ? NetworkImage(profileUrl) : null,
                                                child: (profileUrl == "null" || profileUrl == "")
                                                    ?
                                                AutoSizeText(
                                                  Name.substring(0,1),
                                                  style: GoogleFonts.aBeeZee(
                                                      color: Colors.black,
                                                      fontSize: size.height * 0.035,
                                                      fontWeight: FontWeight.w600),
                                                )
                                                    : null,
                                              ),
                                              SizedBox(width: size.width*0.005),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    Name,
                                                    style: GoogleFonts.aBeeZee(color: Colors.black,fontSize: size.width*0.012,fontWeight: FontWeight.w600),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: size.width*0.2,
                                                        child: AutoSizeText("${
                                                            snapshot.data?.data()!["Messages"].length >0
                                                                ?
                                                            snapshot.data!.data()!["${snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["UID"].toString().split("@")[0]}"]['Name']
                                                                :
                                                            ""
                                                        } : ${
                                                            snapshot.data?.data()!["Messages"].length > 0
                                                                ?
                                                            snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].length <25 ? snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"] : snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].toString().substring(0,25)
                                                                :
                                                            ""
                                                        }",
                                                          style: GoogleFonts.aBeeZee(
                                                              color: Colors.black.withOpacity(0.80),
                                                              fontSize: size.height*0.02,
                                                              fontWeight: FontWeight.w500
                                                          ),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      ),
                                                      readCount - count>0
                                                          ?
                                                      CircleAvatar(
                                                        radius: size.width*0.008,
                                                        backgroundColor: Colors.green,
                                                        child: AutoSizeText("${readCount - count}",
                                                          style: GoogleFonts.aBeeZee(
                                                              color: Colors.white,
                                                              fontSize: size.height*0.01,
                                                              fontWeight: FontWeight.w500
                                                          ),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      )
                                                          :
                                                      const SizedBox(),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                    ),
                                  )
                                      :
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        usermodel["Message_channels"][index];
                                      });
                                    },
                                    child: SizedBox(
                                      height: size.height*0.11,
                                      child: Card(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width:size.width*0.005,
                                            ),
                                            CircleAvatar(
                                              backgroundColor: const Color.fromRGBO(86, 149, 178, 1),
                                              radius: size.width*0.015,
                                              backgroundImage: snapshot.data!.data()!["image_URL"]!="null"? NetworkImage(snapshot.data!.data()!["image_URL"]) : null,
                                              child: snapshot.data?.data()!["image_URL"] == "null"
                                                  ?
                                              AutoSizeText(
                                                usermodel["Message_channels"][index].toString().split(" ")[6].substring(0, 1),
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black,
                                                    fontSize: size.height * 0.035,
                                                    fontWeight: FontWeight.w600),
                                              )
                                                  : null,
                                            ),

                                            SizedBox(width: size.width*0.005),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  usermodel["Message_channels"][index],
                                                  style: GoogleFonts.aBeeZee(color: Colors.black,fontSize: size.width*0.012,fontWeight: FontWeight.w600),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width*0.15,
                                                      child: AutoSizeText("${
                                                          snapshot.data?.data()!["Messages"].length >0
                                                              ?
                                                          snapshot.data!.data()!["${snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["UID"].toString().split("@")[0]}"]['Name']
                                                              :
                                                          ""
                                                      } : ${
                                                          snapshot.data?.data()!["Messages"].length > 0
                                                              ?
                                                          snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].length <25 ? snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"] : snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].toString().substring(0,20)
                                                              :
                                                          ""
                                                      }",
                                                        style: GoogleFonts.aBeeZee(
                                                            color: Colors.black.withOpacity(0.80),
                                                            fontSize: size.height*0.02,
                                                            fontWeight: FontWeight.w500
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    readCount - count>0
                                                        ?
                                                    CircleAvatar(
                                                      radius: size.width*0.008,
                                                      backgroundColor: Colors.green,
                                                      child: AutoSizeText("${readCount - count}",
                                                        style: GoogleFonts.aBeeZee(
                                                            color: Colors.white,
                                                            fontSize: size.height*0.01,
                                                            fontWeight: FontWeight.w500
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    )
                                                        :
                                                    const SizedBox(),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                      :
                                  const CircularProgressIndicator(color: Colors.amber,);
                                }
                            ),
                          );
                        }, )
                      :
                      SizedBox();
                    }
                  )
              )
          ),
          Expanded(
              child: ChatPage(channel: channel))

        ]
      )
    );
  }
}
