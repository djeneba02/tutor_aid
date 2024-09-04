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
        'userRole': 'User', // Modifie ceci selon le rôle réel de l'utilisateur
      });
      _messageController.clear();
    }
  }

  Future<void> _editMessage(String messageId, String currentText) async {
    final String? newText = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Message'),
        content: TextField(
          controller: TextEditingController(text: currentText),
          decoration: InputDecoration(labelText: 'New message'),
          onChanged: (value) {
            // Pas besoin d'affecter à une variable ici
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop<String>(null),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () => Navigator.of(ctx).pop<String>(currentText),
          ),
        ],
      ),
    );

    if (newText != null && newText.isNotEmpty) {
      await _firestore.collection('chats').doc(messageId).update({'text': newText});
    }
  }

  void _deleteMessage(String messageId) async {
    await _firestore.collection('chats').doc(messageId).delete();
  }

  @override
  Widget build(BuildContext context) {
    Color peachPuff = const Color(0xFFFFEDE0);
    Color messageBackgroundColor = Colors.white;
    Color userMessageBackgroundColor = Colors.blueAccent.withOpacity(0.2);
    Color messageTextColor = Colors.black;
    Color userMessageTextColor = Colors.white;

    return Scaffold(
      appBar: CustomAppBar(title: 'Espace de Discutions'),
      drawer: CustomDrawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('chats').orderBy('createdAt', descending: true).snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final chatDocs = chatSnapshot.data?.docs;
                if (chatDocs == null || chatDocs.isEmpty) {
                  return Center(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Aucun message encore.',
                        style: TextStyle(color: Colors.grey, fontSize: 18.0),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    final chatDoc = chatDocs[index];
                    final messageId = chatDoc.id;
                    final userId = chatDoc['userId'];
                    final currentUser = _auth.currentUser;

                    bool isUserMessage = userId == currentUser?.uid;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isUserMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isUserMessage ? userMessageBackgroundColor : messageBackgroundColor,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        chatDoc['userName'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isUserMessage ? userMessageTextColor : messageTextColor,
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        chatDoc['text'],
                                        style: TextStyle(color: isUserMessage ? userMessageTextColor : messageTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isUserMessage)
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _editMessage(messageId, chatDoc['text']),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deleteMessage(messageId),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Envoyer un message...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: peachPuff,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
