import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lara/core/constants/app_constants.dart';
import 'package:lara/domain/entities/message_entity.dart';

class GeminiDatasource {
  GeminiDatasource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> sendMessage({
    required String message,
    required List<MessageEntity> history,
    required String personality,
  }) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/${AppConstants.geminiModel}:generateContent',
    );

    final body = <String, Object?>{
      'system_instruction': {
        'parts': [
          {'text': 'Me responda de forma $personality'},
        ],
      },
      'contents': _buildContents(userMessage: message, history: history),
    };

    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': AppConstants.geminiApiKey,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gemini HTTP ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = json['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('Gemini: nenhum candidato na resposta');
    }

    final content =
        (candidates.first as Map<String, dynamic>)['content']
            as Map<String, dynamic>?;
    final parts = content?['parts'] as List?;
    if (parts == null || parts.isEmpty) {
      throw Exception('Gemini: nenhuma parte na resposta');
    }

    final text = (parts.first as Map<String, dynamic>)['text'] as String?;
    if (text == null || text.isEmpty) {
      throw Exception('Gemini: texto vazio na resposta');
    }

    return text;
  }

  List<Map<String, Object>> _buildContents({
    required String userMessage,
    required List<MessageEntity> history,
  }) {
    final contents = history
        .where((m) => m.status == MessageStatus.sent && m.content.isNotEmpty)
        .map(
          (m) => <String, Object>{
            'role': m.role == MessageRole.user ? 'user' : 'model',
            'parts': [
              {'text': m.content},
            ],
          },
        )
        .toList();

    contents.add({
      'role': 'user',
      'parts': [
        {'text': userMessage},
      ],
    });

    return contents;
  }
}
