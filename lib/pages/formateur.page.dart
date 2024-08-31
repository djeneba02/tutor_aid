import 'package:flutter/material.dart';

class FormateurPage extends StatelessWidget {
  const FormateurPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définir la couleur peachPuff ici
    Color peachPuff = const Color(0xFFFFEDE0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Formateur"),
      ),
    );
  }
}