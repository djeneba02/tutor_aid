import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tutor_aid/pages/AppBar.dart';
import 'package:tutor_aid/pages/Sidebar.dart';

class DashbordPage extends StatelessWidget {
  const DashbordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double cardHeight = screenSize.width * 0.35; // Hauteur réduite pour les cartes
    final double pieChartHeight = screenSize.height * 0.30; // Hauteur augmentée pour le pie chart

    return Scaffold(
      appBar: CustomAppBar(title: 'Tableau de Bord Administratif'),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Ajoutez des marges autour du contenu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              // Utilisation de Container avec une hauteur réduite pour les cartes
              Container(
                width: double.infinity, // Permet aux cartes d'utiliser toute la largeur disponible
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.30, // Ajustez le ratio pour modifier la taille des cartes
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard('Apprenants', '150', Icons.person, Colors.blue),
                    _buildStatCard('Formateurs', '20', Icons.school, Colors.green),
                    _buildStatCard('Tickets Résolus', '120', Icons.check_circle, Colors.orange),
                    _buildStatCard('Tickets en Attente', '30', Icons.pending, Colors.red),
                  ],
                ),
              ),
              SizedBox(height: 80), // Espacement au-dessus du pie chart

              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: pieChartHeight,
                child: _buildPieChart(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour une statistique sous forme de Container
  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // ombre en bas
          ),
        ],
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            count,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget pour un graphique circulaire (Pie Chart)
  Widget _buildPieChart() {
    return Center(
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: 60,
              title: 'Résolus',
              radius: 25,
              titleStyle: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.orange,
              value: 30,
              title: 'EnCours',
              radius: 25,
              titleStyle: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.red,
              value: 10,
              title: 'Attente',
              radius: 25,
              titleStyle: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
