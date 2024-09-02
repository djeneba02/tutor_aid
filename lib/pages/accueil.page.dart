
import 'package:flutter/material.dart';
import 'package:tutor_aid/pages/AppBar.dart';
import 'package:tutor_aid/pages/Sidebar.dart';


class AccueilPage extends StatelessWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définir la couleur peachPuff ici
    Color peachPuff = const Color(0xFFFFEDE0);

    return Scaffold(
       appBar: CustomAppBar(title: ''),
      
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
