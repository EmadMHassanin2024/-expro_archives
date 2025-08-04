import 'package:flutter/material.dart';

class ViewDecisionScreen extends StatelessWidget {
  const ViewDecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض تفاصيل القرار'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اسم القرار: قرار نزع 1', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('رقم القرار: 1001', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('اسم المالك: أحمد محمد', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('المساحة: 500 م²', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('المنطقة: الرياض', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('التاريخ: 2025-08-01', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
