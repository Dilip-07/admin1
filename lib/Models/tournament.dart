import 'package:cloud_firestore/cloud_firestore.dart';

class Tournamentsmodel {
  String game;
  String organizationName;
  String organizationInfo;
  String tournamentsName;
  String startDate;
  String endDate;
  String image1;
  String image2;
  String image3;
  String tournamentsDetail;
  String rules;
  String prizePool;
  String contactVenue;
  int commentsCount;
  String date;
  String timeStamp;

  Tournamentsmodel(
      {this.game,
      this.organizationName,
      this.organizationInfo,
      this.tournamentsName,
      this.startDate,
      this.endDate,
      this.image1,
      this.image2,
      this.image3,
      this.tournamentsDetail,
      this.rules,
      this.prizePool,
      this.contactVenue,
      this.commentsCount,
      this.date,
      this.timeStamp});

  factory Tournamentsmodel.fromFirestore(QueryDocumentSnapshot snapshot) {
    var d = snapshot.data();
    return Tournamentsmodel(
        game: d['game'],
        organizationName: d['organization-name'],
        organizationInfo: d['organization-info'],
        tournamentsName: d['tournament-name'],
        startDate: d['start-date'],
        endDate: d['end-date'],
        image1: d['image1'],
        image2: d['image2'],
        image3: d['image3'],
        tournamentsDetail: d['tournament-details'],
        rules: d['rules'],
        prizePool: d['prize-pool'],
        contactVenue: d['contact-venue'],
        commentsCount: d['comments-count'],
        date: d['date'],
        timeStamp: d['Time-stamp']);
  }
}
