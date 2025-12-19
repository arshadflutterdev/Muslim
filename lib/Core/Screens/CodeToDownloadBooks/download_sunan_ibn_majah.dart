import 'dart:convert';

import 'package:http/http.dart' as http;

class DownloadSunanIbnMajah {
  final String apiKey =
      "%242y%2410%24pk5MeOVosBVG5x5EgPZQOuYdd4Mo6JFFrVOT2z9xGA9oAO4eu6rte";

  Future<void> getdownloadbook() async {
    final getresponse = await http.get(
      Uri.parse(
        "https://hadithapi.com/api/ibn-e-majah/chapters?apiKey=%242y%2410%24pk5MeOVosBVG5x5EgPZQOuYdd4Mo6JFFrVOT2z9xGA9oAO4eu6rte",
      ),
    );
    if (getresponse.statusCode == 200) {
      final responsedecode = jsonDecode(getresponse.body);
      final chapterlist = responsedecode["chapters"] ?? [];
      for (var hadiths in chapterlist) {
        final chapterno = hadiths["chapterNumber"];
        final hadithresponse = await http.get(
          Uri.parse(
            "https://hadithapi.com/api/hadiths/?book=ibn-e-majah&chapter=$chapterno&apiKey=$apiKey",
          ),
        );
        if (hadithresponse.statusCode == 200) {
          final haditdecode = jsonDecode(hadithresponse.body);

          hadiths["hadiths"] = haditdecode["hadiths"]["data"];
        } else {
          throw Exception("Failed to fetch all details");
        }
      }
    }
  }
}
