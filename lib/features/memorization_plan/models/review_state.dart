import '../../../core/models/archive_day_model.dart';

class ReviewState {
  final List<ArchiveDayModel> pendingReviews;
  final List<ArchiveDayModel> completedReviews;

  const ReviewState({
    this.pendingReviews = const [],
    this.completedReviews = const [],
  });

  bool get isEmpty => pendingReviews.isEmpty && completedReviews.isEmpty;
}
