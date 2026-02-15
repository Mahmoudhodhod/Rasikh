import 'package:flutter_riverpod/flutter_riverpod.dart';
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
final memorizationTabIndexProvider = StateProvider<int>((ref) => 0);
final reportsTabIndexProvider = StateProvider<int>((ref) => 0);
final resourcesTabIndexProvider = StateProvider<int>((ref) => 0);