import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadSunanAnnasai {
  final String apiKey =
      "%242y%2410%24pk5MeOVosBVG5x5EgPZQOuYdd4Mo6JFFrVOT2z9xGA9oAO4eu6rte";

  Future<void> getDownload() async {
    try {
      final getresponse = await http.get(
        Uri.parse(
          "https://hadithapi.com/api/sunan-nasai/chapters?apiKey=$apiKey",
        ),
      );
      final responsedecode = jsonDecode(getresponse.body);
      final chapterlist = responsedecode["chapters"];
      if (getresponse.statusCode == 200) {
        for (var hadiths in chapterlist) {
          final chapterNo = hadiths["chapterNumber"];
          final hadithresponse = await http.get(
            Uri.parse(
              "https://hadithapi.com/api/hadiths/?book=sunan-nasai&chapter=$chapterNo&apiKey=$apiKey",
            ),
          );
          if (hadithresponse.statusCode == 200) {
            final haditdecode = jsonDecode(hadithresponse.body);
            hadiths["hadiths"] = haditdecode["hadiths"]["data"] ?? [];
          } else {
            throw Exception("Failed to fetch error");
          }
        }
      }
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/sunan-nasai.json");
      await file.writeAsString(
        jsonEncode({"book": "sunan-nasai", "chapters": chapterlist}),
      );
    } catch (e) {
      throw Exception("failed ${e.toString()}");
    }
  }
}
