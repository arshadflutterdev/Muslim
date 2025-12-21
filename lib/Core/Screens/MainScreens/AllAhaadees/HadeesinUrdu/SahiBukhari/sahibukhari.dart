import 'dart:convert';
import 'dart:io';
import 'package:Muslim/Core/Const/app_fonts.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/HadeesinUrdu/SahiBukhari/hadithDetails.dart';
import 'package:Muslim/Core/Services/ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Muslim/Core/Screens/MainScreens/AllAhaadees/SahihMuslim/sahmuslim_chapters_model.dart';

class BukhariUrdu extends StatefulWidget {
  final String title;
  const BukhariUrdu({super.key, required this.title});

  @override
  State<BukhariUrdu> createState() => _BukhariUrduState();
}

class _BukhariUrduState extends State<BukhariUrdu> {
  List<Chapters> chaptersList = [];

  bool isLoading = true;
  bool hasError = false;
  Future<void> loadofflinechapters() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/sahih-bukhari.json");
      if (file.existsSync()) {
        final fileContent = await file.readAsString();
        final jsonData = jsonDecode(fileContent);
        final chapterData = Sahimuslimchapterlist.fromJson(jsonData);
        setState(() {
          chaptersList = chapterData.chapters ?? [];

          print(chaptersList);

          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      hasError = true;
      isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadofflinechapters();
    // loadChapters();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
            : hasError
            ? const Center(child: Text("Error loading chapters"))
            : chaptersList.isEmpty
            ? const Center(child: Text("No chapters found"))
            : ListView.builder(
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
                            builder: (context) => HadithdetailsUrdu(
                              ChapterId: chapter.id.toString(),
                            ),
                          ),
                        );
                      },
                      title: Text(
                        chapter.chapterUrdu ?? '',
                        style: TextStyle(
                          fontFamily: AppFonts.urdufont,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Text(
                        chapter.chapterNumber ?? "No name",
                        style: TextStyle(
                          fontFamily: AppFonts.arabicfont,
                          fontSize: 18,
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
