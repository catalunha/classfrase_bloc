import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/models/phrase_model.dart';
import '../../../core/models/user_profile_model.dart';

class PdfAllPhrasesPage extends StatelessWidget {
  final List<PhraseModel> phraseList;
  final UserProfileModel userProfile;
  const PdfAllPhrasesPage({
    Key? key,
    required this.phraseList,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClassFrase em PDF')),
      body: PdfPreview(
        pdfFileName: 'classfrase',
        build: (format) => _generatePdf(format, 'ClassFrase em PDF'),
        canDebug: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final font1 = await PdfGoogleFonts.openSansRegular();
    // final font2 = await PdfGoogleFonts.openSansBold();
    pw.ImageProvider? image;

    // try {
    //   final provider = await flutterImageProvider(
    //       NetworkImage(_pdfController.phrase.user.profile!.photo ?? ''));
    //   image = provider;
    // } catch (e) {
    //   //print"--> Erro em _generatePdf: $e");
    // }
    pdf.addPage(
      pw.MultiPage(
        // theme: theme(font1, font2),
        pageFormat: pageFormat(format),
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        footer: (pw.Context context) => footerPage(context),
        build: (pw.Context context) => <pw.Widget>[
          headerClassificator(image),
          pw.Divider(),

          ...writePhraseList(),

          // }

          // pw.Text(
          //   'Fonte: ${_pdfController.phrase.font}',
          //   style: const pw.TextStyle(fontSize: 10),
          // ),
          // pw.Text(
          //   'Pasta: ${_pdfController.phrase.folder}',
          //   style: const pw.TextStyle(fontSize: 10),
          // ),
          // header('Classificações:'),
          // ...buildClassByLine(context),
          // header('Diagrama:'),
          // _pdfController.phrase.diagramUrl != null &&
          //         _pdfController.phrase.diagramUrl!.isNotEmpty
          //     ? pw.Row(
          //         children: [
          //           pw.Text(
          //             'Para ver o diagrama online consulte: ',
          //             style: const pw.TextStyle(fontSize: 10),
          //           ),
          //           _UrlText(
          //               _pdfController.phrase.diagramUrl ?? 'Sem diagrama.',
          //               _pdfController.phrase.diagramUrl ?? 'Sem diagrama'),
          //           // _UrlText('clique aqui.', _pdfController.phrase.diagramUrl!),
          //         ],
          //       )
          //     : pw.Text(''),
        ],
      ),
    );

    return pdf.save();
  }

  pageFormat(format) {
    return format.copyWith(
      width: 21.0 * PdfPageFormat.cm,
      height: 29.7 * PdfPageFormat.cm,
      marginTop: 1.0 * PdfPageFormat.cm,
      marginLeft: 1.0 * PdfPageFormat.cm,
      marginRight: 1.0 * PdfPageFormat.cm,
      marginBottom: 1.0 * PdfPageFormat.cm,
    );
  }

  footerPage(context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
      decoration: const pw.BoxDecoration(
          border: pw.Border(
              top: pw.BorderSide(width: 1.0, color: PdfColors.black))),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'ClassFrase (R) 2023. Feito com carinho pela Família Catalunha. Ore por nós, que Deus te abençõe.',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Pág.: ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  header(text) {
    return pw.Header(
      level: 1,
      child: pw.Text(text),
    );
  }

  writePhraseList() {
    List<pw.Widget> lineList = [];
    for (var phrase in phraseList) {
      lineList.add(writePhrase(phrase));
    }

    return lineList;
  }

  writePhrase(PhraseModel phrase) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            phrase.phrase,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(
              fontSize: 18,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.Text('Pública: ${phrase.isPublic ? "Sim" : "Não"}'),
        pw.Text('Pasta: ${phrase.folder}'),
        pw.Text('Fonte: ${phrase.font}'),
        pw.Row(children: [
          pw.Text('Para ver o diagrama online '),
          _UrlText('clique aqui.', phrase.diagramUrl),
        ]),
        pw.Text(
          'Ou consulte ',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.Text(
          phrase.diagramUrl ?? '',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.Text('Observações: ${phrase.note ?? ""}'),
        pw.Divider(),
      ],
    );
  }

  headerClassificator(image) {
    return pw.Header(
      level: 1,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: <pw.Widget>[
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(userProfile.name ?? 'Sem nome'),
              pw.Text(userProfile.email),
              pw.Text('Classificador destas ${phraseList.length} frases:'),
              // pw.Divider(),
            ],
          ),
          // image != null
          //     ? pw.Image(
          //         image,
          //         width: 50,
          //         height: 100,
          //       )
          //     : pw.Text(':-(('),
        ],
      ),
    );
  }

  theme(font1, font2) {
    return pw.ThemeData.withFont(
      base: font1,
      bold: font2,
    );
  }

  // List<pw.Widget> buildClassByLine(context) {
  //   List<pw.Widget> lineList = [];

  //   for (var classId in _pdfController.phrase.classOrder) {
  //     Classification classification =
  //         _pdfController.phrase.classifications[classId]!;

  //     // +++ Montando frase destacando a seleção
  //     List<pw.InlineSpan> listSpan = [];
  //     for (var i = 0; i < _pdfController.phrase.phraseList.length; i++) {
  //       listSpan.add(pw.TextSpan(
  //         text: _pdfController.phrase.phraseList[i],
  //         style: _pdfController.phrase.phraseList[i] != ' ' &&
  //                 classification.posPhraseList.contains(i)
  //             ? pw.TextStyle(
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: PdfColors.orange900,
  //                 decoration: pw.TextDecoration.underline,
  //                 decorationStyle: pw.TextDecorationStyle.solid,
  //               )
  //             : null,
  //       ));
  //     }
  //     pw.RichText richText = pw.RichText(
  //       text: pw.TextSpan(
  //         style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //         children: listSpan,
  //       ),
  //     );

  //     // +++ Montando classificações desta seleção
  //     List<pw.Widget> categoryWidgetList = [];
  //     List<String> categoryIdList = classification.categoryIdList;
  //     List<String> classOrdemList = [];
  //     ClassificationService classificationService = Get.find();
  //     for (var id in categoryIdList) {
  //       CatClassModel? catClassModel = classificationService.categoryAll
  //           .firstWhereOrNull((catClass) => catClass.id == id);
  //       if (catClassModel != null) {
  //         classOrdemList.add(catClassModel.ordem);
  //       }
  //     }

  //     if (classOrdemList.isNotEmpty) {
  //       classOrdemList.sort();

  //       for (var element in classOrdemList) {
  //         categoryWidgetList.add(
  //           pw.Bullet(
  //             text: element,
  //             style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //           ),
  //         );
  //       }
  //     }

  //     // Juntando frase e classificações
  //     lineList.add(
  //       pw.Column(
  //         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //         children: <pw.Widget>[
  //           richText,
  //           ...categoryWidgetList,
  //         ],
  //       ),
  //     );
  //   }
  //   return lineList;
  // }
}

class _UrlText extends pw.StatelessWidget {
  final String text;
  final String? url;
  _UrlText(this.text, this.url);

  @override
  pw.Widget build(pw.Context context) {
    return url == null
        ? pw.Text(
            text,
            style: const pw.TextStyle(
              // decoration: pw.TextDecoration.underline,
              // color: PdfColors.blue,
              fontSize: 10,
            ),
          )
        : pw.UrlLink(
            destination: url!,
            child: pw.Text(
              text,
              style: const pw.TextStyle(
                // decoration: pw.TextDecoration.underline,
                // color: PdfColors.blue,
                fontSize: 10,
              ),
            ),
          );
  }
}
