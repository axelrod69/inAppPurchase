import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_app/inAppController.dart';
import 'package:purchase_app/inAppPurchase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (context) => InAppController(),
      child: MaterialApp(
        home: InAppPurchase(),
      ),
    );
  }
}
