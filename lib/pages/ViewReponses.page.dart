import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_aid/Services/reponse.dart';
import 'package:tutor_aid/model/reponse.dart';

class ViewReponsesPage extends StatelessWidget {
  final String ticketId;

  const ViewReponsesPage({Key? key, required this.ticketId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reponseService = ReponseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réponses du Ticket'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Afficher le titre du ticket
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('Tickets').doc(ticketId).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var ticketData = snapshot.data!.data() as Map<String, dynamic>;
                String ticketTitle = ticketData['titre'] ?? 'Titre inconnu';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Titre du Ticket :',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ) ??
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                  ),
                );
              },
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('Tickets').doc(ticketId).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var ticketData = snapshot.data!.data() as Map<String, dynamic>;
                String ticketTitle = ticketData['titre'] ?? 'Titre inconnu';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    ticketTitle,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.teal[600],
                        ) ??
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal[600]),
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<List<Reponse>>(
                stream: reponseService.getReponsesForTicket(ticketId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var reponses = snapshot.data!;

                  if (reponses.isEmpty) {
                    return const Center(child: Text('Aucune réponse disponible', style: TextStyle(fontSize: 18, color: Colors.grey)));
                  }

                  return ListView.builder(
                    itemCount: reponses.length,
                    itemBuilder: (context, index) {
                      var reponse = reponses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            reponse.reponse,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Repondu par: ${reponse.userName}\nDate: ${reponse.date.toDate()}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
