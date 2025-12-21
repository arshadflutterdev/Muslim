import 'dart:convert';
import 'dart:io';
import 'package:Muslim/Core/Const/app_fonts.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/Sunan_Abu_Dawood/Models/chapters_model.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/Sunan_Abu_Dawood/Show_details/sunan_hadith_details.dart';
import 'package:Muslim/Core/Services/ad_controller.dart';
import 'package:Muslim/Core/Widgets/TextFields/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SunanChapterDetails extends StatefulWidget {
  const SunanChapterDetails({super.key});

  @override
  State<SunanChapterDetails> createState() => _SunanChapterDetailsState();
}

class _SunanChapterDetailsState extends State<SunanChapterDetails> {
  List<Chapters> chapterList = [];

  bool isLoading = false;
  bool hasError = false;
  //function to loadOffline chapterss
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
            ? const Center(child: Text("Failed to fetch"))
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
                            builder: (context) => SunanHadithDetails(
                              chapterno: chapter.chapterNumber ?? '',
                            ),
                          ),
                        );
                      },
                      title: Text(
                        chapter.chapterEnglish ?? "No name",
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        chapter.chapterNumber ?? '',
                        style: TextStyle(
                          fontFamily: AppFonts.arabicfont,
                          fontSize: 20,
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
