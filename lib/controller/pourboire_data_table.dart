import 'package:flutter/material.dart';
import '../models/pourboire.dart';
import '../utils/color.dart';
import '../pages/pourboire_detail_page.dart';

class PourboireDataTableSource extends DataTableSource {
  final List<Pourboire> pourboires;
  final BuildContext context;

  PourboireDataTableSource(this.pourboires, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= pourboires.length) return null;

    final pourboire = pourboires[index];

    return DataRow.byIndex(
      index: index,
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
              builder: (context) => PourboireDetailPage(pourboire: pourboire),
            ),
          );
        }
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => pourboires.length;

  @override
  int get selectedRowCount => 0;
}
