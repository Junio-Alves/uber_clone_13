import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile {
  final String userUid;
  final String nome;
  final String email;
  final String profileUrl;
  Profile({
    required this.userUid,
    required this.nome,
    required this.email,
    required this.profileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "userUid": userUid,
      "Nome": nome,
      "Email": email,
      "profileUrl": profileUrl,
    };
  }

  factory Profile.fromFireStore(Map<String, dynamic> data) {
    return Profile(
      userUid: data["userUid"],
      nome: data["Nome"],
      email: data["Email"],
      profileUrl: data["profileUrl"],
    );
  }

  static Future<Profile> getUserData() async {
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    final userId = auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await store.collection("usuarios").doc(userId).get();
    return Profile.fromFireStore(snapshot.data() as Map<String, dynamic>);
  }
}
