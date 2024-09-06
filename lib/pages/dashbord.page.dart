import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tutor_aid/pages/AppBar.dart';
import 'package:tutor_aid/pages/Sidebar.dart';

class DashbordPage extends StatefulWidget {
  const DashbordPage({Key? key}) : super(key: key);

  @override
  _DashbordPageState createState() => _DashbordPageState();
}

class _DashbordPageState extends State<DashbordPage> {
  late Stream<QuerySnapshot> _ticketStream;

  @override
  void initState() {
    super.initState();
    _ticketStream = FirebaseFirestore.instance.collection('Tickets').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double cardHeight = screenSize.width * 0.35;
    final double pieChartHeight = screenSize.height * 0.30;

    return Scaffold(
      appBar: CustomAppBar(title: 'Tableau de Bord Administratif'),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.30,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard('Apprenants', _getApprenantCount(), Icons.person, Colors.blue),
                    _buildStatCard('Formateurs', _getFormateurCount(), Icons.school, Colors.green),
                    _buildStatCard('Tickets Résolus', _getResolvedTicketsCount(), Icons.check_circle, Colors.orange),
                    _buildStatCard('Tickets en Attente', _getPendingTicketsCount(), Icons.pending, Colors.red),
                  ],
                ),
              ),
              SizedBox(height: 80),
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

  Widget _buildStatCard(String title, Future<String> countFuture, IconData icon, Color color) {
    return FutureBuilder<String>(
      future: countFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
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
                snapshot.data ?? '0',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _getApprenantCount() async {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'APPRENANT').get();
    return userSnapshot.size.toString();
  }

  Future<String> _getFormateurCount() async {
    // Remplacez ceci par la logique appropriée pour compter les formateurs
    QuerySnapshot formateurSnapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'FORMATEUR').get();
    return formateurSnapshot.size.toString();
  }

  Future<String> _getResolvedTicketsCount() async {
    QuerySnapshot ticketSnapshot = await FirebaseFirestore.instance.collection('Tickets').where('status', isEqualTo: 'Répondu').get();
    return ticketSnapshot.size.toString();
  }

  Future<String> _getPendingTicketsCount() async {
    QuerySnapshot ticketSnapshot = await FirebaseFirestore.instance.collection('Tickets').where('status', isEqualTo: 'Attente').get();
    return ticketSnapshot.size.toString();
  }

  Widget _buildPieChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: _ticketStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        int resolved = snapshot.data?.docs.where((doc) => doc['status'] == 'Répondu').length ?? 0;
        int inProgress = snapshot.data?.docs.where((doc) => doc['status'] == 'En cours').length ?? 0;
        int pending = snapshot.data?.docs.where((doc) => doc['status'] == 'Attente').length ?? 0;

        return Center(
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.green,
                  value: resolved.toDouble(),
                  title: 'Répondu',
                  radius: 25,
                  titleStyle: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                PieChartSectionData(
                  color: Colors.orange,
                  value: inProgress.toDouble(),
                  title: 'EnCours',
                  radius: 25,
                  titleStyle: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                PieChartSectionData(
                  color: Colors.red,
                  value: pending.toDouble(),
                  title: 'Attente',
                  radius: 25,
                  titleStyle: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
