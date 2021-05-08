import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminBloc extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _adminPass;
  String _userType = 'admin';
  bool _isSignedIn = false;
  bool _testing = false;

  List _games = [];
  List get games => _games;

  AdminBloc() {
    checkSignIn();
    getAdminPass();
  }

  String get adminPass => _adminPass;
  String get userType => _userType;
  bool get isSignedIn => _isSignedIn;
  bool get testing => _testing;

  Future getAdminPass() async {
    firestore
        .collection('admin')
        .doc('user type')
        .get()
        .then((DocumentSnapshot snap) {
      String _aPass = snap['admin password'];
      _adminPass = _aPass;
      notifyListeners();
    });
  }

  Future<int> getTotalDocuments(String documentName) async {
    final String fieldName = 'count';
    final DocumentReference ref =
        firestore.collection('item_count').doc(documentName);
    DocumentSnapshot snap = await ref.get();
    if (snap.exists == true) {
      int itemCount = snap[fieldName] ?? 0;
      return itemCount;
    } else {
      await ref.set({fieldName: 0});
      return 0;
    }
  }

  Future increaseCount(String documentName) async {
    await getTotalDocuments(documentName).then((int documentCount) async {
      await firestore
          .collection('item_count')
          .doc(documentName)
          .update({'count': documentCount + 1});
    });
  }

  Future decreaseCount(String documentName) async {
    await getTotalDocuments(documentName).then((int documentCount) async {
      await firestore
          .collection('item_count')
          .doc(documentName)
          .update({'count': documentCount - 1});
    });
  }

  Future getGames() async {
    QuerySnapshot snap = await firestore.collection('games').get();
    List d = snap.docs;
    _games.clear();
    d.forEach((element) {
      _games.add(element['gamename']);
    });
    notifyListeners();
  }

  Future deleteContent(timestamp, String collectionName) async {
    await firestore.collection(collectionName).doc(timestamp).delete();
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    _userType = 'Admin';
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }

  Future setSignInForTesting() async {
    _testing = true;
    _userType = 'tester';
    notifyListeners();
  }

  Future saveNewAdminPassword(String newPassword) async {
    await firestore.collection('admin').doc('user type').update(
        {'admin password': newPassword}).then((value) => getAdminPass());
    notifyListeners();
  }
}
