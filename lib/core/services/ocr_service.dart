import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../errors/exceptions.dart';

abstract class OcrService {
  Future<String> recognizeText(String imagePath);
  Future<Map<String, String>> extractHealthFields(String imagePath);
  void dispose();
}

class OcrServiceImpl implements OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  @override
  Future<String> recognizeText(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );
      return recognizedText.text;
    } catch (e) {
      throw OcrException(
        'Erreur lors de la reconnaissance de texte OCR',
        cause: e,
      );
    }
  }

  @override
  Future<Map<String, String>> extractHealthFields(String imagePath) async {
    try {
      final rawText = await recognizeText(imagePath);
      final lines = rawText.split('\n');
      final Map<String, String> extracted = {};

      for (final line in lines) {
        final lower = line.toLowerCase();
        if (lower.contains('groupe') ||
            lower.contains('sanguin') ||
            lower.contains('rh')) {
          extracted['Groupe sanguin'] = line;
        } else if (lower.contains('tension') ||
            lower.contains('ta:') ||
            lower.contains('pa:')) {
          extracted['Tension artérielle'] = line;
        } else if (lower.contains('poids') || lower.contains('kg')) {
          extracted['Poids'] = line;
        } else if (lower.contains('dpa') ||
            lower.contains('terme') ||
            lower.contains('accouchement')) {
          extracted['Date d\'accouchement'] = line;
        } else if (lower.contains('ddr') || lower.contains('règles')) {
          extracted['DDR'] = line;
        } else if (lower.contains('vaccin') ||
            lower.contains('vat') ||
            lower.contains('tétanos')) {
          extracted['Vaccination'] = line;
        }
      }

      // Si aucune correspondance exacte n'est trouvée, fournir les premières lignes significatives
      if (extracted.isEmpty && lines.isNotEmpty) {
        for (int i = 0; i < lines.length && i < 4; i++) {
          final trimmed = lines[i].trim();
          if (trimmed.isNotEmpty) {
            extracted['Info ${i + 1}'] = trimmed;
          }
        }
      }

      return extracted;
    } catch (e) {
      throw OcrException(
        'Erreur lors de l\'extraction des champs du carnet de santé',
        cause: e,
      );
    }
  }

  @override
  void dispose() {
    _textRecognizer.close();
  }
}
