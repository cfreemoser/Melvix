import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';
import 'package:netflix_gallery/domain/melvix_file.dart';
import 'package:netflix_gallery/domain/quick_content.dart';

class StorageService {
  final firebase_storage.FirebaseStorage _storage;

  StorageService() : _storage = firebase_storage.FirebaseStorage.instance;

  Future<String?> getDownloadPathFromRef(String ref) async {
    try {
      return await _storage.ref(ref).getDownloadURL();
    } on FirebaseException catch (error) {
      if (error.code == "quota-exceeded") {
        throw StorageQuotaExceeded();
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future uploadQuickContent(MelvixFile file, String folderRef) async {
    final fileRef = _storage.ref().child(folderRef + "/" + file.name);
    try {
      var contentType = mime(file.name);

      await fileRef.putData(
          file.content,
          SettableMetadata(
            contentType: contentType,
          ));
    } on FirebaseException {
      throw StorageUploadError();
    }
  }

  Future<List<QuickContent?>?> getDownloadAllDownloadPathsFromFolderRef(
      String folderRef) async {
    try {
      var listResult = await _storage.ref(folderRef).list();
      return Future.wait(listResult.items.map(mapFromRef));
    } catch (e) {
      return null;
    }
  }

  Future<QuickContent?> mapFromRef(firebase_storage.Reference reference) async {
    try {
      var downloadUrl = await reference.getDownloadURL();
      var type = await reference.getMetadata().then((e) => e.contentType);
      if (type == "video/mp4" || type == "video/webm") {
        return QuickContent(
            contentUrl: downloadUrl, type: QuickContentType.video);
      } else if (type != null && type.startsWith("image") ||
          type != null && type.startsWith("video")) {
        return QuickContent(
            contentUrl: downloadUrl, type: QuickContentType.photo);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class StorageQuotaExceeded implements Exception {
  // can contain constructors, variables and methods
}

class StorageUploadError implements Exception {
  // can contain constructors, variables and methods
}

class StorageUnsupportedContentTypeError implements Exception {}
