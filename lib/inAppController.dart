import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:onepref/onepref.dart';

class InAppController with ChangeNotifier {
  List<ProductDetails> _products = [];
  List<ProductId> _productId = [
    ProductId(id: 'weekly', isConsumable: false),
    ProductId(id: 'gold', isConsumable: false),
    ProductId(id: 'premium', isConsumable: false)
  ];
  bool _isSubscribed = false;

  IApEngine iApEngine = IApEngine();

  List<ProductDetails> get products {
    return [..._products];
  }

  List<ProductId> get productId {
    return [..._productId];
  }

  bool get isSubscribed {
    return _isSubscribed;
  }

  void getProducts() async {
    await iApEngine.getIsAvailable().then((value) async {
      if (value) {
        await iApEngine.queryProducts(_productId).then((res) {
          _products.clear();
          _products.addAll(res.productDetails);
        });
      }
    });
    notifyListeners();
  }

  Future<void> listenPurchases(List<PurchaseDetails> list) async {
    if (list.isNotEmpty) { 
      for (PurchaseDetails purchaseDetails in list) {
        if (purchaseDetails.status == PurchaseStatus.restored ||
            purchaseDetails.status == PurchaseStatus.purchased) {
          Map purchaseData = json
              .decode(purchaseDetails.verificationData.localVerificationData);

          if (purchaseData['acknowledge']) {
            setStatus(true);
          } else {
            if (Platform.isAndroid) {
              final InAppPurchaseAndroidPlatformAddition
                  androidPlatformAddition = iApEngine.inAppPurchase
                      .getPlatformAddition<
                          InAppPurchaseAndroidPlatformAddition>();
              await androidPlatformAddition.consumePurchase(purchaseDetails).then((value) {
                setStatus(true);
              });            
            }

            if(purchaseDetails.pendingCompletePurchase) {
              await iApEngine.inAppPurchase.completePurchase(purchaseDetails).then((value) {
                setStatus(true);
              });
            }
          }
        }
      }
    }
  }

  void setStatus(bool value) {
    _isSubscribed = value;
    OnePref.setPremium(_isSubscribed);
  }
}
