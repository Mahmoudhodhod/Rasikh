import '../../../core/models/archive_day_model.dart';

class LinkingState {
  final List<ArchiveDayModel> pendingLinks;
  final List<ArchiveDayModel> completedLinks;

  const LinkingState({
    this.pendingLinks = const [],
    this.completedLinks = const [],
  });

  bool get isEmpty => pendingLinks.isEmpty && completedLinks.isEmpty;
}
