import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/user_model.dart';
import '../data/models/reference_model.dart';
import '../data/repositories/auth_repository.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';
import '../widgets/login/login_field.dart';
import '../widgets/login/login_primary_button.dart';
import '../widgets/login/login_footer_link.dart';
import '../widgets/register/dropdown_field.dart';
import '../widgets/register/role_chip.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedRole = 'Stagiaire';

  final _nomController           = TextEditingController();
  final _prenomController        = TextEditingController();
  final _emailController         = TextEditingController();
  final _telephoneController     = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _passwordController      = TextEditingController();
  final _etablissementController = TextEditingController();

  List<ReferenceModel> _filieres = [];
  List<ReferenceModel> _cycles   = [];
  ReferenceModel? selectedFiliere;
  ReferenceModel? selectedCycle;

  bool _isPasswordHidden = true;

  String? _nomError;
  String? _emailError;
  String? _passwordError;
  String? _filiereError;
  String? _etablissementError;
  String? _cycleError;

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  Future<void> _loadReferences() async {
    try {
      final repo         = sl<AuthRepository>();
      final filieresData = await repo.getFilieres();
      final cyclesData   = await repo.getCycles();
      if (!mounted) return;
      setState(() { _filieres = filieresData; _cycles = cyclesData; });
    } catch (e) { debugPrint('Erreur références : $e'); }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _dateNaissanceController.dispose();
    _passwordController.dispose();
    _etablissementController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dateNaissanceController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _register() {
    setState(() {
      _nomError = null; _emailError = null; _passwordError = null;
      _filiereError = null; _etablissementError = null; _cycleError = null;
    });

    bool hasError = false;
    if (_nomController.text.trim().isEmpty) {
      _nomError = 'Le nom est requis'; hasError = true;
    }
    if (_emailController.text.trim().isEmpty) {
      _emailError = "L'adresse email est requise"; hasError = true;
    } else if (!_emailController.text.trim().contains('@')) {
      _emailError = 'Adresse email invalide'; hasError = true;
    }
    if (_passwordController.text.trim().isEmpty) {
      _passwordError = 'Le mot de passe est requis'; hasError = true;
    } else if (_passwordController.text.trim().length < 6) {
      _passwordError = 'Minimum 6 caractères'; hasError = true;
    }
    if (selectedRole == 'Stagiaire') {
      if (selectedFiliere == null) { _filiereError = 'Sélectionnez une filière'; hasError = true; }
      if (_etablissementController.text.trim().isEmpty) { _etablissementError = "L'établissement est requis"; hasError = true; }
      if (selectedCycle == null) { _cycleError = 'Sélectionnez un cycle'; hasError = true; }
    }
    if (hasError) { setState(() {}); return; }

    final user = UserModel(
      nom:           _nomController.text.trim(),
      prenom:        _prenomController.text.trim(),
      email:         _emailController.text.trim(),
      password:      _passwordController.text.trim(),
      telephone:     _telephoneController.text.trim(),
      dateNaissance: _dateNaissanceController.text.trim(),
      role:          selectedRole.toUpperCase(),
      etablissement: selectedRole == 'Stagiaire' ? _etablissementController.text.trim() : null,
      filiereId:     selectedRole == 'Stagiaire' ? selectedFiliere?.id : null,
      cycleId:       selectedRole == 'Stagiaire' ? selectedCycle?.id   : null,
    );
    context.read<AuthBloc>().add(RegisterSubmitted(user));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Compte créé avec succès !'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ));
          context.router.replace(const LoginRoute());
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),

                // ── Titre ──────────────────────────────────
                const Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rejoignez la plateforme ASM dès aujourd\'hui',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textLight,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 32),

                // ── Sélection rôle ─────────────────────────
                _SectionTitle(text: 'Votre rôle'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    RoleChip(
                      label: 'Stagiaire',
                      description: 'Suivi & missions',
                      icon: Icons.description_outlined,
                      selected: selectedRole == 'Stagiaire',
                      onTap: () => setState(() => selectedRole = 'Stagiaire'),
                    ),
                    const SizedBox(width: 12),
                    RoleChip(
                      label: 'Encadrant',
                      description: 'Gérer les équipes',
                      icon: Icons.person_outline_rounded,
                      selected: selectedRole == 'Encadrant',
                      onTap: () => setState(() => selectedRole = 'Encadrant'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Identité ───────────────────────────────
                _SectionTitle(text: 'Identité'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LoginField(
                        controller: _prenomController,
                        label: 'Prénom',
                        hint: 'Votre prénom',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LoginField(
                        controller: _nomController,
                        label: 'Nom',
                        hint: 'Votre nom',
                        errorText: _nomError,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LoginField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'exemple@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                ),
                const SizedBox(height: 16),
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

                const SizedBox(height: 24),

                // ── Coordonnées ────────────────────────────
                _SectionTitle(text: 'Coordonnées'),
                const SizedBox(height: 12),
                LoginField(
                  controller: _telephoneController,
                  label: 'Téléphone',
                  hint: '+216 XX XXX XXX',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                LoginField(
                  controller: _dateNaissanceController,
                  label: 'Date de naissance',
                  hint: 'AAAA-MM-JJ',
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  suffixIcon: const Icon(Icons.calendar_today_outlined,
                      size: 18, color: Color(0xFFBEC5D0)),
                ),

                // ── Champs stagiaire ───────────────────────
                if (selectedRole == 'Stagiaire') ...[
                  const SizedBox(height: 24),
                  _SectionTitle(text: 'Formation'),
                  const SizedBox(height: 12),
                  DropdownField(
                    hint: 'Sélectionnez votre filière',
                    icon: Icons.book_outlined,
                    value: selectedFiliere?.nom,
                    items: _filieres.map((f) => f.nom).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedFiliere =
                            _filieres.firstWhere((f) => f.nom == val);
                      });
                    },
                    errorText: _filiereError,
                  ),
                  const SizedBox(height: 16),
                  LoginField(
                    controller: _etablissementController,
                    label: 'Établissement',
                    hint: 'Nom de votre établissement',
                    errorText: _etablissementError,
                  ),
                  const SizedBox(height: 16),
                  DropdownField(
                    hint: 'Sélectionnez votre cycle',
                    icon: Icons.history_edu_outlined,
                    value: selectedCycle?.nom,
                    items: _cycles.map((c) => c.nom).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCycle =
                            _cycles.firstWhere((c) => c.nom == val);
                      });
                    },
                    errorText: _cycleError,
                  ),
                ],

                const SizedBox(height: 32),

                // ── Bouton créer compte ────────────────────
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return LoginPrimaryButton(
                      label: 'Créer mon compte',
                      onPressed: isLoading ? null : _register,
                      isLoading: isLoading,
                    );
                  },
                ),

                const SizedBox(height: 28),

                // ── Lien connexion ─────────────────────────
                LoginFooterLink(
                  question: 'Déjà un compte ? ',
                  actionText: 'Se connecter',
                  onAction: () =>
                      context.router.replace(const LoginRoute()),
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textDark,
          fontFamily: 'Poppins',
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}