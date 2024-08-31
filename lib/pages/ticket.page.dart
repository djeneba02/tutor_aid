import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({Key? key}) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final Stream<QuerySnapshot> _ticketsStream = FirebaseFirestore.instance.collection("Tickets").snapshots();
  final TextEditingController _searchController = TextEditingController();

  // Fonction pour supprimer un ticket
  void _deleteTicket(String ticketId) {
    FirebaseFirestore.instance.collection('Tickets').doc(ticketId).delete();
  }

  // Fonction pour modifier un ticket
  void _editTicket(String ticketId) {
    // Implémentez la navigation vers la page de modification ou afficher une boîte de dialogue
  }

  // Fonction pour ajouter un nouveau ticket
  void _addTicket() {
    // Implémentez la logique d'ajout d'un ticket ici
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Tickets"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 114, 41), // Couleur de fond du bouton
                    borderRadius: BorderRadius.circular(8), // Bordure légèrement arrondie
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white), // Icône blanche
                    onPressed: _addTicket,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Rechercher",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Vous pouvez filtrer les résultats ici en fonction de la recherche
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _ticketsStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Une erreur s\'est produite'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucun ticket disponible'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    String ticketId = document.id;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Titre: ${data['titre']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text('Description: ${data['description']}'),
                          const SizedBox(height: 10),
                          Text('Status: ${data['status']}'),
                          Text('Catégorie: ${data['categorie']}'),
                          Text('Date de création: ${(data['date_creation'] as Timestamp).toDate()}'),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editTicket(ticketId), // Appel à la fonction de modification
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTicket(ticketId), // Appel à la fonction de suppression
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
