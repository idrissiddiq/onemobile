import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFD632D),
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFFD632D),
              radius: 60,
              child: Icon(
                    Icons.person,
                    size: 40.0,
                    color: Color(0xFFFF993C),
                  ),
            ),
            SizedBox(height: 20),
            Text(
              'Nama Pengguna',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'email@example.com',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk mengedit profil pengguna
              },
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF993C),
                ),
              child: Text('Edit Profil'),
            ),
          ],
        ),
      ),
    );
  }
}