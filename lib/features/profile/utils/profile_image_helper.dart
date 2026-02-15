import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/permission_helper.dart';

class ProfileImageHelper {
  static final ImagePicker _picker = ImagePicker();

  static void showImageSourceActionSheet(
    BuildContext context, {
    required Function(File) onImageReady,
  }) {
    final localizations = AppLocalizations.of(context)!;

    // ignore: prefer_function_declarations_over_variables
    Function(ImageSource) selectImage = (source) async {
      Navigator.of(context).pop();

      bool hasPermission = false;

      if (source == ImageSource.camera) {
        hasPermission = await PermissionHelper.requestCameraPermission(context);
      } else {
        hasPermission = await PermissionHelper.requestGalleryPermission(
          context,
        );
      }

      if (hasPermission) {
        try {
          final pickedFile = await _picker.pickImage(source: source);
          if (pickedFile != null) {
            _cropImage(context, File(pickedFile.path), onImageReady);
          }
        } catch (e) {
          debugPrint("Error picking image: $e");
        }
      }
    };

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(localizations.cameraOption),
              onPressed: () => selectImage(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text(localizations.galleryOption),
              onPressed: () => selectImage(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localizations.cancelOption),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Iconsax.camera, color: TColors.primary),
                  title: Text(
                    localizations.cameraOption,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () => selectImage(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Iconsax.gallery, color: TColors.primary),
                  title: Text(
                    localizations.galleryOption,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () => selectImage(ImageSource.gallery),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  static Future<void> _cropImage(
    BuildContext context,
    File imageFile,
    Function(File) onImageReady,
  ) async {
    final localizations = AppLocalizations.of(context)!;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 80,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: localizations.cropImageTitle,
          toolbarColor: TColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: localizations.cropImageTitle,
          doneButtonTitle: localizations.cropImageDone,
          cancelButtonTitle: localizations.cropImageCancel,
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          resetAspectRatioEnabled: false,
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    if (croppedFile != null) {
      onImageReady(File(croppedFile.path));
    }
  }

  static void showProfileImagePreview(
    BuildContext context, {
    required UserModel user,
    File? currentLocalFile,
    required VoidCallback onEditClicked,
  }) {
    final localizations = AppLocalizations.of(context)!;

    ImageProvider imageProvider;
    if (currentLocalFile != null) {
      imageProvider = FileImage(currentLocalFile);
    } else if (user.profileImage != null && user.profileImage!.isNotEmpty) {
      imageProvider = CachedNetworkImageProvider(user.profileImage!);
    } else {
      imageProvider = const AssetImage('assets/images/default_profile.png');
    }

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    InteractiveViewer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.contain,
                          height: 400,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onEditClicked();
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(localizations.changePhotoAction),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
