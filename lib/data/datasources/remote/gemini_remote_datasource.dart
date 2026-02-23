import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lara/domain/entities/chat_entity.dart';

class GeminiRemoteDatasource {
  GeminiRemoteDatasource({
    required String apiKey,
    http.Client? client,
    this.model = 'gemini-2.5-flash',
  }) : _apiKey = apiKey,
       _client = client ?? http.Client();

  final String _apiKey;
  final http.Client _client;
  final String model;

  String _systemPrompt(Personality p) {
    return switch (p) {
      Personality.ironic =>
        'Você é a LARA. Sua marca é o sarcasmo inteligente e a ironia fina. Responda com um toque de deboche elegante, mas mantenha a utilidade.',
      Personality.formal =>
        'Você é a LARA, atuando como um mestre de cerimônias ou mordomo britânico. Seja extremamente polida, use linguagem culta e trate o usuário com máxima reverência.',
      Personality.direct =>
        'Você é a LARA no Modo Foco. Seja o mais direta e concisa possível. Sem saudações longas ou termos desnecessários. Vá direto ao ponto.',
      Personality.motivator =>
        'Você é a LARA, sua mentora e coach. Traga energia positiva, incentive o usuário e use uma linguagem inspiradora para manter o foco nos objetivos.',
      Personality.nerd || Personality.philosophical =>
        'Você é a LARA, uma especialista geek e profunda. Use referências de cultura pop, ciência ou filosofia. Não tenha medo de ser técnica ou reflexiva.',
      _ =>
        'Você é a LARA, uma assistente bem-humorada, leve e inteligente. Faça piadas sutis quando couber, sem atrapalhar a resposta.',
    };
  }

  List<Map<String, Object?>> _buildContents({
    required String userMessage,
    required Personality personality,
    required List<Map<String, String>> history,
  }) {
    final contents = <Map<String, Object?>>[];

    contents.add({
      'role': 'user',
      'parts': [
        {'text': _systemPrompt(personality)},
      ],
    });

    for (final h in history) {
      final role = (h['role'] ?? 'user').trim();
      final text = (h['content'] ?? '').trim();
      if (text.isEmpty) continue;

      contents.add({
        'role': (role == 'assistant' || role == 'model') ? 'model' : 'user',
        'parts': [
          {'text': text},
        ],
      });
    }

    contents.add({
      'role': 'user',
      'parts': [
        {'text': userMessage},
      ],
    });

    return contents;
  }

  Stream<String> streamLaraResponse({
    required String userMessage,
    required Personality personality,
    required List<Map<String, String>> history,
  }) async* {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:streamGenerateContent?alt=sse',
    );

    final body = <String, Object?>{
      'contents': _buildContents(
        userMessage: userMessage,
        personality: personality,
        history: history,
      ),
    };

    final request = http.Request('POST', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'x-goog-api-key': _apiKey,
      })
      ..body = jsonEncode(body);

    final streamed = await _client.send(request);

    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      final errText = await streamed.stream.bytesToString();
      throw Exception('Gemini HTTP ${streamed.statusCode}: $errText');
    }

    const decoder = Utf8Decoder();
    var buffer = '';

    await for (final chunkBytes in streamed.stream) {
      buffer += decoder.convert(chunkBytes);

      while (true) {
        final eventIndex = buffer.indexOf('\n\n');
        if (eventIndex == -1) break;

        final rawEvent = buffer.substring(0, eventIndex);
        buffer = buffer.substring(eventIndex + 2);

        final lines = rawEvent
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty)
            .toList();

        for (final line in lines) {
          if (!line.startsWith('data:')) continue;

          final data = line.substring(5).trim();
          if (data.isEmpty || data == '[DONE]') continue;

          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final candidates = (json['candidates'] as List?) ?? const [];
            if (candidates.isEmpty) continue;

            final c0 = candidates.first as Map<String, dynamic>;
            final content = c0['content'] as Map<String, dynamic>?;
            final parts = (content?['parts'] as List?) ?? const [];
            if (parts.isEmpty) continue;

            final p0 = parts.first as Map<String, dynamic>;
            final text = p0['text'] as String?;
            if (text != null && text.isNotEmpty) {
              yield text;
            }
          } catch (_) {
            rethrow;
          }
        }
      }
    }
  }
}
