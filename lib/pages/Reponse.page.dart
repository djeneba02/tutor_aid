import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReponsePage extends StatefulWidget {
  final String ticketId; // L'ID du ticket pour lequel nous voulons répondre

  const ReponsePage({Key? key, required this.ticketId}) : super(key: key);

  @override
  _ReponsePageState createState() => _ReponsePageState();
}

class _ReponsePageState extends State<ReponsePage> {
  final TextEditingController _reponseController = TextEditingController();
  bool _isSubmitting = false;
  String? displayName; // Stocke le nom d'affichage de l'utilisateur

  get user_name  => FirebaseAuth.instance.currentUser!.displayName;

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // Récupère les informations de l'utilisateur au démarrage
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        displayName = user.displayName; // Récupère le nom d'affichage de l'utilisateur
      });
    } else {
      print("Aucun utilisateur n'est connecté");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Répondre au Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichez les détails du ticket ici si nécessaire
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Tickets')
                    .doc(widget.ticketId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var ticketData = snapshot.data!.data() as Map<String, dynamic>;

                  return ListView(
                    children: [
                      Text('Titre: ${ticketData['titre']}'),
                      Text('Description: ${ticketData['description']}'),
                      // Affichez d'autres détails du ticket si nécessaire
                    ],
                  );
                },
              ),
            ),
            TextField(
              controller: _reponseController,
              decoration: const InputDecoration(
                labelText: 'Votre réponse',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReponse,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Envoyer la réponse'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReponse() async {
    if (_reponseController.text.isEmpty) {
      // Affichez un message d'erreur si la réponse est vide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer une réponse avant de soumettre.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Log pour vérifier l'exécution de la fonction
      print('Tentative d\'envoi de la réponse');

      await FirebaseFirestore.instance.collection('Reponses').add({
        'user_name': displayName ?? 'Utilisateur inconnu', // Utilisez un nom d'utilisateur par défaut si displayName est nul
        'ticketId': widget.ticketId,
        'reponse': _reponseController.text,
        'date': Timestamp.now(),
      });

      print('Réponse envoyée avec succès');

      // Optionnel : Mettre à jour le statut du ticket ici
      await FirebaseFirestore.instance
          .collection('Tickets')
          .doc(widget.ticketId)
          .update({'status': 'Répondu'});

      Navigator.of(context).pop(); // Retourne à la page précédente
    } catch (e) {
      // Affichez une erreur si la soumission échoue
      print('Erreur lors de la soumission: $e'); // Pour débogage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la soumission: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
