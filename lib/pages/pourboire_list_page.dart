import 'package:flutter/material.dart';
import '../models/pourboire.dart';
import '../utils/color.dart';
import 'pourboire_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      print('Utilisateur actuel : ${_supabase.auth.currentUser}');

      final res = await _supabase.from('pourboires').select();

      print('Réponse brute : $res');

      if (res != null && res is List) {
        List<Pourboire> pourboires = res
            .map((item) => Pourboire.fromMap(item as Map<String, dynamic>))
            .toList();

        print('Liste des pourboires : $pourboires');

        return pourboires;
      } else {
        print('Aucune donnée récupérée ou format inattendu.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshPourboires,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 20),
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

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
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
                          rows: pourboires
                              .map(
                                (pourboire) => DataRow(
                                  cells: [
                                    DataCell(Text(pourboire.id.toString())),
                                    DataCell(Text('${pourboire.montant} €')),
                                    DataCell(Text(pourboire.commentaire ?? '')),
                                  ],
                                  onSelectChanged: (bool? selected) {
                                    if (selected != null && selected) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PourboireDetailPage(
                                                  pourboire: pourboire),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                              .toList(),
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
