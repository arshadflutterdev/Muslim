import 'dart:convert';

import 'package:http/http.dart' as http;

class DownloadSunanAnnasai {
  final String apiKey =
      "%242y%2410%24pk5MeOVosBVG5x5EgPZQOuYdd4Mo6JFFrVOT2z9xGA9oAO4eu6rte";

  Future<void> getDownload() async {
    final getresponse = await http.get(
      Uri.parse(
        "https://hadithapi.com/api/sunan-nasai/chapters?apiKey=$apiKey",
      ),
    );
    if (getresponse.statusCode == 200) {
      final responsedecode = jsonDecode(getresponse.body);
      final chapterlist = responsedecode["chapters"];
      for (var hadiths in chapterlist) {
        final chapterNo = hadiths["chapterNumber"];
        final hadithresponse = await http.get(
          Uri.parse(
            "https://hadithapi.com/api/hadiths/?book=sunan-nasai&chapter=$chapterNo&apiKey=$apiKey",
          ),
        );
        if (hadithresponse.statusCode == 200) {
          final haditdecode = jsonDecode(hadithresponse.body);
          hadiths["hadiths"] = haditdecode["hadiths"]["data"];
        } else {
          throw Exception("Failed to fetch error");
        }
      }
    }
  }
}
