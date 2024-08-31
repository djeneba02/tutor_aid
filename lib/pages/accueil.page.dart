
import 'package:flutter/material.dart';


class AccueilPage extends StatelessWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définir la couleur peachPuff ici
    Color peachPuff = const Color(0xFFFFEDE0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [const Color.fromARGB(255, 201, 159, 159), peachPuff],
            ),
          ),
           child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: peachPuff,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/logo1.png"),
                      radius: 40,
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  // Action à réaliser lorsque cet élément est pressé
                Navigator.of(context).pushReplacementNamed('/Formateur');
                },
                leading: const Icon(Icons.person), // Icône pour cet élément
                title: const Text("Formateur"),
              ),

              ListTile(
                onTap: () {
                  // Action à réaliser lorsque cet élément est pressé
                Navigator.of(context).pushReplacementNamed('/Ticket');
                },
                
                leading: const Icon(Icons.airplane_ticket), // Icône pour cet élément
                title: const Text("Ticket"),
              ),

              ListTile(
                onTap: () {
                  // Action à réaliser lorsque cet élément est pressé
                Navigator.of(context).pushReplacementNamed('/UserManagement');
                },
                
                leading: const Icon(Icons.verified_user_sharp), // Icône pour cet élément
                title: const Text("Utilisateurs"),
              ),

              ListTile(
                onTap: () {
                  // Action à réaliser lorsque cet élément est pressé
                Navigator.of(context).pushReplacementNamed('/User');
                },
                
                leading: const Icon(Icons.verified_user_sharp), // Icône pour cet élément
                title: const Text("Utilis"),
              ),


              ListTile(
                onTap: () {
                  // Action à réaliser lorsque cet élément est pressé
                  Navigator.of(context).pushReplacementNamed('/Cours');
                },
                leading: const Icon(Icons.book), // Icône pour cet élément
                title: const Text("Cours"),
              ),
              ListTile(
                onTap: () {
                  // Action à réaliser lorsque cet élément est pressé
                  Navigator.of(context).pushReplacementNamed('/Historique');
                },
                leading: const Icon(Icons.schedule), // Icône pour cet élément
                title: const Text("Historique"),
              ),
              ListTile(
                onTap: () {
                  // Action à réaliser lorsque cet élément est pressé
                  Navigator.of(context).pushReplacementNamed('/Paramètre');
                },
                leading: const Icon(Icons.settings), // Icône pour cet élément
                title: const Text("Paramètres"),
              ),
              // Ajoutez d'autres éléments ici
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Utiliser min pour éviter l'expansion
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/origlogo.png",  // Chemin correct de votre image
              width: 400,  // Largeur ajustée
              height: 400, // Hauteur ajustée
            ),
            const SizedBox(height: 20), // Espace entre l'image et le texte
            const Text(
              "Connectez-vous facilement avec vos formateurs et obtenez le soutien dont vous avez besoin.",
              textAlign: TextAlign.center, // Centrer le texte horizontalement
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Espace entre le texte et le bouton
            ElevatedButton(
              onPressed: () {
                // Action à réaliser lorsque le bouton est pressé
               Navigator.of(context).pushReplacementNamed('/Login');
              },
              child: const Text("Commencer"),
            ),
          ],
        ),
      ),
    );
  }
}
