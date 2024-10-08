// class Pourboire {
//   final int id;
//   final double montant;
//   final String commentaire;

//   Pourboire({
//     required this.id,
//     required this.montant,
//     required this.commentaire,
//   });
// }

// List<Pourboire> pourboires = [
//   Pourboire(id: 1, montant: 5.0, commentaire: 'Super service !'),
//   Pourboire(id: 2, montant: 10.0, commentaire: 'Très satisfait.'),
//   Pourboire(id: 3, montant: 2.5, commentaire: 'Correct.'),
//   Pourboire(id: 4, montant: 100, commentaire: 'Correct.'),
// ];

class Pourboire {
  final int id;
  final double montant;
  final String commentaire;
  final DateTime? createdAt;

  Pourboire({
    required this.id,
    required this.montant,
    required this.commentaire,
    required this.createdAt,
  });

  factory Pourboire.fromMap(Map<String, dynamic> map) {
    return Pourboire(
      id: map['id'] as int,
      montant: (map['montant'] as num).toDouble(),
      commentaire: map['commentaire'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }
}
