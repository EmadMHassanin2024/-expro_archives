import 'dart:io';
import 'package:expro_archives/services/storage_service.dart';
import 'package:expro_archives/views/dash_board.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final storageService = StorageService();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _decisionNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _areaController = TextEditingController();
  final _regionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  DateTime? _decisionDate;
  File? _draftPdfFile;
  List<File> _attachments = [];

  bool _isLoading = false;

  // حد الحجم في خطة Supabase المجانية: 50MB = 52,428,800 bytes
  static const int _maxBytes = 52428800;

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

  // ✅ دالة مساعدة لبناء مسار الملف داخل الـBucket
  String _buildPath({
    required String decisionId,
    required String folder, // drafts | attachments
    required File file,
  }) {
    final originalName = file.path.split('/').last;
    final ts = DateTime.now().millisecondsSinceEpoch;
    // مثال مسار: decisions/<decisionId>/drafts/1692200000_original.pdf
    return 'decisions/$decisionId/$folder/${ts}_$originalName';
  }

  // ✅ (بديل Firebase) رفع ملف إلى Supabase Storage عبر StorageService
  Future<String> _uploadWithSupabase({
    required File file,
    required String decisionId,
    required String folder,
  }) async {
    try {
      final fileSize = await file.length();
      if (fileSize > _maxBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حجم الملف يتجاوز 50MB — لم يتم الرفع')),
        );
        return '';
      }
      final path = _buildPath(
        decisionId: decisionId,
        folder: folder,
        file: file,
      );
      final url = await storageService.uploadFile(file, path);
      return url ?? '';
    } catch (e) {
      debugPrint('Supabase upload error: $e');
      return '';
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      addAttachment(file); // الآن تمرّر File وليس String
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

      // ✅ رفع ملف المسودة (Supabase)
      String draftUrl = '';
      if (_draftPdfFile != null) {
        draftUrl = await _uploadWithSupabase(
          file: _draftPdfFile!,
          decisionId: decisionId,
          folder: 'drafts',
        );
      }

      // ✅ رفع المرفقات (Supabase)
      final List<String> attachmentsUrls = [];
      if (_attachments.isNotEmpty) {
        for (final file in _attachments) {
          final url = await _uploadWithSupabase(
            file: file,
            decisionId: decisionId,
            folder: 'attachments',
          );

          if (url.isNotEmpty) {
            attachmentsUrls.add(url);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("فشل رفع أحد المرفقات")));
          }
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
        draftUrl: draftUrl.isNotEmpty ? draftUrl : null,
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
        searchKeywords: [],
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
          builder: (context) => DashboardScreen(newDecision: newDecision),
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
    _scrollController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _decisionNumberController.dispose();
    _ownerNameController.dispose();
    _areaController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  void addAttachment(File attachment) {
    setState(() {
      _attachments.add(attachment);
    });

    // تمرير التمرير بعد انتهاء الإطار الحالي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة قرار جديد")),
      body: Scrollbar(
        controller: _scrollController, // هنا
        thumbVisibility:
            true, // اجعل شريط التمرير دائمًا مرئي لتجنب بعض الأخطاء
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: _scrollController, // ويجب تمريره هنا أيضاً
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,

        child: Icon(Icons.add),
      ),
    );
  }
}
