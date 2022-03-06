import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageService {
  final firebase_storage.FirebaseStorage _storage;

  StorageService() : _storage = firebase_storage.FirebaseStorage.instance;

  Future<String?> testfunc() async {
    try {
      firebase_storage.ListResult result = await _storage.ref().listAll();

      result.items.forEach((firebase_storage.Reference ref) {
        log('Found file: $ref.');
      });

      result.prefixes.forEach((firebase_storage.Reference ref) {
        log('Found directory: $ref');
      });

      return _storage
          .ref("9a96876e2f8f3dc4f3cf45f02c61c0c1.jpeg")
          .getDownloadURL();
    } catch (e) {
      log("$e");
      print(e);
      return null;
    }
  }

  Future<String?> testfunc2() async {
    try {
      firebase_storage.ListResult result = await _storage.ref().listAll();

      result.items.forEach((firebase_storage.Reference ref) {
        log('Found file: $ref.');
      });

      result.prefixes.forEach((firebase_storage.Reference ref) {
        log('Found directory: $ref');
      });

      return _storage.ref("i-am-watching-you.mp4").getDownloadURL();
    } catch (e) {
      log("$e");
      print(e);
      return null;
    }
  }
}
