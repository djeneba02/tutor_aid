import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Role {
  final String id;
  final String name;

  Role({required this.id, required this.name});

  // Méthode pour convertir un document Firestore en instance de Role
  factory Role.fromFirestore(DocumentSnapshot doc) {
    print('Document data: ${doc.data()}'); // Log des données du document
    return Role(
      id: doc.id,
      name: doc['name'] ?? '', // Utilisation d'une valeur par défaut si 'name' est null
    );
  }

  // Méthode pour convertir une instance de Role en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
    };
  }
}