import 'dart:io';
import 'package:expro_archives/views/dash_board.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/decision_model.dart';
import '../models/workflow_step.dart';

class AddDecisionScreen extends StatefulWidget {
  const AddDecisionScreen({super.key});

  @override
  State<AddDecisionScreen> createState() => _AddDecisionScreenState();
}

class _AddDecisionScreenState extends State<AddDecisionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _decisionNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _areaController = TextEditingController();
  final _regionController = TextEditingController();

  DateTime? _decisionDate;
  File? _draftPdfFile;
  List<File> _attachments = [];
  bool _isLoading = false;

  Future<void> _pickDecisionDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _decisionDate = picked;
      });
    }
  }

  Future<void> _pickDraftPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null &&
        result.files.isNotEmpty &&
        result.files.single.path != null) {
      setState(() {
        _draftPdfFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        final newFiles = result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();
        _attachments.addAll(newFiles);
      });
    }
  }

  // رفع ملف واحد داخل مجلد محدد مع اسم فريد
  Future<String> _uploadFile(
    File file,
    String decisionId,
    String folder,
  ) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child(
        'decisions/$decisionId/$folder/$fileName',
      );
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Upload error: $e');
      return ''; // فشل الرفع
    }
  }

  Future<void> _saveDecision() async {
    if (!(_formKey.currentState?.validate() ?? false) ||
        _decisionDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى تعبئة جميع الحقول المطلوبة.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final decisionId = const Uuid().v4();

      // رفع ملف المسودة إذا تم اختياره
      String draftUrl = '';
      if (_draftPdfFile != null) {
        draftUrl = await _uploadFile(_draftPdfFile!, decisionId, 'drafts');
      }

      // رفع المرفقات إذا تم اختيارها
      List<String> attachmentsUrls = [];
      if (_attachments.isNotEmpty) {
        for (final file in _attachments) {
          final url = await _uploadFile(file, decisionId, 'attachments');
          if (url.isNotEmpty) attachmentsUrls.add(url);
        }
      }

      // إنشاء موديل القرار
      final newDecision = DecisionModel(
        id: decisionId,
        title: _titleController.text,
        description: _descriptionController.text,
        decisionNumber: _decisionNumberController.text,
        decisionDate: _decisionDate!,
        ownerName: _ownerNameController.text,
        area: _areaController.text,
        region: _regionController.text,
        draftPdfPath: draftUrl.isNotEmpty ? draftUrl : null,
        draftDecisionPath: null,
        draftCeoLetterPath: null,
        draftMinisterialPath: null,
        attachments: attachmentsUrls,
        createdAt: DateTime.now(),
        workflowSteps: [
          WorkflowStep(
            stepName: "إعداد القرار",
            isCompleted: false,
            order: 0,
            title: 'تبوك',
          ),
          WorkflowStep(
            stepName: "مراجعة",
            isCompleted: false,
            order: 1,
            title: 'مكة',
          ),
          WorkflowStep(
            stepName: "اعتماد",
            isCompleted: false,
            order: 2,
            title: 'جدة',
          ),
        ],
      );

      // حفظ القرار في Firestore
      await FirebaseFirestore.instance
          .collection('decisions')
          .doc(decisionId)
          .set(newDecision.toJson());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("تم حفظ القرار بنجاح")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            newDecision: DecisionModel(
              id: '1',
              title: 'قرار تجريبي',
              description: 'وصف القرار',
              decisionNumber: '123',
              decisionDate: DateTime.now(),
              ownerName: 'مالك القرار',
              area: 'المنطقة 1',
              region: 'الإقليم أ',
              draftPdfPath: null,
              attachments: [],
              workflowSteps: [],
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء الحفظ: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _decisionNumberController.dispose();
    _ownerNameController.dispose();
    _areaController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة قرار جديد")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "عنوان القرار"),
                validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "الوصف"),
                validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
              ),
              TextFormField(
                controller: _decisionNumberController,
                decoration: const InputDecoration(labelText: "رقم القرار"),
                validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
              ),
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(labelText: "اسم المالك"),
                validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
              ),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: "المساحة"),
                validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
              ),
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(labelText: "المنطقة"),
                validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(
                  _decisionDate == null
                      ? "اختر تاريخ القرار"
                      : "تاريخ القرار: ${_decisionDate!.toLocal()}".split(
                          ' ',
                        )[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDecisionDate,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickDraftPdf,
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(
                  _draftPdfFile == null
                      ? "اختر ملف PDF للمسودة"
                      : "تم اختيار: ${_draftPdfFile!.path.split('/').last}",
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickAttachments,
                icon: const Icon(Icons.attach_file),
                label: Text(
                  _attachments.isEmpty
                      ? "اختر مرفقات"
                      : "عدد المرفقات: ${_attachments.length}",
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveDecision,
                      child: const Text("حفظ القرار"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
