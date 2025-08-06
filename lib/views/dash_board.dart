import 'package:expro_archives/views/decision_workflow.dart';
import 'package:flutter/material.dart';
import 'package:expro_archives/views/add_decision_screen.dart';
import 'package:expro_archives/views/view_decision_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'قرارات نزع الملكية',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: DefaultTextStyle(
          style: const TextStyle(color: Colors.black),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDecisionScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'إضافة قرار نزع',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ابحث باسم المالك أو المنطقة...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DataTable(
                        columnSpacing: 20,
                        headingRowColor: MaterialStateProperty.all(
                          Colors.teal.shade100,
                        ),
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columns: const [
                          DataColumn(label: Text('م')),
                          DataColumn(label: Text('اسم قرار النزع')),
                          DataColumn(label: Text('رقم قرار النزع')),
                          DataColumn(label: Text('التاريخ')),
                          DataColumn(label: Text('اسم المالك')),
                          DataColumn(label: Text('المساحة')),
                          DataColumn(label: Text('المنطقة')),
                          DataColumn(label: Text('الإجراءات')),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              const DataCell(Text('1')),
                              const DataCell(Text('قرار نزع 1')),
                              const DataCell(Text('1001')),
                              const DataCell(Text('2025-08-01')),
                              const DataCell(Text('أحمد محمد')),
                              const DataCell(Text('500 م²')),
                              const DataCell(Text('الرياض')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ViewDecisionScreen(),
                                          ),
                                        );
                                      },
                                      tooltip: 'عرض',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        // تعديل القرار
                                      },
                                      tooltip: 'تعديل',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        // حذف القرار
                                      },
                                      tooltip: 'حذف',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.work),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PostDecisionWorkflowPage(),
                                          ),
                                        );
                                      },
                                      tooltip: 'إجراءات ما بعد القرار',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('2')),
                              const DataCell(Text('قرار نزع 2')),
                              const DataCell(Text('1002')),
                              const DataCell(Text('2025-08-02')),
                              const DataCell(Text('سارة عبدالله')),
                              const DataCell(Text('320 م²')),
                              const DataCell(Text('مكة')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ViewDecisionScreen(),
                                          ),
                                        );
                                      },
                                      tooltip: 'عرض',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {},
                                      tooltip: 'تعديل',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {},
                                      tooltip: 'حذف',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.work),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PostDecisionWorkflowPage(),
                                          ),
                                        );
                                      },
                                      tooltip: 'إجراءات ما بعد القرار',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
