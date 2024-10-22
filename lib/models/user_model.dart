import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Usuario {
  final String userUid;
  final String nome;
  final String email;
  final String profileUrl;
  Usuario({
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

  factory Usuario.fromFireStore(Map<String, dynamic> data) {
    return Usuario(
      userUid: data["userUid"],
      nome: data["Nome"],
      email: data["Email"],
      profileUrl: data["profileUrl"],
    );
  }

  static Future<Usuario> getUserData() async {
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    final userId = auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await store.collection("usuarios").doc(userId).get();
    return Usuario.fromFireStore(snapshot.data() as Map<String, dynamic>);
  }
}
