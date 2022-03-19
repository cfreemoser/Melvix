import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageService {
  final firebase_storage.FirebaseStorage _storage;

  StorageService() : _storage = firebase_storage.FirebaseStorage.instance;

  Future<String?> getDownloadPathFromRef(String ref) async {
    try {
      return _storage.ref(ref).getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
