import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:finca/utils/app_exception.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService._();

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadFileWithUIntList(
    String path,
    Uint8List fileData, {
    bool isUpdating = false,
  }) async {
    try {
      final storageReference = _storage.ref().child(path);
      if (isUpdating) {
        try {
          await storageReference.delete();
        } catch (e) {}
      }
      final uploadTask = storageReference.putData(fileData);

      await uploadTask.whenComplete(() => null);

      return await storageReference.getDownloadURL();
    } on FirebaseException catch (e) {
      throw AppException(
        title: 'Upload Failed',
        message: e.message ?? 'Something went wrong!',
      );
    } catch (e, stacktrace) {
      log('uploadimagestacktrace: $stacktrace');
      throw AppException(
        title: 'Upload Failed',
        message: e.toString(),
      );
    }
  }

  static Future<String> uploadFile(String path, File file) async {
    try {
      final storageReference = _storage.ref().child(path);
      final uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() => null);

      return await storageReference.getDownloadURL();
    } on FirebaseException catch (e) {
      throw AppException(
        title: 'Upload Failed',
        message: e.message ?? 'Something went wrong!',
      );
    } catch (e, stacktrace) {
      log('uploadimagestacktrace: $stacktrace');
      throw AppException(
        title: 'Upload Failed',
        message: e.toString(),
      );
    }
  }

  static Future<void> deleteFile(String fileUrl) async {
    try {
      final storageReference = _storage.refFromURL(fileUrl);
      await storageReference.delete();
    } on FirebaseException catch (e) {
      throw AppException(
        title: 'Delete Failed',
        message: e.message ?? 'Something went wrong!',
      );
    } catch (e) {
      throw AppException(
        title: 'Delete Failed',
        message: e.toString(),
      );
    }
  }
}
