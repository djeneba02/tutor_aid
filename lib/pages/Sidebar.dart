import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  // Définir une couleur personnalisée pour "peach"
  static const Color peachColor = Color(0xFFFFDAB9); // Code hexadécimal pour la couleur "peach"

 Future<String> _getUserRole() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return doc.get('role') ?? 'unknown';
      }
    }
    return 'unknown';
  } catch (e) {
    print('Erreur lors de la récupération du rôle: $e');
    return 'unknown';
  }
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Drawer(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        String userRole = snapshot.data ?? 'unknown';

        return Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [const Color.fromARGB(255, 201, 159, 159), peachColor],
              ),
            ),
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: peachColor, // Utiliser la couleur personnalisée
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/logo1.png"),
                        radius: 40,
                      ),
                      SizedBox(width: 16.0), // Ajouter un espace entre l'avatar et le texte
                      Text(
                        'Bienvenue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      
                     
                      if (userRole == 'FORMATEUR' || userRole == 'APPRENANT')
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/Ticket');
                          },
                          leading: const Icon(Icons.airplane_ticket, color: Colors.black),
                          title: const Text("Ticket"),
                        ),

                         ListTile(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/BaseDeConnaissance');
                          },
                          leading: const Icon(Icons.book_sharp, color: Colors.black),
                          title: const Text("BaseDeConnaissance"),
                        ),

                      if (userRole == 'ADMIN')
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/User');
                        },
                        leading: const Icon(Icons.person, color: Colors.black),
                        title: const Text("Utilisateur"),
                      ),

                    ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Chat');
                        },
                        leading: const Icon(Icons.chat, color: Colors.black),
                        title: const Text("chat"),
                      ),

                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Notification');
                        },
                        leading: const Icon(Icons.notification_add, color: Colors.black),
                        title: const Text("Notification"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Historique');
                        },
                        leading: const Icon(Icons.history, color: Colors.black),
                        title: const Text("Historique"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Profil');
                        },
                        leading: const Icon(Icons.account_circle, color: Colors.black),
                        title: const Text("Profil"),
                      ),
                       if (userRole == 'ADMIN')
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Rapport');
                        },
                        leading: const Icon(Icons.insert_chart, color: Colors.black),
                        title: const Text("Rapport"),
                      ),
                      
                      SizedBox(height: 16.0),
                      ListTile(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacementNamed('/Login'); // Remplacez '/Login' par la route de votre page de connexion
                        },
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text("Déconnexion"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
