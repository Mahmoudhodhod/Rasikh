import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/repository/auth_repository.dart';
final countriesListProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return api.getCountries();
});
