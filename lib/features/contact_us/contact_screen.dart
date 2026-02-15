import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/cache_service.dart';
import '../../core/models/user_model.dart';
import '../../core/api/api_exceptions.dart';
import '../../core/utils/error_translator.dart';
import '../auth/repository/auth_repository.dart';
import '../../core/models/contact_type_model.dart';
import 'contact_repository.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  final bool isLoggedIn;

  const ContactUsScreen({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  ConsumerState<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends ConsumerState<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _messageController = TextEditingController();

  int? _selectedContactTypeId; 
  List<ContactType> _contactTypes = [];
  bool _isLoadingTypes = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchContactTypes();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchContactTypes() async {
    try {
      final types = await ref
          .read(contactRepositoryProvider)
          .fetchContactTypes();
      if (mounted) {
        setState(() {
          _contactTypes = types;
          _isLoadingTypes = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching types: $e");
      if (mounted) setState(() => _isLoadingTypes = false);
    }
  }

  (IconData, Color, String) _getTypeStyle(
    ContactType type,
    AppLocalizations localizations,
  ) {
    final String name = type.name.trim();

    if (name.contains("شكوى") ||
        name.contains("Complaint") ||
        name.contains("plaint")) {
      return (
        Iconsax.warning_2,
        Colors.redAccent,
        localizations.contactTypeComplaint,
      );
    } else if (name.contains("ملاحظة") ||
        name.contains("Note") ||
        name.contains("notice")) {
      return (
        Iconsax.clipboard_text,
        Colors.blueAccent,
        localizations.contactTypeNote,
      );
    } else if (name.contains("أفكار") ||
        name.contains("فكرة") ||
        name.contains("Idea")) {
      return (Iconsax.lamp_on, Colors.amber, localizations.contactTypeIdea);
    } else if (name.contains("استفسار") ||
        name.contains("سؤال") ||
        name.contains("Inquiry") ||
        name.contains("Query")) {
      return (
        Iconsax.message_question,
        Colors.green,
        localizations.contactTypeInquiry,
      );
    } else {
      return (Iconsax.message, Colors.grey, type.name);
    }
  }
  Future<void> _launchWebsite() async {
    final Uri url = Uri.parse('https://rasekh.app/portal/login');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  UserModel? _getCachedUser() {
    final cache = ref.read(cacheServiceProvider);
    final data = cache.getData(key: CacheKeys.userProfile);
    if (data == null) return null;

    try {
      return UserModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> _sendMessage() async {
    HapticFeedback.lightImpact();
    final localizations = AppLocalizations.of(context)!;

    if (!widget.isLoggedIn) {
      _showSnackBar(localizations.apiUnexpectedError, isError: true);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      _showSnackBar(localizations.validationFillAllFields, isError: true);
      return;
    }

    if (_selectedContactTypeId == null) {
      _showSnackBar(localizations.contactTypeHint, isError: true);
      return;
    }

    final cachedUser = _getCachedUser();
    if (cachedUser == null) {
      _showSnackBar(localizations.apiUnexpectedError, isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final secureStorage = ref.read(secureStorageProvider);
      final userIdString = await secureStorage.read(key: 'user_id');
      final String userId = userIdString ?? cachedUser.id;

      int typeId = 1;
      switch (_selectedContactTypeId) {
        case 1:
          typeId = 1;
          break;
        case 2:
          typeId = 2;
          break;
        case 3:
          typeId = 3;
          break;
        case 4:
          typeId = 4;
          break;
      }

      await ref
          .read(apiServiceProvider)
          .sendContactMessage(
            userId: userId,
            description: _messageController.text.trim(),
            contactTypeId: typeId,
          );

      if (mounted) {
        _clearForm();
        _showSuccessDialog(localizations);
      }
    } on ApiException catch (e) {
      if (mounted) {
        _showSnackBar(getErrorMessage(e, context), isError: true);
      }
    } catch (e) {
      debugPrint("Error sending contact message: $e");
      if (mounted) {
        _showSnackBar(localizations.apiUnexpectedError, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearForm() {
    _messageController.clear();
    setState(() {
      _selectedContactTypeId = null;
    });
  }

  void _showSuccessDialog(AppLocalizations localizations) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 10),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.tick_circle,
                    size: 40,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  localizations.dialogSuccessTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TColors.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.dialogSuccessContent,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      localizations.dialogButtonOk,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.redAccent : TColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        content: Row(
          children: [
            Icon(
              isError ? Iconsax.warning_2 : Iconsax.tick_circle,
              color: Colors.white,
              size: 26,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.contactUsTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderBanner(textTheme, localizations),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildContactInfo(textTheme, localizations),
                  const SizedBox(height: 24),
                  _buildGuestCard(localizations),
                  if (widget.isLoggedIn) ...[
                    const SizedBox(height: 32),
                    _buildContactForm(localizations, isLandscape),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(
    TextTheme textTheme,
    AppLocalizations localizations,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16.0, 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/welcome_contact_banner.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.black.withOpacity(0.7),
              ),
              child: const SizedBox(height: 50),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              localizations.contactUsHeader,
              style: textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(
    TextTheme textTheme,
    AppLocalizations localizations,
  ) {
    return Column(
      children: [
        Text(
          localizations.contactInfoTitle,
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          localizations.contactInfoSub,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // _buildInfoRow(icon: Iconsax.call, text: '+986 4479 35673'),
        const SizedBox(height: 16),
        // _buildInfoRow(icon: Iconsax.sms, text: 'rasekh@gmail.com'),
        const SizedBox(height: 24),
        // _buildSocialIcons(),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: TColors.primary, size: 24),
        const SizedBox(width: 12),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(FontAwesomeIcons.youtube),
        const SizedBox(width: 16),
        _buildSocialIcon(FontAwesomeIcons.instagram),
        const SizedBox(width: 16),
        _buildSocialIcon(FontAwesomeIcons.facebook),
        const SizedBox(width: 16),
        _buildSocialIcon(FontAwesomeIcons.twitter),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: TColors.secondary,
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildGuestCard(AppLocalizations localizations) {
    const website = 'https://rasekh.app/';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.secondary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TColors.secondary.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Iconsax.link_21, color: TColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.openInWebSite,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: TColors.secondary,
                  ),
                ),
                const SizedBox(height: 6),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    website,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.black.withOpacity(0.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                await _launchWebsite();
              } catch (_) {
                if (mounted) {
                  _showSnackBar(
                    localizations.apiUnexpectedError,
                    isError: true,
                  );
                }
              }
            },
            icon: const Icon(Iconsax.export_1, color: TColors.primary),
            tooltip: 'Open website',
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm(AppLocalizations localizations, bool isLandscape) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              hint: _isLoadingTypes
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      localizations.contactTypeHint,
                      style: const TextStyle(color: Colors.grey),
                    ),
              value: _selectedContactTypeId,
              icon: const Icon(Iconsax.arrow_down_1, color: TColors.primary),
              items: _contactTypes.map((type) {
                final style = _getTypeStyle(type, localizations);
                final icon = style.$1;
                final color = style.$2;
                final text = style.$3;

                return DropdownMenuItem<int>(
                  value: type.id,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: TColors.secondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (int? newId) {
                setState(() {
                  _selectedContactTypeId = newId;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _messageController,
            decoration: InputDecoration(labelText: localizations.messageLabel),
            maxLines: 4,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? localizations.validationMessageRequired
                : null,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading ? null : _sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
              shadowColor: TColors.primary.withOpacity(0.3),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(localizations.sendButton),
          ),
          if(!isLandscape)
          const SizedBox(height: 45),
        ],
      ),
    );
  }
}

