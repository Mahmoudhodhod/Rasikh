import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../l10n/app_localizations.dart';

import '../reports/reports_hub_screen.dart';
import '../memorization_plan/plan_hub_screen.dart';
import '../resources/resources_hub_screen.dart';
import 'dashboard_screen.dart';
import '../../core/widgets/app_drawer.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/navigation/provider.dart';
import '../../features/auth/repository/auth_repository.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const List<Widget> _pages = <Widget>[
    DashboardPage(),
    PlanHubScreen(),
    ReportsHubScreen(),
    ResourcesHubScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final selectedIndex = ref.watch(bottomNavIndexProvider);
    final authState = ref.watch(authStateProvider);
    final isGuest = authState == AuthStatus.guest;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isGuest ? null : const CustomDrawer(),
      body: IndexedStack(index: selectedIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) =>
            ref.read(bottomNavIndexProvider.notifier).state = index,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.home_2),
            label: localizations.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.book_1),
            label: localizations.navMemorization,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.chart_2),
            label: localizations.navPerformance,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/moshaf.svg',
              width: 44,
              height: 44,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/moshaf.svg',
              width: 44,
              height: 44,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
