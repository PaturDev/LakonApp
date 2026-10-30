import 'package:supabase_flutter/supabase_flutter.dart';

class AIService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> ask(String question) async {
    final response = await _supabase.functions.invoke(
      'cultural-assistant',
      body: {
        'question': question,
      },
    );

    final data = response.data;

    if (data is Map && data['answer'] is String) {
      return data['answer'] as String;
    }

    throw Exception('Jawaban AI tidak ditemukan: $data');
  }
}