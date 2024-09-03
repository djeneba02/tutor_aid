import 'package:flutter/material.dart';
import 'package:tutor_aid/pages/AppBar.dart';
import 'package:tutor_aid/pages/Sidebar.dart';

class BaseDeConnaissancePage extends StatelessWidget {
  const BaseDeConnaissancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définir la couleur peachPuff ici
    Color peachPuff = const Color(0xFFFFEDE0);

    return Scaffold(
      appBar: CustomAppBar(title: 'Formateur'),
      drawer: CustomDrawer(),
    );
  }
}