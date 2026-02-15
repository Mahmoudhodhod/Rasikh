import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_service.dart';
import '../../../core/models/certificate_model.dart';
import '../../auth/repository/auth_repository.dart';

final certificatesRepositoryProvider = Provider(
  (ref) => CertificatesRepository(ref.watch(apiServiceProvider)),
);

final certificatesProvider = FutureProvider.autoDispose<List<CertificateModel>>(
  (ref) async {
    final repo = ref.watch(certificatesRepositoryProvider);
    return repo.getCertificates();
  },
);

class CertificatesRepository {
  final ApiService _apiService;
  final _secureStorage = const FlutterSecureStorage();

  CertificatesRepository(this._apiService);

  Future<List<CertificateModel>> getCertificates() async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("No User ID");

    final data = await _apiService.getCertificates(userId);

    return data.map((e) => CertificateModel.fromJson(e)).toList();
  }
}
