import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constraints.dart';
import 'Top3_Leaderboard_tile.dart';

class IndividualAssignmentLeaderboard extends StatefulWidget {
  const IndividualAssignmentLeaderboard({super.key, required this.index, required this.subject});
  final int index;
  final String subject;
  @override
  State<IndividualAssignmentLeaderboard> createState() => _IndividualAssignmentLeaderboardState();
}

class _IndividualAssignmentLeaderboardState extends State<IndividualAssignmentLeaderboard> {
  List<Map<String,dynamic>>result=[];
  bool load = false;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      height:size.height*0.9,
      width:size.width*0.4,
      color:Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   leading: IconButton(
      //       onPressed: (){
      //         Navigator.pop(context);
      //       },
      //       icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,),
      //   ),
      // ),
      child: StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection("Assignment")
                .doc(
                "${usermodel["University"].split(" ")[0]} ${usermodel["College"].split(" ")[0]} ${usermodel["Course"].split(" ")[0]} ${usermodel["Branch"].split(" ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget.subject}"
            )
                .snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData && !load){
                calculateResult(snapshot);
                load=false;
              }

              return snapshot.hasData && load
                  ?
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    TopThree(
                      data: [
                        {
                          "Name" : result[0]['Name'],
                          "Email" : result[0]['Email'],
                          "Submitted" : result[0]['Score'],
                        },
                        {
                          "Name" : result[1]['Name'],
                          "Email" : result[1]['Email'],
                          "Submitted" : result[1]['Score'],
                        },
                        {
                          "Name" : result[2]['Name'],
                          "Email" : result[2]['Email'],
                          "Submitted" : result[2]['Score'],
                        }
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       children: [
                    //         AutoSizeText("Average Submission/Assignment: ",
                    //           style: GoogleFonts.tiltNeon(
                    //               color: Colors.black,
                    //               fontSize: size.width*0.05
                    //           ),),
                    //         AutoSizeText("$averageSubmission",
                    //           style: GoogleFonts.tiltNeon(
                    //               color: Colors.green[900],
                    //               fontSize: size.width*0.06
                    //           ),),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: size.height * 0.022,
                    ),
                    Column(
                        children: [
                          SizedBox(
                              height: size.height * 0.45,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: result.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(size.height * 0.008),
                                    child: SizedBox(
                                      height: size.height * 0.08,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.02,
                                            child: Center(
                                                child: AutoSizeText(
                                                    "${index+1}",
                                                    style: GoogleFonts.tiltNeon(
                                                        fontSize: size.height*0.03,
                                                        color: Colors.black
                                                    )
                                                )),
                                          ),
                                          Container(
                                            height: size.height * 0.07,
                                            width: size.width * 0.36,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black,width: 1.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(size.width * 0.08)),
                                              color: result[index]["Score"]*2 < snapshot.data!.data()?["Total_Assignment"] ? Colors.red[400] : Colors.green,
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                  EdgeInsets.all(size.height * 0.006),
                                                  child: StreamBuilder(
                                                      stream: FirebaseFirestore.instance.collection("Students").doc(result[index]["Email"]).snapshots(),
                                                      builder: (context, studentsnapshot) {
                                                        return studentsnapshot.hasData
                                                            ?
                                                        CircleAvatar(
                                                            radius: size.width * 0.013,
                                                            backgroundColor: Colors.green[900],
                                                            child:  studentsnapshot.data!.data()?["Profile_URL"] !="null" && studentsnapshot.data!.data()?["Profile_URL"] != null
                                                                ?
                                                            CircleAvatar(
                                                              radius: size.width * 0.012,
                                                              backgroundImage: NetworkImage(studentsnapshot.data!.data()?["Profile_URL"]),
                                                            )
                                                                :
                                                            CircleAvatar(
                                                              radius: size.width * 0.012,
                                                              backgroundImage: const AssetImage("assets/images/unknown.png"),
                                                            )
                                                        )
                                                            :
                                                        const SizedBox();
                                                      }
                                                  ),
                                                ),
                                                Expanded(
                                                    child:Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        AutoSizeText(
                                                          result[index]["Name"],
                                                          style: GoogleFonts.tiltNeon(
                                                              color: Colors.black,
                                                              fontSize: size.width * 0.011),
                                                          maxLines: 1,
                                                          textAlign: TextAlign.left,
                                                        ),
                                                        AutoSizeText(
                                                          result[index]["Rollnumber"],
                                                          style: GoogleFonts.tiltNeon(
                                                              color: Colors.black,
                                                              fontSize: size.width * 0.01),
                                                          maxLines: 1,
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      ],
                                                    )
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },

                              )
                          ),
                        ])
                  ],
                ),
              )
                  :
              SizedBox(
                height: size.height*0.9,
                width: size.width*0.4,
                child: Center(
                  child: AutoSizeText(
                    "You did not uploaded a single assignment till now.\nPlease upload the assignment.",
                    style: GoogleFonts.tiltNeon(
                        fontSize: 20,
                        color: Colors.black
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
        ),
    );
  }



  calculateResult(AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) async {
    result.clear();
    final allStudentsdata = await FirebaseFirestore.
    instance.
    collection("Students").
    where("Subject", arrayContains: widget.subject).
    where("University",isEqualTo: usermodel["University"]).
    where("Year",isEqualTo: usermodel["Year"]).
    where("Branch",isEqualTo: usermodel["Branch"]).
    where("College",isEqualTo: usermodel["College"]).
    where("Section",isEqualTo: usermodel["Section"]).
    where("Course",isEqualTo: usermodel["Course"]).
    get();
    for(var email in  allStudentsdata.docs)
    {
      Map<String,dynamic>data={};
      data["Name"]=email.data()["Name"];
      data["Rollnumber"]=email.data()["Rollnumber"];
      data["Email"]=email.data()["Email"];
      data["Score"]=0;
      data["Quiz-Time"]= Timestamp.fromMicrosecondsSinceEpoch(10000000) ;
      Timestamp x = Timestamp(10, 10);
      print("...............;;;;;;;;;;;;;; ${widget.index}");
      if(snap.data!.data()?["Assignment-${widget.index+1}"]["Submitted-by"].contains(email.data()['Email']) && snap.data!.data()?["Assignment-${widget.index+1}"]["submitted-Assignment"][email.data()['Email'].toString().split('@')[0]]['Status'] == "Accepted"){
        data["Score"]=1;
        data["Quiz-Time"]= snap.data!.data()?["Assignment-${widget.index+1}"]["submitted-Assignment"][email.data()['Email'].toString().split('@')[0]]['Time'];
      }
      result.add(data);
    }
    sortResult();
    setState(() {
      load=true;
    });
  }


  sortResult(){
    print("before: $result");
    result.sort((a, b) {
      print("a,b : $a $b");
      print("Compared ${a["Score"].compareTo(b["Score"])}");
      return a["Score"].compareTo(b["Score"]);
    },
    );
    result.sort((a,b) {
      if(a["Score"]==b["Score"])
      {
        return a["Quiz-Time"].millisecondsSinceEpoch.compareTo(b["Quiz-Time"].millisecondsSinceEpoch);
      }
      else{
        return 0;
      }
    });
    result.sort((a,b) {
      if(a["Quiz-Time"]==b["Quiz-Time"])
      {
        return a["Rollnumber"].compareTo(b["Rollnumber"]);
      }
      else{
        return 0;
      }
    });
    result=result.reversed.toList();
    print(result);
  }
}
