import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';

class DetailsScreen extends StatelessWidget {
  int id;

  DetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.contact;
    final int i = id;
    return Scaffold(
      body: Column(
        children: [Text(scans[i].name), Text(scans[i].phone)],
      ),
    );
  }
}
