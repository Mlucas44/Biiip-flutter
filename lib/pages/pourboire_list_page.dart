import 'package:flutter/material.dart';
import '../models/pourboire.dart';
import '../utils/color.dart';
import 'pourboire_detail_page.dart';
import 'ajouter_pourboire_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controller/pourboire_data_table.dart';

class PourboireListPage extends StatefulWidget {
  const PourboireListPage({super.key});

  @override
  _PourboireListPageState createState() => _PourboireListPageState();
}

class _PourboireListPageState extends State<PourboireListPage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  late Future<List<Pourboire>> _futurePourboires;

  @override
  void initState() {
    super.initState();
    _futurePourboires = _fetchPourboires();
  }

  Future<List<Pourboire>> _fetchPourboires() async {
    try {
      final res = await _supabase
          .from('pourboires')
          .select()
          .order('created_at', ascending: false);

      if (res != null && res is List) {
        List<Pourboire> pourboires = res
            .map((item) => Pourboire.fromMap(item as Map<String, dynamic>))
            .toList();

        return pourboires;
      } else {
        return [];
      }
    } catch (e) {
      print('Erreur lors de la récupération des pourboires : $e');
      return [];
    }
  }

  Future<void> _refreshPourboires() async {
    setState(() {
      _futurePourboires = _fetchPourboires();
    });
  }

  void _ajouterPourboire() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AjouterPourboirePage()),
    );
    if (result == true) {
      _refreshPourboires();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterPourboire,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPourboires,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22.0, bottom: 5.0),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Pourboire>>(
                future: _futurePourboires,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erreur : ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Aucun pourboire disponible.'),
                    );
                  } else {
                    List<Pourboire> pourboires = snapshot.data!;

                    final pourboireDataSource =
                        PourboireDataTableSource(pourboires, context);

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PaginatedDataTable(
                          header: const Text(
                            'Liste des pourboires',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Montant',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Commentaire',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                          source: pourboireDataSource,
                          rowsPerPage: 10,
                          columnSpacing: 20,
                          showCheckboxColumn: false,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
