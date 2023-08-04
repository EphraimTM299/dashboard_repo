// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:store_responsive_dashboard/models/products.dart';

class Laundromats {
  final String address;
  final String name;
  String imagePath;
  final GeoPoint location;
  final List<Products> products;
  double distance;
  final double rating;
  final String city;
  final String turnAround;
  final String specialOffers;
  final String numberOfLocations;
  double deliveryPrice;

  Laundromats({
    required this.numberOfLocations,
    required this.deliveryPrice,
    required this.address,
    required this.name,
    required this.imagePath,
    required this.location,
    required this.products,
    required this.distance,
    required this.rating,
    required this.city,
    required this.turnAround,
    required this.specialOffers,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> tempProducts =
        products.map((product) => product.toMap()).toList();
    return <String, dynamic>{
      'name': name,
      'imagePath': imagePath,
      'location': location,
      'products': tempProducts,
      'special_offers': specialOffers,
      'city': city,
      'distance': distance,
      'rating': rating,
      'turnAround': turnAround,
      "address": address,
      'deliveryPrice': deliveryPrice
    };
  }

  factory Laundromats.fromMap(Map<String, dynamic> map) {
    List<Products> tempProducts =
        List<Map<String, dynamic>>.from(map['products'])
            .map((product) => Products.fromMap(product as Map<String, dynamic>))
            .toList();
    return Laundromats(
        name: map['name'] as String,
        city: map['city'] as String,
        imagePath: map['imagePath'] as String,
        location: map['location'] as GeoPoint,
        distance: map['distance'].toDouble(),
        rating: map['rating'].toDouble(),
        turnAround: map['turnAround'].toString(),
        specialOffers: map['special_offers'].toString(),
        products: tempProducts,
        address: map['address'].toString(),
        numberOfLocations: map['address'].toString(),
        deliveryPrice: map['deliveryPrice'].toDouble());
  }

  factory Laundromats.fromJson(String source) =>
      Laundromats.fromMap(json.decode(source) as Map<String, dynamic>);
}
