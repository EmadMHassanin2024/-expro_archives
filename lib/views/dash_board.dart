import 'package:flutter/material.dart';
import 'package:expro_archives/views/decision_workflow.dart';
import 'package:expro_archives/views/add_decision_screen.dart';
import 'package:expro_archives/views/view_decision_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, String>> decisions = const [
    {
      'id': '1',
      'name': 'قرار نزع 1',
      'number': '1001',
      'date': '2025-08-01',
      'owner': 'أحمد محمد',
      'area': '500 م²',
      'region': 'الرياض',
    },
    {
      'id': '2',
      'name': 'قرار نزع 2',
      'number': '1002',
      'date': '2025-08-02',
      'owner': 'سارة عبدالله',
      'area': '320 م²',
      'region': 'مكة',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isWeb = screenWidth >= 1024;

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
        body: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.start,
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
                  SizedBox(
                    width: isMobile ? screenWidth - 32 : 400,
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
              child: decisions.isEmpty
                  ? const Center(child: Text("لا توجد بيانات حالياً."))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DataTable(
                                columnSpacing: isMobile ? 8 : 20,
                                headingRowColor: MaterialStateProperty.all(
                                  Colors.teal.shade100,
                                ),
                                border: TableBorder.all(
                                  color: Colors.grey.shade300,
                                ),
                                columns: [
                                  const DataColumn(label: Text('م')),
                                  const DataColumn(label: Text('اسم القرار')),
                                  const DataColumn(label: Text('الرقم')),
                                  if (!isMobile)
                                    const DataColumn(label: Text('التاريخ')),
                                  if (!isMobile)
                                    const DataColumn(label: Text('المالك')),
                                  if (isTablet || isWeb)
                                    const DataColumn(label: Text('المساحة')),
                                  if (isTablet || isWeb)
                                    const DataColumn(label: Text('المنطقة')),
                                  const DataColumn(label: Text('الإجراءات')),
                                ],
                                rows: decisions.map((decision) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(decision['id']!)),
                                      DataCell(Text(decision['name']!)),
                                      DataCell(Text(decision['number']!)),
                                      if (!isMobile)
                                        DataCell(Text(decision['date']!)),
                                      if (!isMobile)
                                        DataCell(Text(decision['owner']!)),
                                      if (isTablet || isWeb)
                                        DataCell(Text(decision['area']!)),
                                      if (isTablet || isWeb)
                                        DataCell(Text(decision['region']!)),
                                      DataCell(
                                        Wrap(
                                          spacing: 4,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.visibility,
                                              ),
                                              tooltip: 'عرض',
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const ViewDecisionScreen(),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              tooltip: 'تعديل',
                                              onPressed: () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'ميزة التعديل لم تُفعّل بعد',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              tooltip: 'حذف',
                                              onPressed: () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'تم حذف القرار: ${decision['name']}',
                                                    ),
                                                    backgroundColor:
                                                        Colors.red[400],
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.work),
                                              tooltip: 'إجراءات ما بعد القرار',
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        PostDecisionWorkflowPage(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
