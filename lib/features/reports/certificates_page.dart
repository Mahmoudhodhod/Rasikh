import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import 'certificate_view_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/certificate_model.dart';
import 'repository/certificates_repository.dart';
import '../auth/repository/auth_repository.dart';
import '../../core/widgets/login_required_widget.dart';

class CertificatesPage extends ConsumerWidget {
  const CertificatesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final isGuest = authState == AuthStatus.guest;

    if (isGuest) {
      return Scaffold(
        body: LoginRequiredWidget(
          title: l10n.loginRequiredTitle,
          message: l10n.loginRequiredMessage,
        ),
      );
    }

    final certificatesAsync = ref.watch(certificatesProvider);

    return Scaffold(
      body: certificatesAsync.when(
        data: (certificates) {
          if (certificates.isEmpty) {
            return _buildEmptyState(l10n);
          }
          return _buildCertificatesList(certificates, l10n);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildErrorState(context, ref, l10n, e),
      ),
    );
  }

  Widget _buildCertificatesList(
    List<CertificateModel> certificates,
    AppLocalizations l10n,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final cert = certificates[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: TColors.primary,
              child: Icon(Iconsax.award, color: Colors.white),
            ),
            title: Text(cert.partName),
            subtitle: Text("${cert.planName} - ${cert.date}"),

            trailing: IconButton(
              icon: const Icon(Iconsax.eye, color: TColors.secondary),
              onPressed: () {
                _openCertificate(context, cert);
              },
            ),
            onTap: () {
              _openCertificate(context, cert);
            },
          ),
        );
      },
    );
  }

  void _openCertificate(BuildContext context, CertificateModel cert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificateViewScreen(certificate: cert),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.55,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        'assets/images/no_certificate.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    l10n.noCertificatesFound,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Object error,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: TColors.reportMedium.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.wifi_square,
                        size: 50,
                        color: TColors.reportMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "خطأ في الاتصال",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: TColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "تعذر تحميل الشهادات. تأكد من اتصالك بالإنترنت وحاول مرة أخرى.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: TColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(certificatesProvider);
                      },
                      icon: const Icon(Iconsax.refresh),
                      label: Text(l10n.retryButton),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
