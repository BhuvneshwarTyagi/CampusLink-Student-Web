import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_student/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../../Constraints.dart';

class uploadAssignment extends StatefulWidget {
  const uploadAssignment(
      {super.key,
        required this.selectedSubject,
        required this.assignmentNumber, required this.totalSubmittedAssignment});
  final String selectedSubject;
  final int assignmentNumber;
  final int totalSubmittedAssignment;
  @override
  State<uploadAssignment> createState() => _uploadAssignmentState();
}

class _uploadAssignmentState extends State<uploadAssignment> {
  late final FilePickerResult? filePath;
  bool fileSelected = false;



  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return ListTile(
      onTap: (){
          showDialog(
            context: context, builder: (context) {
            return Dialog(
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width*0.02),
                side: BorderSide(
                  color: Colors.black,
                  width: size.width*0.002,
                ),
              ),
              child: Card(
                // elevation:30,
                // shadowColor: Colors.black,
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.width*0.02),
                ),
                child: Container(
                  width:size.width*0.5,
                  height:size.height*0.6,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width*0.02),
                    color:Colors.white,
                  ),
                  // appBar: AppBar(
                  //   leading: IconButton(onPressed: () {
                  //     Navigator.pop(context);
                  //   }, icon: const Icon(Icons.arrow_back_ios)),
                  // ),
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child:
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.all(size.height * 0.015),
                          child: Row(
                            children: [
                              AutoSizeText(
                                "Upload File",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: size.width*0.018,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              const Icon(
                                Icons.cloud_upload,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: size.height * 0.1,
                                width: size.width*0.3,
                                child: DottedBorder(
                                    color: Colors.black,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(12),
                                    padding: EdgeInsets.all(size.height * 0.01),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          size: size.height * 0.04,
                                          Icons.upload_sharp,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.03,
                                        ),
                                        AutoSizeText(
                                          "Drop item here  or",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: size.height * 0.02,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await FilePicker.platform
                                                .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: ['pdf'],
                                                allowMultiple: false)
                                                .then((value) {
                                              if (value!.files[0].path!.isNotEmpty) {
                                                filePath = value;
                                                print(
                                                    ".......PickedFile${filePath?.files[0]
                                                        .path}");
                                                setState(() {
                                                  fileSelected = true;
                                                });
                                              }
                                            });
                                          },
                                          child: AutoSizeText(
                                            "Browse File",
                                            style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        fileSelected
                                            ? Icon(
                                          size: size.height * 0.02,
                                          Icons.check_circle,
                                          color: Colors.green.shade800,
                                        )
                                            : const SizedBox()
                                      ],
                                    ))),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.06,
                        ),
                        Center(
                          child: Container(
                            height: size.height * 0.06,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(size.width * 0.033)),
                                border: Border.all(color: Colors.black, width: 2)),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent),
                              onPressed: () async {
                                if (fileSelected) {
                                  Navigator.push(context, PageTransition(
                                      child: const loading(
                                          text: "Please Wait Data is Uploading...."),
                                      type: PageTransitionType.bottomToTop),);
                                  Reference ref = FirebaseStorage.instance
                                      .ref("Student_Assignment")
                                      .child(
                                      "${usermodel["University"].split(
                                          " ")[0]} ${usermodel["College"].split(
                                          " ")[0]} ${usermodel["Course"].split(
                                          " ")[0]} ${usermodel["Branch"].split(
                                          " ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget
                                          .selectedSubject}");
                                  DateTime stamp = DateTime.now();
                                  Reference filename = ref.child("$stamp");
                                  TaskSnapshot snap = await filename
                                      .putFile(File("${filePath!.files[0].path}"));
                                  String pdfURL = " ";
                                  await snap.ref
                                      .getDownloadURL()
                                      .then((value) => pdfURL = value)
                                      .whenComplete(() {
                                    FirebaseFirestore.instance
                                        .collection("Assignment")
                                        .doc(
                                        "${usermodel["University"].split(
                                            " ")[0]} ${usermodel["College"].split(
                                            " ")[0]} ${usermodel["Course"].split(
                                            " ")[0]} ${usermodel["Branch"].split(
                                            " ")[0]} ${usermodel["Year"]} ${usermodel["Section"]} ${widget
                                            .selectedSubject}")
                                        .update({
                                      "Total_Submitted_Assignment":{
                                        usermodel["Email"]
                                            .toString()
                                            .split("@")[0]: FieldValue.increment(1),
                                      },
                                      "Assignment-${widget.assignmentNumber}.Submitted-by":
                                      FieldValue.arrayUnion([
                                        "${usermodel["Email"]}"
                                      ]),
                                      "Assignment-${widget
                                          .assignmentNumber}.submitted-Assignment.${usermodel["Email"]
                                          .toString()
                                          .split("@")[0]}":
                                      {
                                        "Document_Type": filePath?.files[0].extension,
                                        "File_Size": filePath?.files[0].size,
                                        "Time": stamp,
                                        "Status": "Pending",
                                        "PdfUrl": pdfURL,
                                        "Name": usermodel["Name"],
                                        "Roll-No": usermodel["Rollnumber"],
                                      }
                                    }).whenComplete(() {
                                      print("Completed");
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }


                                    );
                                  }
                                  );
                                }
                                else {
                                  InAppNotifications.instance
                                    ..titleFontSize = 14.0
                                    ..descriptionFontSize = 14.0
                                    ..textColor = Colors.black
                                    ..backgroundColor =
                                    const Color.fromRGBO(150, 150, 150, 1)
                                    ..shadow = true
                                    ..animationStyle =
                                        InAppNotificationsAnimationStyle.scale;
                                  InAppNotifications.show(
                                      title: 'Failed',
                                      duration: const Duration(seconds: 2),
                                      description: "Please Select the File",
                                      leading: const Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.red,
                                        size: 20,
                                      ));
                                }
                              },
                              child: AutoSizeText(
                                "Submit",
                                style: GoogleFonts.openSans(
                                    fontSize: size.height * 0.025,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),

                      ]),
                    ),
                  ),
                ),
            );
          },);
        },
      title: AutoSizeText(
            "Submit",
            style: GoogleFonts.courgette(
                fontSize:
                size.width * 0.013)

        ),
      leading: SizedBox(
        height:size.height*0.05,
        width: size.width*0.03,
        child: Image.asset("assets/images/upload-icon.png"),
      ),
      trailing: AutoSizeText(
          "${widget.totalSubmittedAssignment}",
          style: GoogleFonts.courgette(
              fontSize:
              size.width * 0.015,
          color:Colors.black)

      ),
    );
  }
}
