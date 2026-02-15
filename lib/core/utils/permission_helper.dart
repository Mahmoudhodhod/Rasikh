import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

class PermissionHelper {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    return _requestPermission(context, Permission.camera, 'الكاميرا');
  }

  static Future<bool> requestGalleryPermission(BuildContext context) async {
    Permission permission;
    if (Platform.isAndroid) {
      
      permission = Permission.photos;
    } else {
      permission = Permission.photos;
    }

    return _requestPermission(context, permission, 'معرض الصور');
  }

  static Future<bool> _requestPermission(
    BuildContext context,
    Permission permission,
    String permissionName,
  ) async {
    var status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    status = await permission.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      if (context.mounted) {
        _showSettingsDialog(context, permissionName);
      }
      return false;
    }

    return false;
  }

  static void _showSettingsDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('الإذن مطلوب'),
          content: Text(
            'لا يمكننا الوصول إلى $permissionName. يرجى تفعيل الإذن من إعدادات التطبيق للمتابعة.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                openAppSettings();
              },
              child: const Text('الإعدادات'),
            ),
          ],
        );
      },
    );
  }
}
