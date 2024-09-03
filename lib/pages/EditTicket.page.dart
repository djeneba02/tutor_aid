import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTicketPage extends StatefulWidget {
  final String ticketId;
  final Map<String, dynamic> ticketData;

  const EditTicketPage({
    Key? key,
    required this.ticketId,
    required this.ticketData,
  }) : super(key: key);

  @override
  _EditTicketPageState createState() => _EditTicketPageState();
}

class _EditTicketPageState extends State<EditTicketPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _selectedCategory;
  final List<String> _categories = ['Technique', 'Pédagogique', 'Autre']; // Exemple de catégories

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.ticketData['titre']);
    _descriptionController = TextEditingController(text: widget.ticketData['description']);
    _selectedCategory = widget.ticketData['categorie'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTicket() async {
    try {
      await FirebaseFirestore.instance.collection('Tickets').doc(widget.ticketId).update({
        'titre': _titleController.text,
        'description': _descriptionController.text,
        'categorie': _selectedCategory,
        'status': widget.ticketData['status'], // Conservez l'état actuel
        'date_creation': widget.ticketData['date_creation'], // Conservez la date de création
      });
      Navigator.of(context).pop(); // Retour à la page précédente après la mise à jour
    } catch (e) {
      print('Erreur lors de la mise à jour : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la mise à jour')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Catégorie'),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTicket,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
