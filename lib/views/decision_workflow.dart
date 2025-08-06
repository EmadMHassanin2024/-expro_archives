import 'package:flutter/material.dart';

class PostDecisionWorkflowPage extends StatelessWidget {
  const PostDecisionWorkflowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<WorkflowStep> steps = [
      WorkflowStep(
        title: 'رفع قرار النزع المعتمد',
        description: 'رفع القرار النهائي المعتمد للنزع.',
        icon: Icons.upload_file,
        onTap: () {
          // TODO: تنفيذ الرفع
        },
      ),
      WorkflowStep(
        title: 'توليد 8 خطابات',
        description: 'إنشاء الخطابات المطلوبة بعد القرار.',
        icon: Icons.description,
        onTap: () {
          // TODO: تنفيذ التوليد
        },
      ),
      WorkflowStep(
        title: 'عرض واعتماد الخطابات',
        description: 'مراجعة الخطابات والموافقة عليها.',
        icon: Icons.mark_email_read,
        onTap: () {
          // TODO: تنفيذ العرض والاعتماد
        },
      ),
      WorkflowStep(
        title: 'إرسال الخطابات للجهات',
        description: 'إرسال الخطابات عبر البريد الإلكتروني والواتساب.',
        icon: Icons.send,
        onTap: () {
          // TODO: تنفيذ الإرسال
        },
      ),
      WorkflowStep(
        title: 'رفع الردود على الخطابات',
        description: 'رفع ملفات الردود من الجهات.',
        icon: Icons.reply,
        onTap: () {
          // TODO: تنفيذ رفع الردود
        },
      ),
      WorkflowStep(
        title: 'إعلام الجهات عند اكتمال الردود',
        description: 'إرسال إشعار باكتمال الردود.',
        icon: Icons.notifications_active,
        onTap: () {
          // TODO: تنفيذ الإعلام
        },
      ),
      WorkflowStep(
        title: 'رفع محضر لجنة التقدير المعتمد',
        description: 'رفع محضر التقدير النهائي.',
        icon: Icons.assignment_turned_in,
        onTap: () {
          // TODO: تنفيذ الرفع
        },
      ),
      WorkflowStep(
        title: 'رفع محضر لجنة الحصر',
        description: 'رفع محضر الحصر النهائي.',
        icon: Icons.assignment,
        onTap: () {
          // TODO: تنفيذ الرفع
        },
      ),
      WorkflowStep(
        title: 'تجميع المرفقات النهائية وإرسالها',
        description: 'تجميع الملفات النهائية وإرسالها بالبريد.',
        icon: Icons.archive,
        onTap: () {
          // TODO: تنفيذ التجميع والإرسال
        },
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إجراءات ما بعد القرار'),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                leading: Icon(step.icon, color: Colors.teal, size: 36),
                title: Text(
                  step.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(step.description),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: step.onTap,
              ),
            );
          },
        ),
      ),
    );
  }
}

class WorkflowStep {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  WorkflowStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });
}
