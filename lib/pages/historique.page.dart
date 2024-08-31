import 'package:flutter/material.dart';

class HistoriquePage extends StatelessWidget {
  const HistoriquePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définir la couleur peachPuff ici
    Color peachPuff = const Color(0xFFFFEDE0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
      ),
    );
  }
}