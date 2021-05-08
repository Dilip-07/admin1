import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String nickName;
  String userEmail;
  String imageUrl;
  String uid;
  String phoneNumber;

  User({
    this.nickName,
    this.userEmail,
    this.imageUrl,
    this.uid,
    this.phoneNumber,
  });

  factory User.fromFirestore(QueryDocumentSnapshot snapshot) {
    var d = snapshot.data();

    return User(
      nickName: d[' Nick Name'] ?? '',
      userEmail: d['email'] ?? '',
      imageUrl: d['image url'] ??
          'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png',
      uid: d['uid'] ?? '',
      phoneNumber: d['Phone number'] ?? '',
    );
  }
}
