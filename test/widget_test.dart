import 'dart:convert';
// // import 'package:alquran_app/app/data/models/detail_surah.dart';
// // import 'package:alquran_app/app/data/models/surah.dart';
// import 'package:alquran_app/app/data/models/detail_surah.dart';
// // import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// // import 'package:alquran_app/app/data/models/detail_ayat.dart';

// // // void main() async {
// // //   Uri urlSurah = Uri.parse("https://api.quran.gading.dev/surah");
// // //   var responseSurah = await http.get(urlSurah);

// // //   List data = (json.decode(responseSurah.body) as Map<String, dynamic>)["data"];

// // //   // print(data[113]["number"]);

// // //   // data dari api (raw data) -> Model (yang sudah disiapkan)

// // //   Surah surahAnnas = Surah.fromJson(data[113]);

// // //   // print(surahAnnas.name?.short); // ini coba masuk ke nested model
// // //   // print(surahAnnas.number);
// // //   // print(surahAnnas.numberOfVerses);
// // //   // print(surahAnnas.revelation.id);
// // //   // print(surahAnnas.sequence);
// // //   // print(surahAnnas.tafsir.id);
// // //   // print(surahAnnas.toJson()); // untuk print semuanya

// // //   // print("____________");

// // //   // Uri urlAnnas =
// // //   //     Uri.parse("https://api.quran.gading.dev/surah/${surahAnnas.number}");
// // //   // var resAnnas = await http.get(urlAnnas);

// // //   // Map<String, dynamic> dataAnnas =
// // //       // (json.decode(resAnnas.body) as Map<String, dynamic>)["data"];

// // //   // DetailSurah annas = DetailSurah.fromJson(dataAnnas);

// // //   // print(annas.name);
// // //   // print(annas.verses![0].text!.arab);
// // // }

// // void main() async {
// //   var res =
// //       await http.get(Uri.parse("https://api.quran.gading.dev/surah/108/1"));
// //   Map<String, dynamic> data = json.decode(res.body)["data"];
// //   Map<String, dynamic> dataToModel = {
// //     "number": data["number"],
// //     "meta": data["meta"],
// //     "text": data["text"],
// //     "translation": data["translation"],
// //     "audio": data["audio"],
// //     "tafsir": data["tafsir"]
// //   };
// //   if (kDebugMode) {
// //     print(dataToModel);
// //   }

// //   // convert Map -> Model Ayat

// //   DetailAyat ayat = DetailAyat.fromJson(dataToModel);

// //   if (kDebugMode) {
// //     print(ayat.tafsir?.id?.short);
// //   }
// // }

// // List<Map<String, dynamic>>

// void main() async {
//   int juz = 1;

//   List<Map<String, dynamic>> penampungAyat = [];
//   List<Map<String, dynamic>> allJuz = [];
//   for (var i = 0; i <= 114; i++) {
//     Uri url = Uri.parse("https://api.quran.gading.dev/surah/$i");
//     var res = await http.get(url);

//     Map<String, dynamic> rawData = json.decode(res.body)['data'];
//     DetailSurah data = DetailSurah.fromJson(rawData);

//     if (data.verses != null) {
//       data.verses!.forEach((ayat) {
//         if (ayat.meta?.juz == juz) {
//           penampungAyat.add(
//               {"surah": data.name?.transliteration?.id ?? '', "ayat": ayat});
//         } else {
//           print("==================");
//           print("berhasil memasukkan juz $juz");
//           print("START :");
//           print((penampungAyat[0]["ayat"] as Verse).number?.inSurah);
//           print("END :");
//           print((penampungAyat[penampungAyat.length - 1]["ayat"] as Verse)
//               .number
//               ?.inSurah);
//           allJuz.add({
//             "juz": juz,
//             "start": penampungAyat[0],
//             "end": penampungAyat[penampungAyat.length - 1],
//             "verses": penampungAyat
//           });
//           juz++;
//           penampungAyat.clear();
//           penampungAyat.add(
//               {"surah": data.name?.transliteration?.id ?? '', "ayat": ayat});
//         }
//       });
//     }
//   }
//   print("==================");
//   print("berhasil memasukkan juz $juz");
//   print("START :");
//   print((penampungAyat[0]["ayat"] as Verse).number?.inSurah);
//   print("END :");
//   print((penampungAyat[penampungAyat.length - 1]["ayat"] as Verse)
//       .number
//       ?.inSurah);
//   allJuz.add({
//     "juz": juz,
//     "start": penampungAyat[0],
//     "end": penampungAyat[penampungAyat.length - 1],
//     "verses": penampungAyat
//   });
// }

import 'package:alquran_app/app/data/models/detail_surah.dart';

void main() async {
  int juz = 1;

  List<Map<String, dynamic>> penampungAyat = [];
  List<Map<String, dynamic>> allJuz = [];
  for (var i = 0; i <= 114; i++) {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah/$i");
    var res = await http.get(url);

    Map<String, dynamic> rawData = json.decode(res.body)['data'];
    DetailSurah data = DetailSurah.fromJson(rawData);

    if (data.verses != null) {
      for (var ayat in data.verses!) {
        if (ayat.meta?.juz == juz) {
          penampungAyat.add(
              {"surah": data.name?.transliteration?.id ?? '', "ayat": ayat});
        } else {
          allJuz.add({
            "juz": juz,
            "start": penampungAyat[0],
            "end": penampungAyat[penampungAyat.length - 1],
            "verses": penampungAyat
          });
          juz++;
          penampungAyat = [];
          penampungAyat.add(
              {"surah": data.name?.transliteration?.id ?? '', "ayat": ayat});
        }
      }
    }
  }

  allJuz.add({
    "juz": juz,
    "start": penampungAyat[0],
    "end": penampungAyat[penampungAyat.length - 1],
    "verses": penampungAyat
  });
}
