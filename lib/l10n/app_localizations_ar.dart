// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'راسخ';

  @override
  String get home => 'الرئيسة';

  @override
  String get homeWelcome => 'مرحبًا بك في تطبيق راسخ';

  @override
  String get goTosettings => 'اذهب إلى الإعدادات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get welcomeMessage => 'مرحبًا بك 👋';

  @override
  String get homePage => 'الصفحة الرئيسة';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get appVersion => 'إصدار 1.0.0';

  @override
  String get language => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get resourcesHubTitle => 'المصادر';

  @override
  String get tafsirAndTadabburTab => 'تفسير وتدبر';

  @override
  String get tajweedTab => 'التجويد';

  @override
  String tafsirDetailTitle(int verseNumber, String surahName) {
    return 'تفسير الآية $verseNumber من سورة $surahName';
  }

  @override
  String get tafsirLabel => 'التفسير:';

  @override
  String get searchBySurahNameHint => 'بحث باسم السورة';

  @override
  String get searchByVerseNumberHint => 'بحث برقم الآية';

  @override
  String surahNameLabel(String surahName) {
    return 'سورة $surahName';
  }

  @override
  String verseNumberLabel(int verseNumber) {
    return 'آية $verseNumber';
  }

  @override
  String get viewTafsirButton => 'عرض التفسير';

  @override
  String get example => '\'أمثلة:\'';

  @override
  String get certificateScreenTitle => 'شهادة تقدير';

  @override
  String get downloadAsPdfButton => 'تحميل بصيغة PDF';

  @override
  String certificateTitle(String courseName) {
    return 'شهادة تقدير حفظ $courseName';
  }

  @override
  String get certificatePresentedTo => 'هذه الشهادة مقدمة لـ:';

  @override
  String get certificateBlessing => 'بارك الله فيك وجعل حفظك للقرآن نورًا لك في الدنيا والآخرة.';

  @override
  String get signatureLabel => '___________________ التوقيع';

  @override
  String certificateCompletionTitle(int partNumber) {
    return 'شهادة إتمام الجزء $partNumber';
  }

  @override
  String certificateIssueDate(String date) {
    return 'تاريخ الإصدار: $date';
  }

  @override
  String get noCertificatesFound => 'لا يوجد شهادات';

  @override
  String get performanceTrackingTitle => 'متابعة الأداء';

  @override
  String get reportsTab => 'التقارير';

  @override
  String get certificatesTab => 'الشهادات';

  @override
  String get prophetSaidLabel => 'قال رسول الله ﷺ:';

  @override
  String get memorizationReportTitle => 'تقرير الحفظ';

  @override
  String get savedVersesStatTitle => 'عدد الآيات المحفوظة';

  @override
  String get savedVersesStatUnit => 'آية';

  @override
  String get savedPagesStatTitle => 'عدد الأوجه المحفوظة';

  @override
  String get savedPagesStatUnit => 'وجه';

  @override
  String get savedJuzStatTitle => 'عدد الأجزاء المحفوظة';

  @override
  String get savedJuzStatUnit => 'جزء';

  @override
  String get dailyAverageStatTitle => 'المتوسط اليومي للحفظ';

  @override
  String get dailyAverageStatUnit => 'آيات';

  @override
  String get profileScreenTitle => 'الملف الشخصي';

  @override
  String get personalInformationTitle => 'المعلومات الشخصية';

  @override
  String get addressInformationTitle => 'معلومات العنوان';

  @override
  String get editButton => 'تعديل';

  @override
  String get firstNameLabel => 'الاسم الأول ';

  @override
  String get middleNameLabel => 'الاسم الأوسط ';

  @override
  String get lastNameLabel => 'الاسم الأخير ';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get phoneLabel => 'رقم الهاتف ';

  @override
  String get passwordLabel => 'كلمة السر ';

  @override
  String get logoutButton => 'تسجيل الخروج';

  @override
  String profileLoadError(String error) {
    return 'فشل تحميل الملف الشخصي: $error';
  }

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String get editProfileDialogTitle => 'تعديل المعلومات الشخصية';

  @override
  String get firstNameFormFieldLabel => 'الاسم الأول';

  @override
  String get middleNameFormFieldLabel => 'الاسم الأوسط';

  @override
  String get lastNameFormFieldLabel => 'الاسم الأخير';

  @override
  String get emailFormFieldLabel => 'البريد الإلكتروني';

  @override
  String get phoneFormFieldLabel => 'رقم الجوال';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get saveButton => 'حفظ';

  @override
  String get validationEmptyFirstName => 'الرجاء إدخال الاسم الأول';

  @override
  String get validationInvalidNameFormat => 'الاسم يجب أن يحتوي على حروف فقط';

  @override
  String get validationEmptyMiddleName => 'الرجاء إدخال الاسم الأوسط';

  @override
  String get validationEmptyLastName => 'الرجاء إدخال الاسم الأخير';

  @override
  String get validationEmptyEmail => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get validationInvalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get invalidPhoneNumber => 'رقم الجوال غير صالح';

  @override
  String get changePasswordDialogTitle => 'تغيير كلمة المرور';

  @override
  String get oldPasswordFormFieldLabel => 'كلمة المرور القديمة';

  @override
  String get newPasswordFormFieldLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPasswordFormFieldLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get validationEmptyOldPassword => 'الرجاء إدخال كلمة المرور القديمة';

  @override
  String get validationEmptyNewPassword => 'الرجاء إدخال كلمة المرور الجديدة';

  @override
  String get validationPasswordTooShort => 'كلمة المرور قصيرة';

  @override
  String get validationPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get editAddressDialogTitle => 'تعديل العنوان';

  @override
  String get countryFormFieldLabel => 'البلد';

  @override
  String get cityFormFieldLabel => 'المدينة';

  @override
  String get addressDetailsFormFieldLabel => 'العنوان بالتفاصيل';

  @override
  String get validationEmptyCountry => 'الرجاء إدخال البلد';

  @override
  String get validationEmptyCity => 'الرجاء إدخال المدينة';

  @override
  String get validationEmptyAddressDetails => 'الرجاء إدخال التفاصيل';

  @override
  String get profileUpdateSuccess => 'تم تحديث المعلومات بنجاح';

  @override
  String profileUpdateFailed(String error) {
    return 'فشل التحديث: $error';
  }

  @override
  String get passwordUpdateSuccess => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get oldPasswordIncorrect => 'كلمة المرور القديمة غير صحيحة';

  @override
  String get addressUpdateSuccess => 'تم تحديث العنوان بنجاح';

  @override
  String get apiConnectionTimeout => 'انتهت مهلة الاتصال بالخادم.';

  @override
  String get apiBadRequest => 'طلب غير صالح. يرجى مراجعة البيانات المدخلة.';

  @override
  String get apiUnauthorized => 'بيانات الدخول غير صحيحة.';

  @override
  String get apiNotFound => 'لم يتم العثور على المورد المطلوب.';

  @override
  String get apiPhoneNumberExists => 'رقم الهاتف مستخدم بالفعل.';

  @override
  String get apiServerError => 'حدث خطأ في الخادم، يرجى المحاولة لاحقًا.';

  @override
  String apiUnexpectedErrorWithCode(String statusCode) {
    return 'حدث خطأ غير متوقع: $statusCode';
  }

  @override
  String get apiRequestCancelled => 'تم إلغاء الطلب.';

  @override
  String get apiNoInternetConnection => 'لا يوجد اتصال بالإنترنت.';

  @override
  String get apiUnknownError => 'حدث خطأ غير معروف.';

  @override
  String get apiUnexpectedError => 'حدث خطأ غير متوقع, يرجى المحاولة مرة أخرى.';

  @override
  String get apiOldPasswordIncorrect => 'كلمة المرور القديمة غير صحيحة.';

  @override
  String get welcomeBack => 'مرحبًا بعودتك 👋';

  @override
  String get loginPrompt => 'الرجاء إدخال البريد الإلكتروني وكلمة المرور لتسجيل الدخول';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get validationEnterPhoneNumber => 'الرجاء إدخال رقم الهاتف';

  @override
  String get validationEnterPassword => 'الرجاء إدخال كلمة المرور';

  @override
  String get forgotPasswordButton => 'نسيت كلمة المرور؟';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get createAccountButton => 'إنشاء حساب';

  @override
  String get registerTitle => 'إنشاء حساب جديد';

  @override
  String get stepBasicInfo => 'البيانات الأساسية';

  @override
  String get stepDetails => 'التفاصيل';

  @override
  String get registerWelcome => 'أهلاً بك 👋';

  @override
  String get registerWelcomeSub => 'لنبدأ ببعض المعلومات الأساسية لإنشاء ملفك الشخصي.';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get ageLabel => 'العمر';

  @override
  String get nextButton => 'التالي';

  @override
  String get step2Title => 'خطوة أخيرة! 🚀';

  @override
  String get step2Sub => 'ساعدنا في تخصيص تجربتك من خلال هذه التفاصيل.';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get validationCountryRequired => 'الدولة مطلوبة';

  @override
  String get planSelectionTitle => 'كيف تفضل أن تحفظ؟';

  @override
  String get planSelfPaced => 'حفظ ذاتي';

  @override
  String get planSelfPacedSub => 'أحفظ بمفردي وأراجع متى شئت';

  @override
  String get planGroup => 'حلقة تحفيظ';

  @override
  String get planGroupSub => 'الانضمام لمجموعة تشجيعية';

  @override
  String get planTutor => 'معلم خاص (عن بعد)';

  @override
  String get planTutorSub => 'متابعة دقيقة مع معلم';

  @override
  String get validationPlanRequired => 'الرجاء اختيار خطة الحفظ';

  @override
  String get registerSuccess => 'تم إنشاء الحساب بنجاح!';

  @override
  String get createAccountAction => 'إنشاء الحساب';

  @override
  String get loginOptionsTitle => 'دعنا نتعمق في حسابك';

  @override
  String get loginWithGoogle => 'تسجيل الدخول عبر جوجل';

  @override
  String get loginWithApple => 'تسجيل الدخول عبر آبل';

  @override
  String get orDivider => 'أو';

  @override
  String get loginWithPhone => 'تسجيل الدخول ';

  @override
  String get forgotPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPasswordHeading => 'هل نسيت كلمة المرور؟';

  @override
  String get forgotPasswordSub => 'إذا كنت تواجه مشكلة في تذكر البريد الإلكتروني الصحيح فلا تتردد في التواصل مع فريق الدعم الفني للمساعدة.';

  @override
  String get enterEmailLabel => 'أدخل البريد الإلكتروني';

  @override
  String get startNowButton => 'ابدأ الآن';

  @override
  String get backButton => 'العودة إلى الخلف';

  @override
  String get otpTitle => 'تغيير كلمة المرور';

  @override
  String get otpMessage => 'تم إرسال رمز تفعيل لإعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى التحقق ونسخ الرمز.';

  @override
  String get otpLabel => 'كود التفعيل';

  @override
  String get validationEnterCode => 'الرجاء إدخال الكود';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmPasswordLabel => 'إعادة كتابة كلمة المرور';

  @override
  String get passwordResetSuccess => 'تم تعيين كلمة المرور بنجاح';

  @override
  String get finishButton => 'إنهاء';

  @override
  String get validationEmail => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get validationPasswordLength => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get validationPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get logoutTitle => 'تسجيل الخروج';

  @override
  String get logoutConfirmationTitle => 'تأكيد تسجيل الخروج';

  @override
  String get logoutConfirmationMessage => 'هل أنت متأكد أنك تريد تسجيل الخروج من الحساب؟';

  @override
  String get logoutSuccess => 'تم تسجيل الخروج بنجاح.';

  @override
  String get logoutQuestion => 'هل تريد تسجيل الخروج من حسابك؟';

  @override
  String logoutFailed(String error) {
    return 'فشل تسجيل الخروج: $error';
  }

  @override
  String get onboardingTitle1 => 'مرحبًا بك في راسخ';

  @override
  String get onboardingSub1 => 'طريقتك الذكية لحفظ القرآن الكريم وتثبيته بأسلوب منظم وفعال.';

  @override
  String get onboardingTitle2 => 'خطط حفظ مرنة';

  @override
  String get onboardingSub2 => 'اختر الخطة التي تناسب وقتك ومستواك، وتابع تقدمك يومًا بيوم بسهولة.';

  @override
  String get onboardingTitle3 => 'مراجعة واختبارات ذكية';

  @override
  String get onboardingSub3 => 'نظام مراجعة متكامل يساعدك على تثبيت المحفوظ، مع اختبارات لقياس إتقانك.';

  @override
  String get skipButton => 'تخطي';

  @override
  String get validationEnterName => 'الرجاء إدخال الاسم';

  @override
  String get validationNameThreeParts => 'الرجاء إدخال الاسم الثلاثي على الأقل';

  @override
  String get validationNameCharsOnly => 'الاسم يجب أن يحتوي على أحرف فقط';

  @override
  String get validationValidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get validationEnterPhone => 'الرجاء إدخال رقم الهاتف';

  @override
  String get validationInvalidPhone => 'رقم الهاتف غير صالح';

  @override
  String validationFieldRequired(String fieldName) {
    return 'الرجاء إدخال $fieldName';
  }

  @override
  String get cameraOption => 'الكاميرا';

  @override
  String get galleryOption => 'معرض الصور';

  @override
  String get cancelOption => 'إلغاء';

  @override
  String get cropImageTitle => 'قص الصورة';

  @override
  String get cropImageDone => 'تم';

  @override
  String get cropImageCancel => 'إلغاء';

  @override
  String get changePhotoAction => 'تغيير الصورة';

  @override
  String get contactUsTitle => 'تواصل معنا';

  @override
  String get contactUsHeader => 'تواصل معنا';

  @override
  String get contactInfoTitle => 'لا تتردد في الاتصال بنا في أي وقت';

  @override
  String get contactInfoSub => 'سوف نقوم بالرد في أسرع وقت ممكن';

  @override
  String get contactTypeHint => 'اختر نوع التواصل';

  @override
  String get contactTypeGeneral => 'استفسار عام';

  @override
  String get contactTypeTechnical => 'شكوى فنية';

  @override
  String get contactTypeSuggestion => 'اقتراح تطويري';

  @override
  String get messageLabel => 'رسالتك';

  @override
  String get validationMessageRequired => 'الرجاء كتابة رسالتك';

  @override
  String get sendButton => 'إرسال';

  @override
  String get messageSentSuccess => 'تم إرسال رسالتك بنجاح';

  @override
  String get validationFillAllFields => 'الرجاء التأكد من ملء جميع الحقول المطلوبة ⚠️';

  @override
  String get dashboardTitle => 'راسخ';

  @override
  String welcomeUser(String userName) {
    return 'مرحبًا بك، $userName!';
  }

  @override
  String get welcomeSubtitle => 'رحلتك مع القرآن مستمرة بخطى ثابتة!';

  @override
  String get quoteText => 'تذكّر دائمًا: كل آية تحفظها ترفعك درجة، وكل جهد تبذله في الحفظ هو خطوة نحو النور والبركة. واصل المسير، فنحن معك في كل خطوة!';

  @override
  String get aboutUsTitle => 'من نحن';

  @override
  String get aboutUsContent => 'راسخ هو برنامج قراني رفيع المستوى، يهدف إلى الكتابة والحفظ والاستماع والمراجعة والربط لكل مقطع من المقرر المراد حفظه وبيان مستوى إنجاز الطالب لذلك كله.\nيهدف الي مساعدة الطلاب والطالبات في أنحاء العالم على حفظ القرآن الكريم بطريقة منظمة وفعالة، وذلك من خلال توفير نظام متكامل يجمع بين الخطط الورقية والتدريب الرقمي.';

  @override
  String completedParts(int count) {
    return 'لقد أتممت حتى الآن $count من أجزاء القرآن الكريم';
  }

  @override
  String get progressGood => 'مستوى متقدم وجيد في الحفظ';

  @override
  String get progressNeedsImprovement => 'يحتاج الى تحسين';

  @override
  String get progressNeedsIntensiveReview => 'يحتاج الى مراجعة مكثفة';

  @override
  String nextTarget(String targetName) {
    return '🌟 الهدف القادم: $targetName';
  }

  @override
  String get startMemorizingButton => 'ابدأ الحفظ';

  @override
  String get studentNamePlaceholder => 'اسم الطالب';

  @override
  String get nextPartOrSurah => 'الجزء/السورة التالية';

  @override
  String get welcomeToRasikh => 'في تطبيق راسخ';

  @override
  String failedToLoadStatistics(Object error) {
    return 'فشل في تحميل الإحصائيات: $error';
  }

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navMemorization => 'الحفظ';

  @override
  String get navPerformance => 'الأداء';

  @override
  String get navUnderstanding => 'الفهم';

  @override
  String get archiveScreenTitle => 'الأرشيف';

  @override
  String get planNamePlaceholder => 'خطة 3 شهور';

  @override
  String archiveLoadError(String error) {
    return 'فشل تحميل الأرشيف: $error';
  }

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusIncomplete => 'غير مكتمل';

  @override
  String get detailMemorization => 'الحفظ';

  @override
  String get detailReview => 'المراجعة';

  @override
  String get detailRepetition => 'التكرار';

  @override
  String get detailListening => 'الاستماع';

  @override
  String get detailLinking => 'الربط';

  @override
  String get detailWriting => 'كتابة الآيات';

  @override
  String get writingCompleted => 'تمت';

  @override
  String get writingNotCompleted => 'لم تتم';

  @override
  String get memorizationInputHintLearning => 'ابدأ الكتابة...';

  @override
  String get memorizationInputHintTesting => 'اكتب الآيات هنا للتحقق من حفظك...';

  @override
  String get hintButton => 'تلميح';

  @override
  String planLoadError(Object error) {
    return 'خطأ في تحميل الخطة: $error';
  }

  @override
  String get startWriting => 'ابدأ الكتابة';

  @override
  String get planTitlePrefix => 'الخطة : ';

  @override
  String get fromSurah => 'من سورة:';

  @override
  String get fromAyah => 'من آية:';

  @override
  String get toAyah => 'الى آية:';

  @override
  String get reviewMode => 'وضع المراجعة';

  @override
  String get memorizationMode => 'وضع الحفظ';

  @override
  String get startTypingBelow => 'ابدأ الكتابة في الحقل أدناه...';

  @override
  String get repetitionLabel => 'التكرار';

  @override
  String repetitionCount(int current, int total) {
    return '$current من $total';
  }

  @override
  String get listenNow => 'استمع الآن';

  @override
  String get writingAndRecitation => 'الكتابة';

  @override
  String get saveProgress => 'حفظ التقدم';

  @override
  String get completeMemorization => 'إتمام الحفظ';

  @override
  String get planHubTitle => 'متابعة الحفظ';

  @override
  String get tabMemorizationPlan => 'الحفظ';

  @override
  String get tabLinking => 'الربط';

  @override
  String get tabArchive => 'الأرشيف';

  @override
  String get reviewBannerText => 'لا تنسَ أن المراجعة تُثبّت الحفظ، فاجعل وردك اليومي متوازنًا بين التقدم والمراجعة.';

  @override
  String get previousReviewTitle => 'المراجعة السابقة';

  @override
  String get nextReviewTitle => 'المراجعة التالية';

  @override
  String linkingTitle(String surahName) {
    return 'ربط سورة $surahName';
  }

  @override
  String get reviewButton => 'مراجعة';

  @override
  String get linkButton => 'ربط';

  @override
  String get fromSurahLabel => 'من سورة:';

  @override
  String get fromAyahLabel => 'من آية:';

  @override
  String get toAyahLabel => 'إلى آية:';

  @override
  String get noActivePlan => 'لا توجد خطة نشطة';

  @override
  String get apiNoActivePlan => 'لا توجد خطة حفظ مجدولة لهذا اليوم.';

  @override
  String get errorNoPlanTitle => 'لا توجد خطة اليوم';

  @override
  String get errorNoInternetTitle => 'انقطع الاتصال';

  @override
  String get errorGeneralTitle => 'حدث خطأ';

  @override
  String get refreshButton => 'تحديث';

  @override
  String get stopListening => ' إيقاف';

  @override
  String get errorLoadingSurahsList => 'خطأ في تحميل قائمة السور';

  @override
  String failedToLoadCertificates(Object errorMessage) {
    return 'فشل في تحميل الشهادات: $errorMessage';
  }

  @override
  String get notDefined => 'لم يتم التحديد';

  @override
  String get noArchiveData => 'لا يوجد أرشيف حتى الآن';

  @override
  String validationRequiredField(String fieldName) {
    return 'الرجاء إدخال $fieldName';
  }

  @override
  String get validationEnterAge => 'الرجاء إدخال العمر';

  @override
  String get validationAgeNumberOnly => 'العمر يجب أن يكون رقمًا صحيحًا';

  @override
  String get validationAgeRange => 'الرجاء إدخال عمر حقيقي بين 15 و 120';

  @override
  String get failedToLoadCountries => 'فشل في تحميل البلدان';

  @override
  String get searchCountryHint => 'ابحث عن البلد';

  @override
  String get noResultsFound => 'لم يتم العثور على نتايج';

  @override
  String get openInWebSite => 'فتح في الموقع';

  @override
  String get uploadingImage => 'جاري رفع الصورة...';

  @override
  String get imageUploadSuccess => 'تم تحديث صورة الملف الشخصي بنجاح';

  @override
  String imageUploadFailed(String error) {
    return 'فشل رفع الصورة: $error';
  }

  @override
  String get soryFailedToLoadReport => 'عذراً، فشل تحميل التقرير';

  @override
  String get checkInternetThenRetry => 'تأكد من اتصالك بالإنترنت والمحاولة مرة أخرى';

  @override
  String get surahNumber => 'سورة رقم ';

  @override
  String get noTafsirAvailableForNow => 'لا يوجد نص تفسير متاح حالياً.';

  @override
  String get selectedSurahName => 'الفاتحة';

  @override
  String get showAllAyahs => 'عرض جميع الآيات';

  @override
  String get selectAyah => 'تحديد رقم الآية';

  @override
  String get ayahNumber => 'الآية رقم';

  @override
  String get noAyahFound => 'لا توجد آية بهذا الرقم في النتائج الحالية';

  @override
  String get getCertificate => 'الحصول على الشهادة';

  @override
  String get failedToLoadCertificate => 'فشل جلب الشهادة:';

  @override
  String get certificateNotIssued => 'الشهادة قيد الإصدار، يرجى المحاولة لاحقاً';

  @override
  String get numberOfSavedParts => 'عدد الأجزاء المحفوظة';

  @override
  String get startNowThenYouWillSucceedInshaAllah => 'ابدأ الآن وستصل بإذن الله!';

  @override
  String get dateOfCompletion => 'تاريخ الإنجاز';

  @override
  String get errorLoadingData => 'خطاء في تحميل البيانات';

  @override
  String get retry => 'اعادة المحاولة';

  @override
  String get loading => 'جاري التحميل';

  @override
  String get completed => 'لا يوجد عملية متابعة';

  @override
  String get noPlanSelected => 'لم يتم تحديد خطة';

  @override
  String get reviewLinkScreenTitle => 'صفحة المراجعة والربط';

  @override
  String get errorTitle => 'عفواً! حدث خطأ ما';

  @override
  String get tryAgain => 'إعادة المحاولة';

  @override
  String get errorNoInternet => 'يبدو أنك غير متصل بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';

  @override
  String get errorTimeout => 'استغرق الاتصال وقتاً طويلاً للرد. يرجى التحقق من اتصالك أو المحاولة لاحقاً.';

  @override
  String get errorUnknown => 'حدث خطأ غير متوقع. يرجى إعادة تشغيل التطبيق.';

  @override
  String get errorGeneric => 'حدثت مشكلة أثناء تحميل البيانات.';

  @override
  String errorServerDown(int statusCode) {
    return 'واجهنا مشكلة في الخادم (الكود: $statusCode). يرجى المحاولة مرة أخرى قريباً.';
  }

  @override
  String get errorOccurredTitle => 'حدث خطاء';

  @override
  String get errorOccurredMessage => 'حدث خطاء في التطبيق. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';

  @override
  String get tajweedRulesTitle => 'قواعد التجويد';

  @override
  String get validationPasswordWeak => 'يجب أن تحتوي كلمة المرور على حرف أو رمز واحد على الأقل';

  @override
  String get userGuideTitle => 'دليل المستخدم';

  @override
  String get welcomeTitle => 'مرحبًا بك في \"راسخ\" 🌿';

  @override
  String get welcomeContent => 'تم تصميم هذا البرنامج ليكون رفيقك الذكي في رحلة حفظ كتاب الله. هدفنا ليس مجرد الحفظ، بل \"الرسوخ\".\n\nنحن نؤمن بالتكامل، لذا يمكنك متابعة وردك اليومي عبر التطبيق أو الموقع الإلكتروني.';

  @override
  String get visitWebsite => 'زيارة موقعنا الإلكتروني';

  @override
  String get firstStepTitle => 'الخطوة الأولى: اختيار المسار';

  @override
  String get firstStepContent => 'لدينا خطط مرنة تناسب مستواك وهمتك. سواء كنت مبتدئاً أو متقدماً.\nإذا لم تقم باختيار خطتك أثناء التسجيل، يمكنك استعراض الخطط المتاحة واختيار الأنسب لك الآن.';

  @override
  String get goToMemorization => 'انتقل إلى صفحة الحفظ';

  @override
  String get secondStepTitle => 'الخطوة الثانية: الورد اليومي';

  @override
  String get methodologyIntro => 'سر \"راسخ\" يكمن في المنهجية الثلاثية:';

  @override
  String get listen => 'استمع';

  @override
  String get listenDesc => 'لتصحيح التلاوة';

  @override
  String get read => 'اقرأ';

  @override
  String get readDesc => 'بتمعن وتركيز';

  @override
  String get write => 'اكتب';

  @override
  String get writeDesc => 'لتثبيت الحفظ';

  @override
  String get progressTitle => 'الخطوة الثالثة: متابعة الإنجاز';

  @override
  String get progressContent => 'حفظك لا يضيع! كل يوم تنجزه يتم توثيقه في الأرشيف لتعرف بالضبط أين تقف في مسيرتك.';

  @override
  String get viewArchive => 'شاهد تقدمك في الأرشيف';

  @override
  String get reviewTitle => 'المراجعة والترسيخ';

  @override
  String get reviewContent => 'الحفظ رأس المال، والمراجعة هي الربح.\n• المراجعة: خصصنا صفحة مستقلة للتذكير.\n• الربط: لضمان ترابط الآيات والسور.';

  @override
  String get masteryTitle => 'الفهم والإتقان';

  @override
  String get masteryContent => 'اجعل الحفظ مقرونًا بالفهم:\n• التجويد.\n• التفسير.\n• المصحف الشريف.';

  @override
  String get footerMessage => 'وفقكم الله لما يحب ويرضى';

  @override
  String get tabReview => 'المراجعة';

  @override
  String get goToTajweed => 'انتقل الى صفحة التجويد';

  @override
  String get goToQuran => 'انتقل الى صفحة القرآن';

  @override
  String get goToTafsir => 'انتقل الى صفحة التفسير';

  @override
  String get goToMushaf => 'انتقل الى صفحة المصحف الشريف';

  @override
  String get memrizationPlans => 'خطة الحفظ';

  @override
  String get mushafTab => 'المصحف';

  @override
  String get planCompletionTitle => 'نسبة إنجاز الخطة';

  @override
  String get completionStatTitle => 'نسبة الإكمال';

  @override
  String get linkedVersesStatTitle => 'الآيات المرتبطة';

  @override
  String get reviewedVersesStatTitle => 'الآيات المُراجَعة';

  @override
  String get totalPartsStatTitle => 'إجمالي الأجزاء';

  @override
  String get performanceStatTitle => 'الأداء';

  @override
  String get completedDaysStatTitle => 'الأيام المكتملة';

  @override
  String get completedDaysLabel => 'أيام مكتملة';

  @override
  String get daysUnit => 'يوم';

  @override
  String get performanceStatUnit => 'نقطة';

  @override
  String get motivationLabel => 'رسالة تحفيزية';

  @override
  String get progressLabel => 'تقدمك';

  @override
  String get reminderLabel => 'تذكير';

  @override
  String get notClassifiedLabel => 'غير مصنف';

  @override
  String get reviewScreenTitle => 'المراجعة';

  @override
  String get reviewEmptyTitle => 'لا توجد مراجعات حالياً';

  @override
  String get reviewEmptySubtitle => 'أكمل الحفظ وستظهر هنا خطط المراجعة تلقائياً.';

  @override
  String reviewDueCount(int count) {
    return 'مطلوب مراجعة $count يوم';
  }

  @override
  String get reviewNoReviewTitle => 'لا توجد مراجعة';

  @override
  String get reviewNoReviewSubtitle => 'هذه الخطة لا تحتوي على مراجعة حالياً .';

  @override
  String get reviewVersesUnavailable => 'تعذر عرض آيات المراجعة (نطاق المراجعة غير مكتمل).';

  @override
  String get reviewSheetTitlePrefix => 'مراجعة';

  @override
  String get listenButton => 'استماع';

  @override
  String get reviewDoneButton => 'تمت المراجعة';

  @override
  String get linkScreenTitle => 'الربط';

  @override
  String linkDueCount(int count) {
    return 'عليك $count ربط';
  }

  @override
  String get linkEmptyTitle => 'لا توجد مهام ربط حالياً';

  @override
  String get linkEmptySubtitle => 'لم يتم إعداد ربط لهذه الفترة حسب الخطة.';

  @override
  String get linkNoLinkTitle => 'لا يوجد ربط';

  @override
  String get linkNoLinkSubtitle => 'هذا اليوم لا يحتوي على ربط حالياً حسب الخطة.';

  @override
  String get linkVersesUnavailable => 'تعذر عرض آيات الربط (نطاق الربط غير مكتمل).';

  @override
  String get linkSheetTitlePrefix => 'ربط';

  @override
  String get linkDoneButton => 'تم الربط';

  @override
  String get validationGmailOnlyEmail => 'يرجى إدخال بريد إلكتروني صحيح ينتهي بـ @gmail.com';

  @override
  String get planInProgress => 'قيد التنفيذ';

  @override
  String get planCompleted => 'تمت بنجاح';

  @override
  String get planLockedHint => 'مغلق - أكمل الخطة السابقة';

  @override
  String get tapToStart => 'اضغط للبدء';

  @override
  String planSwitchedTo(String planName) {
    return 'تم التبديل إلى: $planName';
  }

  @override
  String get planMustCompleteToUnlock => 'عذرًا، يجب إتمام الخطة الحالية بالكامل لفتح هذه الخطة.';

  @override
  String get mainSection => 'الرئيسية';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get supportSection => 'الدعم';

  @override
  String get accountSection => 'الحساب';

  @override
  String get somethingWentWrong => 'حدث خطأ ما، يرجى المحاولة مرة أخرى.';

  @override
  String get quranGreeting => 'ليكن القرآن رفيقك الدائم';

  @override
  String get contactTypeComplaint => 'شكوى';

  @override
  String get contactTypeNote => 'ملاحظة';

  @override
  String get contactTypeIdea => 'أفكار';

  @override
  String get contactTypeInquiry => 'استفسار';

  @override
  String get dialogSuccessTitle => 'تم الإرسال بنجاح';

  @override
  String get dialogSuccessContent => 'شكراً لتواصلك معنا. تم استلام رسالتك، وسيقوم فريقنا بالرد عليك قريباً عبر البريد الإلكتروني أو الواتساب، أو عبر الاتصال الهاتفي إن لزم الأمر.';

  @override
  String get dialogButtonOk => 'حسناً';

  @override
  String get dailyAchievementTitle => 'إنجازك اليومي';

  @override
  String get dailyAchievementSubtitle => 'الاستمرار في الحفظ يوصلك لختم كتاب الله بانتظام.';

  @override
  String get dailyTipTitle => 'نصيحة اليوم';

  @override
  String get dailyTipSubtitle => 'خيركم من تعلم القرآن وعلمه، واصل المسير.';

  @override
  String get dailyPlanTitle => 'خطتك الحالية';

  @override
  String get dailyPlanSubtitle => 'تابع تقدمك في الخطة الموضوعة لضمان رسوخ الحفظ.';

  @override
  String get numberOfVerses => 'عدد الآيات';

  @override
  String get numberOfPages => 'عدد الأوجه';

  @override
  String get dailyAverage => 'المتوسط اليومي';

  @override
  String get performance => 'الأداء';

  @override
  String get performanceGood => 'جيد';

  @override
  String get currentPlanImportanceTitle => 'الخطة الحالية: ';

  @override
  String mistakesWarning(int count) {
    return '⚠️ لديك $count أخطاء. يرجى مراجعة الكلمات باللون الأحمر وتصحيحها لتتمكن من الحفظ.';
  }

  @override
  String get correctionMismatchError => 'الكلمة غير مطابقة للتفصيل المطلوب، حاول مرة أخرى';

  @override
  String correctionTitle(int current, int total) {
    return 'تصحيح ($current/$total)';
  }

  @override
  String get actualWordLabel => 'الكلمة الفعلية';

  @override
  String correctionDetailLabel(String detail) {
    return 'التفصيل: $detail';
  }

  @override
  String get correctionHintText => 'اكتب الكلمة هنا...';

  @override
  String get checkButton => 'تحقق';

  @override
  String get writingSuccessSaving => 'تمت الكتابة بنجاح ✅ جاري الحفظ...';

  @override
  String get warningTitle => 'تنبيه';

  @override
  String get exitWarningMessage => 'لم تكمل الكتابة بعد، هل تريد الخروج وفقدان التقدم الحالي؟';

  @override
  String get continueButton => 'استمرار';

  @override
  String get exitAnywayButton => 'خروج على أي حال';

  @override
  String get completeWritingWarning => '⚠️ يرجى إكمال كتابة الآيات أولاً لتثبيت الحفظ.';

  @override
  String repetitionRemainingWarning(int count, int total) {
    return '⚠️ بقي عليك تكرار الآيات $count مرات إضافية (المطلوب $total).';
  }

  @override
  String listeningRemainingWarning(int count, int total) {
    return '⚠️ بقي عليك الاستماع للتلاوة $count مرات إضافية (المطلوب $total).';
  }

  @override
  String get recordingPlanCompletion => 'جاري تسجيل إتمام الخطة...';

  @override
  String get planCompletionSuccess => 'مبارك! تم إتمام ورد اليوم بنجاح 🎉';

  @override
  String savingError(String error) {
    return 'حدث خطأ أثناء الحفظ: $error';
  }

  @override
  String get listeningCompletedSuccess => 'تم احتساب استماع كامل ✅';

  @override
  String get planCompletedCongrats => 'ما شاء الله! لقد أتممت الخطة بنجاح';

  @override
  String get duaMessage => 'جعل الله القرآن نوراً لك في الدنيا والآخرة ✨';

  @override
  String get chooseNextStep => 'اختر خطوتك القادمة:';

  @override
  String get allPlansCompleted => 'أحسنت! لقد أتممت جميع الخطط المتاحة.';

  @override
  String get failedToLoadPlans => 'فشل تحميل الخطط';

  @override
  String failedToLoadPlansWithError(String error) {
    return 'فشل تحميل الخطط: $error';
  }

  @override
  String failedToSwitchPlan(String error) {
    return 'فشل تغيير الخطة: $error';
  }

  @override
  String get failedToSwitchPlanTryLater => 'فشل تبديل الخطة. يرجى المحاولة لاحقاً.';

  @override
  String get continueAsGuest => 'تصفح كزائر';

  @override
  String get guestModeTitle => 'تسجيل دخول مطلوب';

  @override
  String get guestModeMessage => 'يرجى تسجيل الدخول للوصول إلى هذه الميزة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get loginScreenSubtitle => 'سجل دخولك للمتابعة والاستفادة من كافة ميزات التطبيق';

  @override
  String get choosePlanOptional => 'اختر خطة (اختياري)';

  @override
  String get defaultPlanWillBeUsed => 'سيتم استخدام الخطة الافتراضية';

  @override
  String get doYouHaveAccount => 'هل لديك حساب؟';

  @override
  String get emptyPlanMessage => 'عذراً، هذه الخطة فارغة حالياً';

  @override
  String get emptyPlanSubmessage => 'لم تتم إضافة أي مهام يومية لهذه الخطة بعد. يمكنك اختيار خطة أخرى للبدء.';

  @override
  String get availablePlansLabel => 'الخطط المتاحة:';

  @override
  String get noOtherPlansAvailable => 'لا توجد خطط أخرى متاحة حالياً.';

  @override
  String get failedToLoadData => 'خطأ في تحميل البيانات';

  @override
  String get registerHelpNote => 'ملاحظة سريعة قبل المحاولة مرة أخرى';

  @override
  String get registerHelpDescription => 'قد يكون سبب الخطأ أن رقم الهاتف أو البريد الإلكتروني مستخدم مسبقًا.\nتأكد من البيانات، أو سجّل الدخول إذا كان لديك حساب بالفعل.';

  @override
  String get userGuide => 'دليل المستخدم';

  @override
  String get loginRequiredTitle => 'تسجيل الدخول مطلوب';

  @override
  String get loginRequiredMessage => 'عذراً، لا يمكنك عرض الشهادات في وضع الزائر. يرجى تسجيل الدخول للمتابعة.';

  @override
  String get reportsGuestMessage => 'عذراً، لا يمكنك عرض تقارير الحفظ في وضع الزائر. يرجى تسجيل الدخول للمتابعة.';

  @override
  String get deleteAccountButton => 'حذف الحساب';

  @override
  String get deleteAccountTitle => 'حذف الحساب';

  @override
  String get deleteAccountWarning => 'سيتم حذف جميع بياناتك نهائياً ولا يمكن التراجع عن هذا الإجراء. هل أنت متأكد؟';

  @override
  String get deleteAccountConfirmButton => 'نعم، حذف الحساب';

  @override
  String get deleteAccountCancel => 'Cancel';

  @override
  String get deleteAccountSuccess => 'تم حذف الحساب بنجاح';

  @override
  String deleteAccountFailed(String error) {
    return 'فشل حذف الحساب: $error';
  }
}
