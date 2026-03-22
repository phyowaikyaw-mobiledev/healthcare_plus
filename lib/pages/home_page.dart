import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare_plus/pages/doctor_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>;
        });
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthcare Plus'),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${userData!['name']}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'How can we help you today?',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),

            if (userData!['userType'] == 'patient') ...[
              _buildFeatureCard(
                'Book Appointment',
                Icons.calendar_today,
                Colors.blue,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorListPage(),
                    ),
                  );
                },
              ),
              _buildFeatureCard(
                'My Appointments',
                Icons.list_alt,
                Colors.green,
                    () {
                  // Will implement later
                },
              ),
            ],

            if (userData!['userType'] == 'doctor') ...[
              _buildFeatureCard(
                'Appointment Schedule',
                Icons.schedule,
                Colors.orange,
                    () {
                  // Will implement later
                },
              ),
              _buildFeatureCard(
                'My Patients',
                Icons.people,
                Colors.purple,
                    () {
                  // Will implement later
                },
              ),
            ],

            _buildFeatureCard(
              'Medical Records',
              Icons.medical_services,
              Colors.red,
                  () {
                // Will implement later
              },
            ),
            _buildFeatureCard(
              'Profile',
              Icons.person,
              Colors.teal,
                  () {
                // Will implement later
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}