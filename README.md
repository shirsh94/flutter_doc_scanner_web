# flutter_doc_scanner_web

A Flutter plugin for document scanning on the Web using `package:web`.

## Example

Explore the `example` directory for a sample Flutter app using `flutter_doc_scanner_web`.

## Installation

Add `flutter_doc_scanner_web` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_doc_scanner_web: ^0.1.0
```

## Usage

Use the following function for document scanning on Web:

```dart
scannedDocuments = await FlutterDocScanner().getScanDocumentsWeb(
    context,
    appBarTitle: "Crop Document",
    captureButtonText: "Capture Image",
    cropButtonText: "Crop & Save",
    cropPdfButtonText: "Crop & PDF",
    width: 400,
    height: 400,
);
```

## Issues and Feedback
Report issues or send feedback [here](https://github.com/shirsh94/flutter_doc_scanner_web/issues).

## License

The MIT License (MIT) Copyright (c) 2024 Shirsh Shukla

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


