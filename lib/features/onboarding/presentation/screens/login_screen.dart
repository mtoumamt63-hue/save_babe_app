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
import '../../../../core/widgets/sb_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showError('Veuillez renseigner votre adresse e-mail');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showError('Format d\'adresse e-mail invalide');
      return;
    }

    if (password.isEmpty) {
      _showError('Veuillez renseigner votre mot de passe');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authServiceProvider).signInWithEmail(email, password);

      if (!mounted) return;

      // Vérifier si l'utilisateur avait déjà complété l'onboarding
      final userState = ref.read(appUserStateProvider);
      if (userState.onboarded) {
        context.go('/app/home');
      } else {
        context.go('/onboarding/pregnancy');
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Erreur lors de la connexion';
      switch (e.code) {
        case 'user-not-found':
          message = 'Aucun compte trouvé avec cet e-mail.';
          break;
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Identifiants incorrects. Vérifiez votre mot de passe.';
          break;
        case 'invalid-email':
          message = 'Adresse e-mail mal formatée.';
          break;
        case 'user-disabled':
          message = 'Ce compte a été désactivé.';
          break;
        case 'operation-not-allowed':
        case 'configuration-not-found':
          message = 'L\'authentification par e-mail n\'est pas activée sur la console Firebase.';
          break;
        case 'too-many-requests':
          message =
              'Trop de tentatives. Veuillez patienter avant de réessayer.';
          break;
        case 'network-request-failed':
          message = 'Connexion internet impossible. Vérifiez votre réseau.';
          break;
        default:
          if (e.message != null &&
              e.message!.contains('CONFIGURATION_NOT_FOUND')) {
            message = 'L\'authentification Email/Mot de passe n\'est pas encore activée dans la console Firebase.';
          } else {
            message = e.message ?? 'Une erreur inattendue est survenue.';
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.destructive,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
              SbHeader(title: 'Connexion', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Text(
                'Bon retour parmi nous',
                style: AppTypography.displayM.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connectez-vous pour retrouver vos données médicales et le suivi de votre grossesse.',
                style: AppTypography.bodyM.copyWith(
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 32),
              SbTextField(
                label: 'Adresse e-mail',
                controller: _emailController,
                placeholder: 'grace@exemple.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              SbTextField(
                label: 'Mot de passe',
                controller: _passwordController,
                placeholder: 'Votre mot de passe',
                obscureText: true,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 32),
              SbButton(
                text: 'Se connecter',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submit,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => context.push('/onboarding/signup'),
                  child: RichText(
                    text: TextSpan(
                      style: AppTypography.bodyM.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                      ),
                      children: const [
                        TextSpan(text: 'Pas encore de compte ? '),
                        TextSpan(
                          text: 'Créer un compte',
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
              const SizedBox(height: 24),
              const SbPrivateBadge(
                text: 'Vos données sont chiffrées et isolées',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
