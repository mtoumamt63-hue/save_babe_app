import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../errors/exceptions.dart';

abstract class AudioService {
  Future<bool> initSpeech();
  Future<void> startListening({
    required void Function(String text) onResult,
    String? localeId,
  });
  Future<void> stopListening();
  bool get isListening;

  Future<void> initTts();
  Future<void> speak(String text);
  Future<void> stopSpeaking();
  bool get isSpeaking;
}

class AudioServiceImpl implements AudioService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isSpeechInitialized = false;
  bool _isTtsInitialized = false;
  bool _isSpeakingNow = false;

  @override
  bool get isListening => _speechToText.isListening;

  @override
  bool get isSpeaking => _isSpeakingNow;

  @override
  Future<bool> initSpeech() async {
    try {
      if (_isSpeechInitialized) {
        return true;
      }
      _isSpeechInitialized = await _speechToText.initialize(
        onError: (val) {},
        onStatus: (val) {},
      );
      return _isSpeechInitialized;
    } catch (e) {
      throw AudioException(
        'Impossible d\'initialiser la reconnaissance vocale',
        cause: e,
      );
    }
  }

  @override
  Future<void> startListening({
    required void Function(String text) onResult,
    String? localeId,
  }) async {
    try {
      if (!_isSpeechInitialized) {
        final ready = await initSpeech();
        if (!ready) {
          throw const AudioException('Reconnaissance vocale non disponible');
        }
      }
      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        listenOptions: SpeechListenOptions(localeId: localeId ?? 'fr_FR'),
      );
    } catch (e) {
      throw AudioException('Erreur pendant l\'écoute audio', cause: e);
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      if (_speechToText.isListening) {
        await _speechToText.stop();
      }
    } catch (e) {
      throw AudioException('Erreur lors de l\'arrêt de l\'écoute', cause: e);
    }
  }

  @override
  Future<void> initTts() async {
    try {
      if (_isTtsInitialized) {
        return;
      }
      await _flutterTts.setLanguage('fr-FR');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);

      _flutterTts.setStartHandler(() {
        _isSpeakingNow = true;
      });
      _flutterTts.setCompletionHandler(() {
        _isSpeakingNow = false;
      });
      _flutterTts.setErrorHandler((msg) {
        _isSpeakingNow = false;
      });

      _isTtsInitialized = true;
    } catch (e) {
      throw AudioException(
        'Impossible d\'initialiser la synthèse vocale',
        cause: e,
      );
    }
  }

  @override
  Future<void> speak(String text) async {
    try {
      if (!_isTtsInitialized) {
        await initTts();
      }
      _isSpeakingNow = true;
      await _flutterTts.speak(text);
    } catch (e) {
      _isSpeakingNow = false;
      throw AudioException('Erreur lors de la lecture audio', cause: e);
    }
  }

  @override
  Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
      _isSpeakingNow = false;
    } catch (e) {
      throw AudioException(
        'Erreur lors de l\'arrêt de la synthèse vocale',
        cause: e,
      );
    }
  }
}
