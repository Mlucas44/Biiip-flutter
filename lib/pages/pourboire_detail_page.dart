// pages/pourboire_detail_page.dart
import 'package:flutter/material.dart';
import '../models/pourboire.dart';
import '../utils/color.dart';

class PourboireDetailPage extends StatelessWidget {
  final Pourboire pourboire;

  const PourboireDetailPage({super.key, required this.pourboire});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du pourboire #${pourboire.id}'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Montant : ${pourboire.montant} €',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Commentaire :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              pourboire.commentaire,
              style: const TextStyle(fontSize: 16),
            ),
            // Ajoutez d'autres détails si nécessaire
          ],
        ),
      ),
    );
  }
}
