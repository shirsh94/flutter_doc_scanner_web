import 'package:flutter/material.dart';
import 'flutter_doc_scanner_web_platform_interface.dart';
import 'flutter_doc_scanner_web_web.dart';

class FlutterDocScannerWeb {
  Future<String?> getPlatformVersion() {
    return FlutterDocScannerWebPlatform.instance.getPlatformVersion();
  }

  /// Opens the document scanner dialog in a web environment.
  Future<String?> getScanDocumentsWeb(
      BuildContext context, {
        required String appBarTitle,
        required String captureButtonText,
        required String cropButtonText,
        required String cropPdfButtonText,
        required double width,
        required double height,
      }) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentScannerPage(
          appBarTitle: appBarTitle,
          captureButtonText: captureButtonText,
          cropButtonText: cropButtonText,
          cropPdfButtonText: cropPdfButtonText,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
