import 'package:examen_practic/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class ScanTiles extends StatelessWidget {
  const ScanTiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.contact;

    return ListView.builder(
        itemCount: scans.length,
        itemBuilder: (_, i) => Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (DismissDirection direction) {
                scanListProvider.deleteScansByID(scans[i].id);
              },
              child: ListTile(
                title: Text(scans[i].name),
                subtitle: Text(scans[i].phone),
                trailing:
                    const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                onTap: () {
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                            id: i,
                          ));
                },
              ),
            ));
  }
}
