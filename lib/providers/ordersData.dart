import 'package:flutter/material.dart';
import 'package:store_responsive_dashboard/models/Orders.dart';

class OrdersData extends ChangeNotifier {
  double cost = 0.0;
  int? numOfOrders;

  double revenue = 0;

  double calculateRevenue(List<Orders> orders) {
    revenue = orders.fold(0, (value, element) {
      return value + ((element).cost ?? 0);
    });
    return revenue;
  }

  notifyListeners();
}
