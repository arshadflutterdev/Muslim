import 'dart:convert';
import 'dart:io';
import 'package:Muslim/Core/Const/app_fonts.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/HadeesinUrdu/Sunan_Ibn_e_Majah/ShowDetails/majah_detailed.dart';
import 'package:Muslim/Core/Services/ad_controller.dart';
import 'package:Muslim/Core/Widgets/TextFields/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/Sunan_Ibn_e_Majah/Models/sunan_ibn_e_majah_chapter_model.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/Sunan_Ibn_e_Majah/ShowDetails/majah_detailed.dart';

class IbneMajahUrdu extends StatefulWidget {
  const IbneMajahUrdu({super.key});

  @override
  State<IbneMajahUrdu> createState() => _IbneMajahUrduState();
}

class _IbneMajahUrduState extends State<IbneMajahUrdu> {
  List<Chapters> chaptersList = [];
  bool isLoading = true;
  bool hasError = false;
  Future<void> getDownloadChapters() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/ibn-e-majah.json");
      print("here is file path ${file.path}");

      final fileContant = await file.readAsString();

      final filedecode = jsonDecode(fileContant);
      final chaptersss = MajahChapterModel.fromJson(filedecode);
      setState(() {
        chaptersList = chaptersss.chapters ?? [];
        print("all chapters instance $chaptersList");
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      print("error regarding chapters ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    getDownloadChapters();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,

          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        backgroundColor: isLoading ? Colors.white : Colors.white,
        body: Builder(
          builder: (context) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            } else if (hasError) {
              return const Center(child: Text("No Internet Connection ❌"));
            } else if (chaptersList.isEmpty) {
              return const Center(child: Text("No chapters found"));
            }

            return ListView.builder(
              itemCount: chaptersList.length,
              itemBuilder: (context, index) {
                final chapter = chaptersList[index];
                return Card(
                  elevation: 3,
                  color: Colors.white,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MajahDetailedUrdu(
                            chapterIdss: chapter.chapterNumber,
                          ),
                        ),
                      );
                    },
                    title: Text(
                      chapter.chapterUrdu ?? "No name",
                      style: TextStyle(
                        fontFamily: AppFonts.urdufont,
                        fontSize: 20,
                        height: 2,
                      ),
                    ),
                    trailing: Text(
                      chapter.chapterNumber ?? '',
                      style: TextStyle(
                        fontFamily: AppFonts.arabicfont,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      onWillPop: () async {
        AdController().tryShowAd();
        return true;
      },
    );
  }
}
