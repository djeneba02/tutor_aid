import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutor_aid/liste/User.dart';
import 'package:tutor_aid/pages/UserManagement.page.dart';
import 'package:tutor_aid/pages/chat.page.dart';
import 'package:tutor_aid/pages/dashbord.page.dart';
import 'package:tutor_aid/pages/profil.page.dart';
import 'package:tutor_aid/pages/rapport.page.dart';
import 'package:tutor_aid/pages/ticket.page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:tutor_aid/pages/accueil.page.dart';
import 'package:tutor_aid/pages/basedeconnaissance.page.dart';
import 'package:tutor_aid/pages/notification.page.dart';
import 'package:tutor_aid/pages/login.page.dart';
import 'package:tutor_aid/pages/historique.page.dart';

const dGreen = Color.fromARGB(255, 197, 51, 112);
const dWhite = Colors.white;
const dBlack = Colors.black;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      debugShowCheckedModeBanner:false,
      // Utilisation de routes
      routes: {
        '/': (context) => const AccueilPage(),
        '/BaseDeConnaissance': (context) => const BaseDeConnaissancePage(),
        '/Notification': (context) => const NotificationPage(),
        '/Historique': (context) => const HistoriquePage(),
        '/Login': (context) => LoginPage(),
        '/Ticket': (context) => TicketPage(),
        '/UserManagement': (context) => UserManagementPage(),
        '/User': (context) => UserPage(),
        '/Dashbord': (context) => DashbordPage(),
        '/Profil': (context) => ProfilPage(),
        '/Rapport': (context) => RapportPage(),
        '/Chat': (context) => ChatPage(),
      },
    );
  }
}
