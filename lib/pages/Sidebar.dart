import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  // Définir une couleur personnalisée pour "peach"
  static const Color peachColor = Color(0xFFFFDAB9); // Code hexadécimal pour la couleur "peach"

  Future<String> _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.get('role') ?? 'unknown';
    }
    return 'unknown';
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
                      if (userRole == 'ADMIN' || userRole == 'FORMATEUR')
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/Formateur');
                          },
                          leading: const Icon(Icons.person, color: Colors.black),
                          title: const Text("Formateur"),
                        ),
                      if (userRole == 'ADMIN' || userRole == 'APPRENANT')
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/Ticket');
                          },
                          leading: const Icon(Icons.airplane_ticket, color: Colors.black),
                          title: const Text("Ticket"),
                        ),
                      if (userRole == 'ADMIN')
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/UserManagement');
                          },
                          leading: const Icon(Icons.group, color: Colors.black),
                          title: const Text("Utilisateurs"),
                        ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/User');
                        },
                        leading: const Icon(Icons.person, color: Colors.black),
                        title: const Text("Profil Utilisateur"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Cours');
                        },
                        leading: const Icon(Icons.book, color: Colors.black),
                        title: const Text("Cours"),
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
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Rapport');
                        },
                        leading: const Icon(Icons.insert_chart, color: Colors.black),
                        title: const Text("Rapport"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Parametre');
                        },
                        leading: const Icon(Icons.settings, color: Colors.black),
                        title: const Text("Paramètres"),
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
