import 'package:flutter/material.dart';

class OrdersData extends ChangeNotifier {
  double? cost;
  int? numOfOrders;

  double revenue = 0;

  void calculateRevenue() {
    revenue = numOfOrders! * cost!;
  }

  notifyListeners();
}
