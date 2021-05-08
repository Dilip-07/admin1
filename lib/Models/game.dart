import 'package:cloud_firestore/cloud_firestore.dart';

class GamesModel {
  String gamename;
  String imageUrl;
  String timestamp;

  GamesModel({this.gamename, this.imageUrl, this.timestamp});

  factory GamesModel.fromFirestore(DocumentSnapshot snapshot) {
    var d = snapshot.data();
    return GamesModel(
      gamename: d['gamename'],
      imageUrl: d['imageUrl'],
      timestamp: d['timestamp'],
    );
  }
}
