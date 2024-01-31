// import 'package:flutter/material.dart';
// import 'package:quran_station/src/core/utils/constance_manager.dart';
// import 'package:quran_station/src/core/utils/navigation_manager.dart';
// import 'package:quran_station/src/modules/audios/presentation/screens/audioPlayerScreen.dart';
// import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
//
// import '../../data/models/moshaf.dart';
//
// class MoshafScreen extends StatelessWidget {
//   final Moshaf moshaf;
//   const MoshafScreen({super.key, required this.moshaf});
//
//   @override
//   Widget build(BuildContext context) {
//     // debugPrint("moshaf name is ${moshaf.surahList}");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(moshaf.moshafData.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView.separated(
//             addAutomaticKeepAlives: true,
//             shrinkWrap: true,
//             itemBuilder: (context, index) => InkWell(
//                   onTap: () {
//                     context.push(AudioPlayerScreen(
//                         audioUrl: ,
//                         title: ConstanceManager.quranSurahsNames[index]));
//                   },
//                   child: SurahItem(
//                     surahId: surahs[index],
//                   ),
//                 ),
//             separatorBuilder: (context, index) => SizedBox(
//                   height: 10,
//                 ),
//             itemCount: surahs.length),
//       ),
//     );
//   }
//
//   List<int> _getSurahsIndexesFromString(String surahsString) {
//     List<int> surahs = [];
//     debugPrint("https://server6.mp3quran.net/akdr/002.mp3");
//     List<String> surahsStringList = surahsString.split(",");
//     for (var element in surahsStringList) {
//       surahs.add(int.parse(element) - 1);
//     }
//     return surahs;
//   }
// }
