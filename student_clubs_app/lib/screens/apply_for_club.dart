import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApplyForClub extends StatefulWidget {
  ApplyForClub({Key key}) : super(key: key);

  @override
  State<ApplyForClub> createState() => _ApplyForClubState();
}

class _ApplyForClubState extends State<ApplyForClub> {
  final imgUrl1 =
      "https://firebasestorage.googleapis.com/v0/b/student-clubs-aaae0.appspot.com/o/applyForClub%2FKulup_Danismani_Kabul_Formu_Ek2_NhXptQe.docx?alt=media&token=e5f58741-5482-4e4e-a0c0-c214f0712d36";

  final imgUrl2 =
      "https://firebasestorage.googleapis.com/v0/b/student-clubs-aaae0.appspot.com/o/applyForClub%2FTaahhutname_Ek3_7_kisi_hr59598.docx?alt=media&token=b0d22738-9f35-49bc-be95-db38b70f1d2a";

  var dio = Dio();

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.blue])),
      child: Scaffold(
        backgroundColor: Appcolors.transparent,
        appBar: AppBar(
          backgroundColor: Appcolors.mainColor,
          centerTitle: true,
          title: Text("Documents to Apply"),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainClubPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                FirebaseAuth.instance.currentUser().then((firebaseUser) {
                  if (firebaseUser == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  }
                });
              },
            ),
          ],
        ),
        body: Center(
            child: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolors.transparent,
                    border: Border.all(color: Appcolors.darkBlueColor)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "You need to download all the files below and fill them. "
                    "After that you have to give all the documents by hand to "
                    "SKS department inside the university "
                    " to be able to create a club. ",
                    style: TextStyle(color: Appcolors.textColor, fontSize: 25),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton.icon(
                  onPressed: () async {
                    String realpath =
                        await ExtStorage.getExternalStoragePublicDirectory(
                            ExtStorage.DIRECTORY_DOWNLOADS);
                    String fullPath =
                        realpath + "/klup_danisman_kabul_form.pdf";
                    print('full path ${fullPath}');

                    downloadClubFile(dio, imgUrl1, fullPath);
                  },
                  icon: Icon(
                    Icons.file_download,
                    color: Colors.white,
                  ),
                  color: Appcolors.darkBlueColor,
                  textColor: Colors.white,
                  label: Text('Download Kulup Danisman Kabul Formu')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton.icon(
                  onPressed: () async {
                    String realpath =
                        await ExtStorage.getExternalStoragePublicDirectory(
                            ExtStorage.DIRECTORY_DOWNLOADS);
                    //var tempDir = await getTemporaryDirectory();
                    String fullPath = realpath + "/taahhutname.pdf";
                    print('full path ${fullPath}');

                    downloadClubFile(dio, imgUrl2, fullPath);
                  },
                  icon: Icon(
                    Icons.file_download,
                    color: Colors.white,
                  ),
                  color: Appcolors.darkBlueColor,
                  textColor: Colors.white,
                  label: Text('Download Taahhutname')),
            )
          ],
        )),
      ),
    );
  }

  Future<void> downloadClubFile(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      print('Permission granted');
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future<String> _getPathToDownload() async {
    return await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
  }

  void requestPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }
}
