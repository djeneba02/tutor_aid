import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tutor_aid/pages/historique.page.dart'; // Ajoutez cette ligne pour afficher les messages toast


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Définir la couleur peachPuff ici
    Color peachPuff = const Color(0xFFFFEDE0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        color: peachPuff,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ajouter une image avant le formulaire
            Image.asset(
              'assets/images/login.png', // Chemin de l'image dans le dossier assets
              height: 280.0, // Ajuster la hauteur de l'image
            ),
            const SizedBox(
                height: 24.0), // Espacement entre l'image et le formulaire
            // Champ de texte pour l'email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            // Champ de texte pour le mot de passe
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Bouton de connexion
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.length > 9) { // Modifié la longueur minimale du mot de passe
                  login();
                } else {
                  Fluttertoast.showToast(msg: "Veuillez entrer un email valide et un mot de passe d'au moins 12 caractères.");
                }
              },
              child: const Text("Login"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    final auth = FirebaseAuth.instance;
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Connexion réussie
      Fluttertoast.showToast(msg: "Connexion réussie !");
      
      // Rediriger vers la page d'accueil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HistoriquePage()), 
      );
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Aucun utilisateur trouvé pour cet email.";
          break;
        case 'wrong-password':
          errorMessage = "Mot de passe incorrect.";
          break;
        case 'invalid-email':
          errorMessage = "Votre email n'a pas un format valide.";
          break;
        default:
          errorMessage = "Impossible de se connecter. Veuillez vérifier vos informations et réessayer.";
      }
      Fluttertoast.showToast(msg: errorMessage);
    } catch (e) {
      // Gestion des autres erreurs
      Fluttertoast.showToast(msg: "Une erreur inconnue est survenue.");
    }
  }
}
