import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_aid/pages/AppBar.dart';
import 'package:tutor_aid/pages/EditTicket.page.dart';
import 'package:tutor_aid/pages/Reponse.page.dart';
import 'package:tutor_aid/pages/Sidebar.dart';
import 'package:tutor_aid/pages/ViewReponses.page.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({Key? key}) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final Stream<QuerySnapshot> _ticketsStream =
      FirebaseFirestore.instance.collection("Tickets").snapshots();
  final TextEditingController _searchController = TextEditingController();

  // Liste des catégories (exemples)
  final List<String> _categories = ['Technique', 'Pédagogique', 'Autre'];
  String? _selectedCategory;
  String? uid;
  String? displayName;
  String? role;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        _categories.first; // Sélectionner la première catégorie par défaut
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        uid = user.uid;
        displayName = user.displayName;
      });

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          role = userDoc
              .get('role'); // Assure-toi que 'role' est bien le nom du champ
        });
      } else {
        print(
            "Les informations sur le rôle de l'utilisateur sont introuvables");
      }
    } else {
      print("Aucun utilisateur n'est connecté");
    }
  }

  // Fonction pour supprimer un ticket
  void _deleteTicket(String ticketId) {
    FirebaseFirestore.instance.collection('Tickets').doc(ticketId).delete();
  }

  void _editTicket(String ticketId, Map<String, dynamic> ticketData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTicketPage(
          ticketId: ticketId,
          ticketData: ticketData,
        ),
      ),
    );
  }

   // Fonction pour assigner un ticket à un formateur
  void _assignTicket(String ticketId) {
    FirebaseFirestore.instance.collection('Tickets').doc(ticketId).update({
      'status': 'En cours',
      'assigned_to': uid, // Assigne le ticket à l'ID du formateur
      'assigned_by_name': displayName,
    });
  }

  // Fonction pour ajouter un nouveau ticket
  void _addTicket() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _titleController = TextEditingController();
        final TextEditingController _descriptionController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Ajouter un nouveau ticket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: const InputDecoration(labelText: 'Catégorie'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    _selectedCategory != null) {
                  FirebaseFirestore.instance.collection('Tickets').add({
                    'titre': _titleController.text,
                    'description': _descriptionController.text,
                    'status': 'Attente', // Statut par défaut
                    'categorie': _selectedCategory,
                    'date_creation': Timestamp.now(),
                    'user_id': uid, // Utiliser l'ID de l'utilisateur actuel
                    'user_name': displayName,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Liste des Tickets'),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (role == 'APPRENANT')
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 114, 41),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
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
                        // Vous pouvez ajouter une logique pour filtrer les résultats ici
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: role == 'FORMATEUR'
                  ? FirebaseFirestore.instance.collection("Tickets").snapshots()
                  : FirebaseFirestore.instance
                      .collection("Tickets")
                      .where('user_id', isEqualTo: uid)
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Une erreur s\'est produite'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucun ticket disponible'));
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    String ticketId = document.id;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
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
                          Text('Status: ${data['status']}'),
                          Text('Catégorie: ${data['categorie']}'),
                          Text(
                            'Date de création: ${(data['date_creation'] as Timestamp).toDate()}',
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //  if (role == 'FORMATEUR')
                              IconButton(
                                icon: const Icon(Icons.visibility,
                                    color: Colors.blue),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Détails du Ticket'),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Titre: ${data['titre']}'),
                                            Text(
                                                'Description: ${data['description']}'),
                                            Text('Status: ${data['status']}'),
                                            Text(
                                                'Catégorie: ${data['categorie']}'),
                                            Text(
                                                'Date de création: ${(data['date_creation'] as Timestamp).toDate()}'),
                                            Text(
                                                'Créé par: ${data['user_name']}'),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Fermer'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),

                                  if (role == 'FORMATEUR' &&
                                  data['status'] == 'Attente') ...[
                                IconButton(
                                  icon: const Icon(Icons.assignment_ind,
                                      color: Colors.green),
                                  onPressed: () {
                                    _assignTicket(ticketId);
                                  },
                                ),
                              ],
                              if (role == 'FORMATEUR' &&
                                  data['status'] == 'En cours' &&
                                  data['assigned_to'] == uid) ...[
                                IconButton(
                                  icon: const Icon(Icons.reply,
                                      color: Colors.orange),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReponsePage(ticketId: ticketId),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              
                              IconButton(
                                icon: const Icon(Icons.comment,
                                    color: Colors.blue),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewReponsesPage(ticketId: ticketId),
                                    ),
                                  );
                                },
                              ),
                              // if (role != 'APPRENANT')
                              // IconButton(
                              //   icon:
                              //       const Icon(Icons.reply, color: Colors.blue),
                              //   onPressed: () {
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             ReponsePage(ticketId: ticketId),
                              //       ),
                              //     );
                              //   },
                              // ),
                              if (role == 'APPRENANT') ...[
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editTicket(ticketId, data),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteTicket(ticketId),
                                ),
                              ],
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
