import 'dart:convert';
import 'package:alquran_app/app/constant/color.dart';
import 'package:alquran_app/app/data/models/db/bookmark.dart';
import 'package:http/http.dart' as http;
import 'package:alquran_app/app/data/models/detail_surah.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';

class DetailSurahController extends GetxController {
  AutoScrollController scrollC = AutoScrollController();
  // RxString audioCondition = "Stop".obs;
  final player = AudioPlayer();
  Verse? lastVerse;

  DatabaseManager database = DatabaseManager.instance;

  Future<void> addBookmark(
      bool lastRead, DetailSurah surah, Verse ayat, int indexAyat) async {
    Database db = await database.db;

    bool flagExist = false;

    if (lastRead == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkData = await db.query("bookmark",
          columns: [
            "surah",
            "number_surah",
            "ayat",
            "juz",
            "via",
            "index_ayat",
            "last_read"
          ],
          where:
              "surah = '${surah.name!.transliteration!.id!.replaceAll("'", "+")}' and number_surah = ${surah.number!} and ayat = ${ayat.number!.inSurah!} and juz = ${ayat.meta!.juz!} and via = 'surah' and index_ayat = $indexAyat and last_read = 0");
      if (checkData.isNotEmpty) {
        flagExist = true;
      }
    }

    if (flagExist == false) {
      await db.insert(
        "bookmark",
        {
          "surah": surah.name!.transliteration!.id!.replaceAll("'", "+"),
          "number_surah": surah.number!,
          "ayat": ayat.number!.inSurah!,
          "juz": ayat.meta!.juz!,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": lastRead == true ? 1 : 0,
        },
      );

      Get.back(); // tutup dialog
      Get.snackbar("Berhasil", "Berhasil menambahkan bookmark",
          colorText: appPurple);
    } else {
      Get.back(); // tutup dialog
      Get.snackbar("Terjadi Kesalahan", "Bookmark telah tersedia",
          colorText: appPurple);
    }

    // var data = await db.query("bookmark");
    // print(data);
  }

  RxBool isDark = false.obs;

  Future<DetailSurah> getDetailSurah(String id) async {
    Uri urlSurah = Uri.parse("https://api.quran.gading.dev/surah/$id");
    var responseSurah = await http.get(urlSurah);

    Map<String, dynamic> data =
        (json.decode(responseSurah.body) as Map<String, dynamic>)["data"];

    return DetailSurah.fromJson(data);
  }

  void stopAudio(Verse ayat) async {
    try {
      await player.stop();
      ayat.audioCondition = "Stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi kesalahan",
          middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi kesalahan", middleText: "Tidak dapat stop audio");
    }
  }

  void resumeAudio(Verse ayat) async {
    try {
      ayat.audioCondition = "Playing";
      update();
      await player.play();
      ayat.audioCondition = "Stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi kesalahan",
          middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi kesalahan", middleText: "Tidak dapat resume audio");
    }
  }

  void pauseAudio(Verse ayat) async {
    try {
      await player.pause();
      ayat.audioCondition = "Pause";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi kesalahan",
          middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi kesalahan", middleText: "Tidak dapat pause audio");
    }
  }

  void playAudio(Verse? ayat) async {
    if (ayat?.audio?.primary != null) {
      // Catching errors at load time
      try {
        lastVerse ??= ayat;
        lastVerse!.audioCondition = "Stop";
        lastVerse = ayat; // logic untuk ketika lastverse sudah ada
        lastVerse!.audioCondition = "Stop";
        update();
        await player
            .stop(); // mencegah terjadinya penumpukkan audio yang sedang berjalan
        await player.setUrl(ayat!.audio!.primary!);
        ayat.audioCondition = "Playing";
        update();
        await player.play();
        ayat.audioCondition = "Stop";
        await player.stop();
        update();
      } on PlayerException catch (e) {
        Get.defaultDialog(
            title: "Terjadi kesalahan", middleText: e.message.toString());
      } on PlayerInterruptedException catch (e) {
        Get.defaultDialog(
            title: "Terjadi kesalahan",
            middleText: "Connection aborted: ${e.message}");
      } catch (e) {
        Get.defaultDialog(
            title: "Terjadi kesalahan",
            middleText: "Tidak dapat memutar audio");
      }
    } else {
      Get.defaultDialog(
          title: "Terjadi kesalahan", middleText: "URL Audio tidak ada");
    }
  }

  @override
  void onClose() async {
    await player.stop();
    await player.dispose();
    super.onClose();
  }
}
