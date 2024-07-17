// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter/services.dart';
// import 'package:quran_station/src/core/utils/styles_manager.dart';
//
//
//
// class PDFScreen extends StatefulWidget {
//   @override
//   _PDFScreenState createState() => _PDFScreenState();
// }
//
// class _PDFScreenState extends State<PDFScreen> {
//   int _totalPages = 604;
//   int _currentPage = 0;
//   bool _isReady = false;
//   String _errorMessage = '';
//   late PDFViewController _pdfViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//           children: [
//             Expanded(
//               child: const PDF(
//                   pageSnap: false, enableSwipe: true, pageFling: false,)
//                   .fromAsset("assets/quran_data/Quran.pdf",
//               ),
//             ),
//           ],
//         ));
//   }
// }