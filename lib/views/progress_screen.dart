import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:local_db_app/viewmodels/db_viewmodels.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Getting directly in ui...
    // final taskVM = context.watch<TaskViewModel>();
    // final totalTasks = taskVM.tasks.length;
    // final completed = taskVM.tasks.where((t) => t.isCompleted).length;
    // final pending = totalTasks - completed;

    //Getting from viewModel just using in ui...
    final taskVM = context.watch<TaskViewModel>();
    final total = taskVM.totalTasks;
    final completed = taskVM.completedTasks;
    final pending = taskVM.pendingTasks;

    return Scaffold(
      appBar: AppBar(title: Text("📊 Task Progress"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Task Completion Overview",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: completed.toDouble(),
                      title: 'Completed\n$completed',
                      radius: 80,
                      titleStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: pending.toDouble(),
                      title: 'Pending\n$pending',
                      radius: 80,
                      titleStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Total: ', style: TextStyle(fontSize: 16)),
                  TextSpan(
                    text: '$total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.teal,
                    ),
                  ),
                  TextSpan(text: ' tasks', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
