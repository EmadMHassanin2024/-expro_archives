import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:ui' as ui;

class AddDecisionScreen extends StatefulWidget {
  @override
  _AddDecisionScreenState createState() => _AddDecisionScreenState();
}

class _AddDecisionScreenState extends State<AddDecisionScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  String decisionNumber = '';
  DateTime? decisionDate;
  String ownerName = '';
  String area = '';
  String region = '';
  DateTime? createdAt;
  String? attachmentFileName;

  Future<void> _pickDecisionDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: decisionDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        decisionDate = picked;
      });
    }
  }

  Future<void> _pickCreatedAtDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: createdAt ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        createdAt = picked;
      });
    }
  }

  Future<void> _pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        attachmentFileName = File(
          result.files.single.path!,
        ).path.split('/').last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text('إضافة قرار نزع ملكية')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth >= 600;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildFormField(
                      label: 'اسم القرار',
                      child: TextFormField(
                        decoration: _inputDecoration('أدخل اسم القرار'),
                        onSaved: (value) => title = value ?? '',
                        validator: _requiredValidator,
                      ),
                      isWide: isWideScreen,
                    ),
                    _buildFormField(
                      label: 'وصف القرار',
                      child: TextFormField(
                        maxLines: 3,
                        decoration: _inputDecoration('أدخل وصف القرار'),
                        onSaved: (value) => description = value ?? '',
                        validator: _requiredValidator,
                      ),
                      isWide: isWideScreen,
                    ),
                    _buildFormField(
                      label: 'رقم القرار',
                      child: TextFormField(
                        decoration: _inputDecoration('أدخل رقم القرار'),
                        onSaved: (value) => decisionNumber = value ?? '',
                        validator: _requiredValidator,
                      ),
                      isWide: isWideScreen,
                    ),
                    _buildFormField(
                      label: 'تاريخ القرار',
                      child: InkWell(
                        onTap: _pickDecisionDate,
                        child: InputDecorator(
                          decoration: _inputDecoration('اختر تاريخ القرار'),
                          child: Text(
                            decisionDate == null
                                ? ''
                                : DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(decisionDate!),
                          ),
                        ),
                      ),
                      isWide: isWideScreen,
                    ),
                    _buildFormField(
                      label: 'اسم المالك',
                      child: TextFormField(
                        decoration: _inputDecoration('أدخل اسم المالك'),
                        onSaved: (value) => ownerName = value ?? '',
                        validator: _requiredValidator,
                      ),
                      isWide: isWideScreen,
                    ),
                    _buildFormField(
                      label: 'المساحة',
                      child: TextFormField(
                        decoration: _inputDecoration('أدخل المساحة'),
                        onSaved: (value) => area = value ?? '',
                        validator: _requiredValidator,
                      ),
                      isWide: isWideScreen,
                    ),
                    _buildFormField(
                      label: 'المنطقة',
                      child: TextFormField(
                        decoration: _inputDecoration('أدخل اسم المنطقة'),
                        onSaved: (value) => region = value ?? '',
                        validator: _requiredValidator,
                      ),
                      isWide: isWideScreen,
                    ),
                    _buildFormField(
                      label: 'تاريخ الإنشاء',
                      child: InkWell(
                        onTap: _pickCreatedAtDate,
                        child: InputDecorator(
                          decoration: _inputDecoration('اختر تاريخ الإنشاء'),
                          child: Text(
                            createdAt == null
                                ? ''
                                : DateFormat('yyyy-MM-dd').format(createdAt!),
                          ),
                        ),
                      ),
                      isWide: isWideScreen,
                    ),
                    _buildFormField(
                      label: 'إدراج المرفق',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.attach_file),
                            label: Text('اختر ملف'),
                            onPressed: _pickAttachment,
                          ),
                          if (attachmentFileName != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('الملف: $attachmentFileName'),
                            ),
                        ],
                      ),
                      isWide: isWideScreen,
                    ),
                    SizedBox(width: double.infinity),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text('حفظ'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم حفظ البيانات بنجاح'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            child: Text('إلغاء'),
                            onPressed: () {
                              _formKey.currentState?.reset();
                              setState(() {
                                decisionDate = null;
                                createdAt = null;
                                attachmentFileName = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    required bool isWide,
  }) {
    return SizedBox(
      width: isWide ? 300 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(hintText: hint, border: OutlineInputBorder());
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }
}
