import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/models/catclass_model.dart';
import '../../../core/models/phrase_classification_model.dart';
import '../../../core/models/phrase_model.dart';
import '../../../core/repositories/phrase_repository.dart';
import 'bloc/pdf_one_bloc.dart';
import 'bloc/pdf_one_state.dart';

class PdfOnePage extends StatelessWidget {
  final PhraseModel phrase;
  final List<CatClassModel> categoryAll;

  const PdfOnePage({
    super.key,
    required this.phrase,
    required this.categoryAll,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhraseRepository(),
      child: BlocProvider(
        create: (context) => PdfOneBloc(
          model: phrase,
          repository: RepositoryProvider.of<PhraseRepository>(context),
        ),
        child: PdfOneView(categoryAll: categoryAll),
      ),
    );
  }
}

class PdfOneView extends StatelessWidget {
  // final PhraseModel phrase;
  final List<CatClassModel> categoryAll;
  const PdfOneView({
    Key? key,
    // required this.phrase,
    required this.categoryAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClassFrase em PDF')),
      body: BlocBuilder<PdfOneBloc, PdfOneState>(
        builder: (context, state) {
          print('one ${state.model.classifications}');
          if (state.model.classifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return PdfPreview(
              pdfFileName: 'classfrase',
              build: (format) => _generatePdf(state.model, format),
              canDebug: false,
              canChangeOrientation: false,
              canChangePageFormat: false,
            );
          }
        },
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    PhraseModel model,
    PdfPageFormat format,
  ) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final font1 = await PdfGoogleFonts.openSansRegular();
    // final font2 = await PdfGoogleFonts.openSansBold();
    // pw.ImageProvider? image;

    // try {
    //   final provider = await flutterImageProvider(
    //       NetworkImage(phrase.user.profile!.photo ?? ''));
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
          headerClassificator(model.userProfile.name ?? 'Sem nome'),
          phraseText(model.phraseList.join()),
          pw.Text(
            'Pasta: ${model.folder}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Fonte: ${model.font}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Observações: ${model.note}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          header('Classificações:'),
          ...buildClassByLine(model),
          header('Diagrama:'),
          model.diagramUrl != null && model.diagramUrl!.isNotEmpty
              ? pw.Row(
                  children: [
                    pw.Text(
                      'Para ver o diagrama online consulte: ',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    _UrlText('Clique aqui', model.diagramUrl ?? 'Sem diagrama'),
                    // _UrlText('clique aqui.', phrase.diagramUrl!),
                  ],
                )
              : pw.Text(''),
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

  phraseText(String txt) {
    return pw.Center(
      child: pw.Text(
        txt,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(
          fontSize: 18,
          color: PdfColors.black,
        ),
      ),
    );
  }

  headerClassificator(String name) {
    return pw.Header(
      level: 1,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: <pw.Widget>[
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(name),
            pw.Text('Classificador da frase:'),
          ]),
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

  List<pw.Widget> buildClassByLine(
    PhraseModel model,
  ) {
    List<pw.Widget> lineList = [];

    for (var classId in model.classOrder) {
      Classification classification = model.classifications[classId]!;

      // +++ Montando frase destacando a seleção
      List<pw.InlineSpan> listSpan = [];
      for (var i = 0; i < model.phraseList.length; i++) {
        listSpan.add(pw.TextSpan(
          text: model.phraseList[i],
          style: model.phraseList[i] != ' ' &&
                  classification.posPhraseList.contains(i)
              ? pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.orange900,
                  decoration: pw.TextDecoration.underline,
                  decorationStyle: pw.TextDecorationStyle.solid,
                )
              : null,
        ));
      }
      pw.RichText richText = pw.RichText(
        text: pw.TextSpan(
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
          children: listSpan,
        ),
      );

      // +++ Montando classificações desta seleção
      List<pw.Widget> categoryWidgetList = [];
      List<String> categoryIdList = classification.categoryIdList;
      List<String> classOrdemList = [];
      // List<CatClassModel> categoryAll =
      //     context.read<CatClassBloc>().categoryAll;

      for (var id in categoryIdList) {
        CatClassModel? catClassModel =
            categoryAll.firstWhereOrNull((catClass) => catClass.id == id);
        if (catClassModel != null) {
          classOrdemList.add(catClassModel.ordem);
        }
      }

      if (classOrdemList.isNotEmpty) {
        classOrdemList.sort();

        for (var element in classOrdemList) {
          categoryWidgetList.add(
            pw.Text('      $element'),

            // pw.Bullet(
            //   text: element,
            //   style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
            // ),
          );
        }
      }

      // Juntando frase e classificações
      lineList.add(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            richText,
            ...categoryWidgetList,
            pw.SizedBox(height: 5)
          ],
        ),
      );
    }
    return lineList;
  }
}

class _UrlText extends pw.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
      destination: url,
      child: pw.Text(
        text,
        style: const pw.TextStyle(
            // decoration: pw.TextDecoration.underline,
            // color: PdfColors.blue,
            fontSize: 10),
      ),
    );
  }
}
