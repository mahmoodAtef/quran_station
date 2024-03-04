import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class TajweedPdfScreen extends StatelessWidget {
  const TajweedPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const PDF(
                pageSnap: true, enableSwipe: true, pageFling: true, fitPolicy: FitPolicy.WIDTH)
            .cachedFromUrl(
      'https://firebasestorage.googleapis.com/v0/b/quran-station-f943f.appspot.com/o/files%2Ftajweed.pdf?alt=media&token=a184719e-e1da-4b0c-9c5f-0f70f323cc67',
      placeholder: (progress) => Center(
          child: CircularProgressIndicator.adaptive(
        value: progress / 100,
      )),
      errorWidget: (error) => Center(child: Text(error.toString())),
    ));
  }
}
