import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PhotoService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick a photo from gallery
  static Future<String?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        return await _savePhotoLocally(File(image.path));
      }
      return null;
    } catch (e) {
      debugPrint('[PhotoService] Error picking from gallery: $e');
      return null;
    }
  }

  /// Take a photo with camera
  static Future<String?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        return await _savePhotoLocally(File(image.path));
      }
      return null;
    } catch (e) {
      debugPrint('[PhotoService] Error taking photo: $e');
      return null;
    }
  }

  /// Save photo to app's document directory
  static Future<String> _savePhotoLocally(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${appDir.path}/photos');

      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      final fileName = 'expense_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final savedFile = await imageFile.copy('${photosDir.path}/$fileName');

      debugPrint('[PhotoService] Photo saved: ${savedFile.path}');
      return savedFile.path;
    } catch (e) {
      debugPrint('[PhotoService] Error saving photo: $e');
      rethrow;
    }
  }

  /// Delete photo by path
  static Future<void> deletePhoto(String? photoPath) async {
    if (photoPath == null || photoPath.isEmpty) return;

    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('[PhotoService] Photo deleted: $photoPath');
      }
    } catch (e) {
      debugPrint('[PhotoService] Error deleting photo: $e');
    }
  }

  /// Check if photo exists
  static Future<bool> photoExists(String? photoPath) async {
    if (photoPath == null || photoPath.isEmpty) return false;

    try {
      final file = File(photoPath);
      return await file.exists();
    } catch (e) {
      debugPrint('[PhotoService] Error checking photo: $e');
      return false;
    }
  }

  /// Show photo picker dialog
  static Future<String?> showPhotoPicker() async {
    // This would typically show a dialog asking user to choose
    // For now, return null - UI should handle this
    return null;
  }
}
