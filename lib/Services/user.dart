import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutor_aid/model/user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter un utilisateur
  Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Créer un nouvel utilisateur avec Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Mettre à jour le profil de l'utilisateur avec le nom
        await user.updateProfile(displayName: name);

        // Enregistrer les détails supplémentaires dans Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'displayName': name,
          'role': role,  // Assurez-vous que ce champ correspond à ce que vous attendez dans UserModel
        });

        return user;
      }
    } catch (e) {
      print('Failed to register user: $e');
    }
    return null;
  }

  // Mettre à jour le rôle d'un utilisateur
   Future<void> updateUserRole(String uid, String newRole) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'role': newRole,
      });
    } catch (e) {
      print('Failed to update user role: $e');
    }
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(User user) async {
    try {
      // Supprimer le document de l'utilisateur dans Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Supprimer l'utilisateur dans Firebase Auth
      await user.delete();
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }

  // Récupérer les détails d'un utilisateur
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
    } catch (e) {
      print('Failed to get user: $e');
    }
    return null;
  }

  // Récupérer la liste des utilisateurs sans le mot de passe
  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Failed to get users: $e');
      return [];
    }
  }
}
