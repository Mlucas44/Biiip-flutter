import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/color.dart';

class AjouterPourboirePage extends StatefulWidget {
  const AjouterPourboirePage({super.key});

  @override
  _AjouterPourboirePageState createState() => _AjouterPourboirePageState();
}

class _AjouterPourboirePageState extends State<AjouterPourboirePage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _commentaireController = TextEditingController();

  bool _isLoading = false;

  Future<void> _ajouterPourboire() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final montant = double.parse(_montantController.text.trim());
      final commentaire = _commentaireController.text.trim();

      try {
        final res = await _supabase.from('pourboires').insert({
          'montant': montant,
          'commentaire': commentaire,
        });
        Navigator.pop(context, true);
      } catch (e) {
        _showError('Erreur : ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _montantController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un pourboire'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _montantController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Montant (€)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un montant.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Veuillez entrer un montant valide.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _commentaireController,
                      decoration: const InputDecoration(
                        labelText: 'Commentaire',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _ajouterPourboire,
                      child: const Text('Ajouter'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
