import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/Provider/user.dart';
import 'package:tankio_webpage/Screen/home.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final loginProvider = ref.read(userProvider);
    loginProvider.controllerLoginEmail.text = _userController.text.trim();
    loginProvider.controllerLoginPassword.text = _passwordController.text;

    final success = await loginProvider.loginUser();
    if (!mounted || !success) {
      return;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;
    final cardMaxWidth = isDesktop ? 1240.0 : 760.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF7FAF7), Color(0xFFE9F3E6), Color(0xFFFDFEFE)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -130,
              left: -120,
              child: IgnorePointer(
                child: Container(
                  height: 420,
                  width: 420,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF60AF47).withValues(alpha: 0.17),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 52,
              right: -90,
              child: IgnorePointer(
                child: Container(
                  height: 260,
                  width: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF60AF47).withValues(alpha: 0.10),
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              right: -120,
              child: IgnorePointer(
                child: Container(
                  height: 440,
                  width: 440,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF0F3D52).withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 48,
              child: IgnorePointer(
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0F3D52).withValues(alpha: 0.08),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.70),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A0E1726),
                            blurRadius: 34,
                            offset: Offset(0, 18),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Material(
                          color: const Color(0xFFFFFFFF),
                          child: isDesktop
                              ? IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          padding: const EdgeInsets.all(40),
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFFF7FBF6),
                                                Color(0xFFEFF7EA),
                                                Color(0xFFE6F2E0),
                                              ],
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 6,
                                                right: 6,
                                                child: Container(
                                                  height: 210,
                                                  width: 210,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xFF60AF47,
                                                      ).withValues(alpha: 0.10),
                                                      width: 1.2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 52,
                                                right: 52,
                                                child: Container(
                                                  height: 130,
                                                  width: 130,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xFF60AF47,
                                                      ).withValues(alpha: 0.08),
                                                      width: 1.2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 20,
                                                left: 0,
                                                child: Container(
                                                  height: 180,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: const Color(
                                                      0xFF60AF47,
                                                    ).withValues(alpha: 0.08),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            60,
                                                          ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Color(
                                                            0x1660AF47,
                                                          ),
                                                          blurRadius: 18,
                                                          offset: Offset(0, 8),
                                                        ),
                                                      ],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Image.asset(
                                                      'assets/logo-tankio-bg-removed.png',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 28),
                                                  const Text(
                                                    'Tankio',
                                                    style: TextStyle(
                                                      color: Color(0xFF0F3D52),
                                                      fontSize: 42,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      height: 1.0,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  const Text(
                                                    'Panel web administrativo',
                                                    style: TextStyle(
                                                      color: Color(0xFF5C7567),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 28),
                                                  const SizedBox(
                                                    width: 420,
                                                    child: Text(
                                                      'Acceso limpio, moderno y enfocado en escritorio para trabajar con tus procesos de forma rapida y organizada.',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF425465,
                                                        ),
                                                        fontSize: 18,
                                                        height: 1.55,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 30),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 14,
                                                              vertical: 10,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.82,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                999,
                                                              ),
                                                          border: Border.all(
                                                            color: const Color(
                                                              0xFFE3ECDC,
                                                            ),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Secure access',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF45605A,
                                                            ),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 14,
                                                              vertical: 10,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              const Color(
                                                                0xFF60AF47,
                                                              ).withValues(
                                                                alpha: 0.12,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                999,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          'Dashboard ready',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF2F6E2D,
                                                            ),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 34,
                                            vertical: 38,
                                          ),
                                          color: Colors.white,
                                          child: Center(
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                maxWidth: 420,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Welcome back',
                                                    style: TextStyle(
                                                      color: Color(0xFF0F172A),
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      height: 1.1,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    'Ingresa con tu usuario y contrasena para continuar.',
                                                    style: TextStyle(
                                                      color: Color(0xFF64748B),
                                                      fontSize: 14,
                                                      height: 1.5,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 28),
                                                  Form(
                                                    key: _formKey,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        const Text(
                                                          'Usuario',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF334155,
                                                            ),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              _userController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .emailAddress,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration: InputDecoration(
                                                            hintText:
                                                                'usuario@tankio.com',
                                                            prefixIcon: const Icon(
                                                              Icons
                                                                  .person_outline_rounded,
                                                              size: 20,
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                const Color(
                                                                  0xFFF8FAF7,
                                                                ),
                                                            contentPadding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      18,
                                                                  vertical: 18,
                                                                ),
                                                            border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    60,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFFDDE7DB,
                                                                    ),
                                                                  ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    60,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFFDDE7DB,
                                                                    ),
                                                                  ),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    60,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFF60AF47,
                                                                    ),
                                                                    width: 1.6,
                                                                  ),
                                                            ),
                                                          ),
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value
                                                                    .trim()
                                                                    .isEmpty) {
                                                              return 'Ingresa tu usuario';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          height: 18,
                                                        ),
                                                        const Text(
                                                          'Contrasena',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF334155,
                                                            ),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              _passwordController,
                                                          obscureText:
                                                              _obscurePassword,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          onFieldSubmitted:
                                                              (_) async {
                                                                await _submitLogin();
                                                              },
                                                          decoration: InputDecoration(
                                                            hintText:
                                                                'Ingresa tu contrasena',
                                                            prefixIcon: const Icon(
                                                              Icons
                                                                  .lock_outline_rounded,
                                                              size: 20,
                                                            ),
                                                            suffixIcon: IconButton(
                                                              splashRadius: 18,
                                                              onPressed: () {
                                                                setState(() {
                                                                  _obscurePassword =
                                                                      !_obscurePassword;
                                                                });
                                                              },
                                                              icon: Icon(
                                                                _obscurePassword
                                                                    ? Icons
                                                                          .visibility_rounded
                                                                    : Icons
                                                                          .visibility_off_rounded,
                                                                size: 20,
                                                              ),
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                const Color(
                                                                  0xFFF8FAF7,
                                                                ),
                                                            contentPadding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      18,
                                                                  vertical: 18,
                                                                ),
                                                            border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    60,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFFDDE7DB,
                                                                    ),
                                                                  ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    60,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFFDDE7DB,
                                                                    ),
                                                                  ),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    60,
                                                                  ),
                                                              borderSide:
                                                                  const BorderSide(
                                                                    color: Color(
                                                                      0xFF60AF47,
                                                                    ),
                                                                    width: 1.6,
                                                                  ),
                                                            ),
                                                          ),
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Ingresa tu contrasena';
                                                            }
                                                            if (value.length <
                                                                6) {
                                                              return 'La contrasena debe tener al menos 6 caracteres';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          height: 14,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Checkbox(
                                                              value:
                                                                  _rememberMe,
                                                              activeColor:
                                                                  const Color(
                                                                    0xFF60AF47,
                                                                  ),
                                                              side: const BorderSide(
                                                                color: Color(
                                                                  0xFFC8D5C2,
                                                                ),
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      5,
                                                                    ),
                                                              ),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  _rememberMe =
                                                                      value ??
                                                                      false;
                                                                });
                                                              },
                                                            ),
                                                            const Text(
                                                              'Recordarme',
                                                              style: TextStyle(
                                                                color: Color(
                                                                  0xFF334155,
                                                                ),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            TextButton(
                                                              onPressed: () {},
                                                              child: const Text(
                                                                'Olvidaste tu contrasena?',
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF60AF47,
                                                                  ),
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          height: 56,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                    0xFF60AF47,
                                                                  ),
                                                              foregroundColor:
                                                                  Colors.white,
                                                              elevation: 0,
                                                              shadowColor: Colors
                                                                  .transparent,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      60,
                                                                    ),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                _submitLogin,
                                                            child: const Text(
                                                              'Ingresar',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 5,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: const Color(
                                                              0xFFF7FAF4,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  60,
                                                                ),
                                                            border: Border.all(
                                                              color:
                                                                  const Color(
                                                                    0xFFE2EAD9,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .shield_outlined,
                                                                size: 18,
                                                                color: Color(
                                                                  0xFF60AF47,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  'Acceso seguro para administradores y operadores.',
                                                                  style: TextStyle(
                                                                    color: Color(
                                                                      0xFF51606C,
                                                                    ),
                                                                    fontSize:
                                                                        13,
                                                                    height:
                                                                        1.45,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(22),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFFF7FBF6),
                                              Color(0xFFEFF7EA),
                                              Color(0xFFE6F2E0),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.75,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 58,
                                              width: 58,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0x1660AF47),
                                                    blurRadius: 16,
                                                    offset: Offset(0, 8),
                                                  ),
                                                ],
                                              ),
                                              padding: const EdgeInsets.all(9),
                                              child: Image.asset(
                                                'assets/logo-tankio-bg-removed.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(height: 22),
                                            const Text(
                                              'Tankio',
                                              style: TextStyle(
                                                color: Color(0xFF0F3D52),
                                                fontSize: 34,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Panel web administrativo',
                                              style: TextStyle(
                                                color: Color(0xFF5C7567),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE7EEE3),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x120E1726),
                                              blurRadius: 26,
                                              offset: Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Welcome back',
                                                style: TextStyle(
                                                  color: Color(0xFF0F172A),
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                'Ingresa con tu usuario y contrasena para continuar.',
                                                style: TextStyle(
                                                  color: Color(0xFF64748B),
                                                  fontSize: 14,
                                                  height: 1.5,
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                              const Text(
                                                'Usuario',
                                                style: TextStyle(
                                                  color: Color(0xFF334155),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              TextFormField(
                                                controller: _userController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'usuario@tankio.com',
                                                  prefixIcon: const Icon(
                                                    Icons
                                                        .person_outline_rounded,
                                                    size: 20,
                                                  ),
                                                  filled: true,
                                                  fillColor: const Color(
                                                    0xFFF8FAF7,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 18,
                                                        vertical: 18,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                          color: Color(
                                                            0xFFDDE7DB,
                                                          ),
                                                        ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFFDDE7DB,
                                                              ),
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFF60AF47,
                                                              ),
                                                              width: 1.6,
                                                            ),
                                                      ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return 'Ingresa tu usuario';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'Contrasena',
                                                style: TextStyle(
                                                  color: Color(0xFF334155),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              TextFormField(
                                                controller: _passwordController,
                                                obscureText: _obscurePassword,
                                                textInputAction:
                                                    TextInputAction.done,
                                                onFieldSubmitted: (_) async {
                                                  await _submitLogin();
                                                },
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Ingresa tu contrasena',
                                                  prefixIcon: const Icon(
                                                    Icons.lock_outline_rounded,
                                                    size: 20,
                                                  ),
                                                  suffixIcon: IconButton(
                                                    splashRadius: 18,
                                                    onPressed: () {
                                                      setState(() {
                                                        _obscurePassword =
                                                            !_obscurePassword;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      _obscurePassword
                                                          ? Icons
                                                                .visibility_rounded
                                                          : Icons
                                                                .visibility_off_rounded,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: const Color(
                                                    0xFFF8FAF7,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 18,
                                                        vertical: 18,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    borderSide:
                                                        const BorderSide(
                                                          color: Color(
                                                            0xFFDDE7DB,
                                                          ),
                                                        ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFFDDE7DB,
                                                              ),
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Color(
                                                                0xFF60AF47,
                                                              ),
                                                              width: 1.6,
                                                            ),
                                                      ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Ingresa tu contrasena';
                                                  }
                                                  if (value.length < 6) {
                                                    return 'La contrasena debe tener al menos 6 caracteres';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: _rememberMe,
                                                    activeColor: const Color(
                                                      0xFF60AF47,
                                                    ),
                                                    side: const BorderSide(
                                                      color: Color(0xFFC8D5C2),
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _rememberMe =
                                                            value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  const Text(
                                                    'Recordarme',
                                                    style: TextStyle(
                                                      color: Color(0xFF334155),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  TextButton(
                                                    onPressed: () {},
                                                    child: const Text(
                                                      'Olvidaste tu contrasena?',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF60AF47,
                                                        ),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                width: double.infinity,
                                                height: 56,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF60AF47),
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    shadowColor:
                                                        Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            60,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: _submitLogin,
                                                  child: const Text(
                                                    'Ingresar',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 14,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFF7FAF4,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFE2EAD9,
                                                    ),
                                                  ),
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.shield_outlined,
                                                      size: 18,
                                                      color: Color(0xFF60AF47),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        'Acceso seguro para administradores y operadores.',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF51606C,
                                                          ),
                                                          fontSize: 13,
                                                          height: 1.45,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                      ),
                    ),
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
