import 'package:flutter/material.dart';
import 'package:tutor_aid/pages/AppBar.dart';
import 'package:tutor_aid/pages/login.page.dart'; // Assurez-vous que cette importation est correcte

class AccueilPage extends StatefulWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialisation du contrôleur d'animation pour l'effet de fondu
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Durée du fondu en entrée
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn, // Courbe d'animation pour un effet en douceur
    );

    // Démarrer l'animation
    _controller.forward();

    // Délai avant de naviguer vers la page suivante avec une transition douce
    Future.delayed(const Duration(seconds: 6), () {
      _navigateToNextPage();
    });
  }

  void _navigateToNextPage() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(seconds: 2), // Durée de la transition
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: LoginPage(), // Naviguer vers la page de connexion
        );
      },
    ));
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose du contrôleur pour éviter les fuites de mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: Center(
        child: FadeTransition(
          opacity: _animation, // Applique l'animation de fondu
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/origlogo.png", // Chemin correct de ton image
                width: 400, // Largeur ajustée
                height: 400, // Hauteur ajustée
              ),
              const SizedBox(height: 20), // Espace entre l'image et le texte
              const Text(
                "Connectez-vous facilement avec vos formateurs et obtenez le soutien dont vous avez besoin.",
                textAlign: TextAlign.center, // Centrer le texte horizontalement
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
