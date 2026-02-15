import '../../core/models/user_model.dart';
import '../../core/models/dashboard_stats_model.dart';
import '../../core/models/report_model.dart';
import '../../core/models/memorization_plan_model.dart';
import '../../features/memorization_plan/models/review_state.dart';
import '../../features/memorization_plan/models/linking_state.dart';
import '../../core/models/archive_day_model.dart';

class GuestData {
  static final UserModel userProfile = UserModel(
    userId: "guest",
    email: "guest@rasekh.app",
    firstName: "زائر",
    lastName: "الكريم",
    phoneNumber: "0000000000",
    countryName: "المملكة العربية السعودية",
    currentplanName: "خطة الزائر الافتراضية",
    planId: 0,
  );

  static final DashboardStatsModel dashboardStats = DashboardStatsModel(
    overallProgress: 0.0,
    completedParts: 0,
    totalSavedAyat: 0,
    totalWajah: 0,
    averageDailyMemorization: 0.0,
  );

  static final ReportModel reportData = ReportModel(
    savedVersesCount: 0,
    savedPagesCount: 0,
    savedJuzCount: 0,
    dailyAverage: 0.0,
    totalParts: 0,
    linkedVersesCount: 0,
    reviewedVersesCount: 0,
    completionPercentage: 0.0,
    completedDays: 0,
    performance: 0.0,
  );

  static final MemorizationPlanModel memorizationPlan = MemorizationPlanModel(
    progressId: -1,
    currentRepetition: 2,
    currentListening: 1,
    isWritingCompleted: false,
    isMemorizationCompleted: false,
    isReviewCompleted: false,
    isLinkCompleted: false,
    details: DailyPlanDetails(
      id: -1,
      dayNumber: "1",
      surahStartId: 1,
      verseStartNumber: 1,
      verseEndNumber: 7,
      partNumber: 1,
      planId: 0,
    ),
    fullVerseText:
        "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ۝١ ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ ۝٢ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ۝٣ مَـٰلِكِ يَوْمِ ٱلدِّينِ ۝٤",
    surahName: "الفاتحة",
    startAyah: 1,
    endAyah: 4,
    planName: "خطة الزائر",
  );

  static final ReviewState reviewState = ReviewState(
    pendingReviews: [
      ArchiveDayModel(
        id: -1,
        dayNumber: "1",
        surahStartName: "الناس",
        surahEndName: "الناس",
        verseStartNumber: 1,
        verseEndNumber: 6,

        // Actually looking at the File Path output for ArchiveDayModel:
        // ArchiveDayModel({ required this.id, required this.dayNumber, ... this.surahStartName, ... })
        // It does NOT have 'planId', 'reviewSurahId', etc. as named parameters in the constructor if they are not fields.
        // Wait, the file view showed:
        // final int? reviewSurahId; is NOT in the model I viewed?
        // deeper check of ArchiveDayModel view output:
        // Fields: reviewSurahStartName, reviewSurahEndtName, reviewVerseStartNumber, etc.
        reviewSurahStartName: "الناس",
        reviewSurahEndName:
            "الناس", // reviewSurahEndtName in JSON but reviewSurahEndName in dart field?
        // Checked file: final String? reviewSurahEndName; (line 30)
        reviewVerseStartNumber: 1,
        reviewVerseEndNumber: 6,

        repetitionCount: 0,
        listeningCount: 0,
        writingCompleted: false,
        isCompleted: false,
      ),
    ],
    completedReviews: [],
  );

  static final LinkingState linkingState = LinkingState(
    pendingLinks: [
      ArchiveDayModel(
        id: -1,
        dayNumber: "1",
        surahStartName: "الفلق",
        surahEndName: "الفلق",
        verseStartNumber: 1,
        verseEndNumber: 5,

        linkSurahStartName: "الفلق",
        linkSurahEndName: "الفلق",
        linkVerseStartNumber: 1,
        linkVerseEndNumber: 5,

        repetitionCount: 0,
        listeningCount: 0,
        writingCompleted: false,
        isCompleted: false,
      ),
    ],
    completedLinks: [],
  );
}
