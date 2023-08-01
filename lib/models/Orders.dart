// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:intl/intl.dart';

class Orders {
  String? address;
  String? laundromat;
  String? userName;
  DateTime? pickup;
  DateTime? delivery;
  String? status;
  double? cost;
  String? orderId;
  String? orderNum;

  String fomartDate(pickup) {
    String pickupf = DateFormat.MMMMEEEEd().format(pickup);
    String pickupft = DateFormat.Hm().format(pickup);

    String dateAndTime = pickupf + " @ " + pickupft;

    return dateAndTime;
  }

  String fomartDeliverDate(delivery) {
    String deliveryf = DateFormat.MMMMEEEEd().format(delivery);
    String deliveryt = DateFormat.Hm().format(delivery);

    String dateAndTime = deliveryf + " @ " + deliveryt;

    return dateAndTime;
  }

  Orders();

  Orders.fromSnapshot(snapshot)
      : laundromat = snapshot.data()['laundromat'],
        pickup = snapshot.data()['pickup'].toDate(),
        delivery = snapshot.data()['delivery'].toDate(),
        address = snapshot.data()['address'],
        status = snapshot.data()['orderStatus'],
        cost = snapshot.data()["orderAmount"],
        orderId = snapshot.data()['orderId'],
        orderNum = snapshot.data()['orderNumber'],
        userName = snapshot.data()['userName'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'laundromat': laundromat,
      'userName': userName,
      'pickup': pickup,
      'delivery': delivery,
    };
  }

  String toJson() => json.encode(toMap());
}
