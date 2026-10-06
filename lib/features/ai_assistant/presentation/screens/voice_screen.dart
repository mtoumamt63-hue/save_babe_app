import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../domain/services/ai_knowledge_service.dart';

class VoiceScreen extends ConsumerStatefulWidget {
  const VoiceScreen({super.key});

  @override
  ConsumerState<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends ConsumerState<VoiceScreen>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _recognizedText = '';
  String _assistantReply = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;
  final AiKnowledgeService _kbService = const AiKnowledgeService();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startListening() async {
    final audio = ref.read(audioServiceProvider);
    setState(() {
      _isListening = true;
      _recognizedText = '';
      _assistantReply = '';
    });
    _pulseController.repeat(reverse: true);

    try {
      await audio.startListening(
        onResult: (text) {
          setState(() {
            _recognizedText = text;
          });
        },
      );
    } catch (_) {
      // Simulation pour démo/test si pas de micro disponible
      Future.delayed(const Duration(seconds: 2), () {
        if (_isListening && mounted) {
          setState(() {
            _recognizedText = 'Est-ce que je peux faire du sport ?';
          });
          _stopListening();
        }
      });
    }
  }

  Future<void> _stopListening() async {
    final audio = ref.read(audioServiceProvider);
    await audio.stopListening();
    _pulseController.stop();
    _pulseController.reset();

    setState(() {
      _isListening = false;
    });

    if (_recognizedText.trim().isNotEmpty) {
      final reply = _kbService.answer(_recognizedText);
      setState(() {
        _assistantReply = reply;
      });
      await audio.speak(reply);
    }
  }

  Future<void> _speakAgain() async {
    if (_assistantReply.isNotEmpty) {
      await ref.read(audioServiceProvider).speak(_assistantReply);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SbHeader(
                title: 'Assistant vocal',
                subtitle: 'Parlez dans votre langue',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 20),
              // Big round pulse button
              ScaleTransition(
                scale: _isListening
                    ? _pulseScale
                    : const AlwaysStoppedAnimation(1.0),
                child: GestureDetector(
                  onTap: _isListening ? _stopListening : _startListening,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? AppColors.pink : AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (_isListening
                                      ? AppColors.pink
                                      : AppColors.primary)
                                  .withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isListening
                    ? 'Je vous écoute… touchez pour arrêter'
                    : 'Touchez le micro pour parler',
                style: AppTypography.bodyM.copyWith(
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 24),
              // User speech bubble
              if (_recognizedText.isNotEmpty) ...[
                SbCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vous',
                        style: AppTypography.labelS.copyWith(
                          color: isDark
                              ? AppColors.darkMutedForeground
                              : AppColors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _recognizedText,
                        style: AppTypography.bodyL.copyWith(
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              // Assistant answer
              if (_assistantReply.isNotEmpty) ...[
                SbCard(
                  backgroundColor: isDark
                      ? AppColors.darkCard
                      : AppColors.secondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assistant',
                        style: AppTypography.labelS.copyWith(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _assistantReply,
                        style: AppTypography.bodyM.copyWith(
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SbButton(
                        text: '🔊 Réécouter',
                        variant: SbButtonVariant.ghost,
                        onPressed: _speakAgain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.push('/emergency'),
                child: const Text(
                  'Besoin d\'aide urgente ?',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 13,
                    color: AppColors.destructive,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
