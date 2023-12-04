import 'package:alquran_app/app/constant/color.dart';
import 'package:alquran_app/app/data/models/detail_surah.dart' as detail;
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:alquran_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Quran Apps'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.SEARCH),
              icon: const Icon(Icons.search))
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            children: [
              const Text(
                "Assalamualaikum",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GetBuilder<HomeController>(
                builder: (c) => FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Obx(
                        () => Container(
                          height: 150,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: c.isDark.isTrue
                                  ? [appSoftPurple, appPurple]
                                  : [appSoftGreen, appGreen],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 10,
                                right: 0,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Image.asset(
                                        "assets/images/quran.png",
                                      )),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book_rounded,
                                          color: appWhite,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Terakhir dibaca",
                                          style: TextStyle(color: appWhite),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Loading ...",
                                      style: TextStyle(
                                          color: appWhite, fontSize: 20),
                                    ),
                                    Text(
                                      "",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    Map<String, dynamic>? lastRead = snapshot.data;

                    return Obx(
                      () => Container(
                        height: 150,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: c.isDark.isTrue
                                ? [appSoftPurple, appPurple]
                                : [appSoftGreen, appGreen],
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onLongPress: () {
                              if (lastRead != null) {
                                Get.defaultDialog(
                                    title: "Delete Last Read",
                                    middleText:
                                        "Are you sure to delete this last read bookmark?",
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () => Get.back(),
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          c.deleteLastRead(lastRead["id"]);
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ]);
                              }
                            },
                            onTap: () {
                              if (lastRead != null) {
                                switch (lastRead["via"]) {
                                  case "juz":
                                    Map<String, dynamic> dataMapPerJuz =
                                        controller.allJuz[lastRead["juz"] - 1];
                                    Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                                      "juz": dataMapPerJuz,
                                      "bookmark": lastRead
                                    });
                                    break;
                                  default:
                                    Get.toNamed(
                                      Routes.DETAIL_SURAH,
                                      arguments: {
                                        "name": lastRead["surah"]
                                            .toString()
                                            .replaceAll("+", "'"),
                                        "number": lastRead["number_surah"],
                                        "bookmark": lastRead
                                      },
                                    );
                                    break;
                                }
                              }
                            },
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 10,
                                  right: 0,
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Image.asset(
                                          "assets/images/quran.png",
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.menu_book_rounded,
                                            color: appWhite,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Terakhir dibaca",
                                            style: TextStyle(color: appWhite),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (lastRead != null)
                                        Text(
                                          lastRead['surah']
                                              .toString()
                                              .replaceAll("+", "'"),
                                          style: const TextStyle(
                                              color: appWhite, fontSize: 20),
                                        ),
                                      Text(
                                        lastRead == null
                                            ? "Belum ada data"
                                            : "Juz ${lastRead['juz']} | Ayat ${lastRead['ayat']}",
                                        style: const TextStyle(
                                            color: appWhite, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const TabBar(
                indicatorColor: appGreen,
                labelColor: appGreen,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: "Surat",
                  ),
                  Tab(
                    text: "Juz",
                  ),
                  Tab(
                    text: "Bookmark",
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    //Detail Surah
                    FutureBuilder<List<Surah>>(
                      future: controller.getListSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Terjadi kesalahan"),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Tidak ada data"),
                          );
                        }

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Surah surah = snapshot.data![index];
                              return ListTile(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.DETAIL_SURAH,
                                    arguments: {
                                      "name": surah.name!.transliteration!.id,
                                      "number": surah.number!,
                                    },
                                  );
                                },
                                leading: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/octagon.png"),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text("${surah.number}"),
                                  ),
                                ),
                                title: Text(
                                  "${surah.name!.transliteration!.id}",
                                  style: const TextStyle(color: appGreen),
                                ),
                                subtitle: Text(
                                  "${surah.numberOfVerses} | ${surah.revelation!.id}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: Text("${surah.name!.short}"),
                              );
                            });
                      },
                    ),
                    //Detail Juz
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: controller.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          controller.dataAllJuzAvailable.value = false;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Tidak ada data"),
                          );
                        }
                        controller.dataAllJuzAvailable.value = true;
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> dataMapPerJuz =
                                snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_JUZ,
                                    arguments: {"juz": dataMapPerJuz});
                              },
                              leading: Container(
                                height: 35,
                                width: 35,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/octagon.png",
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text("${index + 1}"),
                                ),
                              ),
                              title: Text(
                                "Juz ${index + 1}",
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Mulai dari ${(dataMapPerJuz['start']['surah'] as detail.DetailSurah).name?.transliteration?.id} ayat ${(dataMapPerJuz['start']['ayat'] as detail.Verse).number?.inSurah}",
                                  ),
                                  Text(
                                    "Sampai ${(dataMapPerJuz['end']['surah'] as detail.DetailSurah).name?.transliteration?.id} ayat ${(dataMapPerJuz['end']['ayat'] as detail.Verse).number?.inSurah}",
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    // FutureBuilder<List<juz.Juz>>(
                    //   future: controller.getAllJuz(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.waiting) {
                    //       return const Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //     if (!snapshot.hasData) {
                    //       return const Center(
                    //         child: Text("Tidak ada data"),
                    //       );
                    //     }

                    //     return ListView.builder(
                    //       shrinkWrap: true,
                    //       itemCount: snapshot.data!.length,
                    //       itemBuilder: (context, index) {
                    //         juz.Juz detailJuz = snapshot.data![index];

                    //         String nameStart =
                    //             detailJuz.juzStartInfo?.split(" - ").first ?? "";
                    //         String nameEnd =
                    //             detailJuz.juzEndInfo?.split(" - ").first ?? "";

                    //         List<Surah> rawAllSurahInJuz = [];
                    //         List<Surah> allSurahInJuz = [];

                    //         for (Surah item in controller.allSurah) {
                    //           rawAllSurahInJuz.add(item);
                    //           if (item.name!.transliteration!.id == nameEnd) {
                    //             break;
                    //           }
                    //         }

                    //         for (Surah item
                    //             in rawAllSurahInJuz.reversed.toList()) {
                    //           allSurahInJuz.add(item);
                    //           if (item.name!.transliteration!.id == nameStart) {
                    //             break;
                    //           }
                    //         }

                    //         return ListTile(
                    //           onTap: () {
                    //             Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                    //               "juz": detailJuz,
                    //               "surah": allSurahInJuz.reversed.toList()
                    //             });
                    //           },
                    //           leading: Container(
                    //             height: 35,
                    //             width: 35,
                    //             decoration: const BoxDecoration(
                    //               image: DecorationImage(
                    //                 image: AssetImage(
                    //                   "assets/images/octagon.png",
                    //                 ),
                    //               ),
                    //             ),
                    //             child: Center(
                    //               child: Text("${detailJuz.juz}"),
                    //             ),
                    //           ),
                    //           title: Text(
                    //             "Juz ${detailJuz.juz}",
                    //           ),
                    //           isThreeLine: true,
                    //           subtitle: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               Text(
                    //                 "Mulai dari ${detailJuz.juzStartInfo}",
                    //               ),
                    //               Text(
                    //                 "Sampai ${detailJuz.juzEndInfo}",
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),

                    //Bookmark
                    GetBuilder<HomeController>(
                      builder: (c) {
                        if (c.dataAllJuzAvailable.isFalse) {
                          return const Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Sedang menunggu data juz..."),
                              ],
                            ),
                          );
                        } else {
                          return FutureBuilder<List<Map<String, dynamic>>>(
                            future: c.getBookmark(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text("Bookmark tidak tersedia"),
                                );
                              }

                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      snapshot.data![index];
                                  return ListTile(
                                    onTap: () {
                                      switch (data["via"]) {
                                        case "juz":
                                          Map<String, dynamic> dataMapPerJuz =
                                              controller
                                                  .allJuz[data["juz"] - 1];
                                          Get.toNamed(Routes.DETAIL_JUZ,
                                              arguments: {
                                                "juz": dataMapPerJuz,
                                                "bookmark": data
                                              });
                                          break;
                                        default:
                                          Get.toNamed(
                                            Routes.DETAIL_SURAH,
                                            arguments: {
                                              "name": data["surah"]
                                                  .toString()
                                                  .replaceAll("+", "'"),
                                              "number": data["number_surah"],
                                              "bookmark": data
                                            },
                                          );
                                          break;
                                      }
                                    },
                                    leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/octagon.png"),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text("${index + 1}"),
                                      ),
                                    ),
                                    title: Text(data['surah']
                                        .toString()
                                        .replaceAll("+", "'")),
                                    subtitle: Text(
                                        "Ayat ${data['ayat']} - via ${data['via']}"),
                                    trailing: IconButton(
                                      onPressed: () {
                                        c.deleteBookmark(data['id']);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return controller.changeThemeMode();
        },
        child: Obx(
          () => Icon(
            Icons.color_lens,
            color: controller.isDark.isTrue ? appPurple : appWhite,
          ),
        ),
      ),
    );
  }
}
