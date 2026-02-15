import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import '../auth/repository/auth_repository.dart';
import '../profile/repository/profile_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class TajweedRulesScreen extends ConsumerStatefulWidget {
  const TajweedRulesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TajweedRulesScreen> createState() => _TajweedRulesScreenState();
}

class _TajweedRulesScreenState extends ConsumerState<TajweedRulesScreen> {
  PdfControllerPinch? _pdfController;
  // ignore: unused_field
  int _pagesCount = 0;
  // ignore: unused_field
  int _currentPage = 1;
  bool _isLoading = true;
  double _downloadProgress = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _downloadProgress = 0;
      });

      final apiService = ref.read(apiServiceProvider);

      int? planId;
      try {
        final user = await ref.read(userProfileProvider.future);
        planId = user.planId;
      } catch (e) {
        debugPrint("⚠️ [Tajweed Screen] PlanID error: $e");
      }

      final tajweedData = await apiService.getTajweedRules(id: planId);
      final String? pdfUrl = tajweedData['filePath'];

      if (pdfUrl == null || pdfUrl.isEmpty) {
        throw Exception("لم يتم العثور على رابط الملف");
      }

      final dir = await getApplicationDocumentsDirectory();
      final fileName = pdfUrl.split('/').last;
      final file = File('${dir.path}/$fileName');

      if (!await file.exists()) {
        final dio = Dio();
        await dio.download(
          pdfUrl,
          file.path,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                _downloadProgress = received / total;
              });
            }
          },
        );
      }

      _pdfController?.dispose();

      _pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(file.path),
        initialPage: 1,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ PDF Error: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "حدث خطأ أثناء تحميل الملف. يرجى المحاولة لاحقاً.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF8F9FA),
      appBar: !isLandscape
          ? AppBar(
              title: Text(l10n.tajweedRulesTitle),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: _loadPdf,
                ),
              ],
            )
          : null,
      body: SafeArea(child: _buildBody(l10n, isLandscape)),
    );
  }

  Widget _buildBody(AppLocalizations l10n, bool isLandscape) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            if (_downloadProgress > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(
                  value: _downloadProgress,
                  backgroundColor: TColors.borderSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
                ),
              ),
              const SizedBox(height: 10),
              Text("${(_downloadProgress * 100).toInt()}%"),
            ],
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _PdfError(message: _errorMessage!, onRetry: _loadPdf);
    }

    return Stack(
      children: [
        PdfViewPinch(
          controller: _pdfController!,
          padding: 8,
          onDocumentLoaded: (doc) {
            setState(() => _pagesCount = doc.pagesCount);
          },
          onPageChanged: (page) {
            setState(() => _currentPage = page);
          },
          builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            documentLoaderBuilder: (_) => const _PdfLoading(),
            pageLoaderBuilder: (_) => const _PdfLoading(),
            errorBuilder: (_, error) =>
                _PdfError(message: error.toString(), onRetry: _loadPdf),
          ),
        ),
      ],
    );
  }
}

class _PdfLoading extends StatelessWidget {
  const _PdfLoading();
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _PdfError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _PdfError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.danger, size: 48, color: TColors.reportBad),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          TextButton(onPressed: onRetry, child: const Text("إعادة المحاولة")),
        ],
      ),
    );
  }
}



