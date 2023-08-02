// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import "dart:async";

import "package:animated_custom_dropdown/custom_dropdown.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:intl/intl.dart";
import "package:percent_indicator/percent_indicator.dart";
import "package:provider/provider.dart";
import "package:store_responsive_dashboard/components/constants.dart";
import "package:store_responsive_dashboard/constants/size_config.dart";
import "package:store_responsive_dashboard/models/Orders.dart";
import "package:store_responsive_dashboard/providers/currentUser.dart";
import "package:store_responsive_dashboard/providers/ordersData.dart";
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
  DateTime now = DateTime.now();

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 0, bottom: 35),
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
                          Text(
                            "${Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.laundromatName}",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * .30,
                              child: CupertinoSearchTextField()),
                          Spacer(),
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
                            metric: Text(
                                "R ${Provider.of<OrdersData>(context, listen: false).calculateRevenue(_orderList).toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 20)),
                            subtitle: "Monthly Revenue",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                          CardWidget(
                            title: "Orders",
                            metric: Text("${_orderList.length}",
                                style: TextStyle(fontSize: 20)),
                            subtitle: "Total Orders",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                          CardWidget(
                            title: "Customers",
                            metric: Text(
                              "${_orderList.length}",
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: "Monthly Revenue",
                            icon: Icon(Icons.monetization_on_outlined),
                          ),
                          // CardWidget(
                          //   title: "Customers",
                          //   metric: Text(
                          //     "${_orderList.length}",
                          //     style: TextStyle(fontSize: 20),
                          //   ),
                          //   subtitle: "Monthly Revenue",
                          //   icon: Icon(Icons.monetization_on_outlined),
                          // ),
                          // CardWidget(
                          //   title: "Customers",
                          //   metric: Text(
                          //     "${_orderList.length}",
                          //     style: TextStyle(fontSize: 20),
                          //   ),
                          //   subtitle: "Monthly Revenue",
                          //   icon: Icon(Icons.monetization_on_outlined),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text("Weekly Revenue Breakdown"),
                              SizedBox(
                                height: 5,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                child: Container(
                                    height: 300,
                                    width:
                                        MediaQuery.of(context).size.width * .40,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Container(
                                        width: width * .25,
                                        height: 300,
                                        child: PieChartSample2())),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Container(
                                        width: width * .25,
                                        height: 300,
                                        child: PieChartSample2())),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),

                    Row(
                      children: [
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
                            width: MediaQuery.of(context).size.width * .75,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: DataTable(
                                sortAscending: false,
                                headingTextStyle: TextStyle(
                                    color: Colors.black87,
                                    fontSize: getProportionateScreenWidth(15)),
                                dataTextStyle: TextStyle(
                                    color: Colors.black87,
                                    fontSize: getProportionateScreenWidth(15)),
                                columns: [
                                  const DataColumn(label: Text("OrderNo.")),
                                  const DataColumn(label: Text("Customer")),
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
                                    DataCell(Text(
                                        "${_orderList[index].fomartDate(_orderList[index].pickup)}")),
                                    DataCell(Text(
                                        "${_orderList[index].fomartDeliverDate(_orderList[index].delivery)}")),
                                    DataCell(Text(
                                        "R ${_orderList[index].cost?.toStringAsFixed(2)}")),
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
            Container(
              //  decoration: BoxDecoration(color: Colors.white, ),
              height: height,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 15.0, top: 15),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * .05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.account_circle),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Hi, ${Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.firstName} ",
                                  style: headingStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Text("${DateFormat.MMMMEEEEd().format(now)}")
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Upcoming orders( )",
                              style: headingStyle,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: ((BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        title: Row(
                                          children: [
                                            Text('Order: 01228'),
                                            Spacer(),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                    Icon(Icons.cancel_outlined))
                                          ],
                                        ),
                                        content: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          width: 450,
                                          height: 200,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Items",
                                                        style: subheadingStyle,
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        "Service",
                                                        style: subheadingStyle,
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        "Qty",
                                                        style: subheadingStyle,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("Small Bag"),
                                                      Spacer(),
                                                      Text("Service: Wash"),
                                                      Spacer(),
                                                      Text("2"),
                                                      SizedBox(
                                                        width: 3,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 45.0,
                                                      right: 45,
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF685BFF),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    height: 25,
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "Start Processing")),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }));
                              },
                              child: Card(
                                margin: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Spacer(),
                                            CircularPercentIndicator(
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                              lineWidth: 10,
                                              radius: 30,
                                              percent: 0.25,
                                              progressColor: Colors.white,
                                              backgroundColor: Colors.white38,
                                            ),
                                            Spacer()
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        VerticalDivider(
                                          width: 3,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Spacer(),
                                              Text(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  "Order Date: ${DateFormat.MMMMEEEEd().format(now)}"),
                                              Spacer(),
                                              Text(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  "Order Status: Placed"),
                                              Spacer(),
                                              Text(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  "Order Number: 01228"),
                                              Spacer(),
                                              Text(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  "Due Date: ${DateFormat.MMMMEEEEd().format(now)}"),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFF685BFF),
                                    // color: Colors.amber.shade300,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.width * .08,
                                  width: width * .22,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
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
