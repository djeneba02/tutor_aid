import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:tutor_aid/liste/User.dart';
import 'package:tutor_aid/pages/UserManagement.page.dart';
import 'package:tutor_aid/pages/ticket.page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:tutor_aid/pages/accueil.page.dart';
import 'package:tutor_aid/pages/formateur.page.dart';
import 'package:tutor_aid/pages/cours.page.dart';
import 'package:tutor_aid/pages/login.page.dart';
import 'package:tutor_aid/pages/historique.page.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TutorAid());
}

class TutorAid extends StatelessWidget {
  const TutorAid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Utilisation de routes
      routes: {
        '/': (context) => const AccueilPage(),
        '/Formateur': (context) => const FormateurPage(),
        '/Cours': (context) => const CoursPage(),
        '/Historique': (context) => const HistoriquePage(),
        '/Login': (context) =>  LoginPage(),
        '/Ticket': (context) =>  TicketPage(),
        '/UserManagement': (context) => UserManagementPage(),
        '/User': (context) => UserPage(),
      },
    );
  }
}
