import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../domain/services/ai_knowledge_service.dart';

class ChatMessage {
  const ChatMessage({required this.isUser, required this.text});
  final bool isUser;
  final String text;
}

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiKnowledgeService _kbService = const AiKnowledgeService();

  @override
  void initState() {
    super.initState();
    final name = ref.read(appUserStateProvider).name;
    final displayName = name.isNotEmpty ? name : 'Grâce';
    _messages.add(
      ChatMessage(
        isUser: false,
        text:
            'Bonjour $displayName ! Je réponds à vos questions éducatives, même sans internet. Je ne remplace pas un professionnel de santé.',
      ),
    );

    if (widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialQuery!.trim());
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(isUser: true, text: text.trim()));
      _inputController.clear();
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final reply = _kbService.answer(text);
      setState(() {
        _messages.add(ChatMessage(isUser: false, text: reply));
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SbHeader(
                title: 'Assistant grossesse',
                subtitle: '● Disponible hors connexion',
                onBack: () => context.pop(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg.isUser;

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.82,
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary)
                            : (isDark ? AppColors.darkCard : AppColors.card),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(
                            AppDimensions.radius2xl,
                          ),
                          topRight: const Radius.circular(
                            AppDimensions.radius2xl,
                          ),
                          bottomLeft: Radius.circular(
                            isUser ? AppDimensions.radius2xl : 4,
                          ),
                          bottomRight: Radius.circular(
                            isUser ? 4 : AppDimensions.radius2xl,
                          ),
                        ),
                        border: isUser
                            ? null
                            : Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.border,
                                width: 1,
                              ),
                        boxShadow: isUser
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        msg.text,
                        style: AppTypography.bodyM.copyWith(
                          color: isUser
                              ? Colors.white
                              : (isDark
                                    ? AppColors.darkCardForeground
                                    : AppColors.cardForeground),
                          height: 1.35,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Quick suggestions
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children:
                      [
                        'Paludisme',
                        'Nausées',
                        'Bébé bouge moins',
                        'Sport',
                        'Alimentation',
                      ].map((topic) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _sendMessage(topic),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.primary,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                topic,
                                style: TextStyle(
                                  fontFamily: 'Figtree',
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            // Input bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        onSubmitted: _sendMessage,
                        decoration: InputDecoration(
                          hintText: 'Écrivez votre question…',
                          hintStyle: AppTypography.bodyS.copyWith(
                            color: isDark
                                ? AppColors.darkMutedForeground
                                : AppColors.mutedForeground,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/voice'),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mic_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _sendMessage(_inputController.text),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Emergency Link
            GestureDetector(
              onTap: () => context.push('/emergency'),
              child: const Padding(
                padding: EdgeInsets.only(bottom: 12, top: 4),
                child: Text(
                  'Besoin d\'aide urgente ?',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 12,
                    color: AppColors.destructive,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
