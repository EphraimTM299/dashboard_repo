import 'package:flutter/material.dart';
import 'package:store_responsive_dashboard/constaints.dart';

class Order {
  final IconData icon;
  final String name;
  final String status;
  final String date;
  Order(this.icon, this.name, this.status, this.date);
}

final orders = <Order>[
  Order(Icons.checkroom_outlined, 'Black T-shirt', 'Delivered', '12/09/2021'),
  Order(Icons.ac_unit, 'Black T-shirt', 'Delivered', '12/09/2021'),
  Order(Icons.ac_unit, 'Black T-shirt', 'Delivered', '12/09/2021'),
  Order(Icons.ac_unit, 'Black T-shirt', 'Delivered', '12/09/2021'),
  Order(Icons.ac_unit, 'Black T-shirt', 'Delivered', '12/09/2021'),
];

final columnNames = ['', 'Time', ''];

class OrderTable extends StatelessWidget {
  const OrderTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DataColumn> columns =
        columnNames.map((e) => DataColumn(label: Text(e))).toList();
    final List<DataRow> rows = orders
        .map((order) => DataRow(cells: [
              DataCell(Row(
                children: [
                  Container(
                    child: Icon(
                      order.icon,
                      color: Theme.of(context).primaryColor,
                    ),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 14,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                              color: Color.fromRGBO(147, 198, 176, 0.2))
                        ]),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      order.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor),
                    ),
                  )
                ],
              )),
              DataCell(Text(
                order.date,
                style: TextStyle(fontStyle: FontStyle.italic),
              )),
              DataCell(Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1, color: Theme.of(context).primaryColor)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      order.status,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 12),
                    ),
                  )))
            ]))
        .toList();
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: DataTable(
        dataRowHeight: 70,
        columns: columns,
        rows: rows,
        headingRowHeight: 0,
        dividerThickness: 0,
      ),
    );
  }
}
