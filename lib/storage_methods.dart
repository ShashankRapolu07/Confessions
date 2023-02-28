import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(
      String collection_name, String doc_name, Uint8List image_data) async {
    String downloadURL = 'Some error occurred';
    Reference ref = await _storage.ref().child(collection_name).child(doc_name);
    UploadTask uploadTask = ref.putData(image_data);
    TaskSnapshot snap = await uploadTask;
    downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }
}
