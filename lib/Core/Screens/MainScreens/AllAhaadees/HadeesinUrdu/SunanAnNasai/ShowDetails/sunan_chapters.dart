import 'dart:convert';
import 'dart:io';
import 'package:Muslim/Core/Const/app_fonts.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/HadeesinUrdu/SunanAnNasai/ShowDetails/sunananasai_hadith_details.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/SunanAnNasai/Models/sunananasai_chapter_model.dart';
import 'package:Muslim/Core/Services/ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SunanChaptersssUrdu extends StatefulWidget {
  const SunanChaptersssUrdu({super.key});

  @override
  State<SunanChaptersssUrdu> createState() => _SunanChaptersssUrduState();
}

class _SunanChaptersssUrduState extends State<SunanChaptersssUrdu> {
  List<Chapters> chapterList = [];
  bool isLoading = true;
  bool hasError = false;
  Future<void> getDownloadedChapterss() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/sunan-nasai.json");
      if (file.existsSync()) {
        final fileContant = await file.readAsString();
        final fileChapters = jsonDecode(fileContant);
        final chaptersss = SunanAnNasaiChapterModel.fromJson(fileChapters);
        setState(() {
          chapterList = chaptersss.chapters ?? [];
          isLoading = false;
        });
      } else {
        print("there is no file exists");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      print("error related ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    getDownloadedChapterss();
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
            ? const Center(child: Text("No chapters found"))
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
                            builder: (context) => SunananasaiHadithDetailsUrdu(
                              chapterno: chapter.chapterNumber,
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
