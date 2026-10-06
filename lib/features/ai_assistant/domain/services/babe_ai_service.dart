import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'ai_knowledge_service.dart';

class BabeAiService {
  static const String _defaultApiKey = 'rd_sk_prod_Bb-tAgB79ClActVkY772eZlz0HboltTU';
  static const String _endpoint = 'https://api.rodiumai.io/v1/chat/completions';

  final String apiKey;
  final String model;
  final AiKnowledgeService _offlineKb;

  BabeAiService({
    this.apiKey = _defaultApiKey,
    this.model = 'google/gemini-3.8-flash',
    AiKnowledgeService? offlineKb,
  }) : _offlineKb = offlineKb ?? const AiKnowledgeService();

  static const String _systemPrompt = '''
Tu es Babe IA, l'assistante virtuelle de santé maternelle et néonatale de l'application SaveBabe.
Ton rôle :
1. Accompagner les futures mères et jeunes mamans avec bienveillance, clarté et empathie.
2. Donner des conseils éducatifs simples et validés médicalement sur la grossesse, la nutrition, l'hygiène, la vaccination et le suivi du nouveau-né.
3. Alerter immédiatement en cas de signes de danger obstétricaux (saignements, fièvre, maux de tête intenses, vision trouble, gonflement soudain, arrêt des mouvements de bébé, contractions prématurées) et conseiller de se rendre sans attendre dans une structure de santé ou d'appeler les urgences.
4. Rappeler toujours avec douceur que tes conseils ne remplacent pas une consultation médicale avec une sage-femme ou un médecin.
Sois chaleureuse, encourageante et concise dans tes réponses.
''';

  /// Envoie un message à l'API RodiumAI ou bascule sur la base locale en cas d'erreur/hors-ligne.
  Future<String> sendMessage({
    required String userMessage,
    List<Map<String, String>> history = const [],
  }) async {
    try {
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _systemPrompt},
        ...history,
        {'role': 'user', 'content': userMessage},
      ];

      final response = await http
          .post(
            Uri.parse(_endpoint),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': model,
              'messages': messages,
              'temperature': 0.7,
              'max_tokens': 600,
            }),
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final reply = choices[0]['message']['content'] as String?;
          if (reply != null && reply.trim().isNotEmpty) {
            return reply.trim();
          }
        }
      } else {
        debugPrint('Babe AI API error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Babe AI API exception: $e');
    }

    // Fallback transparent hors-ligne / base de connaissances
    return _offlineKb.answer(userMessage);
  }
}
