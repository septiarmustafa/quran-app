import 'package:alquran_app/app/constant/color.dart';
import 'package:alquran_app/app/data/models/detail_surah.dart' as detail;
import 'package:alquran_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_juz_controller.dart';

// ignore: must_be_immutable
class DetailJuzView extends GetView<DetailJuzController> {
  final Map<String, dynamic> dataMapPerJuz = Get.arguments["juz"];
  Map<String, dynamic>? bookmark;

  // ignore: non_constant_identifier_names
  final HomeC = Get.find<HomeController>();

  DetailJuzView({super.key});

  //OPSI PERTAMA
  // final juz.Juz detailJuz = Get.arguments["juz"];
  // final List<Surah> allSurahInJuz = Get.arguments["surah"];

  @override
  Widget build(BuildContext context) {
    if (Get.arguments["bookmark"] != null) {
      bookmark = Get.arguments["bookmark"];

      controller.scrollC.scrollToIndex(
        bookmark!["index_ayat"],
        preferPosition: AutoScrollPosition.begin,
      );
    }
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }

    //OPSI KEDUA

    List<Widget> allAyat = List.generate(
      (dataMapPerJuz['verses'] as List).length,
      (index) {
        Map<String, dynamic> ayat = dataMapPerJuz['verses'][index];

        detail.DetailSurah surah = ayat["surah"];
        detail.Verse verse = ayat["ayat"];

        return AutoScrollTag(
          key: ValueKey(index),
          index: index,
          controller: controller.scrollC,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (verse.number?.inSurah == 1)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => Get.defaultDialog(
                        backgroundColor:
                            Get.isDarkMode ? appSoftPurple : appSoftGreen,
                        contentPadding: const EdgeInsets.all(20),
                        title:
                            "Tafsir Surat ${surah.name!.transliteration!.id}",
                        titleStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
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
                                  : [appSoftGreen, appGreen],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: [
                                Text(
                                  surah.name?.transliteration?.id ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: appWhite,
                                  ),
                                ),
                                Text(
                                  "( ${surah.name?.translation?.id ?? 'Tidak ada data'} )",
                                  style: const TextStyle(
                                      fontSize: 16, color: appWhite),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${surah.numberOfVerses} Ayat | ${surah.revelation!.id}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: appWhite,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode
                        ? appSoftPurple.withOpacity(0.3)
                        : appSoftGreen.withOpacity(0.3)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/octagon.png"),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${verse.number?.inSurah}",
                                style: TextStyle(
                                    color:
                                        Get.isDarkMode ? appWhite : appPurple),
                              ),
                            ),
                          ),
                          Text(
                            surah.name?.transliteration?.id ?? '',
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 17),
                          )
                        ],
                      ),
                      GetBuilder<DetailJuzController>(
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
                                              true, surah, verse, index);
                                          HomeC.update();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: appGreen),
                                        child: const Text("Last Read"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          c.addBookmark(
                                              false, surah, verse, index);
                                          HomeC.update();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: appGreen),
                                        child: const Text("Bookmark"),
                                      ),
                                    ]);
                              },
                              icon: const Icon(Icons.bookmark_add_outlined),
                              color: appPurple,
                            ),
                            (verse.audioCondition == "Stop")
                                ? IconButton(
                                    onPressed: () {
                                      c.playAudio(verse);
                                    },
                                    icon: const Icon(Icons.play_arrow),
                                    color: appPurple)
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      (verse.audioCondition == "Playing")
                                          ? IconButton(
                                              onPressed: () {
                                                c.pauseAudio(verse);
                                              },
                                              icon: const Icon(Icons.pause),
                                              color: appPurple,
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                c.resumeAudio(verse);
                                              },
                                              icon:
                                                  const Icon(Icons.play_arrow),
                                              color: appPurple,
                                            ),
                                      IconButton(
                                        onPressed: () {
                                          c.stopAudio(verse);
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
                "${verse.text?.arab}",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${verse.text?.transliteration?.en}",
                textAlign: TextAlign.justify,
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${verse.translation?.id}",
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Juz ${dataMapPerJuz['juz']}'),
        centerTitle: true,
      ),
      body: ListView(
          padding: const EdgeInsets.all(20),
          controller: controller.scrollC,
          children: allAyat),
    );

    // OPSI PERTAMA
    // allSurahInJuz.forEach((element) {
    //   print(element.name!.transliteration!.id);
    // });
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Juz ${detailJuz.juz}'),
    //     centerTitle: true,
    //   ),
    //   body: ListView.builder(
    //     padding: const EdgeInsets.all(20),
    //     itemCount: detailJuz.verses?.length ?? 0,
    //     itemBuilder: (context, index) {
    //       if (detailJuz.verses == null || detailJuz.verses?.length == 0) {
    //         return const Center(
    //           child: Text("Tidak ada data"),
    //         );
    //       }
    //       juz.Verses ayat = detailJuz.verses![index];

    //       if (index != 0) {
    //         if (ayat.number?.inSurah == 1) {
    //           controller.index++;
    //         }
    //       }

    //       return Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Container(
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(10),
    //                 color: Get.isDarkMode
    //                     ? appSoftPurple.withOpacity(0.3)
    //                     : appSoftGreen.withOpacity(0.3)),
    //             child: Padding(
    //               padding:
    //                   const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       Container(
    //                         margin: EdgeInsets.only(right: 10),
    //                         height: 40,
    //                         width: 40,
    //                         decoration: const BoxDecoration(
    //                             image: DecorationImage(
    //                                 image: AssetImage(
    //                                     "assets/images/octagon.png"))),
    //                         child: Center(
    //                             child: Text(
    //                           "${ayat.number?.inSurah}",
    //                           style: TextStyle(
    //                               color: Get.isDarkMode ? appWhite : appPurple),
    //                         )),
    //                       ),
    //                       Text(
    //                         allSurahInJuz[controller.index]
    //                                 .name
    //                                 ?.transliteration
    //                                 ?.id ??
    //                             '',
    //                         style: const TextStyle(
    //                             fontStyle: FontStyle.italic, fontSize: 17),
    //                       )
    //                     ],
    //                   ),
    //                   Row(
    //                     children: [
    //                       IconButton(
    //                         onPressed: () {},
    //                         icon: const Icon(Icons.bookmark_add_outlined),
    //                         color: appPurple,
    //                       ),
    //                       IconButton(
    //                           onPressed: () {},
    //                           icon: const Icon(Icons.play_arrow),
    //                           color: appPurple),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Text(
    //             "${ayat.text?.arab}",
    //             textAlign: TextAlign.end,
    //             style: const TextStyle(
    //               fontSize: 25,
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Text(
    //             "${ayat.text?.transliteration?.en}",
    //             textAlign: TextAlign.justify,
    //             style:
    //                 const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Text(
    //             "${ayat.translation?.id}",
    //             textAlign: TextAlign.justify,
    //             style: const TextStyle(
    //               fontSize: 18,
    //             ),
    //           ),
    //           const SizedBox(height: 30),
    //         ],
    //       );
    //     },
    //   ),
    // );
  }
}
