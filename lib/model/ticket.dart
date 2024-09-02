import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  String id;
  String titre;
  String description;
  String status;
  String categorie;
  Timestamp dateCreation;
  String userId;

  Ticket({
    required this.id,
    required this.titre,
    required this.description,
    required this.status,
    required this.categorie,
    required this.dateCreation,
    required this.userId,
  });

  // Convertir un document Firestore en instance de Ticket
  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    return Ticket(
      id: doc.id,
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'Attente',
      categorie: data['categorie'] ?? '',
      dateCreation: data['date_creation'] ?? Timestamp.now(),
      userId: data['user_id'] ?? '',
    );
  }

  // Convertir une instance de Ticket en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'status': status,
      'categorie': categorie,
      'date_creation': dateCreation,
      'user_id': userId,
    };
  }
}
