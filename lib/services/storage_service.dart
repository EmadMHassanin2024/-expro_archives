import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class StorageService {
  //المفتاح اللي بيدخلك على قاعدة البيانات والتخزين.
  final supa.SupabaseClient supabase = supa.Supabase.instance.client;

  Future<String?> uploadFile(File file, String path) async {
    try {
      // بيرجع اسم الملف المرفوع فقط (أو بيرمي Exception لو فيه خطأ)
      await supabase.storage.from('uploads').upload(path, file);

      // نحصل على رابط الملف
      final String publicUrl = supabase.storage
          .from('uploads')
          .getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<Uint8List?> downloadFile(String path) async {
    try {
      // بيرجع بيانات الملف (Uint8List)
      final Uint8List data = await supabase.storage
          .from('uploads')
          .download(path);
      return data;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }
}
