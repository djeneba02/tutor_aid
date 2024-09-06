import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutor_aid/Services/user.dart';

import 'AppBar.dart';
import 'Sidebar.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final UserService _userService = UserService();
  User? _currentUser;
  String? _role;
  bool _isEditing = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _userService.getUserProfile(user.uid);
      setState(() {
        _currentUser = user;
        _role = userData['role'];
        _nameController.text = user.displayName ?? '';
        _emailController.text = user.email ?? '';
      });
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveChanges() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final newName = _nameController.text;
    final newEmail = _emailController.text;

    if (newName.isNotEmpty && newEmail.isNotEmpty) {
      try {
        await _currentUser?.updateProfile(displayName: newName);
        if (_currentUser?.email != newEmail) {
          await _currentUser?.updateEmail(newEmail);
        }

        if (oldPassword.isNotEmpty && newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
          if (newPassword != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('New password and confirmation do not match')),
            );
            return;
          }
          if (newPassword.length < 6) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('New password must be at least 6 characters long')),
            );
            return;
          }

          final credential = EmailAuthProvider.credential(
            email: _currentUser!.email!,
            password: oldPassword,
          );
          await _currentUser!.reauthenticateWithCredential(credential);
          await _currentUser?.updatePassword(newPassword);
        }

        _loadUserProfile();
        _toggleEditing();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        print('Failed to update profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      drawer: CustomDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _currentUser == null
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: _currentUser?.photoURL != null
                    ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_currentUser!.photoURL!),
                )
                    : Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: _isEditing
                    ? TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter new name',
                  ),
                )
                    : Text(
                  _currentUser?.displayName ?? 'Unknown',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: _isEditing
                    ? TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter new email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                )
                    : Text(
                  _currentUser?.email ?? 'Unknown',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            if (_isEditing)
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Old Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: TextField(
                        controller: _oldPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Enter old password',
                        ),
                        obscureText: true,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'New Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: TextField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                        ),
                        obscureText: true,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Confirm New Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Confirm new password',
                        ),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  'Role',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _role ?? 'Unknown',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isEditing
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[400], // Blue-grey color for a softer appearance
                  ),
                ),
                ElevatedButton(
                  onPressed: _toggleEditing,
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300], // Light red color
                  ),
                ),
              ],
            )
                : ElevatedButton(
              onPressed: _toggleEditing,
              child: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[400], // Blue-grey color for a softer appearance
              ),
            ),
          ],
        ),
      ),
    );
  }
}
