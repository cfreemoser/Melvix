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

  // TODO support video and folders
  Future<List<String?>?> getDownloadAllDownloadPathsFromFolderRef(
      String folderRef) async {
    try {
      var listResult = await _storage.ref(folderRef).list();
      return Future.wait(listResult.items.map((e) => e.getDownloadURL()));
    } catch (e) {
      return null;
    }
  }
}
