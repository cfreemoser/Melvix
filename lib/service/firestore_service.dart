import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netflix_gallery/domain/content_ref.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<ContentRef>?> getAllContent() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('content');
    var collection = await ref.get();
    var contentRefs = collection.docs
        .where((element) => element.exists)
        .map(_mapToRef)
        .where((element) => element != null)
        .map((e) => e!)
        .toList();

    return contentRefs;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> subscribeToContent() {
    return firestore.collection('content').snapshots();
  }

  ContentRef? _mapToRef(QueryDocumentSnapshot<Object?> snapshot) {
    try {
      List<dynamic> dyn = snapshot['categories'].toList();
      List<String> categories = dyn.map((e) => e as String).toList();
      try {
        return ContentRef(
          bucket: snapshot['bucket'],
          videoURLPath: snapshot['videoPath'],
          description: snapshot['description'],
          title: snapshot['title'],
          titleSvgPath: snapshot['titleSvgPath'],
          categories: categories,
        );
      } catch (e) {
        return ContentRef(
          bucket: snapshot['bucket'],
          videoURLPath: snapshot['videoPath'],
          description: snapshot['description'],
          title: snapshot['title'],
          titleSvgPath: null,
          categories: categories,
        );
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
