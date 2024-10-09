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
