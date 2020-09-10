import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class ShowChartSales extends StatefulWidget {
  @override
  _ShowChartSalesState createState() => _ShowChartSalesState();
}

class _ShowChartSalesState extends State<ShowChartSales> {
  ChartData chartData = ChartData();
  VerticalBarChartOptions verticalBarChartOptions = VerticalBarChartOptions();
  LabelLayoutStrategy labelLayoutStrategy;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defineData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: VerticalBarChart(
          painter: VerticalBarChartPainter(),
          container: VerticalBarChartContainer(
            chartData: chartData,
            chartOptions: verticalBarChartOptions,
            xContainerLabelLayoutStrategy: labelLayoutStrategy,
          ),
        ),
      ),
    );
  }

  void defineData() {
    chartData.xLabels = [
      'Product',
      'Product2',
      'Product3',
      'Product4',
    ];
    chartData.dataRows = [
      [40.0, 30.0, 10.0, 20.0]
    ];
    chartData.dataRowsLegends = ['test1', 'test2', 'test3', 'test4'];
    chartData.dataRowsColors = [Colors.red];
    chartData.yLabels =['one','two','three','four'];
    labelLayoutStrategy =
        DefaultIterativeLabelLayoutStrategy(options: verticalBarChartOptions);
  }
}
