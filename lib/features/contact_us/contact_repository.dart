import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_service.dart';
import '../../core/models/contact_type_model.dart';
import '../auth/repository/auth_repository.dart';
final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ContactRepository(apiService);
});

class ContactRepository {
  final ApiService _apiService;

  ContactRepository(this._apiService);

  Future<List<ContactType>> fetchContactTypes() async {
    try {
      final rawData = await _apiService.getContactTypes();

      // ignore: unnecessary_type_check
      if (rawData is List) {
        return rawData.map((json) => ContactType.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitMessage({
    required String userId,
    required String description,
    required int typeId,
  }) async {
    await _apiService.sendContactMessage(
      userId: userId,
      description: description,
      contactTypeId: typeId,
    );
  }
}
