import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_app/inAppController.dart';

class InAppPurchase extends StatefulWidget {
  InAppPurchaseState createState() => InAppPurchaseState();
}

class InAppPurchaseState extends State<InAppPurchase> {
  @override
  void initState() {
    // TODO: implement initState
    final provider = Provider.of<InAppController>(context, listen: false);

    provider.iApEngine.inAppPurchase.purchaseStream
        .listen((listOfPurchaseDetails) {
      provider.listenPurchases(listOfPurchaseDetails);
    });

    provider.getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<InAppController>(context);

    // TODO: implement build
    return Scaffold(
        body: ListView.builder(
      itemCount: products.products.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => products.iApEngine
            .handlePurchase(products.products[index], products.productId),
        child: ListTile(
          leading: Text(products.products[index].description),
          trailing: Text(products.products[index].price),
        ),
      ),
    ));
  }
}
