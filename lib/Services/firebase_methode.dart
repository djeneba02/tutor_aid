import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMethode {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String role,
  }) async {
    String res = "Une erreur s'est produite";

    try {
      // Création de l'utilisateur
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enregistrement des informations supplémentaires dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'role': role,
      });

      res = "Inscription réussie";
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs spécifiques à Firebase
      if (e.code == 'weak-password') {
        res = "Le mot de passe est trop faible.";
      } else if (e.code == 'email-already-in-use') {
        res = "L'email est déjà utilisé.";
      } else if (e.code == 'invalid-email') {
        res = "L'email n'a pas un format valide.";
      }
    } catch (e) {
      // Gestion des autres erreurs
      res = "Une erreur inconnue est survenue.";
    }

    return res;
  }

  // Fonction pour récupérer les informations de l'utilisateur
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print("Erreur lors de la récupération des informations de l'utilisateur: $e");
    }
    return null;
  }
}
