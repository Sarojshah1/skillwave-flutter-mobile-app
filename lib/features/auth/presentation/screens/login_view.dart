import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/cores/common/common_snackbar.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/auth/presentation/widgets/loading_overlay.dart';
import 'package:skillwave/features/auth/presentation/widgets/login_form.dart';
import 'package:skillwave/cores/network/hive_service.dart';
import 'package:skillwave/cores/services/api_service.dart';
import 'package:skillwave/features/auth/domian/entity/login_entity.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

@RoutePage()
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final HiveService _hiveService = HiveService();
  final BiometricHelper _biometricHelper = BiometricHelper();
  bool _showBiometric = false;
  bool _biometricAvailable = false;
  bool _biometricPromptShown = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _checkAndShowFirstTimeBiometricPrompt();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final canCheck = await _biometricHelper.canCheckBiometrics();
    final enabled = _hiveService.isBiometricEnabled();
    final email = _hiveService.getEmail();
    final password = _hiveService.getPassword();
    setState(() {
      _biometricAvailable = canCheck;
      _showBiometric = enabled && email != null && password != null;
    });
  }

  Future<void> _checkAndShowFirstTimeBiometricPrompt() async {
    final box = await Hive.openBox('userBox');
    final shown = box.get('biometric_prompt_shown', defaultValue: false);
    if (!shown) {
      await _showSetupBiometricDialog();
      await box.put('biometric_prompt_shown', true);
      setState(() {
        _biometricPromptShown = true;
      });
    }
  }

  Future<void> _handleLogin() async {
    final connectivity = await Connectivity().checkConnectivity();
    final isOffline = connectivity is List
        ? connectivity.contains(ConnectivityResult.none)
        : connectivity == ConnectivityResult.none;
    if (isOffline) {
      CommonSnackbar.show(
        context,
        message: 'No internet connection. Please check your network.',
        isError: true,
        title: 'Network Error',
      );
      return;
    }
    // Proceed with login logic (dispatch AuthBloc event, etc.)
    context.read<AuthBloc>().add(
      LogInRequested(
        entity: LogInEntity(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      ),
    );
  }

  Future<void> _handleBiometricLogin() async {
    final canCheck = await _biometricHelper.canCheckBiometrics();
    if (!canCheck) {
      await _showSetupBiometricDialog();
      return;
    }
    final authenticated = await _biometricHelper.authenticateWithBiometrics();
    if (authenticated) {
      final email = _hiveService.getEmail();
      final password = _hiveService.getPassword();
      if (email != null && password != null) {
        await _hiveService.saveCredentials(email, password);
        await _hiveService.setBiometricEnabled(true);
        CommonSnackbar.show(
          context,
          title: "Success",
          message: "Biometric login enabled!",
          isError: false,
        );
        setState(() {}); // Refresh UI to show biometric button
      } else {
        CommonSnackbar.show(
          context,
          title: "Error",
          message: "No credentials found. Please login with password first.",
          isError: true,
        );
      }
    } else {
      CommonSnackbar.show(
        context,
        title: "Error",
        message: "Authentication failed. Try again or use password.",
        isError: true,
      );
    }
  }

  Future<void> _promptEnableBiometrics(String email, String password) async {
    final enable = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enable Biometric Login?'),
        content: Text(
          'Would you like to enable fingerprint/face login for future logins? You can set up your fingerprint/face in your device settings if you haven\'t already.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );
    if (enable == true) {
      // Require fingerprint scan now
      final authenticated = await _biometricHelper.authenticateWithBiometrics();
      if (authenticated) {
        await _hiveService.saveCredentials(email, password);
        await _hiveService.setBiometricEnabled(true);
        CommonSnackbar.show(
          context,
          title: "Success",
          message: "Biometric login enabled!",
          isError: false,
        );
        setState(() {}); // Refresh UI to show biometric button
      } else {
        CommonSnackbar.show(
          context,
          title: "Error",
          message: "Fingerprint/Face scan failed. Biometric login not enabled.",
          isError: true,
        );
      }
    }
  }

  Future<void> _showSetupBiometricDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Up Biometric'),
        content: Text(
          'To use fingerprint/face login, please set up biometrics in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show a post-login dialog to enable biometrics (non-blocking)
  void _showPostLoginBiometricPrompt(String email, String password) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.fingerprint, color: SkillWaveAppColors.primary),
            SizedBox(width: 8),
            Text('Enable Biometric Login?'),
          ],
        ),
        content: Text(
          'For faster and more secure logins, enable fingerprint/face login. Would you like to set this up now?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Maybe Later'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SkillWaveAppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              final canCheck = await _biometricHelper.canCheckBiometrics();
              if (!canCheck) {
                await _showSetupBiometricDialog();
                return;
              }
              final authenticated = await _biometricHelper
                  .authenticateWithBiometrics();
              if (authenticated) {
                await _hiveService.saveCredentials(email, password);
                await _hiveService.setBiometricEnabled(true);
                CommonSnackbar.show(
                  context,
                  title: "Success",
                  message: "Biometric login enabled!",
                  isError: false,
                );
                setState(() {});
              } else {
                CommonSnackbar.show(
                  context,
                  title: "Error",
                  message:
                      "Fingerprint/Face scan failed. Biometric login not enabled.",
                  isError: true,
                );
              }
            },
            child: Text('Enable'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthLoading) {
          } else if (state is LoginSuccess) {
            final email = _emailController.text.trim();
            final password = _passwordController.text.trim();
            if (email.isNotEmpty && password.isNotEmpty) {
              await _hiveService.saveCredentials(email, password);
            }
            final canCheck = await _biometricHelper.canCheckBiometrics();
            final isEnabled = _hiveService.isBiometricEnabled();
            if (!canCheck && !isEnabled) {
              await _showSetupBiometricDialog();
            }
            CommonSnackbar.show(
              context,
              title: "Success",
              message: "Login successfull",
              isError: false,
            );
            context.replaceRoute(const HomeRoute());
            // After navigating, show the biometric enable prompt (non-blocking)
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!_hiveService.isBiometricEnabled()) {
                _showPostLoginBiometricPrompt(email, password);
              }
            });
          } else if (state is AuthFailure) {
            CommonSnackbar.show(
              context,
              title: "Error",
              message: "Invalid credentials!",
              isError: true,
            );
          }
        },
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: SkillWaveAppColors.primary,
                  expandedHeight: 100,
                  pinned: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(bottom: 20),
                    title: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      children: [
                        LoginForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          biometricHelper: _biometricHelper,
                          hiveService: _hiveService,
                        ),
                        if (!_showBiometric)
                          FutureBuilder<bool>(
                            future: _biometricHelper.canCheckBiometrics(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data == true) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.fingerprint),
                                    label: Text('Login with Fingerprint/Face'),
                                    onPressed: _handleBiometricLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          SkillWaveAppColors.primary,
                                      foregroundColor: Colors.white,
                                      minimumSize: Size(double.infinity, 48),
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}
