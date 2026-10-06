import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_private_badge.dart';
import '../../../../core/widgets/sb_steps.dart';
import '../../../../core/widgets/sb_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _passwordController;
  bool _acceptedTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(appUserStateProvider);
    _nameController = TextEditingController(text: user.name);
    _contactController = TextEditingController(text: user.contact);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.destructive,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submit() async {
    final name = _nameController.text.trim();
    final contact = _contactController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      _showError('Veuillez renseigner votre prénom');
      return;
    }

    if (contact.isEmpty) {
      _showError('Veuillez renseigner votre adresse e-mail');
      return;
    }

    if (!contact.contains('@') || !contact.contains('.')) {
      _showError('Veuillez saisir une adresse e-mail valide');
      return;
    }

    if (password.length < 6) {
      _showError('Le mot de passe doit comporter au moins 6 caractères');
      return;
    }

    if (!_acceptedTerms) {
      _showError('Veuillez accepter les conditions de confidentialité');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Création du compte Firebase réel
      await ref.read(authServiceProvider).signUpWithEmail(contact, password);

      // Enregistrer le nom et l'e-mail dans l'état scopé au nouvel UID
      await ref
          .read(appUserStateNotifierProvider.notifier)
          .update((s) => s.copyWith(name: name, contact: contact));

      if (mounted) {
        context.push('/onboarding/pregnancy');
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Une erreur est survenue lors de l\'inscription';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Cette adresse e-mail est déjà utilisée. Connectez-vous.';
          break;
        case 'invalid-email':
          message = 'Format d\'adresse e-mail invalide.';
          break;
        case 'weak-password':
          message = 'Le mot de passe est trop faible (6 caractères minimum).';
          break;
        case 'operation-not-allowed':
        case 'configuration-not-found':
          message = 'L\'authentification par e-mail n\'est pas activée sur la console Firebase.';
          break;
        case 'network-request-failed':
          message = 'Connexion internet impossible. Vérifiez votre réseau.';
          break;
        default:
          if (e.message != null &&
              e.message!.contains('CONFIGURATION_NOT_FOUND')) {
            message = 'L\'authentification Email/Mot de passe n\'est pas encore activée dans la console Firebase.';
          } else {
            message = e.message ?? message;
          }
      }
      _showError(message);
    } catch (e) {
      _showError('Une erreur inattendue est survenue.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Créer votre compte',
                onBack: () => context.pop(),
              ),
              const SbSteps(currentStep: 1),
              SbTextField(
                label: 'Prénom',
                controller: _nameController,
                placeholder: 'Grâce',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              SbTextField(
                label: 'Adresse e-mail',
                controller: _contactController,
                placeholder: 'grace@exemple.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              SbTextField(
                label: 'Créer un mot de passe',
                controller: _passwordController,
                placeholder: '6 caractères minimum',
                obscureText: true,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _acceptedTerms,
                          activeColor: isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          onChanged: (v) =>
                              setState(() => _acceptedTerms = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.bodyM.copyWith(
                              color: isDark
                                  ? AppColors.darkCardForeground
                                  : AppColors.cardForeground,
                            ),
                            children: const [
                              TextSpan(text: 'J\'accepte les '),
                              TextSpan(
                                text: 'conditions de confidentialité',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SbButton(
                text: 'Continuer',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submit,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => context.push('/onboarding/login'),
                  child: RichText(
                    text: TextSpan(
                      style: AppTypography.bodyM.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                      ),
                      children: const [
                        TextSpan(text: 'Déjà un compte ? '),
                        TextSpan(
                          text: 'Se connecter',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SbPrivateBadge(text: 'Vos informations sont chiffrées'),
            ],
          ),
        ),
      ),
    );
  }
}
