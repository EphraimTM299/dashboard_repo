// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import "dart:async";

import "package:animated_custom_dropdown/custom_dropdown.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:store_responsive_dashboard/models/Orders.dart";
import "package:store_responsive_dashboard/providers/currentUser.dart";
import "package:store_responsive_dashboard/widgets/card.dart";
import "package:store_responsive_dashboard/widgets/chart.dart";
import "package:store_responsive_dashboard/widgets/pie_chart.dart";

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
  double revenue = 0.0;
  List<Orders> _orderList = [];
  var selectedStatus;
  @override
  void initState() {
    final laundromat = Provider.of<CurrentUser>(context, listen: false)
        .getCurrentUser
        ?.laundromatName;

    db
        .collection("orders")
        .where("laundromat", isEqualTo: laundromat)
        .snapshots()
        .listen((event) async {
      List<Orders> _orders = [];
      for (var doc in event.docs) {
        _orders.add(Orders.fromSnapshot(doc));
      }
      _orderList = _orders;
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    // revenue calc

    super.initState();
  }

  String dropdownValue = _items.first;

  bool isExpanded = false;
  final jobRoleCtrl = TextEditingController();
  final orderStatusCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(_orderList);
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
                            metric: Text("${_orderList.length}",
                                style: TextStyle(fontSize: 20)),
                            subtitle: "Lifetime Orders",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                          CardWidget(
                            title: "Orders",
                            metric: Text("${_orderList.length}",
                                style: TextStyle(fontSize: 20)),
                            subtitle: "Ordes today",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                          CardWidget(
                            title: "Gross Revenue",
                            metric: Text(
                              "${_orderList.length}",
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: "Monthly Revenue",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),

                    Row(
                      children: [
                        Column(
                          children: [
                            Text("Weekly Revenue Breakdown"),
                            SizedBox(
                              height: 5,
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
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text("Revenue Breakdown by Service"),
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                                child: Container(
                                    height: 300, child: PieChartSample2())),
                          ],
                        )
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
                            child: DataTable(
                                headingTextStyle: TextStyle(
                                    color: Colors.black87, fontSize: 18),
                                dataTextStyle: TextStyle(color: Colors.black87),
                                columns: [
                                  const DataColumn(
                                      label: Row(
                                    children: [
                                      Text("Order #"),
                                    ],
                                  )),
                                  const DataColumn(
                                      label: Row(
                                    children: [
                                      Text("Customer"),
                                    ],
                                  )),
                                  const DataColumn(label: Text("Order Date")),
                                  const DataColumn(label: Text("Due Date")),
                                  const DataColumn(label: Text("Amount")),
                                  const DataColumn(label: Text("Status")),
                                ],
                                rows: List.generate(
                                  _orderList.length,
                                  (index) => DataRow(cells: [
                                    DataCell(
                                        Text("${_orderList[index].orderNum}")),
                                    DataCell(
                                        Text(_orderList[index].userName ?? '')),
                                    DataCell(
                                        Text("${_orderList[index].pickup}")),
                                    DataCell(
                                        Text("${_orderList[index].delivery}")),
                                    DataCell(Text("${_orderList[index].cost}")),
                                    DataCell(Builder(builder: (context) {
                                      int idx = _items.indexOf(
                                          _orderList[index].status ?? '');

                                      List<String> tempList =
                                          _items.sublist(idx);
                                      return DropdownButton<String>(
                                        borderRadius: BorderRadius.circular(10),
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
                                                .doc(_orderList[index].orderId)
                                                .update({"orderStatus": value});
                                            _orderList[index].status = value;
                                          });
                                        },
                                        value: _orderList[index].status ?? "",
                                      );
                                    })),
                                  ]),
                                )),
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
