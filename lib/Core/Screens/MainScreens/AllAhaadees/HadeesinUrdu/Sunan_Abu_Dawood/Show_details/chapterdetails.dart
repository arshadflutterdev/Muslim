import 'dart:convert';
import 'dart:io';
import 'package:Muslim/Core/Const/app_fonts.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/HadeesinUrdu/Sunan_Abu_Dawood/Show_details/sunan_hadith_details.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/Sunan_Abu_Dawood/Models/chapters_model.dart';

import 'package:Muslim/Core/Services/ad_controller.dart';
import 'package:Muslim/Core/Widgets/TextFields/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SunanChapterDetailsUrdu extends StatefulWidget {
  const SunanChapterDetailsUrdu({super.key});

  @override
  State<SunanChapterDetailsUrdu> createState() =>
      _SunanChapterDetailsUrduState();
}

class _SunanChapterDetailsUrduState extends State<SunanChapterDetailsUrdu> {
  List<Chapters> chapterList = [];
  bool isLoading = true;
  bool hasError = false;
  Future<void> getdownloadedChapters() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/abu-dawood.json");
      final fileContant = await file.readAsString();
      final chaptersss = jsonDecode(fileContant);
      final chapterssList = SunanChapters.fromJson(chaptersss);
      setState(() {
        chapterList = chapterssList.chapters ?? [];
        print("here is All chapters $chapterList");
        isLoading = false;
        // hasError = true;
      });
    } catch (e) {
      throw Exception("Failed to fetch data ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    getdownloadedChapters();
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
        backgroundColor: Colors.white,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
            : hasError
            ? const Center(child: Text("No Internet Connection ❌"))
            : chapterList.isEmpty
            ? const Center(child: Text("No chapters available"))
            : ListView.builder(
                itemCount: chapterList.length,
                itemBuilder: (context, index) {
                  final chapter = chapterList[index];
                  return Card(
                    elevation: 3,
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SunanHadithDetailsUrdu(
                              chapterno: chapter.chapterNumber ?? '',
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
              ),
      ),
      onWillPop: () async {
        AdController().tryShowAd();
        return true;
      },
    );
  }
}
