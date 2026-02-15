import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tafsir_search_screen.dart';
import 'tajweed_rules_screen.dart';
import '../../features/auth/repository/auth_repository.dart';

import '../../l10n/app_localizations.dart';
import '../../core/widgets/rasikh_app_bar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_drawer.dart';
import 'quran/quran_index_screen.dart';

final resourcesTabIndexProvider = StateProvider<int>((ref) => 0);

class ResourcesHubScreen extends ConsumerStatefulWidget {
  const ResourcesHubScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ResourcesHubScreen> createState() => _ResourcesHubScreenState();
}

class _ResourcesHubScreenState extends ConsumerState<ResourcesHubScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    final initialIndex = ref.read(resourcesTabIndexProvider);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(resourcesTabIndexProvider.notifier).state =
            _tabController.index;
      }
    });

    ref.listenManual<int>(resourcesTabIndexProvider, (previous, next) {
      if (_tabController.index != next) {
        _tabController.animateTo(next);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final idx = ref.read(resourcesTabIndexProvider);
      if (mounted && _tabController.index != idx) {
        _tabController.animateTo(
          idx,
          duration: const Duration(milliseconds: 1),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final currentIndex = ref.watch(resourcesTabIndexProvider);
    final authState = ref.watch(authStateProvider);
    final isGuest = authState == AuthStatus.guest;

    return Scaffold(
      appBar: const RasekhAppBar(showLogo: true),
      drawer: isGuest ? null : const CustomDrawer(),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TabBar(
              controller: _tabController,
              onTap: (i) =>
                  ref.read(resourcesTabIndexProvider.notifier).state = i,

              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              tabAlignment: TabAlignment.center,

              labelColor: TColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: TColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Tajawal',
              ),
              tabs: [
                _AnimatedCheckedTab(
                  label: l10n.mushafTab,
                  isActive: currentIndex == 0,
                ),
                _AnimatedCheckedTab(
                  label: l10n.tafsirAndTadabburTab,
                  isActive: currentIndex == 1,
                ),
                _AnimatedCheckedTab(
                  label: l10n.tajweedTab,
                  isActive: currentIndex == 2,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                QuranIndexScreen(),
                TafsirSearchScreen(),
                TajweedRulesScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCheckedTab extends StatelessWidget {
  final String label;
  final bool isActive;

  const _AnimatedCheckedTab({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: isActive
                    ? const Icon(
                        Icons.check_circle,
                        key: ValueKey('active'),
                        size: 16,
                        color: TColors.primary,
                      )
                    : const SizedBox(
                        key: ValueKey('inactive'),
                        width: 16,
                        height: 16,
                      ),
              ),
              const SizedBox(width: 4),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
