import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../widgets/scan_tiles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final contact = scanListProvider.contact;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Inici'),
          actions: [
            IconButton(
              onPressed: () {
                scanListProvider.deleteAll();
              },
              icon: const Icon(Icons.delete_forever),
            )
          ],
        ),
        body: const ScanTiles(),
        floatingActionButton: FloatingActionButton(
            elevation: 0,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, 'add');
            }));
  }
}
