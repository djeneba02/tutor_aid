import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_aid/model/detal.dart';
import 'package:tutor_aid/model/ticket.dart';
import 'ticket.dart';  // Assurez-vous que ce chemin est correct
 // Assurez-vous que ce chemin est correct

class TicketService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Ajouter un ticket
  Future<void> addTicket(Ticket ticket) async {
    try {
      await _db.collection('Tickets').add(ticket.toMap());
    } catch (e) {
      print('Erreur lors de l\'ajout du ticket: $e');
    }
  }

  // Lire tous les tickets
  Stream<List<Ticket>> getTickets() {
    return _db.collection('Tickets').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Ticket.fromFirestore(doc)).toList();
    });
  }

  // Lire un ticket par ID
  Future<Ticket?> getTicketById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection('Tickets').doc(id).get();
      return Ticket.fromFirestore(doc);
    } catch (e) {
      print('Erreur lors de la lecture du ticket: $e');
      return null;
    }
  }

  // Mettre à jour un ticket
  Future<void> updateTicket(String id, Ticket updatedTicket) async {
    try {
      await _db.collection('Tickets').doc(id).update(updatedTicket.toMap());
    } catch (e) {
      print('Erreur lors de la mise à jour du ticket: $e');
    }
  }

  // Supprimer un ticket
  Future<void> deleteTicket(String id) async {
    try {
      await _db.collection('Tickets').doc(id).delete();
    } catch (e) {
      print('Erreur lors de la suppression du ticket: $e');
    }
  }
}

class DetailTicketService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Ajouter un détail de ticket
  Future<void> addDetailTicket(DetailTicket detailTicket) async {
    try {
      await _db.collection('DetailTickets').add(detailTicket.toMap());
    } catch (e) {
      print('Erreur lors de l\'ajout du détail de ticket: $e');
    }
  }

  // Lire tous les détails d'un ticket par ID de ticket
  Stream<List<DetailTicket>> getDetailsByTicketId(String ticketId) {
    return _db.collection('DetailTickets')
      .where('ticket_id', isEqualTo: ticketId)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) => DetailTicket.fromFirestore(doc)).toList();
      });
  }

  // Lire un détail de ticket par ID
  Future<DetailTicket?> getDetailById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection('DetailTickets').doc(id).get();
      return DetailTicket.fromFirestore(doc);
    } catch (e) {
      print('Erreur lors de la lecture du détail de ticket: $e');
      return null;
    }
  }

  // Mettre à jour un détail de ticket
  Future<void> updateDetailTicket(String id, DetailTicket updatedDetail) async {
    try {
      await _db.collection('DetailTickets').doc(id).update(updatedDetail.toMap());
    } catch (e) {
      print('Erreur lors de la mise à jour du détail de ticket: $e');
    }
  }

  // Supprimer un détail de ticket
  Future<void> deleteDetailTicket(String id) async {
    try {
      await _db.collection('DetailTickets').doc(id).delete();
    } catch (e) {
      print('Erreur lors de la suppression du détail de ticket: $e');
    }
  }
}
