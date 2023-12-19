import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class DownloadButton extends StatefulWidget {
  DownloadButton({Key? key,required this.downloadUrl,required this.pdfName,required this.path}) : super(key: key);
  String downloadUrl;
  String pdfName;
  String path;
  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  final dio=Dio();
  double percent=0.0;
  bool isDownloading=false;
  bool isDownloaded=true;
  String? systempath='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      height: size.height*0.045,
      width: size.height*0.045,
      decoration: const BoxDecoration(
          shape: BoxShape.circle
      ),
      child: isDownloaded
          ?
      isDownloading
          ?
      Center(
        child: Center(
          child: CircularPercentIndicator(
            percent: percent,
            radius: size.width*0.045,
            animation: true,
            linearGradient: const LinearGradient(

                colors: [
                  //Colors.lightGreenAccent,
                  CupertinoColors.activeGreen,
                  CupertinoColors.activeGreen,
                  CupertinoColors.activeGreen,
                  Colors.red,
                  Colors.red,
                  Colors.deepOrange,

                  Colors.orangeAccent,

                ]),
            animateFromLastPercent: true,
            curve: accelerateEasing,
            //progressColor: Colors.green,
            center: Text("${(percent*100).toDouble().toStringAsFixed(0)}%",style: GoogleFonts.openSans(fontSize: size.height*0.014),),
            //footer: const Text("Downloading"),
            backgroundColor: Colors.transparent,
          ),
        ),
      )
          :
      InkWell(
          onTap: () async {
              downloadFile(widget.downloadUrl);
            }
          ,
          child: SizedBox(
              width: size.height*0.045,
              height: size.height*0.045,
              child: Image.asset("assets/images/download.png",fit: BoxFit.contain)))
          :
      const SizedBox(),
    );
  }
  void downloadFile(String url) {
    html.AnchorElement anchorElement =  new html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }
}