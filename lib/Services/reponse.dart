import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_aid/model/reponse.dart';

class ReponseService {
 final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Ajouter une réponse à Firestore
  // Future<void> addResponse(String ticketId, String reponseContent) async {
  //   final reponse = Reponse(
  //     id: '', // Firestore générera un ID unique
  //     ticketId: ticketId,
  //     reponse: reponseContent,
  //     date: Timestamp.now(),
  //   );

  //   await _reponseCollection.add(reponse.toMap());
  // }


  Future<void> addResponse(Reponse reponse, String ticketId) async {
    try {
      await _db.collection('Reponses').add(reponse.toMap());
    } catch (e) {
      print('Erreur lors de l\'ajout du ticket: $e');
    }
  }

  // Récupérer les réponses pour un ticket spécifique
  // Stream<List<Reponse>> getReponsesForTicket(String ticketId) {
  //   return _reponseCollection
  //       .where('ticketId', isEqualTo: ticketId)
  //       .orderBy('date', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //         return snapshot.docs.map((doc) => Reponse.fromFirestore(doc)).toList();
  //       });
  // }

  Stream<List<Reponse>> getReponsesForTicket(String ticketId) {
    return _db.collection('Reponses')
      .where('ticketId', isEqualTo: ticketId)  // Filtrer par ID de ticket
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) => Reponse.fromFirestore(doc)).toList();
      });
  }
  
}
