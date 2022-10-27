import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String userName;
  String userEmailId;
  String userStatus;
  UserModel({
    required this.userName,
    required this.userEmailId,
    required this.userStatus,
  });

  factory UserModel.fromMap(QueryDocumentSnapshot<Object?> map) {
    return UserModel(
      userName: map["name"] ?? 'No User',
      userEmailId: map["email"] ?? 'No Email',
      userStatus: map["status"] ?? 'Unknown',
    );
  }
}


class DocModel {
  String docName;
  String docEmailId;
  String docStatus;
  String docId;
  String docExperience;


  DocModel({
    required this.docName,
    required this.docEmailId,
    required this.docStatus,
    required this.docId,
    required this.docExperience,
  });

  factory DocModel.fromMap(QueryDocumentSnapshot<Object?> map) {
    return DocModel(

      docName: map["name"] ?? 'No User',
      docEmailId: map["email"] ?? 'No Email',
      docStatus: map["status"] ?? 'Unknown',
      docExperience: map['id'] ?? 'no id',
      docId: map["experience"] ?? 'no exp',
    );
  }
}