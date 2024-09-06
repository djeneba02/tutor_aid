import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_aid/pages/AppBar.dart';
import 'package:tutor_aid/pages/Sidebar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('chats').add({
        'text': _messageController.text,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'userName': user.displayName ?? 'Unknown',
        'userRole': 'User',
      });
      _messageController.clear();
    }
  }

  // Fonction pour supprimer un message
  void _deleteMessage(String messageId) async {
    await _firestore.collection('chats').doc(messageId).delete();
  }

  // Fonction pour modifier un message
  void _editMessage(String messageId, String newText) async {
    await _firestore.collection('chats').doc(messageId).update({
      'text': newText,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Espace de Discussion'),
      drawer: CustomDrawer(),
      resizeToAvoidBottomInset: true,  // Permet de maintenir l'UI visible avec le clavier
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Section de la liste de messages
            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection('chats')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (chatSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erreur : ${chatSnapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final chatDocs = chatSnapshot.data?.docs ?? [];

                  // Gestion du cas où il n'y a pas de messages
                  if (chatDocs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Aucun message pour l\'instant. Soyez le premier à en envoyer !',
                          style: TextStyle(color: Colors.grey, fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  // Liste des messages
                  return ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),  // Ajout de l'effet de rebond
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx, index) {
                      final chatDoc = chatDocs[index];
                      final userId = chatDoc['userId'];
                      final currentUser = _auth.currentUser;
                      final isUserMessage = userId == currentUser?.uid;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Colors.blueAccent.withOpacity(0.8)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            chatDoc['text'] ?? '',
                            style: TextStyle(
                              color: isUserMessage ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Champ d'envoi de message
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Écrivez un message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
