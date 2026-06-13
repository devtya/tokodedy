import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class StorageService {
  final SupabaseClient _supabase;

  StorageService(this._supabase);

  Future<String?> uploadProductImage(File imageFile) async {
    try {
      final extension = imageFile.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$extension';
      
      await _supabase.storage.from('product_images').upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
          
      final url = _supabase.storage.from('product_images').getPublicUrl(fileName);
      return url;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
