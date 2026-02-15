import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Rasikh'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rasikh App'**
  String get homeWelcome;

  /// No description provided for @goTosettings.
  ///
  /// In en, this message translates to:
  /// **'Go to settings'**
  String get goTosettings;

  /// Drawer item for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// Welcome message in the drawer header
  ///
  /// In en, this message translates to:
  /// **'Welcome 👋'**
  String get welcomeMessage;

  /// Drawer item for the home page
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePage;

  /// Drawer item for contact us page
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Drawer item for logging out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// App version display in the drawer footer
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get appVersion;

  /// The title for the language selection menu
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// The English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// The Arabic language option
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// Title for the Resources Hub screen
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resourcesHubTitle;

  /// Label for the Tafsir and Tadabbur tab
  ///
  /// In en, this message translates to:
  /// **'Tafsir & Tadabbur'**
  String get tafsirAndTadabburTab;

  /// Label for the Tajweed rules tab
  ///
  /// In en, this message translates to:
  /// **'Tajweed'**
  String get tajweedTab;

  /// Title for the tafsir detail screen, showing verse number and surah name.
  ///
  /// In en, this message translates to:
  /// **'Tafsir of Ayah {verseNumber} from Surah {surahName}'**
  String tafsirDetailTitle(int verseNumber, String surahName);

  /// A label indicating the start of the tafsir text.
  ///
  /// In en, this message translates to:
  /// **'Tafsir:'**
  String get tafsirLabel;

  /// Hint text for the Surah name dropdown.
  ///
  /// In en, this message translates to:
  /// **'Search by Surah name'**
  String get searchBySurahNameHint;

  /// Hint text for the verse number search field.
  ///
  /// In en, this message translates to:
  /// **'Search by Ayah number'**
  String get searchByVerseNumberHint;

  /// Label for the Surah name in a search result card.
  ///
  /// In en, this message translates to:
  /// **'Surah {surahName}'**
  String surahNameLabel(String surahName);

  /// Label for the verse number in a search result card.
  ///
  /// In en, this message translates to:
  /// **'Ayah {verseNumber}'**
  String verseNumberLabel(int verseNumber);

  /// Button text to navigate to the detailed tafsir screen.
  ///
  /// In en, this message translates to:
  /// **'View Tafsir'**
  String get viewTafsirButton;

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'Example:'**
  String get example;

  /// App bar title for the certificate screen
  ///
  /// In en, this message translates to:
  /// **'Certificate of Appreciation'**
  String get certificateScreenTitle;

  /// Label for the PDF download button
  ///
  /// In en, this message translates to:
  /// **'Download as PDF'**
  String get downloadAsPdfButton;

  /// The main title on the certificate itself.
  ///
  /// In en, this message translates to:
  /// **'Certificate for Memorizing {courseName}'**
  String certificateTitle(String courseName);

  /// A line of text indicating who the certificate is for
  ///
  /// In en, this message translates to:
  /// **'This certificate is presented to:'**
  String get certificatePresentedTo;

  /// The congratulatory message on the certificate
  ///
  /// In en, this message translates to:
  /// **'May Allah bless you and make your memorization of the Quran a light for you in this life and the hereafter.'**
  String get certificateBlessing;

  /// The signature line label on the certificate
  ///
  /// In en, this message translates to:
  /// **'Signature ___________________ '**
  String get signatureLabel;

  /// Title for a certificate in a list view.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Completion for Part {partNumber}'**
  String certificateCompletionTitle(int partNumber);

  /// Label showing the issue date of a certificate.
  ///
  /// In en, this message translates to:
  /// **'Issue Date: {date}'**
  String certificateIssueDate(String date);

  /// Message displayed when the user has no certificates.
  ///
  /// In en, this message translates to:
  /// **'No Certificates Found'**
  String get noCertificatesFound;

  /// App bar title for the performance tracking screen
  ///
  /// In en, this message translates to:
  /// **'Performance Tracking'**
  String get performanceTrackingTitle;

  /// Label for the Reports tab
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTab;

  /// Label for the Certificates tab
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificatesTab;

  /// Label introducing a hadith
  ///
  /// In en, this message translates to:
  /// **'The Messenger of Allah ﷺ said:'**
  String get prophetSaidLabel;

  /// Title for the stats section
  ///
  /// In en, this message translates to:
  /// **'Memorization Report'**
  String get memorizationReportTitle;

  /// Title for the saved verses stat card
  ///
  /// In en, this message translates to:
  /// **'Memorized Verses'**
  String get savedVersesStatTitle;

  /// Unit for the saved verses stat card
  ///
  /// In en, this message translates to:
  /// **'verse'**
  String get savedVersesStatUnit;

  /// Title for the saved pages stat card
  ///
  /// In en, this message translates to:
  /// **'Memorized Pages'**
  String get savedPagesStatTitle;

  /// Unit for the saved pages stat card
  ///
  /// In en, this message translates to:
  /// **'page'**
  String get savedPagesStatUnit;

  /// Title for the saved Juz' stat card
  ///
  /// In en, this message translates to:
  /// **'Memorized Juz\''**
  String get savedJuzStatTitle;

  /// Unit for the saved Juz' stat card
  ///
  /// In en, this message translates to:
  /// **'Juz\''**
  String get savedJuzStatUnit;

  /// Title for the daily average stat card
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverageStatTitle;

  /// Unit for the daily average stat card
  ///
  /// In en, this message translates to:
  /// **'verses'**
  String get dailyAverageStatUnit;

  /// No description provided for @profileScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileScreenTitle;

  /// No description provided for @personalInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformationTitle;

  /// No description provided for @addressInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get addressInformationTitle;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @middleNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get middleNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile: {error}'**
  String profileLoadError(String error);

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @editProfileDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Personal Information'**
  String get editProfileDialogTitle;

  /// No description provided for @firstNameFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameFormFieldLabel;

  /// No description provided for @middleNameFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get middleNameFormFieldLabel;

  /// No description provided for @lastNameFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameFormFieldLabel;

  /// No description provided for @emailFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailFormFieldLabel;

  /// No description provided for @phoneFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get phoneFormFieldLabel;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @validationEmptyFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get validationEmptyFirstName;

  /// No description provided for @validationInvalidNameFormat.
  ///
  /// In en, this message translates to:
  /// **'Name must contain letters only'**
  String get validationInvalidNameFormat;

  /// No description provided for @validationEmptyMiddleName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your middle name'**
  String get validationEmptyMiddleName;

  /// No description provided for @validationEmptyLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get validationEmptyLastName;

  /// No description provided for @validationEmptyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get validationEmptyEmail;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationInvalidEmail;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid mobile number'**
  String get invalidPhoneNumber;

  /// No description provided for @changePasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordDialogTitle;

  /// No description provided for @oldPasswordFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPasswordFormFieldLabel;

  /// No description provided for @newPasswordFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordFormFieldLabel;

  /// No description provided for @confirmNewPasswordFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPasswordFormFieldLabel;

  /// No description provided for @validationEmptyOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your old password'**
  String get validationEmptyOldPassword;

  /// No description provided for @validationEmptyNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter the new password'**
  String get validationEmptyNewPassword;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsDoNotMatch;

  /// No description provided for @editAddressDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddressDialogTitle;

  /// No description provided for @countryFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryFormFieldLabel;

  /// No description provided for @cityFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityFormFieldLabel;

  /// No description provided for @addressDetailsFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get addressDetailsFormFieldLabel;

  /// No description provided for @validationEmptyCountry.
  ///
  /// In en, this message translates to:
  /// **'Please enter the country'**
  String get validationEmptyCountry;

  /// No description provided for @validationEmptyCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter the city'**
  String get validationEmptyCity;

  /// No description provided for @validationEmptyAddressDetails.
  ///
  /// In en, this message translates to:
  /// **'Please enter address details'**
  String get validationEmptyAddressDetails;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Information updated successfully'**
  String get profileUpdateSuccess;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String profileUpdateFailed(String error);

  /// No description provided for @passwordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordUpdateSuccess;

  /// No description provided for @oldPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Old password is incorrect'**
  String get oldPasswordIncorrect;

  /// No description provided for @addressUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get addressUpdateSuccess;

  /// No description provided for @apiConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout with server.'**
  String get apiConnectionTimeout;

  /// No description provided for @apiBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request. Please check your input.'**
  String get apiBadRequest;

  /// No description provided for @apiUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Incorrect login credentials.'**
  String get apiUnauthorized;

  /// No description provided for @apiNotFound.
  ///
  /// In en, this message translates to:
  /// **'Requested resource not found.'**
  String get apiNotFound;

  /// No description provided for @apiPhoneNumberExists.
  ///
  /// In en, this message translates to:
  /// **'Phone number already exists.'**
  String get apiPhoneNumberExists;

  /// No description provided for @apiServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error, please try again later.'**
  String get apiServerError;

  /// Error message with status code
  ///
  /// In en, this message translates to:
  /// **'Unexpected error: {statusCode}'**
  String apiUnexpectedErrorWithCode(String statusCode);

  /// No description provided for @apiRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled.'**
  String get apiRequestCancelled;

  /// No description provided for @apiNoInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get apiNoInternetConnection;

  /// No description provided for @apiUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred.'**
  String get apiUnknownError;

  /// No description provided for @apiUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred, please try again.'**
  String get apiUnexpectedError;

  /// No description provided for @apiOldPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The old password is incorrect.'**
  String get apiOldPasswordIncorrect;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back 👋'**
  String get welcomeBack;

  /// No description provided for @loginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and password to login'**
  String get loginPrompt;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @validationEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get validationEnterPhoneNumber;

  /// No description provided for @validationEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get validationEnterPassword;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordButton;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get registerTitle;

  /// No description provided for @stepBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get stepBasicInfo;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get stepDetails;

  /// No description provided for @registerWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome 👋'**
  String get registerWelcome;

  /// No description provided for @registerWelcomeSub.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start with some basic information to create your profile.'**
  String get registerWelcomeSub;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Last Step! 🚀'**
  String get step2Title;

  /// No description provided for @step2Sub.
  ///
  /// In en, this message translates to:
  /// **'Help us customize your experience with these details.'**
  String get step2Sub;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @validationCountryRequired.
  ///
  /// In en, this message translates to:
  /// **'Country is required'**
  String get validationCountryRequired;

  /// No description provided for @planSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you prefer to memorize?'**
  String get planSelectionTitle;

  /// No description provided for @planSelfPaced.
  ///
  /// In en, this message translates to:
  /// **'Self-Paced'**
  String get planSelfPaced;

  /// No description provided for @planSelfPacedSub.
  ///
  /// In en, this message translates to:
  /// **'Memorize alone and review whenever I want'**
  String get planSelfPacedSub;

  /// No description provided for @planGroup.
  ///
  /// In en, this message translates to:
  /// **'Memorization Circle'**
  String get planGroup;

  /// No description provided for @planGroupSub.
  ///
  /// In en, this message translates to:
  /// **'Join a group for encouragement'**
  String get planGroupSub;

  /// No description provided for @planTutor.
  ///
  /// In en, this message translates to:
  /// **'Private Tutor (Online)'**
  String get planTutor;

  /// No description provided for @planTutorSub.
  ///
  /// In en, this message translates to:
  /// **'Close follow-up with a teacher'**
  String get planTutorSub;

  /// No description provided for @validationPlanRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a memorization plan'**
  String get validationPlanRequired;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get registerSuccess;

  /// No description provided for @createAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountAction;

  /// No description provided for @loginOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s dive into your account'**
  String get loginOptionsTitle;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @loginWithApple.
  ///
  /// In en, this message translates to:
  /// **'Login with Apple'**
  String get loginWithApple;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get orDivider;

  /// No description provided for @loginWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginWithPhone;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordHeading.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordHeading;

  /// No description provided for @forgotPasswordSub.
  ///
  /// In en, this message translates to:
  /// **'If you are having trouble remembering the correct email, please contact support for assistance.'**
  String get forgotPasswordSub;

  /// No description provided for @enterEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmailLabel;

  /// No description provided for @startNowButton.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startNowButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get backButton;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get otpTitle;

  /// No description provided for @otpMessage.
  ///
  /// In en, this message translates to:
  /// **'An activation code has been sent to your email. Please check and copy the code.'**
  String get otpMessage;

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'Activation Code'**
  String get otpLabel;

  /// No description provided for @validationEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code'**
  String get validationEnterCode;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get passwordResetSuccess;

  /// No description provided for @finishButton.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishButton;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validationEmail;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validationPasswordLength;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMismatch;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of the account?'**
  String get logoutConfirmationMessage;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully.'**
  String get logoutSuccess;

  /// No description provided for @logoutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out of your account?'**
  String get logoutQuestion;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed: {error}'**
  String logoutFailed(String error);

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rasikh'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSub1.
  ///
  /// In en, this message translates to:
  /// **'Your smart way to memorize the Quran and consolidate it in an organized and effective manner.'**
  String get onboardingSub1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Flexible Plans'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSub2.
  ///
  /// In en, this message translates to:
  /// **'Choose the plan that suits your time and level, and track your progress day by day easily.'**
  String get onboardingSub2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Smart Review & Quizzes'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSub3.
  ///
  /// In en, this message translates to:
  /// **'A comprehensive review system helping you consolidate memorization, with tests to measure your mastery.'**
  String get onboardingSub3;

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButton;

  /// No description provided for @validationEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the name'**
  String get validationEnterName;

  /// No description provided for @validationNameThreeParts.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least a full name (three parts)'**
  String get validationNameThreeParts;

  /// No description provided for @validationNameCharsOnly.
  ///
  /// In en, this message translates to:
  /// **'Name must contain letters only'**
  String get validationNameCharsOnly;

  /// No description provided for @validationValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validationValidEmail;

  /// No description provided for @validationEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get validationEnterPhone;

  /// No description provided for @validationInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get validationInvalidPhone;

  /// No description provided for @validationFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter {fieldName}'**
  String validationFieldRequired(String fieldName);

  /// No description provided for @cameraOption.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraOption;

  /// No description provided for @galleryOption.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get galleryOption;

  /// No description provided for @cancelOption.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelOption;

  /// No description provided for @cropImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get cropImageTitle;

  /// No description provided for @cropImageDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get cropImageDone;

  /// No description provided for @cropImageCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cropImageCancel;

  /// No description provided for @changePhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhotoAction;

  /// No description provided for @contactUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUsTitle;

  /// No description provided for @contactUsHeader.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUsHeader;

  /// No description provided for @contactInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Feel free to contact us anytime'**
  String get contactInfoTitle;

  /// No description provided for @contactInfoSub.
  ///
  /// In en, this message translates to:
  /// **'We will reply as soon as possible'**
  String get contactInfoSub;

  /// No description provided for @contactTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Choose contact type'**
  String get contactTypeHint;

  /// No description provided for @contactTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Inquiry'**
  String get contactTypeGeneral;

  /// No description provided for @contactTypeTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical Complaint'**
  String get contactTypeTechnical;

  /// No description provided for @contactTypeSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Development Suggestion'**
  String get contactTypeSuggestion;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get messageLabel;

  /// No description provided for @validationMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your message'**
  String get validationMessageRequired;

  /// No description provided for @sendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendButton;

  /// No description provided for @messageSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent successfully'**
  String get messageSentSuccess;

  /// No description provided for @validationFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please make sure to fill all required fields ⚠️'**
  String get validationFillAllFields;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Rasikh'**
  String get dashboardTitle;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}!'**
  String welcomeUser(String userName);

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your journey with the Quran continues steadily!'**
  String get welcomeSubtitle;

  /// No description provided for @quoteText.
  ///
  /// In en, this message translates to:
  /// **'Always remember: every verse you memorize raises you a degree, and every effort you make in memorization is a step towards light and blessing. Keep going, we are with you every step of the way!'**
  String get quoteText;

  /// No description provided for @aboutUsTitle.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUsTitle;

  /// No description provided for @aboutUsContent.
  ///
  /// In en, this message translates to:
  /// **'Rasikh is a high-level Quranic program aimed at writing, memorizing, listening, reviewing, and linking each section of the curriculum to be memorized, and indicating the student\'s achievement level for all of that.\nIt aims to help male and female students around the world memorize the Holy Quran in an organized and effective manner, by providing an integrated system that combines paper plans and digital training.'**
  String get aboutUsContent;

  /// No description provided for @completedParts.
  ///
  /// In en, this message translates to:
  /// **'You have completed so far {count} of the Quran Juz\''**
  String completedParts(int count);

  /// No description provided for @progressGood.
  ///
  /// In en, this message translates to:
  /// **'Advanced & Good Level'**
  String get progressGood;

  /// No description provided for @progressNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get progressNeedsImprovement;

  /// No description provided for @progressNeedsIntensiveReview.
  ///
  /// In en, this message translates to:
  /// **'Needs Intensive Review'**
  String get progressNeedsIntensiveReview;

  /// No description provided for @nextTarget.
  ///
  /// In en, this message translates to:
  /// **'🌟 Next Target: {targetName}'**
  String nextTarget(String targetName);

  /// No description provided for @startMemorizingButton.
  ///
  /// In en, this message translates to:
  /// **'Start Memorizing'**
  String get startMemorizingButton;

  /// No description provided for @studentNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Student Name'**
  String get studentNamePlaceholder;

  /// No description provided for @nextPartOrSurah.
  ///
  /// In en, this message translates to:
  /// **'Next Part/Surah'**
  String get nextPartOrSurah;

  /// No description provided for @welcomeToRasikh.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rasikh'**
  String get welcomeToRasikh;

  /// No description provided for @failedToLoadStatistics.
  ///
  /// In en, this message translates to:
  /// **'Failed to load statistics: {error}'**
  String failedToLoadStatistics(Object error);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMemorization.
  ///
  /// In en, this message translates to:
  /// **'Memorization'**
  String get navMemorization;

  /// No description provided for @navPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get navPerformance;

  /// No description provided for @navUnderstanding.
  ///
  /// In en, this message translates to:
  /// **'Understanding'**
  String get navUnderstanding;

  /// No description provided for @archiveScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveScreenTitle;

  /// No description provided for @planNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'3 Months Plan'**
  String get planNamePlaceholder;

  /// No description provided for @archiveLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load archive: {error}'**
  String archiveLoadError(String error);

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get statusIncomplete;

  /// No description provided for @detailMemorization.
  ///
  /// In en, this message translates to:
  /// **'Memorization'**
  String get detailMemorization;

  /// No description provided for @detailReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get detailReview;

  /// No description provided for @detailRepetition.
  ///
  /// In en, this message translates to:
  /// **'Repetition'**
  String get detailRepetition;

  /// No description provided for @detailListening.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get detailListening;

  /// No description provided for @detailLinking.
  ///
  /// In en, this message translates to:
  /// **'Linking'**
  String get detailLinking;

  /// No description provided for @detailWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing Verses'**
  String get detailWriting;

  /// No description provided for @writingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get writingCompleted;

  /// No description provided for @writingNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Not Done'**
  String get writingNotCompleted;

  /// No description provided for @memorizationInputHintLearning.
  ///
  /// In en, this message translates to:
  /// **'Start typing...'**
  String get memorizationInputHintLearning;

  /// No description provided for @memorizationInputHintTesting.
  ///
  /// In en, this message translates to:
  /// **'Type the verses here to test your memorization...'**
  String get memorizationInputHintTesting;

  /// No description provided for @hintButton.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hintButton;

  /// No description provided for @planLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading plan: {error}'**
  String planLoadError(Object error);

  /// No description provided for @startWriting.
  ///
  /// In en, this message translates to:
  /// **'Start Writing'**
  String get startWriting;

  /// No description provided for @planTitlePrefix.
  ///
  /// In en, this message translates to:
  /// **'Plan: '**
  String get planTitlePrefix;

  /// No description provided for @fromSurah.
  ///
  /// In en, this message translates to:
  /// **'From Surah:'**
  String get fromSurah;

  /// No description provided for @fromAyah.
  ///
  /// In en, this message translates to:
  /// **'From Ayah:'**
  String get fromAyah;

  /// No description provided for @toAyah.
  ///
  /// In en, this message translates to:
  /// **'To Ayah:'**
  String get toAyah;

  /// No description provided for @reviewMode.
  ///
  /// In en, this message translates to:
  /// **'Review Mode'**
  String get reviewMode;

  /// No description provided for @memorizationMode.
  ///
  /// In en, this message translates to:
  /// **'Memorization Mode'**
  String get memorizationMode;

  /// No description provided for @startTypingBelow.
  ///
  /// In en, this message translates to:
  /// **'Start typing in the field below...'**
  String get startTypingBelow;

  /// No description provided for @repetitionLabel.
  ///
  /// In en, this message translates to:
  /// **'Repetition'**
  String get repetitionLabel;

  /// No description provided for @repetitionCount.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String repetitionCount(int current, int total);

  /// No description provided for @listenNow.
  ///
  /// In en, this message translates to:
  /// **'Listen Now'**
  String get listenNow;

  /// No description provided for @writingAndRecitation.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get writingAndRecitation;

  /// No description provided for @saveProgress.
  ///
  /// In en, this message translates to:
  /// **'Save Progress'**
  String get saveProgress;

  /// No description provided for @completeMemorization.
  ///
  /// In en, this message translates to:
  /// **'Complete Memorization'**
  String get completeMemorization;

  /// No description provided for @planHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Memorization Tracker'**
  String get planHubTitle;

  /// No description provided for @tabMemorizationPlan.
  ///
  /// In en, this message translates to:
  /// **'Memorization'**
  String get tabMemorizationPlan;

  /// No description provided for @tabLinking.
  ///
  /// In en, this message translates to:
  /// **'Linking'**
  String get tabLinking;

  /// No description provided for @tabArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get tabArchive;

  /// No description provided for @reviewBannerText.
  ///
  /// In en, this message translates to:
  /// **'Do not forget that review consolidates memorization, so make your daily routine balanced between progress and review.'**
  String get reviewBannerText;

  /// No description provided for @previousReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Previous Review'**
  String get previousReviewTitle;

  /// No description provided for @nextReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Next Review'**
  String get nextReviewTitle;

  /// No description provided for @linkingTitle.
  ///
  /// In en, this message translates to:
  /// **'Linking {surahName}'**
  String linkingTitle(String surahName);

  /// No description provided for @reviewButton.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewButton;

  /// No description provided for @linkButton.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkButton;

  /// No description provided for @fromSurahLabel.
  ///
  /// In en, this message translates to:
  /// **'From Surah:'**
  String get fromSurahLabel;

  /// No description provided for @fromAyahLabel.
  ///
  /// In en, this message translates to:
  /// **'From Ayah:'**
  String get fromAyahLabel;

  /// No description provided for @toAyahLabel.
  ///
  /// In en, this message translates to:
  /// **'To Ayah:'**
  String get toAyahLabel;

  /// No description provided for @noActivePlan.
  ///
  /// In en, this message translates to:
  /// **'No active memorization plan'**
  String get noActivePlan;

  /// No description provided for @apiNoActivePlan.
  ///
  /// In en, this message translates to:
  /// **'No memorization plan scheduled for today.'**
  String get apiNoActivePlan;

  /// No description provided for @errorNoPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'No Plan Today'**
  String get errorNoPlanTitle;

  /// No description provided for @errorNoInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get errorNoInternetTitle;

  /// No description provided for @errorGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get errorGeneralTitle;

  /// No description provided for @refreshButton.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshButton;

  /// No description provided for @stopListening.
  ///
  /// In en, this message translates to:
  /// **' Stop'**
  String get stopListening;

  /// No description provided for @errorLoadingSurahsList.
  ///
  /// In en, this message translates to:
  /// **'Error loading Surahs list'**
  String get errorLoadingSurahsList;

  /// No description provided for @failedToLoadCertificates.
  ///
  /// In en, this message translates to:
  /// **'Failed to load certificates: {errorMessage}'**
  String failedToLoadCertificates(Object errorMessage);

  /// No description provided for @notDefined.
  ///
  /// In en, this message translates to:
  /// **'Not Defined'**
  String get notDefined;

  /// No description provided for @noArchiveData.
  ///
  /// In en, this message translates to:
  /// **'No archive data yet'**
  String get noArchiveData;

  /// No description provided for @validationRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Please enter {fieldName}'**
  String validationRequiredField(String fieldName);

  /// No description provided for @validationEnterAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter your age'**
  String get validationEnterAge;

  /// No description provided for @validationAgeNumberOnly.
  ///
  /// In en, this message translates to:
  /// **'Age must be a valid integer number'**
  String get validationAgeNumberOnly;

  /// No description provided for @validationAgeRange.
  ///
  /// In en, this message translates to:
  /// **'Please enter a realistic age between 15 and 120'**
  String get validationAgeRange;

  /// No description provided for @failedToLoadCountries.
  ///
  /// In en, this message translates to:
  /// **'Failed to load countries'**
  String get failedToLoadCountries;

  /// No description provided for @searchCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a country'**
  String get searchCountryHint;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @openInWebSite.
  ///
  /// In en, this message translates to:
  /// **'Open in website'**
  String get openInWebSite;

  /// No description provided for @uploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading image...'**
  String get uploadingImage;

  /// No description provided for @imageUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile image updated successfully'**
  String get imageUploadSuccess;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image: {error}'**
  String imageUploadFailed(String error);

  /// No description provided for @soryFailedToLoadReport.
  ///
  /// In en, this message translates to:
  /// **'Sorry, failed to load report'**
  String get soryFailedToLoadReport;

  /// No description provided for @checkInternetThenRetry.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again'**
  String get checkInternetThenRetry;

  /// No description provided for @surahNumber.
  ///
  /// In en, this message translates to:
  /// **'Surah number'**
  String get surahNumber;

  /// No description provided for @noTafsirAvailableForNow.
  ///
  /// In en, this message translates to:
  /// **'No tafsir available for now.'**
  String get noTafsirAvailableForNow;

  /// No description provided for @selectedSurahName.
  ///
  /// In en, this message translates to:
  /// **'Al-Fatihah'**
  String get selectedSurahName;

  /// No description provided for @showAllAyahs.
  ///
  /// In en, this message translates to:
  /// **'Show all ayahs'**
  String get showAllAyahs;

  /// No description provided for @selectAyah.
  ///
  /// In en, this message translates to:
  /// **'Select ayah number'**
  String get selectAyah;

  /// No description provided for @ayahNumber.
  ///
  /// In en, this message translates to:
  /// **'Ayah number'**
  String get ayahNumber;

  /// No description provided for @noAyahFound.
  ///
  /// In en, this message translates to:
  /// **'No ayah found for this number in the current report'**
  String get noAyahFound;

  /// No description provided for @getCertificate.
  ///
  /// In en, this message translates to:
  /// **'Get Certificate'**
  String get getCertificate;

  /// No description provided for @failedToLoadCertificate.
  ///
  /// In en, this message translates to:
  /// **'Failed to load certificate'**
  String get failedToLoadCertificate;

  /// No description provided for @certificateNotIssued.
  ///
  /// In en, this message translates to:
  /// **'Certificate not issued yet, please try again later'**
  String get certificateNotIssued;

  /// No description provided for @numberOfSavedParts.
  ///
  /// In en, this message translates to:
  /// **'Number of saved parts'**
  String get numberOfSavedParts;

  /// No description provided for @startNowThenYouWillSucceedInshaAllah.
  ///
  /// In en, this message translates to:
  /// **'Start now and you will succeed inshaAllah!'**
  String get startNowThenYouWillSucceedInshaAllah;

  /// No description provided for @dateOfCompletion.
  ///
  /// In en, this message translates to:
  /// **'Date of Completion'**
  String get dateOfCompletion;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'No action needed'**
  String get completed;

  /// No description provided for @noPlanSelected.
  ///
  /// In en, this message translates to:
  /// **'No plan selected'**
  String get noPlanSelected;

  /// No description provided for @reviewLinkScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Linking'**
  String get reviewLinkScreenTitle;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something Went Wrong'**
  String get errorTitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'It looks like you\'re offline. Please check your internet connection and try again.'**
  String get errorNoInternet;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The connection took too long to respond. Please check your connection or try again later.'**
  String get errorTimeout;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please restart the application.'**
  String get errorUnknown;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'A problem occurred while loading the data.'**
  String get errorGeneric;

  /// Server error message with status code placeholder.
  ///
  /// In en, this message translates to:
  /// **'We encountered a server issue (Code: {statusCode}). Please try again shortly.'**
  String errorServerDown(int statusCode);

  /// No description provided for @errorOccurredTitle.
  ///
  /// In en, this message translates to:
  /// **'Error Occurred'**
  String get errorOccurredTitle;

  /// No description provided for @errorOccurredMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred in the app. Please check your internet connection and try again.'**
  String get errorOccurredMessage;

  /// No description provided for @tajweedRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Tajweed Rules'**
  String get tajweedRulesTitle;

  /// No description provided for @validationPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one letter or symbol'**
  String get validationPasswordWeak;

  /// No description provided for @userGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get userGuideTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rasikh 🌿'**
  String get welcomeTitle;

  /// No description provided for @welcomeContent.
  ///
  /// In en, this message translates to:
  /// **'This app is designed to be your smart companion in memorizing the Holy Quran. Our goal is not just memorization, but true mastery.\n\nWe believe in integration, so you can follow your daily portion through the app or the website.'**
  String get welcomeContent;

  /// No description provided for @visitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit our website'**
  String get visitWebsite;

  /// No description provided for @firstStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Step One: Choose Your Path'**
  String get firstStepTitle;

  /// No description provided for @firstStepContent.
  ///
  /// In en, this message translates to:
  /// **'We offer flexible plans that match your level and motivation.\nIf you didn’t choose a plan during registration, you can explore and select the most suitable one now.'**
  String get firstStepContent;

  /// No description provided for @goToMemorization.
  ///
  /// In en, this message translates to:
  /// **'Go to memorization page'**
  String get goToMemorization;

  /// No description provided for @secondStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Step Two: Daily Portion'**
  String get secondStepTitle;

  /// No description provided for @methodologyIntro.
  ///
  /// In en, this message translates to:
  /// **'Rasikh’s secret lies in the triple methodology:'**
  String get methodologyIntro;

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// No description provided for @listenDesc.
  ///
  /// In en, this message translates to:
  /// **'Correct recitation'**
  String get listenDesc;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @readDesc.
  ///
  /// In en, this message translates to:
  /// **'With focus and reflection'**
  String get readDesc;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @writeDesc.
  ///
  /// In en, this message translates to:
  /// **'To reinforce memorization'**
  String get writeDesc;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Step Three: Track Progress'**
  String get progressTitle;

  /// No description provided for @progressContent.
  ///
  /// In en, this message translates to:
  /// **'Your effort is never lost. Every completed day is recorded so you always know where you stand.'**
  String get progressContent;

  /// No description provided for @viewArchive.
  ///
  /// In en, this message translates to:
  /// **'View archive'**
  String get viewArchive;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Reinforcement'**
  String get reviewTitle;

  /// No description provided for @reviewContent.
  ///
  /// In en, this message translates to:
  /// **'Memorization is capital, and review is the profit.\n• Review: A dedicated page to help you stay reminded.\n• Connection: To ensure coherence between verses and surahs.'**
  String get reviewContent;

  /// No description provided for @masteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Understanding & Mastery'**
  String get masteryTitle;

  /// No description provided for @masteryContent.
  ///
  /// In en, this message translates to:
  /// **'Make memorization meaningful through understanding:\n• Tajweed.\n• Tafsir.\n• The Holy Mushaf.'**
  String get masteryContent;

  /// No description provided for @footerMessage.
  ///
  /// In en, this message translates to:
  /// **'May Allah grant you success in what He loves and is pleased with'**
  String get footerMessage;

  /// No description provided for @tabReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get tabReview;

  /// No description provided for @goToTajweed.
  ///
  /// In en, this message translates to:
  /// **'Go to Tajweed page'**
  String get goToTajweed;

  /// No description provided for @goToQuran.
  ///
  /// In en, this message translates to:
  /// **'Go to Quran page'**
  String get goToQuran;

  /// No description provided for @goToTafsir.
  ///
  /// In en, this message translates to:
  /// **'Go to Tafsir page'**
  String get goToTafsir;

  /// No description provided for @goToMushaf.
  ///
  /// In en, this message translates to:
  /// **'Go to Mushaf page'**
  String get goToMushaf;

  /// No description provided for @memrizationPlans.
  ///
  /// In en, this message translates to:
  /// **'Memorization plan'**
  String get memrizationPlans;

  /// No description provided for @mushafTab.
  ///
  /// In en, this message translates to:
  /// **'Mushaf'**
  String get mushafTab;

  /// No description provided for @planCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan completion'**
  String get planCompletionTitle;

  /// No description provided for @completionStatTitle.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completionStatTitle;

  /// No description provided for @linkedVersesStatTitle.
  ///
  /// In en, this message translates to:
  /// **'Linked verses'**
  String get linkedVersesStatTitle;

  /// No description provided for @reviewedVersesStatTitle.
  ///
  /// In en, this message translates to:
  /// **'Reviewed verses'**
  String get reviewedVersesStatTitle;

  /// No description provided for @totalPartsStatTitle.
  ///
  /// In en, this message translates to:
  /// **'Total parts'**
  String get totalPartsStatTitle;

  /// No description provided for @performanceStatTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performanceStatTitle;

  /// No description provided for @completedDaysStatTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed days'**
  String get completedDaysStatTitle;

  /// No description provided for @completedDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed days'**
  String get completedDaysLabel;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get daysUnit;

  /// No description provided for @performanceStatUnit.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get performanceStatUnit;

  /// No description provided for @motivationLabel.
  ///
  /// In en, this message translates to:
  /// **'Motivation'**
  String get motivationLabel;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get progressLabel;

  /// No description provided for @reminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminderLabel;

  /// No description provided for @notClassifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Unclassified'**
  String get notClassifiedLabel;

  /// No description provided for @reviewScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewScreenTitle;

  /// No description provided for @reviewEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews right now'**
  String get reviewEmptyTitle;

  /// No description provided for @reviewEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete memorization and your review plans will appear here automatically.'**
  String get reviewEmptySubtitle;

  /// No description provided for @reviewDueCount.
  ///
  /// In en, this message translates to:
  /// **'{count} review day(s) due'**
  String reviewDueCount(int count);

  /// No description provided for @reviewNoReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'No review available'**
  String get reviewNoReviewTitle;

  /// No description provided for @reviewNoReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This plan currently has no review tasks.'**
  String get reviewNoReviewSubtitle;

  /// No description provided for @reviewVersesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to show review verses (review range is incomplete).'**
  String get reviewVersesUnavailable;

  /// No description provided for @reviewSheetTitlePrefix.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewSheetTitlePrefix;

  /// No description provided for @listenButton.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listenButton;

  /// No description provided for @reviewDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get reviewDoneButton;

  /// No description provided for @linkScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Linking'**
  String get linkScreenTitle;

  /// No description provided for @linkDueCount.
  ///
  /// In en, this message translates to:
  /// **'{count} linking tasks due'**
  String linkDueCount(int count);

  /// No description provided for @linkEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No linking tasks'**
  String get linkEmptyTitle;

  /// No description provided for @linkEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No linking tasks were configured for this period.'**
  String get linkEmptySubtitle;

  /// No description provided for @linkNoLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'No linking available'**
  String get linkNoLinkTitle;

  /// No description provided for @linkNoLinkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This day has no linking task as configured for this plan.'**
  String get linkNoLinkSubtitle;

  /// No description provided for @linkVersesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to show linking verses (link range is incomplete).'**
  String get linkVersesUnavailable;

  /// No description provided for @linkSheetTitlePrefix.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkSheetTitlePrefix;

  /// No description provided for @linkDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get linkDoneButton;

  /// No description provided for @validationGmailOnlyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address ending with @gmail.com'**
  String get validationGmailOnlyEmail;

  /// No description provided for @planInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get planInProgress;

  /// No description provided for @planCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get planCompleted;

  /// No description provided for @planLockedHint.
  ///
  /// In en, this message translates to:
  /// **'Locked - complete the previous plan'**
  String get planLockedHint;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to start'**
  String get tapToStart;

  /// No description provided for @planSwitchedTo.
  ///
  /// In en, this message translates to:
  /// **'Switched to: {planName}'**
  String planSwitchedTo(String planName);

  /// No description provided for @planMustCompleteToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you must complete the current plan to unlock this one.'**
  String get planMustCompleteToUnlock;

  /// No description provided for @mainSection.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mainSection;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportSection;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @quranGreeting.
  ///
  /// In en, this message translates to:
  /// **'Let the Quran be your constant companion'**
  String get quranGreeting;

  /// No description provided for @contactTypeComplaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get contactTypeComplaint;

  /// No description provided for @contactTypeNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get contactTypeNote;

  /// No description provided for @contactTypeIdea.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get contactTypeIdea;

  /// No description provided for @contactTypeInquiry.
  ///
  /// In en, this message translates to:
  /// **'Inquiry'**
  String get contactTypeInquiry;

  /// No description provided for @dialogSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Sent Successfully'**
  String get dialogSuccessTitle;

  /// No description provided for @dialogSuccessContent.
  ///
  /// In en, this message translates to:
  /// **'Thank you for contacting us. Your message has been received, and our team will reply to you soon via Email, WhatsApp, or Phone call if necessary.'**
  String get dialogSuccessContent;

  /// No description provided for @dialogButtonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogButtonOk;

  /// No description provided for @dailyAchievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Achievement'**
  String get dailyAchievementTitle;

  /// No description provided for @dailyAchievementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continued memorization leads to completing the Book of Allah regularly.'**
  String get dailyAchievementSubtitle;

  /// No description provided for @dailyTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Tip of the Day'**
  String get dailyTipTitle;

  /// No description provided for @dailyTipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The best among you are those who learn the Quran and teach it.'**
  String get dailyTipSubtitle;

  /// No description provided for @dailyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get dailyPlanTitle;

  /// No description provided for @dailyPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow your progress in the set plan to ensure firm memorization.'**
  String get dailyPlanSubtitle;

  /// No description provided for @numberOfVerses.
  ///
  /// In en, this message translates to:
  /// **'Number of Verses'**
  String get numberOfVerses;

  /// No description provided for @numberOfPages.
  ///
  /// In en, this message translates to:
  /// **'Number of Pages'**
  String get numberOfPages;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @performanceGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get performanceGood;

  /// No description provided for @currentPlanImportanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Plan: '**
  String get currentPlanImportanceTitle;

  /// No description provided for @mistakesWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ You have {count} mistakes. Please review words in red and correct them to proceed.'**
  String mistakesWarning(int count);

  /// No description provided for @correctionMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Word does not match the required detail, please try again'**
  String get correctionMismatchError;

  /// No description provided for @correctionTitle.
  ///
  /// In en, this message translates to:
  /// **'Correction ({current}/{total})'**
  String correctionTitle(int current, int total);

  /// No description provided for @actualWordLabel.
  ///
  /// In en, this message translates to:
  /// **'Actual Word'**
  String get actualWordLabel;

  /// No description provided for @correctionDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Detail: {detail}'**
  String correctionDetailLabel(String detail);

  /// No description provided for @correctionHintText.
  ///
  /// In en, this message translates to:
  /// **'Type the word here...'**
  String get correctionHintText;

  /// No description provided for @checkButton.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get checkButton;

  /// No description provided for @writingSuccessSaving.
  ///
  /// In en, this message translates to:
  /// **'Writing successful ✅ Saving...'**
  String get writingSuccessSaving;

  /// No description provided for @warningTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warningTitle;

  /// No description provided for @exitWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t finished writing yet. Do you want to exit and lose current progress?'**
  String get exitWarningMessage;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @exitAnywayButton.
  ///
  /// In en, this message translates to:
  /// **'Exit Anyway'**
  String get exitAnywayButton;

  /// No description provided for @completeWritingWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Please complete writing the verses first to fix memorization.'**
  String get completeWritingWarning;

  /// No description provided for @repetitionRemainingWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ You have {count} more repetitions (required {total}).'**
  String repetitionRemainingWarning(int count, int total);

  /// No description provided for @listeningRemainingWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ You have {count} more listenings (required {total}).'**
  String listeningRemainingWarning(int count, int total);

  /// No description provided for @recordingPlanCompletion.
  ///
  /// In en, this message translates to:
  /// **'Recording plan completion...'**
  String get recordingPlanCompletion;

  /// No description provided for @planCompletionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Today\'s portion completed successfully 🎉'**
  String get planCompletionSuccess;

  /// No description provided for @savingError.
  ///
  /// In en, this message translates to:
  /// **'Error while saving: {error}'**
  String savingError(String error);

  /// No description provided for @listeningCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Full listening recorded ✅'**
  String get listeningCompletedSuccess;

  /// No description provided for @planCompletedCongrats.
  ///
  /// In en, this message translates to:
  /// **'MashaAllah! You have completed the plan successfully'**
  String get planCompletedCongrats;

  /// No description provided for @duaMessage.
  ///
  /// In en, this message translates to:
  /// **'May Allah make the Quran a light for you in this world and the hereafter ✨'**
  String get duaMessage;

  /// No description provided for @chooseNextStep.
  ///
  /// In en, this message translates to:
  /// **'Choose your next step:'**
  String get chooseNextStep;

  /// No description provided for @allPlansCompleted.
  ///
  /// In en, this message translates to:
  /// **'Well done! You have completed all available plans.'**
  String get allPlansCompleted;

  /// No description provided for @failedToLoadPlans.
  ///
  /// In en, this message translates to:
  /// **'Failed to load plans'**
  String get failedToLoadPlans;

  /// No description provided for @failedToLoadPlansWithError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load plans: {error}'**
  String failedToLoadPlansWithError(String error);

  /// No description provided for @failedToSwitchPlan.
  ///
  /// In en, this message translates to:
  /// **'Failed to change plan: {error}'**
  String failedToSwitchPlan(String error);

  /// No description provided for @failedToSwitchPlanTryLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to switch plan. Please try again later.'**
  String get failedToSwitchPlanTryLater;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @guestModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get guestModeTitle;

  /// No description provided for @guestModeMessage.
  ///
  /// In en, this message translates to:
  /// **'Please login to access this feature'**
  String get guestModeMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loginScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to continue and benefit from all the features of the app'**
  String get loginScreenSubtitle;

  /// No description provided for @choosePlanOptional.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan (Optional)'**
  String get choosePlanOptional;

  /// No description provided for @defaultPlanWillBeUsed.
  ///
  /// In en, this message translates to:
  /// **'Default plan will be used'**
  String get defaultPlanWillBeUsed;

  /// No description provided for @doYouHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Do you have an account?'**
  String get doYouHaveAccount;

  /// No description provided for @emptyPlanMessage.
  ///
  /// In en, this message translates to:
  /// **'Sorry, this plan is currently empty'**
  String get emptyPlanMessage;

  /// No description provided for @emptyPlanSubmessage.
  ///
  /// In en, this message translates to:
  /// **'No daily tasks have been added to this plan yet. You can choose another plan to start.'**
  String get emptyPlanSubmessage;

  /// No description provided for @availablePlansLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Plans:'**
  String get availablePlansLabel;

  /// No description provided for @noOtherPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'No other plans available currently.'**
  String get noOtherPlansAvailable;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get failedToLoadData;

  /// No description provided for @registerHelpNote.
  ///
  /// In en, this message translates to:
  /// **'Quick note before trying again'**
  String get registerHelpNote;

  /// No description provided for @registerHelpDescription.
  ///
  /// In en, this message translates to:
  /// **'The error might be because the phone number or email is already in use.\nVerify your data, or log in if you already have an account.'**
  String get registerHelpDescription;

  /// No description provided for @userGuide.
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get userGuide;

  /// No description provided for @loginRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequiredTitle;

  /// No description provided for @loginRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please login to access this feature'**
  String get loginRequiredMessage;

  /// No description provided for @reportsGuestMessage.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you cannot view memorization reports in guest mode. Please login to continue.'**
  String get reportsGuestMessage;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountConfirmButton;

  /// No description provided for @deleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteAccountCancel;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {error}'**
  String deleteAccountFailed(String error);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
