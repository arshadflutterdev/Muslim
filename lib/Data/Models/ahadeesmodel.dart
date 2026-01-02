// class Hadithnamesss {
//   int? status;
//   String? message;
//   List<Books>? books;

//   Hadithnamesss({this.status, this.message, this.books});

//   Hadithnamesss.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['books'] != null) {
//       books = <Books>[];
//       json['books'].forEach((v) {
//         books!.add(new Books.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.books != null) {
//       data['books'] = this.books!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Books {
//   int? id;
//   String? bookName;
//   String? writerName;
//   String? aboutWriter;
//   String? writerDeath;
//   String? bookSlug;
//   String? hadithsCount;
//   String? chaptersCount;

//   Books({
//     this.id,
//     this.bookName,
//     this.writerName,
//     this.aboutWriter,
//     this.writerDeath,
//     this.bookSlug,
//     this.hadithsCount,
//     this.chaptersCount,
//   });

//   Books.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     bookName = json['bookName'];
//     writerName = json['writerName'];
//     aboutWriter = json['aboutWriter'];
//     writerDeath = json['writerDeath'];
//     bookSlug = json['bookSlug'];
//     hadithsCount = json['hadiths_count'];
//     chaptersCount = json['chapters_count'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['bookName'] = this.bookName;
//     data['writerName'] = this.writerName;
//     data['aboutWriter'] = this.aboutWriter;
//     data['writerDeath'] = this.writerDeath;
//     data['bookSlug'] = this.bookSlug;
//     data['hadiths_count'] = this.hadithsCount;
//     data['chapters_count'] = this.chaptersCount;
//     return data;
//   }
// }
class Hadithnamesss {
  int? status;
  String? message;
  List<Books>? books;

  Hadithnamesss({this.status, this.message, this.books});

  Hadithnamesss.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(Books.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (books != null) {
      data['books'] = books!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Books {
  int? id;
  String? bookName;
  String? writerName;
  String? aboutWriter;
  String? writerDeath;
  String? bookSlug;
  String? hadithsCount;
  String? chaptersCount;
  List<Chapters>? chapters; // updated

  Books({
    this.id,
    this.bookName,
    this.writerName,
    this.aboutWriter,
    this.writerDeath,
    this.bookSlug,
    this.hadithsCount,
    this.chaptersCount,
    this.chapters,
  });

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookName = json['bookName'];
    writerName = json['writerName'];
    aboutWriter = json['aboutWriter'];
    writerDeath = json['writerDeath'];
    bookSlug = json['bookSlug'];
    hadithsCount = json['hadiths_count'];
    chaptersCount = json['chapters_count'];

    // ✅ Populate chapters list if available
    if (json['chapters'] != null) {
      chapters = <Chapters>[];
      json['chapters'].forEach((v) {
        chapters!.add(Chapters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bookName'] = bookName;
    data['writerName'] = writerName;
    data['aboutWriter'] = aboutWriter;
    data['writerDeath'] = writerDeath;
    data['bookSlug'] = bookSlug;
    data['hadiths_count'] = hadithsCount;
    data['chapters_count'] = chaptersCount;

    // ✅ Save chapters list
    if (chapters != null) {
      data['chapters'] = chapters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chapters {
  int? id;
  String? chapterNumber;
  String? chapterEnglish;
  String? chapterUrdu;
  String? chapterArabic;
  String? bookSlug;

  Chapters({
    this.id,
    this.chapterNumber,
    this.chapterEnglish,
    this.chapterUrdu,
    this.chapterArabic,
    this.bookSlug,
  });

  Chapters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapterNumber = json['chapterNumber'];
    chapterEnglish = json['chapterEnglish'];
    chapterUrdu = json['chapterUrdu'];
    chapterArabic = json['chapterArabic'];
    bookSlug = json['bookSlug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['chapterNumber'] = chapterNumber;
    data['chapterEnglish'] = chapterEnglish;
    data['chapterUrdu'] = chapterUrdu;
    data['chapterArabic'] = chapterArabic;
    data['bookSlug'] = bookSlug;
    return data;
  }
}
