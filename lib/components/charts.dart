import 'package:flutter/material.dart';
import 'package:store_responsive_dashboard/constaints.dart';
import 'package:store_responsive_dashboard/widgets/bar_chart.dart';
import 'package:store_responsive_dashboard/widgets/pie_chart.dart';
import 'package:store_responsive_dashboard/widgets/linechart.dart';

class Charts extends StatelessWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= screenLg) {
      return Row(
        children: [
          Flexible(flex: 1, child: BarChartSample1()),
          SizedBox(
            width: componentPadding,
          ),
          Flexible(
            flex: 1,
            child: MyPieChart(),
          ),
        ],
      );
    }

    return Column(
      children: [
        BarChartSample1(),
        SizedBox(
          height: componentPadding,
        ),
        MyPieChart(),
      ],
    );
  }
}
