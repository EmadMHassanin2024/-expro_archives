import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expro_archives/views/decision_workflow.dart';

import 'package:expro_archives/widget/deponcer.dart';
import 'package:flutter/material.dart';
import 'package:expro_archives/models/decision_model.dart';
import 'package:expro_archives/views/add_decision_screen.dart';
import 'package:expro_archives/views/view_decision_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.newDecision});
  final DecisionModel? newDecision;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String searchQuery = '';
  final searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 300);

  void addFakeDecisions() {
    final fakeDecisions = [
      DecisionModel(
        title: 'قرار نزع ملكية 1',
        description: 'وصف القرار الأول',
        decisionNumber: '001',
        decisionDate: DateTime.now().subtract(const Duration(days: 10)),
        ownerName: 'مالك 1',
        area: '100 متر مربع',
        region: 'المنطقة أ',
        draftUrl: null,
        attachments: [],
        workflowSteps: [],
        searchKeywords: [],
      ),
      DecisionModel(
        title: 'قرار نزع ملكية 2',
        description: 'وصف القرار الثاني',
        decisionNumber: '002',
        decisionDate: DateTime.now().subtract(const Duration(days: 5)),
        ownerName: 'مالك 2',
        area: '150 متر مربع',
        region: 'المنطقة ب',
        draftUrl: null,
        attachments: [],
        workflowSteps: [],
        searchKeywords: [],
      ),
      DecisionModel(
        title: 'قرار نزع ملكية 3',
        description: 'وصف القرار الثالث',
        decisionNumber: '003',
        decisionDate: DateTime.now(),
        ownerName: 'مالك 3',
        area: '200 متر مربع',
        region: 'المنطقة ج',
        draftUrl: null,
        attachments: [],
        workflowSteps: [],
        searchKeywords: [],
      ),
    ];

    final collection = FirebaseFirestore.instance.collection('decisions');
    for (var decision in fakeDecisions) {
      collection.add({
        'title': decision.title,
        'description': decision.description,
        'decisionNumber': decision.decisionNumber,
        'decisionDate': Timestamp.fromDate(decision.decisionDate),
        'ownerName': decision.ownerName,
        'area': decision.area,
        'region': decision.region,
        'draftPdfPath': decision.draftPdfPath,
        'attachments': decision.attachments,
        'workflowSteps': [],
        'createdAt': Timestamp.now(),
      });
    }
  }

  Future<void> deleteDecision(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('decisions')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف القرار بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الحذف: $e')));
    }
  }

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
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'إضافة قرارات وهمية',
              onPressed: () {
                addFakeDecisions();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إضافة 3 قرارات وهمية')),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
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
                      controller: searchController,
                      onChanged: (value) {
                        _debouncer.run(() {
                          if (!mounted) return; // أمان إضافي لو اتقفلت الشاشة

                          setState(() => searchQuery = value);
                        });
                      },

                      decoration: InputDecoration(
                        labelText: 'البحث',
                        hintText: '   ابحث باسم المالك او المنطقة ...',
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('decisions')
                    .orderBy('decisionDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final decisionsDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data()! as Map<String, dynamic>;
                    final owner = data['ownerName'] ?? '';
                    final region = data['region'] ?? '';
                    return owner.contains(searchQuery) ||
                        region.contains(searchQuery);
                  }).toList();

                  if (decisionsDocs.isEmpty) {
                    return const Center(child: Text('لا توجد قرارات'));
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),

                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  headingRowHeight: 56,
                                  columnSpacing: isMobile ? 8 : 20,
                                  headingRowColor: MaterialStateProperty.all(
                                    Colors.teal.shade100,
                                  ),
                                  border: TableBorder.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
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
                                  rows: List.generate(decisionsDocs.length, (
                                    index,
                                  ) {
                                    final doc = decisionsDocs[index];
                                    final data =
                                        doc.data()! as Map<String, dynamic>;

                                    final id = (index + 1).toString();
                                    final title = data['title'] ?? '';
                                    final number =
                                        data['decisionNumber']?.toString() ??
                                        '';
                                    final owner = data['ownerName'] ?? '';
                                    final area = data['area'] ?? '';
                                    final region = data['region'] ?? '';

                                    String formattedDate = '';
                                    if (data['decisionDate'] is Timestamp) {
                                      final date =
                                          (data['decisionDate'] as Timestamp)
                                              .toDate();
                                      formattedDate =
                                          '${date.day}/${date.month}/${date.year}';
                                    }

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(id)),
                                        DataCell(Text(title)),
                                        DataCell(Text(number)),
                                        if (!isMobile)
                                          DataCell(Text(formattedDate)),
                                        if (!isMobile) DataCell(Text(owner)),
                                        if (isTablet || isWeb)
                                          DataCell(Text(area)),
                                        if (isTablet || isWeb)
                                          DataCell(Text(region)),
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
                                                          ViewDecisionScreen(
                                                            decisionId: doc.id,
                                                          ),
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
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                tooltip: 'حذف',
                                                onPressed: () {
                                                  deleteDecision(doc.id);
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.work),
                                                tooltip:
                                                    'إجراءات ما بعد القرار',
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
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
