import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEditPage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const UserEditPage({Key? key, required this.userId, required this.userData}) : super(key: key);

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  late TextEditingController _displayNameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.userData['displayName']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _roleController = TextEditingController(text: widget.userData['role']);
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

 Future<void> _updateUser() async {
  if (_displayNameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _roleController.text.isEmpty ||
      (_newPasswordController.text.isNotEmpty && _confirmPasswordController.text.isEmpty) ||
      (_newPasswordController.text.isNotEmpty && _oldPasswordController.text.isEmpty)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tous les champs sont obligatoires.')),
    );
    return;
  }

  if (_newPasswordController.text.isNotEmpty && _newPasswordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Les mots de passe ne correspondent pas.')),
    );
    return;
  }

  try {
    // Mise à jour des informations de l'utilisateur dans Firestore
    await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'displayName': _displayNameController.text,
      'email': _emailController.text,
      'role': _roleController.text,
    });

    // Mise à jour du mot de passe si un nouveau mot de passe est fourni
    if (_newPasswordController.text.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Vérification du mot de passe actuel
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _oldPasswordController.text,
        );

        try {
          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(_newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mot de passe mis à jour avec succès.')),
          );
        } catch (e) {
          print('Failed to reauthenticate: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Échec de la vérification de l\'ancien mot de passe : $e')),
          );
          return;
        }
      }
    }

    Navigator.of(context).pop();
  } catch (e) {
    print('Failed to update user: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Échec de la mise à jour : $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'Utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(labelText: 'Rôle'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(labelText: 'Ancien mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'Nouveau mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
