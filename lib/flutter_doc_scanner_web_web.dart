// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;
import 'flutter_doc_scanner_web_platform_interface.dart';


/// A web implementation of the FlutterDocScannerWebPlatform of the FlutterDocScannerWeb plugin.
class FlutterDocScannerWebWeb extends FlutterDocScannerWebPlatform {
  /// Constructs a FlutterDocScannerWebWeb
  FlutterDocScannerWebWeb();

  static void registerWith(Registrar registrar) {
    FlutterDocScannerWebPlatform.instance = FlutterDocScannerWebWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}

class DocumentScannerPage extends StatefulWidget {
  final String appBarTitle;
  final String captureButtonText;
  final String cropButtonText;
  final String cropPdfButtonText;
  final double width;
  final double height;

  const DocumentScannerPage({
    super.key,
    required this.appBarTitle,
    required this.captureButtonText,
    required this.cropButtonText,
    required this.cropPdfButtonText,
    required this.width,
    required this.height,
  });

  @override
  _DocumentScannerPageState createState() => _DocumentScannerPageState();
}

class _DocumentScannerPageState extends State<DocumentScannerPage> {
  String? _imageUrl;
  String? _pdfUrl;
  double top = 100;
  double left = 50;
  double cropWidth = 200;
  double cropHeight = 200;

  void _captureImage() {
    final web.HTMLInputElement input = web.document.createElement('input') as web.HTMLInputElement;
    input.type = 'file';
    input.accept = 'image/*';
    input.click();

    input.onchange = (web.Event event) {
      final files = input.files;
      if (files == null || files.length == 0) return;

      final reader = web.FileReader();
      reader.readAsDataURL(files.item(0)!);

      reader.onloadend = (web.Event event) {
        setState(() {
          _imageUrl = (reader.result as JSString).toDart;
          _pdfUrl = null; // Reset PDF URL when a new image is picked
        });
      }.toJS;
    }.toJS;
  }

  void _cropImage() {
    if (_imageUrl == null) return;

    final canvas = web.document.createElement('canvas') as web.HTMLCanvasElement;
    final img = web.document.createElement('img') as web.HTMLImageElement;
    img.src = _imageUrl!;

    img.onload = (web.Event event) {
      canvas.width = cropWidth.toInt();
      canvas.height = cropHeight.toInt();

      final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
      ctx.drawImage(
        img,
        left,
        top,
        cropWidth,
        cropHeight,
        0,
        0,
        cropWidth,
        cropHeight,
      );

      final croppedImageUrl = canvas.toDataURL();
      Navigator.of(context).pop(croppedImageUrl);
    }.toJS;
  }

  void _convertToPDF() {
    if (_imageUrl == null) return;

    final canvas = web.document.createElement('canvas') as web.HTMLCanvasElement;
    canvas.width = 595;
    canvas.height = 842;
    final img = web.document.createElement('img') as web.HTMLImageElement;
    img.src = _imageUrl!;

    img.onload = (web.Event event) {
      final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
      ctx.drawImage(img, 0, 0, 595, 842);

      final pdfBlob = web.Blob([canvas.toDataURL().toJS].toJS, web.BlobPropertyBag(type: 'application/pdf'));
      final pdfUrl = web.URL.createObjectURL(pdfBlob);
      _pdfUrl = pdfUrl; // Set the generated PDF URL
      Navigator.of(context).pop(_pdfUrl); // Return the PDF URL
    }.toJS;
  }

  @override
  void initState() {
    super.initState();
    _captureImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appBarTitle)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageUrl == null)
                ElevatedButton(
                  onPressed: _captureImage,
                  child: Text(widget.captureButtonText),
                )
              else
                Stack(
                  children: [
                    Image.network(
                      _imageUrl!,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      top: top,
                      left: left,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            left += details.delta.dx;
                            top += details.delta.dy;
                          });
                        },
                        child: Container(
                          width: cropWidth,
                          height: cropHeight,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -10,
                                left: -10,
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(() {
                                      cropWidth -= details.delta.dx;
                                      cropHeight -= details.delta.dy;
                                      left += details.delta.dx;
                                      top += details.delta.dy;
                                    });
                                  },
                                  child: _buildHandle(),
                                ),
                              ),
                              Positioned(
                                top: -10,
                                right: -10,
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(() {
                                      cropWidth += details.delta.dx;
                                      cropHeight -= details.delta.dy;
                                      top += details.delta.dy;
                                    });
                                  },
                                  child: _buildHandle(),
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                left: -10,
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(() {
                                      cropWidth -= details.delta.dx;
                                      cropHeight += details.delta.dy;
                                      left += details.delta.dx;
                                    });
                                  },
                                  child: _buildHandle(),
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(() {
                                      cropWidth += details.delta.dx;
                                      cropHeight += details.delta.dy;
                                    });
                                  },
                                  child: _buildHandle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (_imageUrl != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _cropImage,
                      child: Text(widget.cropButtonText),
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: _convertToPDF,
                      child: Text(widget.cropPdfButtonText),
                    ),
                  ],
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}


