// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rasikh';

  @override
  String get home => 'Home';

  @override
  String get homeWelcome => 'Welcome to Rasikh App';

  @override
  String get goTosettings => 'Go to settings';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get welcomeMessage => 'Welcome 👋';

  @override
  String get homePage => 'Home Page';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get logout => 'Logout';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get resourcesHubTitle => 'Resources';

  @override
  String get tafsirAndTadabburTab => 'Tafsir & Tadabbur';

  @override
  String get tajweedTab => 'Tajweed';

  @override
  String tafsirDetailTitle(int verseNumber, String surahName) {
    return 'Tafsir of Ayah $verseNumber from Surah $surahName';
  }

  @override
  String get tafsirLabel => 'Tafsir:';

  @override
  String get searchBySurahNameHint => 'Search by Surah name';

  @override
  String get searchByVerseNumberHint => 'Search by Ayah number';

  @override
  String surahNameLabel(String surahName) {
    return 'Surah $surahName';
  }

  @override
  String verseNumberLabel(int verseNumber) {
    return 'Ayah $verseNumber';
  }

  @override
  String get viewTafsirButton => 'View Tafsir';

  @override
  String get example => 'Example:';

  @override
  String get certificateScreenTitle => 'Certificate of Appreciation';

  @override
  String get downloadAsPdfButton => 'Download as PDF';

  @override
  String certificateTitle(String courseName) {
    return 'Certificate for Memorizing $courseName';
  }

  @override
  String get certificatePresentedTo => 'This certificate is presented to:';

  @override
  String get certificateBlessing => 'May Allah bless you and make your memorization of the Quran a light for you in this life and the hereafter.';

  @override
  String get signatureLabel => 'Signature ___________________ ';

  @override
  String certificateCompletionTitle(int partNumber) {
    return 'Certificate of Completion for Part $partNumber';
  }

  @override
  String certificateIssueDate(String date) {
    return 'Issue Date: $date';
  }

  @override
  String get noCertificatesFound => 'No Certificates Found';

  @override
  String get performanceTrackingTitle => 'Performance Tracking';

  @override
  String get reportsTab => 'Reports';

  @override
  String get certificatesTab => 'Certificates';

  @override
  String get prophetSaidLabel => 'The Messenger of Allah ﷺ said:';

  @override
  String get memorizationReportTitle => 'Memorization Report';

  @override
  String get savedVersesStatTitle => 'Memorized Verses';

  @override
  String get savedVersesStatUnit => 'verse';

  @override
  String get savedPagesStatTitle => 'Memorized Pages';

  @override
  String get savedPagesStatUnit => 'page';

  @override
  String get savedJuzStatTitle => 'Memorized Juz\'';

  @override
  String get savedJuzStatUnit => 'Juz\'';

  @override
  String get dailyAverageStatTitle => 'Daily Average';

  @override
  String get dailyAverageStatUnit => 'verses';

  @override
  String get profileScreenTitle => 'Profile';

  @override
  String get personalInformationTitle => 'Personal Information';

  @override
  String get addressInformationTitle => 'Address Information';

  @override
  String get editButton => 'Edit';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get middleNameLabel => 'Middle Name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get passwordLabel => 'Password';

  @override
  String get logoutButton => 'Logout';

  @override
  String profileLoadError(String error) {
    return 'Failed to load profile: $error';
  }

  @override
  String get retryButton => 'Retry';

  @override
  String get editProfileDialogTitle => 'Edit Personal Information';

  @override
  String get firstNameFormFieldLabel => 'First Name';

  @override
  String get middleNameFormFieldLabel => 'Middle Name';

  @override
  String get lastNameFormFieldLabel => 'Last Name';

  @override
  String get emailFormFieldLabel => 'Email';

  @override
  String get phoneFormFieldLabel => 'Mobile Number';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get validationEmptyFirstName => 'Please enter your first name';

  @override
  String get validationInvalidNameFormat => 'Name must contain letters only';

  @override
  String get validationEmptyMiddleName => 'Please enter your middle name';

  @override
  String get validationEmptyLastName => 'Please enter your last name';

  @override
  String get validationEmptyEmail => 'Please enter your email';

  @override
  String get validationInvalidEmail => 'Please enter a valid email address';

  @override
  String get invalidPhoneNumber => 'Invalid mobile number';

  @override
  String get changePasswordDialogTitle => 'Change Password';

  @override
  String get oldPasswordFormFieldLabel => 'Old Password';

  @override
  String get newPasswordFormFieldLabel => 'New Password';

  @override
  String get confirmNewPasswordFormFieldLabel => 'Confirm New Password';

  @override
  String get validationEmptyOldPassword => 'Please enter your old password';

  @override
  String get validationEmptyNewPassword => 'Please enter the new password';

  @override
  String get validationPasswordTooShort => 'Password is too short';

  @override
  String get validationPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get editAddressDialogTitle => 'Edit Address';

  @override
  String get countryFormFieldLabel => 'Country';

  @override
  String get cityFormFieldLabel => 'City';

  @override
  String get addressDetailsFormFieldLabel => 'Address Details';

  @override
  String get validationEmptyCountry => 'Please enter the country';

  @override
  String get validationEmptyCity => 'Please enter the city';

  @override
  String get validationEmptyAddressDetails => 'Please enter address details';

  @override
  String get profileUpdateSuccess => 'Information updated successfully';

  @override
  String profileUpdateFailed(String error) {
    return 'Update failed: $error';
  }

  @override
  String get passwordUpdateSuccess => 'Password changed successfully';

  @override
  String get oldPasswordIncorrect => 'Old password is incorrect';

  @override
  String get addressUpdateSuccess => 'Address updated successfully';

  @override
  String get apiConnectionTimeout => 'Connection timeout with server.';

  @override
  String get apiBadRequest => 'Invalid request. Please check your input.';

  @override
  String get apiUnauthorized => 'Incorrect login credentials.';

  @override
  String get apiNotFound => 'Requested resource not found.';

  @override
  String get apiPhoneNumberExists => 'Phone number already exists.';

  @override
  String get apiServerError => 'Server error, please try again later.';

  @override
  String apiUnexpectedErrorWithCode(String statusCode) {
    return 'Unexpected error: $statusCode';
  }

  @override
  String get apiRequestCancelled => 'Request cancelled.';

  @override
  String get apiNoInternetConnection => 'No internet connection.';

  @override
  String get apiUnknownError => 'Unknown error occurred.';

  @override
  String get apiUnexpectedError => 'Unexpected error occurred, please try again.';

  @override
  String get apiOldPasswordIncorrect => 'The old password is incorrect.';

  @override
  String get welcomeBack => 'Welcome Back 👋';

  @override
  String get loginPrompt => 'Please enter your email and password to login';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get validationEnterPhoneNumber => 'Please enter phone number';

  @override
  String get validationEnterPassword => 'Please enter password';

  @override
  String get forgotPasswordButton => 'Forgot Password?';

  @override
  String get loginButton => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get registerTitle => 'Create New Account';

  @override
  String get stepBasicInfo => 'Basic Info';

  @override
  String get stepDetails => 'Details';

  @override
  String get registerWelcome => 'Welcome 👋';

  @override
  String get registerWelcomeSub => 'Let\'s start with some basic information to create your profile.';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get ageLabel => 'Age';

  @override
  String get nextButton => 'Next';

  @override
  String get step2Title => 'Last Step! 🚀';

  @override
  String get step2Sub => 'Help us customize your experience with these details.';

  @override
  String get countryLabel => 'Country';

  @override
  String get validationCountryRequired => 'Country is required';

  @override
  String get planSelectionTitle => 'How do you prefer to memorize?';

  @override
  String get planSelfPaced => 'Self-Paced';

  @override
  String get planSelfPacedSub => 'Memorize alone and review whenever I want';

  @override
  String get planGroup => 'Memorization Circle';

  @override
  String get planGroupSub => 'Join a group for encouragement';

  @override
  String get planTutor => 'Private Tutor (Online)';

  @override
  String get planTutorSub => 'Close follow-up with a teacher';

  @override
  String get validationPlanRequired => 'Please select a memorization plan';

  @override
  String get registerSuccess => 'Account created successfully!';

  @override
  String get createAccountAction => 'Create Account';

  @override
  String get loginOptionsTitle => 'Let\'s dive into your account';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get loginWithApple => 'Login with Apple';

  @override
  String get orDivider => 'Or';

  @override
  String get loginWithPhone => 'Login';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get forgotPasswordHeading => 'Forgot Password?';

  @override
  String get forgotPasswordSub => 'If you are having trouble remembering the correct email, please contact support for assistance.';

  @override
  String get enterEmailLabel => 'Enter Email';

  @override
  String get startNowButton => 'Start Now';

  @override
  String get backButton => 'Go Back';

  @override
  String get otpTitle => 'Change Password';

  @override
  String get otpMessage => 'An activation code has been sent to your email. Please check and copy the code.';

  @override
  String get otpLabel => 'Activation Code';

  @override
  String get validationEnterCode => 'Please enter the code';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get passwordResetSuccess => 'Password reset successfully';

  @override
  String get finishButton => 'Finish';

  @override
  String get validationEmail => 'Please enter a valid email';

  @override
  String get validationPasswordLength => 'Password must be at least 6 characters';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutConfirmationTitle => 'Confirm Logout';

  @override
  String get logoutConfirmationMessage => 'Are you sure you want to log out of the account?';

  @override
  String get logoutSuccess => 'Logged out successfully.';

  @override
  String get logoutQuestion => 'Do you want to log out of your account?';

  @override
  String logoutFailed(String error) {
    return 'Logout failed: $error';
  }

  @override
  String get onboardingTitle1 => 'Welcome to Rasikh';

  @override
  String get onboardingSub1 => 'Your smart way to memorize the Quran and consolidate it in an organized and effective manner.';

  @override
  String get onboardingTitle2 => 'Flexible Plans';

  @override
  String get onboardingSub2 => 'Choose the plan that suits your time and level, and track your progress day by day easily.';

  @override
  String get onboardingTitle3 => 'Smart Review & Quizzes';

  @override
  String get onboardingSub3 => 'A comprehensive review system helping you consolidate memorization, with tests to measure your mastery.';

  @override
  String get skipButton => 'Skip';

  @override
  String get validationEnterName => 'Please enter the name';

  @override
  String get validationNameThreeParts => 'Please enter at least a full name (three parts)';

  @override
  String get validationNameCharsOnly => 'Name must contain letters only';

  @override
  String get validationValidEmail => 'Please enter a valid email';

  @override
  String get validationEnterPhone => 'Please enter phone number';

  @override
  String get validationInvalidPhone => 'Invalid phone number';

  @override
  String validationFieldRequired(String fieldName) {
    return 'Please enter $fieldName';
  }

  @override
  String get cameraOption => 'Camera';

  @override
  String get galleryOption => 'Photo Gallery';

  @override
  String get cancelOption => 'Cancel';

  @override
  String get cropImageTitle => 'Crop Image';

  @override
  String get cropImageDone => 'Done';

  @override
  String get cropImageCancel => 'Cancel';

  @override
  String get changePhotoAction => 'Change Photo';

  @override
  String get contactUsTitle => 'Contact Us';

  @override
  String get contactUsHeader => 'Contact Us';

  @override
  String get contactInfoTitle => 'Feel free to contact us anytime';

  @override
  String get contactInfoSub => 'We will reply as soon as possible';

  @override
  String get contactTypeHint => 'Choose contact type';

  @override
  String get contactTypeGeneral => 'General Inquiry';

  @override
  String get contactTypeTechnical => 'Technical Complaint';

  @override
  String get contactTypeSuggestion => 'Development Suggestion';

  @override
  String get messageLabel => 'Your Message';

  @override
  String get validationMessageRequired => 'Please enter your message';

  @override
  String get sendButton => 'Send';

  @override
  String get messageSentSuccess => 'Your message has been sent successfully';

  @override
  String get validationFillAllFields => 'Please make sure to fill all required fields ⚠️';

  @override
  String get dashboardTitle => 'Rasikh';

  @override
  String welcomeUser(String userName) {
    return 'Welcome, $userName!';
  }

  @override
  String get welcomeSubtitle => 'Your journey with the Quran continues steadily!';

  @override
  String get quoteText => 'Always remember: every verse you memorize raises you a degree, and every effort you make in memorization is a step towards light and blessing. Keep going, we are with you every step of the way!';

  @override
  String get aboutUsTitle => 'About Us';

  @override
  String get aboutUsContent => 'Rasikh is a high-level Quranic program aimed at writing, memorizing, listening, reviewing, and linking each section of the curriculum to be memorized, and indicating the student\'s achievement level for all of that.\nIt aims to help male and female students around the world memorize the Holy Quran in an organized and effective manner, by providing an integrated system that combines paper plans and digital training.';

  @override
  String completedParts(int count) {
    return 'You have completed so far $count of the Quran Juz\'';
  }

  @override
  String get progressGood => 'Advanced & Good Level';

  @override
  String get progressNeedsImprovement => 'Needs Improvement';

  @override
  String get progressNeedsIntensiveReview => 'Needs Intensive Review';

  @override
  String nextTarget(String targetName) {
    return '🌟 Next Target: $targetName';
  }

  @override
  String get startMemorizingButton => 'Start Memorizing';

  @override
  String get studentNamePlaceholder => 'Student Name';

  @override
  String get nextPartOrSurah => 'Next Part/Surah';

  @override
  String get welcomeToRasikh => 'Welcome to Rasikh';

  @override
  String failedToLoadStatistics(Object error) {
    return 'Failed to load statistics: $error';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navMemorization => 'Memorization';

  @override
  String get navPerformance => 'Performance';

  @override
  String get navUnderstanding => 'Understanding';

  @override
  String get archiveScreenTitle => 'Archive';

  @override
  String get planNamePlaceholder => '3 Months Plan';

  @override
  String archiveLoadError(String error) {
    return 'Failed to load archive: $error';
  }

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusIncomplete => 'Incomplete';

  @override
  String get detailMemorization => 'Memorization';

  @override
  String get detailReview => 'Review';

  @override
  String get detailRepetition => 'Repetition';

  @override
  String get detailListening => 'Listening';

  @override
  String get detailLinking => 'Linking';

  @override
  String get detailWriting => 'Writing Verses';

  @override
  String get writingCompleted => 'Done';

  @override
  String get writingNotCompleted => 'Not Done';

  @override
  String get memorizationInputHintLearning => 'Start typing...';

  @override
  String get memorizationInputHintTesting => 'Type the verses here to test your memorization...';

  @override
  String get hintButton => 'Hint';

  @override
  String planLoadError(Object error) {
    return 'Error loading plan: $error';
  }

  @override
  String get startWriting => 'Start Writing';

  @override
  String get planTitlePrefix => 'Plan: ';

  @override
  String get fromSurah => 'From Surah:';

  @override
  String get fromAyah => 'From Ayah:';

  @override
  String get toAyah => 'To Ayah:';

  @override
  String get reviewMode => 'Review Mode';

  @override
  String get memorizationMode => 'Memorization Mode';

  @override
  String get startTypingBelow => 'Start typing in the field below...';

  @override
  String get repetitionLabel => 'Repetition';

  @override
  String repetitionCount(int current, int total) {
    return '$current of $total';
  }

  @override
  String get listenNow => 'Listen Now';

  @override
  String get writingAndRecitation => 'Writing';

  @override
  String get saveProgress => 'Save Progress';

  @override
  String get completeMemorization => 'Complete Memorization';

  @override
  String get planHubTitle => 'Memorization Tracker';

  @override
  String get tabMemorizationPlan => 'Memorization';

  @override
  String get tabLinking => 'Linking';

  @override
  String get tabArchive => 'Archive';

  @override
  String get reviewBannerText => 'Do not forget that review consolidates memorization, so make your daily routine balanced between progress and review.';

  @override
  String get previousReviewTitle => 'Previous Review';

  @override
  String get nextReviewTitle => 'Next Review';

  @override
  String linkingTitle(String surahName) {
    return 'Linking $surahName';
  }

  @override
  String get reviewButton => 'Review';

  @override
  String get linkButton => 'Link';

  @override
  String get fromSurahLabel => 'From Surah:';

  @override
  String get fromAyahLabel => 'From Ayah:';

  @override
  String get toAyahLabel => 'To Ayah:';

  @override
  String get noActivePlan => 'No active memorization plan';

  @override
  String get apiNoActivePlan => 'No memorization plan scheduled for today.';

  @override
  String get errorNoPlanTitle => 'No Plan Today';

  @override
  String get errorNoInternetTitle => 'Connection Lost';

  @override
  String get errorGeneralTitle => 'Something Went Wrong';

  @override
  String get refreshButton => 'Refresh';

  @override
  String get stopListening => ' Stop';

  @override
  String get errorLoadingSurahsList => 'Error loading Surahs list';

  @override
  String failedToLoadCertificates(Object errorMessage) {
    return 'Failed to load certificates: $errorMessage';
  }

  @override
  String get notDefined => 'Not Defined';

  @override
  String get noArchiveData => 'No archive data yet';

  @override
  String validationRequiredField(String fieldName) {
    return 'Please enter $fieldName';
  }

  @override
  String get validationEnterAge => 'Please enter your age';

  @override
  String get validationAgeNumberOnly => 'Age must be a valid integer number';

  @override
  String get validationAgeRange => 'Please enter a realistic age between 15 and 120';

  @override
  String get failedToLoadCountries => 'Failed to load countries';

  @override
  String get searchCountryHint => 'Search for a country';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get openInWebSite => 'Open in website';

  @override
  String get uploadingImage => 'Uploading image...';

  @override
  String get imageUploadSuccess => 'Profile image updated successfully';

  @override
  String imageUploadFailed(String error) {
    return 'Failed to upload image: $error';
  }

  @override
  String get soryFailedToLoadReport => 'Sorry, failed to load report';

  @override
  String get checkInternetThenRetry => 'Check your internet connection and try again';

  @override
  String get surahNumber => 'Surah number';

  @override
  String get noTafsirAvailableForNow => 'No tafsir available for now.';

  @override
  String get selectedSurahName => 'Al-Fatihah';

  @override
  String get showAllAyahs => 'Show all ayahs';

  @override
  String get selectAyah => 'Select ayah number';

  @override
  String get ayahNumber => 'Ayah number';

  @override
  String get noAyahFound => 'No ayah found for this number in the current report';

  @override
  String get getCertificate => 'Get Certificate';

  @override
  String get failedToLoadCertificate => 'Failed to load certificate';

  @override
  String get certificateNotIssued => 'Certificate not issued yet, please try again later';

  @override
  String get numberOfSavedParts => 'Number of saved parts';

  @override
  String get startNowThenYouWillSucceedInshaAllah => 'Start now and you will succeed inshaAllah!';

  @override
  String get dateOfCompletion => 'Date of Completion';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get completed => 'No action needed';

  @override
  String get noPlanSelected => 'No plan selected';

  @override
  String get reviewLinkScreenTitle => 'Review & Linking';

  @override
  String get errorTitle => 'Oops! Something Went Wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get errorNoInternet => 'It looks like you\'re offline. Please check your internet connection and try again.';

  @override
  String get errorTimeout => 'The connection took too long to respond. Please check your connection or try again later.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please restart the application.';

  @override
  String get errorGeneric => 'A problem occurred while loading the data.';

  @override
  String errorServerDown(int statusCode) {
    return 'We encountered a server issue (Code: $statusCode). Please try again shortly.';
  }

  @override
  String get errorOccurredTitle => 'Error Occurred';

  @override
  String get errorOccurredMessage => 'An error occurred in the app. Please check your internet connection and try again.';

  @override
  String get tajweedRulesTitle => 'Tajweed Rules';

  @override
  String get validationPasswordWeak => 'Password must contain at least one letter or symbol';

  @override
  String get userGuideTitle => 'User Guide';

  @override
  String get welcomeTitle => 'Welcome to Rasikh 🌿';

  @override
  String get welcomeContent => 'This app is designed to be your smart companion in memorizing the Holy Quran. Our goal is not just memorization, but true mastery.\n\nWe believe in integration, so you can follow your daily portion through the app or the website.';

  @override
  String get visitWebsite => 'Visit our website';

  @override
  String get firstStepTitle => 'Step One: Choose Your Path';

  @override
  String get firstStepContent => 'We offer flexible plans that match your level and motivation.\nIf you didn’t choose a plan during registration, you can explore and select the most suitable one now.';

  @override
  String get goToMemorization => 'Go to memorization page';

  @override
  String get secondStepTitle => 'Step Two: Daily Portion';

  @override
  String get methodologyIntro => 'Rasikh’s secret lies in the triple methodology:';

  @override
  String get listen => 'Listen';

  @override
  String get listenDesc => 'Correct recitation';

  @override
  String get read => 'Read';

  @override
  String get readDesc => 'With focus and reflection';

  @override
  String get write => 'Write';

  @override
  String get writeDesc => 'To reinforce memorization';

  @override
  String get progressTitle => 'Step Three: Track Progress';

  @override
  String get progressContent => 'Your effort is never lost. Every completed day is recorded so you always know where you stand.';

  @override
  String get viewArchive => 'View archive';

  @override
  String get reviewTitle => 'Review & Reinforcement';

  @override
  String get reviewContent => 'Memorization is capital, and review is the profit.\n• Review: A dedicated page to help you stay reminded.\n• Connection: To ensure coherence between verses and surahs.';

  @override
  String get masteryTitle => 'Understanding & Mastery';

  @override
  String get masteryContent => 'Make memorization meaningful through understanding:\n• Tajweed.\n• Tafsir.\n• The Holy Mushaf.';

  @override
  String get footerMessage => 'May Allah grant you success in what He loves and is pleased with';

  @override
  String get tabReview => 'Review';

  @override
  String get goToTajweed => 'Go to Tajweed page';

  @override
  String get goToQuran => 'Go to Quran page';

  @override
  String get goToTafsir => 'Go to Tafsir page';

  @override
  String get goToMushaf => 'Go to Mushaf page';

  @override
  String get memrizationPlans => 'Memorization plan';

  @override
  String get mushafTab => 'Mushaf';

  @override
  String get planCompletionTitle => 'Plan completion';

  @override
  String get completionStatTitle => 'Completion';

  @override
  String get linkedVersesStatTitle => 'Linked verses';

  @override
  String get reviewedVersesStatTitle => 'Reviewed verses';

  @override
  String get totalPartsStatTitle => 'Total parts';

  @override
  String get performanceStatTitle => 'Performance';

  @override
  String get completedDaysStatTitle => 'Completed days';

  @override
  String get completedDaysLabel => 'Completed days';

  @override
  String get daysUnit => 'day';

  @override
  String get performanceStatUnit => 'pts';

  @override
  String get motivationLabel => 'Motivation';

  @override
  String get progressLabel => 'Your progress';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get notClassifiedLabel => 'Unclassified';

  @override
  String get reviewScreenTitle => 'Review';

  @override
  String get reviewEmptyTitle => 'No reviews right now';

  @override
  String get reviewEmptySubtitle => 'Complete memorization and your review plans will appear here automatically.';

  @override
  String reviewDueCount(int count) {
    return '$count review day(s) due';
  }

  @override
  String get reviewNoReviewTitle => 'No review available';

  @override
  String get reviewNoReviewSubtitle => 'This plan currently has no review tasks.';

  @override
  String get reviewVersesUnavailable => 'Unable to show review verses (review range is incomplete).';

  @override
  String get reviewSheetTitlePrefix => 'Review';

  @override
  String get listenButton => 'Listen';

  @override
  String get reviewDoneButton => 'Reviewed';

  @override
  String get linkScreenTitle => 'Linking';

  @override
  String linkDueCount(int count) {
    return '$count linking tasks due';
  }

  @override
  String get linkEmptyTitle => 'No linking tasks';

  @override
  String get linkEmptySubtitle => 'No linking tasks were configured for this period.';

  @override
  String get linkNoLinkTitle => 'No linking available';

  @override
  String get linkNoLinkSubtitle => 'This day has no linking task as configured for this plan.';

  @override
  String get linkVersesUnavailable => 'Unable to show linking verses (link range is incomplete).';

  @override
  String get linkSheetTitlePrefix => 'Link';

  @override
  String get linkDoneButton => 'Linked';

  @override
  String get validationGmailOnlyEmail => 'Please enter a valid email address ending with @gmail.com';

  @override
  String get planInProgress => 'In progress';

  @override
  String get planCompleted => 'Completed';

  @override
  String get planLockedHint => 'Locked - complete the previous plan';

  @override
  String get tapToStart => 'Tap to start';

  @override
  String planSwitchedTo(String planName) {
    return 'Switched to: $planName';
  }

  @override
  String get planMustCompleteToUnlock => 'Sorry, you must complete the current plan to unlock this one.';

  @override
  String get mainSection => 'Main';

  @override
  String get preferences => 'Preferences';

  @override
  String get supportSection => 'Support';

  @override
  String get accountSection => 'Account';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get quranGreeting => 'Let the Quran be your constant companion';

  @override
  String get contactTypeComplaint => 'Complaint';

  @override
  String get contactTypeNote => 'Note';

  @override
  String get contactTypeIdea => 'Ideas';

  @override
  String get contactTypeInquiry => 'Inquiry';

  @override
  String get dialogSuccessTitle => 'Sent Successfully';

  @override
  String get dialogSuccessContent => 'Thank you for contacting us. Your message has been received, and our team will reply to you soon via Email, WhatsApp, or Phone call if necessary.';

  @override
  String get dialogButtonOk => 'OK';

  @override
  String get dailyAchievementTitle => 'Daily Achievement';

  @override
  String get dailyAchievementSubtitle => 'Continued memorization leads to completing the Book of Allah regularly.';

  @override
  String get dailyTipTitle => 'Tip of the Day';

  @override
  String get dailyTipSubtitle => 'The best among you are those who learn the Quran and teach it.';

  @override
  String get dailyPlanTitle => 'Current Plan';

  @override
  String get dailyPlanSubtitle => 'Follow your progress in the set plan to ensure firm memorization.';

  @override
  String get numberOfVerses => 'Number of Verses';

  @override
  String get numberOfPages => 'Number of Pages';

  @override
  String get dailyAverage => 'Daily Average';

  @override
  String get performance => 'Performance';

  @override
  String get performanceGood => 'Good';

  @override
  String get currentPlanImportanceTitle => 'Current Plan: ';

  @override
  String mistakesWarning(int count) {
    return '⚠️ You have $count mistakes. Please review words in red and correct them to proceed.';
  }

  @override
  String get correctionMismatchError => 'Word does not match the required detail, please try again';

  @override
  String correctionTitle(int current, int total) {
    return 'Correction ($current/$total)';
  }

  @override
  String get actualWordLabel => 'Actual Word';

  @override
  String correctionDetailLabel(String detail) {
    return 'Detail: $detail';
  }

  @override
  String get correctionHintText => 'Type the word here...';

  @override
  String get checkButton => 'Check';

  @override
  String get writingSuccessSaving => 'Writing successful ✅ Saving...';

  @override
  String get warningTitle => 'Warning';

  @override
  String get exitWarningMessage => 'You haven\'t finished writing yet. Do you want to exit and lose current progress?';

  @override
  String get continueButton => 'Continue';

  @override
  String get exitAnywayButton => 'Exit Anyway';

  @override
  String get completeWritingWarning => '⚠️ Please complete writing the verses first to fix memorization.';

  @override
  String repetitionRemainingWarning(int count, int total) {
    return '⚠️ You have $count more repetitions (required $total).';
  }

  @override
  String listeningRemainingWarning(int count, int total) {
    return '⚠️ You have $count more listenings (required $total).';
  }

  @override
  String get recordingPlanCompletion => 'Recording plan completion...';

  @override
  String get planCompletionSuccess => 'Congratulations! Today\'s portion completed successfully 🎉';

  @override
  String savingError(String error) {
    return 'Error while saving: $error';
  }

  @override
  String get listeningCompletedSuccess => 'Full listening recorded ✅';

  @override
  String get planCompletedCongrats => 'MashaAllah! You have completed the plan successfully';

  @override
  String get duaMessage => 'May Allah make the Quran a light for you in this world and the hereafter ✨';

  @override
  String get chooseNextStep => 'Choose your next step:';

  @override
  String get allPlansCompleted => 'Well done! You have completed all available plans.';

  @override
  String get failedToLoadPlans => 'Failed to load plans';

  @override
  String failedToLoadPlansWithError(String error) {
    return 'Failed to load plans: $error';
  }

  @override
  String failedToSwitchPlan(String error) {
    return 'Failed to change plan: $error';
  }

  @override
  String get failedToSwitchPlanTryLater => 'Failed to switch plan. Please try again later.';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get guestModeTitle => 'Login Required';

  @override
  String get guestModeMessage => 'Please login to access this feature';

  @override
  String get cancel => 'Cancel';

  @override
  String get loginScreenSubtitle => 'Login to continue and benefit from all the features of the app';

  @override
  String get choosePlanOptional => 'Choose a plan (Optional)';

  @override
  String get defaultPlanWillBeUsed => 'Default plan will be used';

  @override
  String get doYouHaveAccount => 'Do you have an account?';

  @override
  String get emptyPlanMessage => 'Sorry, this plan is currently empty';

  @override
  String get emptyPlanSubmessage => 'No daily tasks have been added to this plan yet. You can choose another plan to start.';

  @override
  String get availablePlansLabel => 'Available Plans:';

  @override
  String get noOtherPlansAvailable => 'No other plans available currently.';

  @override
  String get failedToLoadData => 'Error loading data';

  @override
  String get registerHelpNote => 'Quick note before trying again';

  @override
  String get registerHelpDescription => 'The error might be because the phone number or email is already in use.\nVerify your data, or log in if you already have an account.';

  @override
  String get userGuide => 'User Guide';

  @override
  String get loginRequiredTitle => 'Login Required';

  @override
  String get loginRequiredMessage => 'Please login to access this feature';

  @override
  String get reportsGuestMessage => 'Sorry, you cannot view memorization reports in guest mode. Please login to continue.';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountWarning => 'Are you sure you want to delete your account?';

  @override
  String get deleteAccountConfirmButton => 'Delete';

  @override
  String get deleteAccountCancel => 'Cancel';

  @override
  String get deleteAccountSuccess => 'Account deleted successfully';

  @override
  String deleteAccountFailed(String error) {
    return 'Failed to delete account: $error';
  }
}
