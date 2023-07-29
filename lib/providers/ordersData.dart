import 'package:flutter/material.dart';

class OrdersData extends ChangeNotifier {
  double cost = 0.0;
  int? numOfOrders;

  double revenue = 200;

  





  void calculateRevenue(  int numberofOrders) {
     revenue = numberofOrders * cost ;
  }

  notifyListeners();
}
