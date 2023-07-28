// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import "dart:async";

import "package:animated_custom_dropdown/custom_dropdown.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:provider/provider.dart";
import "package:store_responsive_dashboard/components/constants.dart";
import "package:store_responsive_dashboard/models/Orders.dart";
import "package:store_responsive_dashboard/providers/currentUser.dart";
import "package:store_responsive_dashboard/widgets/card.dart";
import "package:store_responsive_dashboard/widgets/chart.dart";

const List<String> _items = <String>[
  'Placed',
  "Picked Up",
  'Received',
  'Processing',
  "Done Processing",
  'Out for Delivery',
  'Complete'
];

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var selectedStatus;
  @override
  void initState() {
    getOrders();

    super.initState();
  }

  String dropdownValue = _items.first;

  Future getOrders() async {
    final laundromat = Provider.of<CurrentUser>(context, listen: false)
        .getCurrentUser
        ?.laundromatName;

    var orders = await FirebaseFirestore.instance
        .collection('orders')
        .where("laundromat", isEqualTo: laundromat)
        .get();

    setState(() {
      _orders = List.from(orders.docs.map((e) => Orders.fromSnapshot(e)));
    });

    setState(() {});
  }

  List<Orders> _orders = [];

  //setting the expansion function for the navigation rail
  bool isExpanded = false;
  final jobRoleCtrl = TextEditingController();
  final orderStatusCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //let's add the navigation menu for this project

                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.laundromatName}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.account_circle),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      "Hi, ${Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.firstName} "),
                                ],
                              ),
                            ],
                          ),
                          Spacer()
                        ],
                      ),
                    ),

                    //Now let's start with the dashboard main rapports

                    //Now let's set the article section
                    const SizedBox(
                      height: 30.0,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CardWidget(
                            title: "Revenue",
                            metric: Text("${_orders.length}",
                                style: TextStyle(fontSize: 20)),
                            subtitle: "Lifetime Orders",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                          CardWidget(
                            title: "Orders",
                            metric: Text("${_orders.length}",
                                style: TextStyle(fontSize: 20)),
                            subtitle: "Ordes today",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                          CardWidget(
                            title: "Gross Revenue",
                            metric: Text(
                              "${_orders.length}",
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: "Monthly Revenue",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                          CardWidget(
                            title: "Order Amount",
                            metric: Text(
                              "R1505.00",
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: "Average to date",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),

                    //let's set the filter section

                    Row(
                      children: [
                        Column(
                          children: [
                            CardWidget(
                              title: "Repeat Orders",
                              metric:
                                  Text("2500", style: TextStyle(fontSize: 20)),
                              subtitle: "Revenue this week",
                              icon: Icon(Icons.monetization_on_outlined),
                            ),
                            CardWidget(
                              title: "Online Orders",
                              metric:
                                  Text("2500", style: TextStyle(fontSize: 20)),
                              subtitle: "Revenue this week",
                              icon: Icon(Icons.monetization_on_outlined),
                            ),
                            CardWidget(
                              title: "Onsite Orders",
                              metric:
                                  Text("2500", style: TextStyle(fontSize: 20)),
                              subtitle: "Revenue this week",
                              icon: Icon(Icons.monetization_on_outlined),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Card(
                          child: Container(
                              height: 300,
                              width: 600,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: MyChart(isShowingMainData: true),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),

                    Row(
                      children: [
                        SizedBox(
                          width: 380.0,
                          child: CupertinoSearchTextField(),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 250,
                              child: CustomDropdown(
                                hintText: 'Filter by',
                                items: const [
                                  'Order Date',
                                  'Amount',
                                  'Order Status',
                                ],
                                controller: jobRoleCtrl,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),
                    // Data Table
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: DataTable(
                                  headingTextStyle: TextStyle(
                                      color: Colors.black87, fontSize: 18),
                                  dataTextStyle:
                                      TextStyle(color: Colors.black87),
                                  columns: [
                                    const DataColumn(
                                        label: Row(
                                      children: [
                                        // Icon(Icons.dashboard_customize),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Order ID"),
                                      ],
                                    )),
                                    const DataColumn(label: Text("Order #")),
                                    const DataColumn(
                                        label: Row(
                                      children: [
                                        // Icon(Icons.people),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Customer"),
                                      ],
                                    )),
                                    const DataColumn(label: Text("Order Date")),
                                    const DataColumn(label: Text("Due Date")),
                                    const DataColumn(label: Text("Amount")),
                                    const DataColumn(label: Text("Status")),
                                  ],
                                  rows: List.generate(
                                    _orders.length,
                                    (index) => DataRow(cells: [
                                      DataCell(
                                          Text("${_orders[index].orderId}")),
                                      DataCell(Text("#100126")),
                                      DataCell(
                                          Text(_orders[index].userName ?? '')),
                                      DataCell(
                                          Text("${_orders[index].pickup}")),
                                      DataCell(
                                          Text("${_orders[index].delivery}")),
                                      DataCell(Text("${_orders[index].cost}")),
                                      DataCell(Builder(builder: (context) {
                                        int idx = _items.indexOf(
                                            _orders[index].status ?? '');

                                        List<String> tempList =
                                            _items.sublist(idx);
                                        return DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          padding: EdgeInsets.all(8),

                                          // hint: Text(_orders[index].status ?? ""),
                                          items: tempList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              dropdownValue = value ?? '';
                                              db
                                                  .collection("orders")
                                                  .doc(_orders[index].orderId)
                                                  .update(
                                                      {"orderStatus": value});
                                              _orders[index].status = value;
                                            });
                                          },
                                          value: _orders[index].status ?? "",
                                        );
                                      })),
                                    ]),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      //let's add the floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: Color(0xFF685BFF),
      ),
    );
  }
}
