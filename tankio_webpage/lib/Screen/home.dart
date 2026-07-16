import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/Page/balances.dart';
import 'package:tankio_webpage/Page/users_app.dart';
import 'package:tankio_webpage/Page/groups.dart';
import 'package:tankio_webpage/Page/payment.dart';
import 'package:tankio_webpage/Page/users.dart';
import 'package:tankio_webpage/Provider/user.dart';
import 'package:tankio_webpage/Screen/login.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  String title = "Dashboard";

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1100;
    final sidebarWidth = size.width < 1300 ? 300.0 : 320.0;
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF6FAF6), Color(0xFFEAF3E5), Color(0xFFFDFEFE)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -120,
              child: IgnorePointer(
                child: Container(
                  height: 360,
                  width: 360,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF60AF47).withValues(alpha: 0.14),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 70,
              right: -110,
              child: IgnorePointer(
                child: Container(
                  height: 280,
                  width: 280,
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
              right: -140,
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: sidebarWidth,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                20,
                                20,
                                16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.88),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE2EAD9),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 28,
                                    color: Color(0x1F0E1726),
                                    offset: Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF60AF47),
                                                Color(0xFF9AD46E),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              60,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 16,
                                                color: Color(0x3360AF47),
                                                offset: Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            'assets/logo-tankio-bg-removed.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'TANKIO',
                                              style: TextStyle(
                                                color: Color(0xFF0F172A),
                                                fontSize: 22,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1.1,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Andres Rincon',
                                              style: TextStyle(
                                                color: Color(0xFF0F172A),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Administrador',
                                              style: TextStyle(
                                                color: Color(0xFF64748B),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 60),

                                    Text(
                                      'NAVEGACION',
                                      style: TextStyle(
                                        color: const Color(0xFF94A3B8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: user.navItemsActive.length,
                                      separatorBuilder: (_, _) =>
                                          const SizedBox(height: 10),
                                      itemBuilder: (context, index) {
                                        final item = user.navItemsActive[index];
                                        final selected =
                                            index == _selectedIndex;
                                        return Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _selectedIndex = index;
                                                title = item.title;
                                              });
                                              _pageController.animateToPage(
                                                index,
                                                duration: const Duration(
                                                  milliseconds: 250,
                                                ),
                                                curve: Curves.easeOutCubic,
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 180,
                                              ),
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: selected
                                                    ? const Color(0xFF60AF47)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: selected
                                                      ? const Color(0xFF60AF47)
                                                      : const Color(0xFFE7EEE3),
                                                ),
                                                boxShadow: selected
                                                    ? const [
                                                        BoxShadow(
                                                          color: Color(
                                                            0x2260AF47,
                                                          ),
                                                          blurRadius: 14,
                                                          offset: Offset(0, 6),
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 42,
                                                    width: 42,
                                                    decoration: BoxDecoration(
                                                      color: selected
                                                          ? Colors.white
                                                                .withValues(
                                                                  alpha: 0.18,
                                                                )
                                                          : const Color(
                                                              0xFFF2F6F2,
                                                            ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            60,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      item.icon,
                                                      color: selected
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF64748B,
                                                            ),
                                                      size: 22,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item.title,
                                                          style: TextStyle(
                                                            color: selected
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF0F172A,
                                                                  ),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          item.subtitle,
                                                          style: TextStyle(
                                                            color: selected
                                                                ? const Color(
                                                                    0xFFE4F5DE,
                                                                  )
                                                                : const Color(
                                                                    0xFF64748B,
                                                                  ),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.chevron_right_rounded,
                                                    color: selected
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF94A3B8,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (_) => const LoginPage(),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xFF0F172A,
                                          ),
                                          backgroundColor: const Color(
                                            0xFFF7FAF4,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFFE2EAD9),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.logout_rounded,
                                          size: 20,
                                        ),
                                        label: const Text(
                                          'Salir',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.96),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE8EEE5),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 22,
                                    color: Color(0x0C0E1726),
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        24,
                                        20,
                                        24,
                                        16,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 5,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF60AF47),
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: const TextStyle(
                                                  color: Color(0xFF0F172A),
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w900,
                                                  height: 1.0,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                'Interfaz limpia, profesional y pensada para escritorio.',
                                                style: TextStyle(
                                                  color: Color(0xFF64748B),
                                                  fontSize: 14,
                                                  height: 1.45,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xFFE8EEE5),
                                    ),
                                    Expanded(
                                      child: PageView(
                                        controller: _pageController,
                                        onPageChanged: (value) {
                                          setState(() {
                                            _selectedIndex = value;
                                          });
                                        },
                                        children: [
                                          _buildDashboardPage(),
                                          GroupsPage(),
                                          UsersPage(),
                                          UserAppPage(),
                                          BalancePage(),
                                          PaymentsPage(),
                                          Container(color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.88),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2EAD9),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 28,
                                  color: Color(0x1F0E1726),
                                  offset: Offset(0, 12),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF60AF47),
                                              Color(0xFF9AD46E),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 16,
                                              color: Color(0x3360AF47),
                                              offset: Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset(
                                          'assets/logo-tankio-bg-removed.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'TANKIO',
                                            style: TextStyle(
                                              color: Color(0xFF0F172A),
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Admin Web Panel',
                                            style: TextStyle(
                                              color: Color(0xFF64748B),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7FAF4),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFE2EAD9),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF60AF47),
                                                Color(0xFF2A9D8F),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              60,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.person_rounded,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Andres Rincon',
                                                style: TextStyle(
                                                  color: Color(0xFF0F172A),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Administrador',
                                                style: TextStyle(
                                                  color: Color(0xFF64748B),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    'NAVEGACION',
                                    style: TextStyle(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: user.navItemsActive.length,
                                    separatorBuilder: (_, _) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      final item = user.navItemsActive[index];
                                      final selected = index == _selectedIndex;
                                      return Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedIndex = index;
                                            });
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(
                                                milliseconds: 250,
                                              ),
                                              curve: Curves.easeOutCubic,
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 180,
                                            ),
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: selected
                                                  ? const Color(0xFF60AF47)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: selected
                                                    ? const Color(0xFF60AF47)
                                                    : const Color(0xFFE7EEE3),
                                              ),
                                              boxShadow: selected
                                                  ? const [
                                                      BoxShadow(
                                                        color: Color(
                                                          0x2260AF47,
                                                        ),
                                                        blurRadius: 14,
                                                        offset: Offset(0, 6),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 42,
                                                  width: 42,
                                                  decoration: BoxDecoration(
                                                    color: selected
                                                        ? Colors.white
                                                              .withValues(
                                                                alpha: 0.18,
                                                              )
                                                        : const Color(
                                                            0xFFF2F6F2,
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          60,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    item.icon,
                                                    color: selected
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF64748B,
                                                          ),
                                                    size: 22,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style: TextStyle(
                                                          color: selected
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xFF0F172A,
                                                                ),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        item.subtitle,
                                                        style: TextStyle(
                                                          color: selected
                                                              ? const Color(
                                                                  0xFFE4F5DE,
                                                                )
                                                              : const Color(
                                                                  0xFF64748B,
                                                                ),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right_rounded,
                                                  color: selected
                                                      ? Colors.white
                                                      : const Color(0xFF94A3B8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (_) => const LoginPage(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(
                                          0xFF0F172A,
                                        ),
                                        backgroundColor: const Color(
                                          0xFFF7FAF4,
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFFE2EAD9),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.logout_rounded,
                                        size: 20,
                                      ),
                                      label: const Text(
                                        'Salir',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 760,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.96),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE8EEE5),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 22,
                                    color: Color(0x0C0E1726),
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        24,
                                        20,
                                        24,
                                        16,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 5,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF60AF47),
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "current.title",
                                                style: const TextStyle(
                                                  color: Color(0xFF0F172A),
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w900,
                                                  height: 1.0,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                'Interfaz limpia, profesional y pensada para escritorio.',
                                                style: TextStyle(
                                                  color: Color(0xFF64748B),
                                                  fontSize: 14,
                                                  height: 1.45,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF7FAF4),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: const Color(0xFFE2EAD9),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Icon(
                                                  Icons.circle,
                                                  size: 10,
                                                  color: Color(0xFF60AF47),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Sistema activo',
                                                  style: TextStyle(
                                                    color: Color(0xFF355C31),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xFFE8EEE5),
                                    ),
                                    Expanded(
                                      child: PageView(
                                        controller: _pageController,
                                        onPageChanged: (value) {
                                          setState(() {
                                            _selectedIndex = value;
                                          });
                                        },
                                        children: [
                                          _buildDashboardPage(),
                                          GroupsPage(),
                                          UsersPage(),
                                          UserAppPage(),
                                          BalancePage(),
                                          PaymentsPage(),
                                          Container(color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF7FBF7),
                  Color(0xFFEFF7EA),
                  Color(0xFFF9FCF8),
                ],
              ),
              border: Border.all(color: const Color(0xFFE2EAD9)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2EAD9)),
                        ),
                        child: const Text(
                          'Dashboard principal',
                          style: TextStyle(
                            color: Color(0xFF355C31),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Control limpio y rapido de la operacion',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        width: 560,
                        child: Text(
                          'Una vista de escritorio sencilla pero profesional para revisar actividad, accesos y estado general de la plataforma.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            height: 1.55,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: const [
                          _MiniChip(label: 'Operando hoy'),
                          _MiniChip(label: 'Panel web'),
                          _MiniChip(label: 'Estilo limpio'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 210,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2EAD9)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C0E1726),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estado general',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9F2E6),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.82,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF60AF47),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        '82%',
                        style: TextStyle(
                          color: Color(0xFF60AF47),
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Rendimiento estable',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              _StatCard(
                title: 'Usuarios activos',
                value: '128',
                subtitle: '+12 this month',
                icon: Icons.people_alt_rounded,
                accent: Color(0xFF60AF47),
              ),
              _StatCard(
                title: 'Pagos hoy',
                value: '24',
                subtitle: 'Movimientos recientes',
                icon: Icons.receipt_long_rounded,
                accent: Color(0xFF0F3D52),
              ),
              _StatCard(
                title: 'Grupos',
                value: '08',
                subtitle: 'Operando correctamente',
                icon: Icons.ev_station_rounded,
                accent: Color(0xFF2A9D8F),
              ),
              _StatCard(
                title: 'Reportes',
                value: '96%',
                subtitle: 'Ejecucion estable',
                icon: Icons.bar_chart_rounded,
                accent: Color(0xFF6BA84F),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE7EEE3)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F0E1726),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumen del dia',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 260,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFF8FCF7),
                              Color(0xFFEFF7E9),
                              Color(0xFFF4FAF2),
                            ],
                          ),
                          border: Border.all(color: const Color(0xFFE2EAD9)),
                        ),
                        child: const Center(
                          child: Text(
                            'Dashboard area',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2EAD9)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C0E1726),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Actividad reciente',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _activityItem(
                        icon: Icons.person_add_alt_1_rounded,
                        title: 'Nuevo usuario registrado',
                        subtitle: 'Hace 12 minutos',
                        trailing: '+1',
                      ),
                      const SizedBox(height: 10),
                      _activityItem(
                        icon: Icons.shopping_bag_rounded,
                        title: 'Pago confirmado',
                        subtitle: 'Hace 24 minutos',
                        trailing: '\$124.50',
                      ),
                      const SizedBox(height: 10),
                      _activityItem(
                        icon: Icons.settings_rounded,
                        title: 'Ajustes actualizados',
                        subtitle: 'Hoy 09:30 AM',
                        trailing: 'OK',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBF8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7EEE3)),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF60AF47).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF60AF47), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              color: Color(0xFF355C31),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EEE3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0E1726),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAF4),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Text(
                  'Live',
                  style: TextStyle(
                    color: Color(0xFF355C31),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;

  const _MiniChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2EAD9)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF355C31),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
