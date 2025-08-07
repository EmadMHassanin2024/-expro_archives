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
        onTap: () {},
      ),
      WorkflowStep(
        title: 'توليد 8 خطابات',
        description: 'إنشاء الخطابات المطلوبة بعد القرار.',
        icon: Icons.description,
        onTap: () {},
      ),
      WorkflowStep(
        title: 'عرض واعتماد الخطابات',
        description: 'مراجعة الخطابات والموافقة عليها.',
        icon: Icons.mark_email_read,
        onTap: () {},
      ),
      WorkflowStep(
        title: 'إرسال الخطابات للجهات',
        description: 'إرسال الخطابات عبر البريد الإلكتروني والواتساب.',
        icon: Icons.send,
        onTap: () {},
      ),
      WorkflowStep(
        title: 'رفع الردود على الخطابات',
        description: 'رفع ملفات الردود من الجهات.',
        icon: Icons.reply,
        onTap: () {},
      ),
      WorkflowStep(
        title: 'إعلام الجهات عند اكتمال الردود',
        description: 'إرسال إشعار باكتمال الردود.',
        icon: Icons.notifications_active,
        onTap: () {},
      ),
      WorkflowStep(
        title: 'رفع محضر لجنة التقدير المعتمد',
        description: 'رفع محضر التقدير النهائي.',
        icon: Icons.assignment_turned_in,
        onTap: () {},
      ),
      WorkflowStep(
        title: 'رفع محضر لجنة الحصر',
        description: 'رفع محضر الحصر النهائي.',
        icon: Icons.assignment,
        onTap: () {},
      ),
      WorkflowStep(
        title: 'تجميع المرفقات النهائية وإرسالها',
        description: 'تجميع الملفات النهائية وإرسالها بالبريد.',
        icon: Icons.archive,
        onTap: () {},
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600; // تابلت أو ويب
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: steps.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return WorkflowStepCard(step: steps[index], isWide: isWide);
                },
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

class WorkflowStepCard extends StatelessWidget {
  final WorkflowStep step;
  final bool isWide;

  const WorkflowStepCard({Key? key, required this.step, required this.isWide})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Icon(step.icon, color: Colors.teal, size: isWide ? 40 : 30),
        title: Text(
          step.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isWide ? 20 : 16,
          ),
        ),
        subtitle: Text(
          step.description,
          style: TextStyle(fontSize: isWide ? 16 : 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: step.onTap,
      ),
    );
  }
}
