import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appliance.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;

  Future<List<Appliance>> fetchAppliances() async {
    final uid = _currentUid;
    if (uid == null) return [];

    var snapshot = await _db.collection('users').doc(uid).collection('appliances').get();
    return snapshot.docs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id;
      return Appliance.fromJson(data);
    }).toList();
  }

  Future<void> saveAppliance(Appliance app) async {
    final uid = _currentUid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).collection('appliances').doc(app.id).set(app.toJson());
  }

  Future<void> deleteAppliance(String id) async {
    final uid = _currentUid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).collection('appliances').doc(id).delete();
  }
}