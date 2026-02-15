import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/certificate_model.dart';

class CertificateViewScreen extends StatelessWidget {
  final CertificateModel certificate;
  const CertificateViewScreen({Key? key, required this.certificate})
    : super(key: key);

  final double certificateWidth = 1368;
  final double certificateHeight = 967;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.certificateScreenTitle)),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 4.0,
              child: Center(
                child: AspectRatio(
                  aspectRatio: certificateWidth / certificateHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                  
                      Image.asset(
                        'assets/images/certificate_template_clear.png',
                        fit: BoxFit.cover,
                      ),
                      _buildPositionedText(
                        topFraction: 0.12,
                        leftFraction: 0.5,
      
                        text: l10n.certificateTitle(
                          certificate.partName,
                        ),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),

                      _buildPositionedText(
                        topFraction: 0.28,
                        leftFraction: 0.5,
                        text: l10n.certificatePresentedTo,
                        fontSize: 6.5,
                        fontWeight: FontWeight.bold,
                      ),

                      _buildPositionedText(
                        topFraction: 0.37,
                        leftFraction: 0.5,
                        text: certificate.studentName,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),

                      _buildPositionedText(
                        topFraction: 0.535,
                        leftFraction: 0.5,
                        text: l10n.certificateBlessing,
                        fontSize: 6,
                        color: TColors.primary,
                        fontWeight: FontWeight.bold,
                      ),

                      _buildPositionedText(
                        topFraction: 0.82,
                        leftFraction: 0.10,
                        text: l10n.signatureLabel,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                      ),
                 
                      _buildPositionedText(
                        topFraction: 0.92,
                        leftFraction: 0.92,
                        text: certificate.date,
                        fontSize: 8.5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Iconsax.document_download),
              label: Text(l10n.downloadAsPdfButton),
              onPressed: () {
                _createAndSavePdfFromImage(context, l10n, certificate);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: TColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionedText({
    required double topFraction,
    double? leftFraction,
    required String text,
    double fontSize = 24.0,
    double height = 1.5,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    final double dx = leftFraction ?? 0.5;
    final double dy = topFraction;

    return Align(
      alignment: FractionalOffset(dx, dy),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            fontFamily: 'Amiri',
            height: height,
          ),
        ),
      ),
    );
  }

  Future<void> _createAndSavePdfFromImage(
    BuildContext context,
    AppLocalizations l10n,
    CertificateModel certificate,
  ) async {
    final pdf = pw.Document();

    final imageBytes = await rootBundle.load(
      'assets/images/certificate_template_clear.png',
    );
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    final fontNormal = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Amiri-Regular.ttf"),
    );
    final fontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Amiri-Bold.ttf"),
    );
    PdfColor _pdfColor(Color c) {
      return PdfColor.fromInt(c.value);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(0),
        build: (pw.Context pdfContext) {
          final pageHeight = pdfContext.page.pageFormat.height;
          final pageWidth = pdfContext.page.pageFormat.width;

          return pw.Stack(
            children: [
              pw.Image(image, fit: pw.BoxFit.cover),
              pw.Positioned(
                top: 0.10 * pageHeight,
                left: 0,
                right: 0,
                child: pw.Center(
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(color: PdfColors.white),
                    child: pw.Text(
             
                      l10n.certificateTitle(certificate.partName),
                      textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        font: fontNormal,
                        fontBold: fontBold,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13 * 2.2,
                        color: _pdfColor(Colors.black),
                        height: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

       
              pw.Positioned(
                top: 0.27 * pageHeight,
                left: 0,
                right: 0,
                child: pw.Center(
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(color: PdfColors.white),
                    child: pw.Text(
                      l10n.certificatePresentedTo,
                      textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        font: fontNormal,
                        fontBold: fontBold,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 6.5 * 2.2,
                        color: _pdfColor(Colors.black),
                        height: 2,
                      ),
                    ),
                  ),
                ),
              ),

              pw.Positioned(
                top: 0.35 * pageHeight,
                left: 0,
                right: 0,
                child: pw.Center(
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(color: PdfColors.white),
                    child: pw.Text(
                      certificate.studentName,
                      textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        font: fontNormal,
                        fontBold: fontBold,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11 * 2.2,
                        color: _pdfColor(Colors.black),
                        height: 2,
                      ),
                    ),
                  ),
                ),
              ),

              pw.Positioned(
                top: 0.505 * pageHeight,
                left: 0,
                right: 0,
                child: pw.Center(
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(color: PdfColors.white),
                    child: pw.Text(
                      l10n.certificateBlessing,
                      textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        font: fontNormal,
                        fontBold: fontBold,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 6 * 2.2,
                        color: _pdfColor(TColors.primary),
                        height: 2,
                      ),
                    ),
                  ),
                ),
              ),

              pw.Positioned(
                top: 0.79 * pageHeight,
                right: 0.70 * pageWidth,
                child: pw.Container(
                  decoration: const pw.BoxDecoration(color: PdfColors.white),
                  child: pw.Text(
                    l10n.signatureLabel,
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      font: fontNormal,
                      fontBold: fontBold,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 8.5 * 1.8,
                      color: _pdfColor(Colors.black),
                      height: 2,
                    ),
                  ),
                ),
              ),

              pw.Positioned(
                top: 0.89 * pageHeight,
                left: 0.83 * pageWidth,
                child: pw.Container(
                  decoration: const pw.BoxDecoration(color: PdfColors.white),
                  child: pw.Text(
                    certificate.date,
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      font: fontNormal,
                      fontSize: 9.5 * 1.8,
                      color: _pdfColor(Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
