import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_aid/Services/user.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole; // Variable pour stocker le rôle sélectionné

  final List<String> _roles = ['ADMIN', 'FORMATEUR', 'APPRENANT']; // Liste des rôles disponibles
  final UserService _userService = UserService();

  void _addUser() async {
    // Vérifiez que tous les champs sont remplis
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedRole == null) {
      _showDialog('Error', 'Please fill all fields');
      return;
    }

    try {
      User? user = await _userService.registerUser(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole!, // Utiliser le rôle sélectionné
      );

      if (user != null) {
        _showDialog('Success', 'Utilisateur ajouté');
        _clearFields();
      } else {
        _showDialog('Error', 'Failed to add user');
      }
    } catch (e) {
      _showDialog('Error', 'An unexpected error occurred: $e');
    }
  }

  // Fonction pour afficher les dialogues
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/User');
              },
            ),
          ],
        );
      },
    );
  }

  // Fonction pour vider les champs de texte
  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _selectedRole = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              hint: Text('Select Role'),
              items: _roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Role',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addUser,
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
