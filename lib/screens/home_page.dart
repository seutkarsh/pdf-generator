import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_generator/screens/PdfPreviewScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _heading = TextEditingController();
  final TextEditingController _content = TextEditingController();
  final pdf = pw.Document();

  //write pdf
  writePDF() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text("PDF Generating Assessment", textScaleFactor: 2),
                  ])),
          pw.Header(level: 1, text: _heading.text),

          // Write All the paragraph in one line.
          // For clear understanding
          pw.Paragraph(text: _content.text),
        ];
      },
    ));
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/example.pdf");
    file.writeAsBytesSync(await pdf.save());
  }

  generatePDF() async {
    writePDF();
    await savePdf();
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    String fullPath = "$documentPath/example.pdf";
    print(fullPath);

    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PdfPreviewScreen(
                  path: fullPath,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Assessment"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextFormField(
              controller: _heading,
              decoration: const InputDecoration(
                  label: Text("Heading"), hintText: "Heading here..."),
            ),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
                minLines: 5,
                maxLines: 10,
                controller: _content,
                decoration: const InputDecoration(
                    label: Text("Content"),
                    hintText: "Type your content here")),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: generatePDF, child: const Text("Generate PDF"))
          ],
        ),
      ))),
    );
  }
}
