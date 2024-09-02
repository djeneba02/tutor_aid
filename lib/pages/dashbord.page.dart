import 'package:flutter/material.dart';
import 'package:tutor_aid/pages/AppBar.dart';
import 'package:tutor_aid/pages/Sidebar.dart';

class DashbordPage extends StatelessWidget {
  const DashbordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définir la couleur peachPuff ici
    Color peachPuff = const Color(0xFFFFEDE0);

    return Scaffold(
      appBar: CustomAppBar(title: 'Home'),
      drawer: CustomDrawer(),
      
      body: Align(
        alignment: Alignment.center, // Centrage horizontal
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity, // Prend toute la largeur disponible
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // Changement de position de l'ombre
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Utilisation de la taille minimale possible
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centrer horizontalement le texte
                children: [
                  Icon(
                    Icons.people,
                    size: 40.0,
                    color: peachPuff,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Liste des Utilisateurs',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: peachPuff,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Exemple de liste des utilisateurs
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: peachPuff),
                    title: Text('Utilisateur 1'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/UtilisateurDetail', arguments: 'Utilisateur 1');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: peachPuff),
                    title: Text('Utilisateur 2'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/UtilisateurDetail', arguments: 'Utilisateur 2');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: peachPuff),
                    title: Text('Utilisateur 3'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/UtilisateurDetail', arguments: 'Utilisateur 3');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
