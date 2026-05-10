import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/di/injection.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/repositories/auth_repository.dart';
import '../widgets/login/login_field.dart';
import '../widgets/login/login_primary_button.dart';
import '../widgets/login/login_footer_link.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isLoading        = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _emailError = null; _passwordError = null; });

    bool hasError = false;
    if (_emailController.text.trim().isEmpty) {
      _emailError = "L'adresse email est requise"; hasError = true;
    } else if (!_emailController.text.trim().contains('@')) {
      _emailError = "Adresse email invalide"; hasError = true;
    }
    if (_passwordController.text.trim().isEmpty) {
      _passwordError = "Le mot de passe est requis"; hasError = true;
    }
    if (hasError) { setState(() {}); return; }

    setState(() => _isLoading = true);
    try {
      final token = await sl<AuthRepository>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (token.isNotEmpty) {
        final role = await sl<AuthRepository>().getRole() ?? '';
        if (!mounted) return;
        if (role == 'ROLE_ADMIN' || role == 'ROLE_RH') {
          context.router.replace(const SubjectListRoute());
        } else if (role == 'ROLE_ENCADRANT') {
          context.router.replace(const EncadrantHomeRoute());
        } else if (role == 'ROLE_STAGIAIRE') {
          await _checkStagiaireAccess(context);
        } else {
          context.router.replace(const SubjectListRoute());
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkStagiaireAccess(BuildContext context) async {
    try {
      const storage = FlutterSecureStorage();
      final token   = await storage.read(key: 'token') ?? '';
      final dio     = sl<DioClient>().dio;
      final resp    = await dio.get('/stages/has-dossier',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      final hasDossier = resp.data as bool;
      if (!context.mounted) return;
      context.router.replace(
          hasDossier ? const StagiaireHomeRoute() : const SubjectListRoute());
    } catch (_) {
      if (!context.mounted) return;
      context.router.replace(const SubjectListRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // ── Titre ──────────────────────────────────
                const Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bonjour, vous avez été manqué !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textLight,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 40),

                // ── Email ──────────────────────────────────
                LoginField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'exemple@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                ),

                const SizedBox(height: 20),

                // ── Mot de passe ───────────────────────────
                LoginField(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  hint: '••••••••••••',
                  obscure: _isPasswordHidden,
                  errorText: _passwordError,
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => _isPasswordHidden = !_isPasswordHidden),
                    child: Icon(
                      _isPasswordHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.textLight,
                      size: 20,
                    ),
                  ),
                ),

                // ── Mot de passe oublié ────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 28),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Bouton connexion ───────────────────────
                LoginPrimaryButton(
                  label: 'Se connecter',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 48),

                // ── Lien inscription ───────────────────────
                LoginFooterLink(
                  question: "Pas encore de compte ? ",
                  actionText: "S'inscrire",
                  onAction: () =>
                      context.router.replace(const RegisterRoute()),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}