import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  static final ImagePicker _picker = ImagePicker();

  /// Request camera permission only
  static Future<bool> requestCameraPermission() async {
    try {
      print('Requesting camera permission...');
      
      PermissionStatus status = await Permission.camera.request();
      bool cameraGranted = status.isGranted;

      print('Camera permission: $cameraGranted');

      return cameraGranted;
    } catch (e) {
      print('Error requesting camera permission: $e');
      return false;
    }
  }

  /// Request storage permission only
  static Future<bool> requestStoragePermission() async {
    try {
      print('Requesting storage permission...');
      
      // For Android 13+ (API 33+), use photos permission
      // For older versions, use storage permission
      PermissionStatus status;
      if (Platform.isAndroid) {
        // Check if we're on Android 13+ (API 33+)
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
      
      bool storageGranted = status.isGranted;

      print('Storage permission: $storageGranted');

      return storageGranted;
    } catch (e) {
      print('Error requesting storage permission: $e');
      return false;
    }
  }

  /// Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      print('Attempting to pick image from camera...');
      
      // Request camera permission only
      bool cameraGranted = await requestCameraPermission();
      if (!cameraGranted) {
        throw Exception('Camera permission is required. Please grant camera permission in settings.');
      }

      print('Camera permission granted, opening camera...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        print('Image selected from camera: ${image.path}');
        return File(image.path);
      } else {
        print('No image selected from camera');
        return null;
      }
    } catch (e) {
      print('Error picking image from camera: $e');
      rethrow;
    }
  }

  /// Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      print('Attempting to pick image from gallery...');
      
      // Request storage permission only
      bool storageGranted = await requestStoragePermission();
      if (!storageGranted) {
        throw Exception('Gallery permission is required. Please grant photos permission in settings.');
      }

      print('Storage permission granted, opening gallery...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        print('Image selected from gallery: ${image.path}');
        return File(image.path);
      } else {
        print('No image selected from gallery');
        return null;
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      rethrow;
    }
  }

  /// Show image picker dialog with better error handling
  static Future<File?> showImagePickerDialog(BuildContext context) async {
    print('Showing image picker dialog...');
    
    // Show a simple bottom sheet instead of dialog for better navigation
    return await showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Color(0xFF2A2F4F),
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image Source',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue, size: 30),
                title: Text('Camera', style: TextStyle(color: Colors.white, fontSize: 16)),
                subtitle: Text('Take a photo', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                onTap: () async {
                  print('Camera option selected');
                  
                  try {
                    final file = await pickImageFromCamera();
                    print('Camera file captured: ${file?.path}');
                    // Return the file through the bottom sheet
                    Navigator.of(bottomSheetContext).pop(file);
                  } catch (e) {
                    print('Camera error: $e');
                    if (context.mounted) {
                      _showCameraErrorDialog(context, e.toString());
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.green, size: 30),
                title: Text('Gallery', style: TextStyle(color: Colors.white, fontSize: 16)),
                subtitle: Text('Choose from photos', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                onTap: () async {
                  print('Gallery option selected');
                  
                  try {
                    final file = await pickImageFromGallery();
                    print('Gallery file selected: ${file?.path}');
                    // Return the file through the bottom sheet
                    Navigator.of(bottomSheetContext).pop(file);
                  } catch (e) {
                    print('Gallery error: $e');
                    if (context.mounted) {
                      _showErrorDialog(context, 'Gallery Error', 'Unable to access gallery. This might be because:\n\n• Photos permission is not granted\n• No photos available\n• Gallery app is not available\n\nPlease check your permissions and try again.');
                    }
                  }
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  print('Bottom sheet cancelled');
                  Navigator.of(bottomSheetContext).pop();
                },
                child: Text('Cancel', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show error dialog with more detailed information
  static void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext errorContext) {
        return AlertDialog(
          backgroundColor: Color(0xFF2A2F4F),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(errorContext).pop(),
              child: Text('OK', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  /// Show camera error dialog with more detailed information
  static void _showCameraErrorDialog(BuildContext context, String errorMessage) {
    String message = 'Unable to open camera. This might be because:\n\n';
    
    if (errorMessage.contains('permission')) {
      message += '• Camera permission is not granted\n';
      message += '• Please grant camera permission in settings\n\n';
      message += 'Try using Gallery instead.';
    } else {
      message += '• Camera is not available on this device/emulator\n';
      message += '• Camera is being used by another app\n';
      message += '• Camera hardware issue\n\n';
      message += 'Try using Gallery instead.';
    }
    
    message += '\n\nError: $errorMessage';
    
    showDialog(
      context: context,
      builder: (BuildContext errorContext) {
        return AlertDialog(
          backgroundColor: Color(0xFF2A2F4F),
          title: Text(
            'Camera Error',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(errorContext).pop(),
              child: Text('OK', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }
} 