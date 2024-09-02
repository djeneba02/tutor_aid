import 'package:cloud_firestore/cloud_firestore.dart';

class DetailTicket {
  String id;
  String ticketId;
  Map<String, dynamic> details;

  DetailTicket({
    required this.id,
    required this.ticketId,
    required this.details,
  });

  // Convertir un document Firestore en instance de DetailTicket
  factory DetailTicket.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    return DetailTicket(
      id: doc.id,
      ticketId: data['ticket_id'] ?? '',
      details: data['details'] ?? {},
    );
  }

  // Convertir une instance de DetailTicket en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'ticket_id': ticketId,
      'details': details,
    };
  }
}
