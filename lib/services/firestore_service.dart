import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {

//  void initState() {
//    print('init stae called');
//    Firestore.instance.settings(host: "10.0.2.2:8080", sslEnabled: false);  }
  FirestoreService._();
  static final instance = FirestoreService._();

//  setSettings(){
//
//  }
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
  }

  Future<void> setData1({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = Firestore.instance.collection(path);
    print('$path: $data');
    await reference.document().setData(data);
  }


  Future<void> deleteData({@required String path}) async {
    final reference = Firestore.instance.document(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
//    Firestore.instance.settings(host: "10.0.2.2:8080", sslEnabled: false);
    print(path);

    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    print('snapshots $snapshots');
    return snapshots.map((snapshot) {
//      print(snapshot.documents.first.data);
      final result = snapshot.documents
          .map((snapshot) => builder(snapshot.data, snapshot.documentID))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = Firestore.instance.document(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data, snapshot.documentID));
  }
}
