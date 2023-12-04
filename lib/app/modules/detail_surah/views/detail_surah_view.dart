import 'package:alquran_app/app/constant/color.dart';
import 'package:alquran_app/app/data/models/detail_surah.dart' as detail;
import 'package:alquran_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_surah_controller.dart';

// ignore: must_be_immutable
class DetailSurahView extends GetView<DetailSurahController> {
  // ignore: non_constant_identifier_names
  final HomeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;

  DetailSurahView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Surah ${Get.arguments["name"]}'),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.DetailSurah>(
        future: controller.getDetailSurah(Get.arguments["number"].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Tidak ada data"),
            );
          }
          if (Get.arguments["bookmark"] != null) {
            bookmark = Get.arguments["bookmark"];

            controller.scrollC.scrollToIndex(
              bookmark!["index_ayat"] + 2,
              preferPosition: AutoScrollPosition.begin,
            );
          }
          detail.DetailSurah surah = snapshot.data!;

          List<Widget> allAyat = List.generate(
            snapshot.data?.verses?.length ?? 0,
            (index) {
              detail.Verse? ayat = snapshot.data?.verses?[index];
              return AutoScrollTag(
                key: ValueKey(index + 2),
                index: index + 2,
                controller: controller.scrollC,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Get.isDarkMode
                              ? appSoftPurple.withOpacity(0.3)
                              : appSoftGreen.withOpacity(0.3)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/octagon.png"))),
                              child: Center(
                                  child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                    color:
                                        Get.isDarkMode ? appWhite : appPurple),
                              )),
                            ),
                            GetBuilder<DetailSurahController>(
                              builder: (c) => Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                          title: "BOOKMARK",
                                          middleText: "Pilih jenis bookmark",
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                await c.addBookmark(
                                                    true,
                                                    snapshot.data!,
                                                    ayat!,
                                                    index);
                                                HomeC.update();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: appGreen),
                                              child: const Text("Last Read"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                c.addBookmark(
                                                    false,
                                                    snapshot.data!,
                                                    ayat!,
                                                    index);
                                                HomeC.update();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: appGreen),
                                              child: const Text("Bookmark"),
                                            ),
                                          ]);
                                    },
                                    icon:
                                        const Icon(Icons.bookmark_add_outlined),
                                    color: appPurple,
                                  ),
                                  (ayat?.audioCondition == "Stop")
                                      ? IconButton(
                                          onPressed: () {
                                            c.playAudio(ayat);
                                          },
                                          icon: const Icon(Icons.play_arrow),
                                          color: appPurple)
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            (ayat?.audioCondition == "Playing")
                                                ? IconButton(
                                                    onPressed: () {
                                                      c.pauseAudio(ayat!);
                                                    },
                                                    icon:
                                                        const Icon(Icons.pause),
                                                    color: appPurple,
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      c.resumeAudio(ayat!);
                                                    },
                                                    icon: const Icon(
                                                        Icons.play_arrow),
                                                    color: appPurple,
                                                  ),
                                            IconButton(
                                              onPressed: () {
                                                c.stopAudio(ayat!);
                                              },
                                              icon: const Icon(Icons.stop),
                                              color: appPurple,
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${ayat!.text?.arab}",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${ayat.text?.transliteration?.en}",
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${ayat.translation?.id}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          );

          // sudah pasti ada data
          return ListView(
            controller: controller.scrollC,
            padding: const EdgeInsets.all(20),
            children: [
              AutoScrollTag(
                key: const ValueKey(0),
                index: 0,
                controller: controller.scrollC,
                child: GestureDetector(
                  onTap: () => Get.defaultDialog(
                    backgroundColor:
                        Get.isDarkMode ? appSoftPurple : appSoftGreen,
                    contentPadding: const EdgeInsets.all(20),
                    title: "Tafsir Surat ${surah.name!.transliteration!.id}",
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    content: Text(
                      surah.tafsir?.id ?? 'Tidak ada tafsir pada surat ini',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  child: Obx(
                    () => Container(
                      height: 150,
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              colors: controller.isDark.isTrue
                                  ? [appSoftPurple, appPurple]
                                  : [appSoftGreen, appGreen])),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Text(
                              "${surah.name!.transliteration!.id}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: appWhite),
                            ),
                            Text(
                              "( ${surah.name!.translation!.id} )",
                              style: const TextStyle(
                                  fontSize: 16, color: appWhite),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${surah.numberOfVerses} Ayat | ${surah.revelation!.id}",
                              style: const TextStyle(
                                  fontSize: 16, color: appWhite),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AutoScrollTag(
                key: const ValueKey(1),
                index: 1,
                controller: controller.scrollC,
                child: const SizedBox(height: 20),
              ),
              ...allAyat
            ],
          );
        },
      ),
    );
  }
}
