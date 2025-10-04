import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String? id;
  final String fullname;
  final String email;
  final String celular;
  final String password;

  const User({
    this.id,
    required this.email,
    required this.fullname,
    required this.password,
    required this.celular,
  });

  toJson() {
    return {
      "fullName": fullname,
      "Email": email,
      "Celular": celular,
      "Password": password,
    };
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return User(
      id: document.id,
      email: data["Email"],
      fullname: data["FullName"],
      password: data["Password"],
      celular: data["Celular"],
    );
  }
}
