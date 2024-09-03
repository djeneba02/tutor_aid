import 'package:cloud_firestore/cloud_firestore.dart';

class Reponse {
  final String userName; // Nom d'utilisateur
  final String reponse;
  final Timestamp date;

  Reponse({
    required this.userName,
    required this.reponse,
    required this.date,
  });

  // Crée une instance de Reponse à partir d'un DocumentSnapshot
  factory Reponse.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reponse(
      userName: data['user_name'] ?? 'Utilisateur inconnu',
      reponse: data['reponse'] ?? '',
      date: data['date'] ?? Timestamp.now(),
    );
  }

  // Convertit une instance de Reponse en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_name': userName,
      'reponse': reponse,
      'date': date,
    };
  }
}
