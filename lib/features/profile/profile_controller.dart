import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasikh/core/widgets/loading_dialog.dart';
import 'package:rasikh/features/profile/repository/profile_repository.dart';
import 'package:rasikh/l10n/app_localizations.dart';
import 'package:rasikh/core/utils/error_translator.dart';
import 'package:rasikh/core/api/api_exceptions.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
      return ProfileController(ref: ref);
    });

class ProfileController extends StateNotifier<bool> {
  final Ref _ref;
  ProfileController({required Ref ref}) : _ref = ref, super(false);

Future<String?> updateUserProfile({
    required BuildContext context,
    required AppLocalizations l10n,
    required Map<String, dynamic> newUserData,
  }) async {
    state = true;
    showLoadingDialog(Navigator.of(context, rootNavigator: true).context);

    try {
      await _ref.read(profileRepositoryProvider).updateUserProfile(newUserData);

      Navigator.of(context, rootNavigator: true).pop();
      _ref.invalidate(userProfileProvider);

      return null;
    } on ApiException catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      return getErrorMessage(e, context);
    } catch (_) {
      Navigator.of(context, rootNavigator: true).pop();
      return l10n.apiUnexpectedError;
    } finally {
      state = false;
    }
  }

Future<String?> changePassword({
  required BuildContext context,
  required AppLocalizations l10n,
  required String oldPassword,
  required String newPassword,
}) async {
  state = true;
  showLoadingDialog(Navigator.of(context, rootNavigator: true).context);

  try {
    await _ref.read(profileRepositoryProvider).changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    Navigator.of(context, rootNavigator: true).pop();
    return null;
  } on ApiException catch (e) {
    Navigator.of(context, rootNavigator: true).pop();
    return getErrorMessage(e, context);
  } catch (_) {
    Navigator.of(context, rootNavigator: true).pop();
    return l10n.apiUnexpectedError;
  } finally {
    state = false;
  }
}

Future<String?> updateAddress({
    required BuildContext context,
    required AppLocalizations l10n,
    required String userId,
    required String countryId,
    required String city,
    required String addressDetails,
  }) async {
    state = true;
    showLoadingDialog(Navigator.of(context, rootNavigator: true).context);

    try {
      await _ref.read(profileRepositoryProvider).updateAddress({
        'userId': userId,
        'countryId': countryId,
        'city': city,
        'addressDetails': addressDetails,
      });

      Navigator.of(context, rootNavigator: true).pop();
      _ref.invalidate(userProfileProvider);

      return null;
    } on ApiException catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      return getErrorMessage(e, context);
    } catch (_) {
      Navigator.of(context, rootNavigator: true).pop();
      return l10n.apiUnexpectedError;
    } finally {
      state = false;
    }
  }

}
