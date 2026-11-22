// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get smallTextSize => 'Small';

  @override
  String get mediumTextSize => 'Medium';

  @override
  String get largeTextSize => 'Large';

  @override
  String get languageSystem => 'Follow system';

  @override
  String get languageIndonesian => 'Indonesian';

  @override
  String get languageEnglish => 'English';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'Follow system';

  @override
  String get timezonePickerTitle => 'Choose time zone';

  @override
  String timezoneChanged(Object timezone) {
    return 'Time zone changed to $timezone';
  }

  @override
  String get themePickerTitle => 'Choose theme';

  @override
  String themeChanged(Object theme) {
    return 'Theme changed to $theme';
  }

  @override
  String get themeSaveFailed => 'Could not save theme. Please try again.';

  @override
  String get textSizePickerTitle => 'Choose text size';

  @override
  String get textSizeSaveFailed =>
      'Could not save text size. Please try again.';

  @override
  String get languagePickerTitle => 'Choose language';

  @override
  String get languageSaveFailed => 'Could not save language. Please try again.';

  @override
  String get emailDetailsTitle => 'Email details';

  @override
  String get registeredEmail => 'Registered email:';

  @override
  String get verificationStatus => 'Verification status:';

  @override
  String get verified => 'Verified';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutConfirmation =>
      'Are you sure you want to log out of Go Finance?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logoutAction => 'Yes, log out';

  @override
  String get profileSettingsTitle => 'Profile & Settings';

  @override
  String get accountSection => 'Account';

  @override
  String get email => 'Email';

  @override
  String get timezone => 'Time zone';

  @override
  String get security => 'Security';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get theme => 'Theme';

  @override
  String get textSize => 'Text size';

  @override
  String get language => 'Language';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get transactionNotifications => 'Transaction notifications';

  @override
  String get transactionNotificationsEnabled =>
      'Transaction notifications enabled';

  @override
  String get transactionNotificationsDisabled =>
      'Transaction notifications disabled';

  @override
  String get savingsNotifications => 'Savings notifications';

  @override
  String get savingsNotificationsEnabled => 'Savings notifications enabled';

  @override
  String get savingsNotificationsDisabled => 'Savings notifications disabled';

  @override
  String get logoutFromAccount => 'Log out of account';

  @override
  String get home => 'Home';

  @override
  String get transactions => 'Transactions';

  @override
  String get savings => 'Savings';

  @override
  String get bills => 'Bills';

  @override
  String get scan => 'Scan';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profilePhoto => 'Profile photo';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String photoUploadSimulation(Object label) {
    return '$label (simulation) — photo upload is not available yet';
  }

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get changeProfilePhoto => 'Change profile photo';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter username';

  @override
  String get usernameRequired => 'Username cannot be empty';

  @override
  String usernameMinLength(int minimum) {
    return 'Username must be at least $minimum characters';
  }

  @override
  String get emailNotEditable => 'Email cannot be changed on this page';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get passwordChangedSimulation => 'Password changed (simulation)';

  @override
  String get changePassword => 'Change password';

  @override
  String get passwordGuidance =>
      'Use at least 8 characters with a combination of letters and numbers.';

  @override
  String get oldPassword => 'Old password';

  @override
  String get enterOldPassword => 'Enter old password';

  @override
  String get oldPasswordRequired => 'Old password is required';

  @override
  String get oldPasswordIncorrect => 'Old password is incorrect';

  @override
  String get newPassword => 'New password';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get newPasswordRequired => 'New password is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get passwordMustContainLettersAndNumbers =>
      'Password must contain letters and numbers';

  @override
  String get newPasswordMustDiffer =>
      'New password cannot match the old password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get repeatNewPassword => 'Repeat new password';

  @override
  String get passwordConfirmationRequired =>
      'Password confirmation is required';

  @override
  String get passwordConfirmationMismatch =>
      'Password confirmation does not match';

  @override
  String demoPasswordNotice(Object password) {
    return 'Demo mode: the dummy old password is \"$password\".';
  }

  @override
  String get savePassword => 'Save password';

  @override
  String get targetSavings => 'Savings Goals';

  @override
  String get createSavingsTargetTooltip => 'Create savings goal';

  @override
  String get activeTargets => 'Active Goals';

  @override
  String get startSavingTitle => 'Let\'s Start Saving!';

  @override
  String get savingEmptyMessage =>
      'Set a goal and save a little at a time — small steps toward a big dream.';

  @override
  String get createFirstSavings => 'Create Your First Savings Goal';

  @override
  String get totalSavings => 'Total Savings';

  @override
  String collectedFromTargets(int count) {
    return 'Collected across $count goals';
  }

  @override
  String targetReached(int percent) {
    return '$percent% reached';
  }

  @override
  String targetDate(Object date) {
    return 'Target: $date';
  }

  @override
  String savedAmountSummary(Object saved, Object target) {
    return '$saved of $target';
  }

  @override
  String get everyDay => 'Every day';

  @override
  String get everyWeek => 'Every week';

  @override
  String everyDays(int days) {
    return 'Every $days days';
  }

  @override
  String get savingHabitTitle => 'Build a saving habit';

  @override
  String get checkInNotDone => 'No check-in yet';

  @override
  String targetPrefix(Object interval) {
    return 'Goal: $interval';
  }

  @override
  String get monthlyActivity => 'This Month\'s Activity';

  @override
  String get noMonthlyCheckIn => 'No check-ins this month yet';

  @override
  String get targetCreationIncomplete =>
      'Complete the name, amount, and target date.';

  @override
  String get customIntervalInvalid =>
      'The custom interval must be between 1 and 365 days.';

  @override
  String get createSavingsTarget => 'Create Savings Goal';

  @override
  String get createNewGoal => 'Create a new goal';

  @override
  String get setGoalSchedule => 'Set your goal and saving schedule.';

  @override
  String get targetName => 'Goal Name';

  @override
  String get sampleLaptop => 'Example: Buy a Laptop';

  @override
  String get targetAmount => 'Target Amount';

  @override
  String get targetDateLabel => 'Target Date';

  @override
  String get chooseTargetDate => 'Choose target date';

  @override
  String get savingInterval => 'Saving Interval';

  @override
  String get chooseSavingFrequency => 'Choose how often you want to save.';

  @override
  String get oneDay => '1 Day';

  @override
  String get oneWeek => '1 Week';

  @override
  String get custom => 'Custom';

  @override
  String get every => 'Every';

  @override
  String get days => 'Days';

  @override
  String get customIntervalHint => 'Enter a number of days, such as 14 or 30.';

  @override
  String savingSchedule(Object interval) {
    return 'Saving schedule: $interval';
  }

  @override
  String get saveAnytime => 'You can still save at any time.';

  @override
  String get goalSummary => 'Goal Summary';

  @override
  String get target => 'Goal';

  @override
  String get schedule => 'Schedule';

  @override
  String get saveTargetButton => 'Save Goal';

  @override
  String get validAmount => 'Enter a valid amount!';

  @override
  String insufficientActiveBalance(Object amount) {
    return 'Insufficient active balance to save $amount!';
  }

  @override
  String depositSuccess(Object amount) {
    return '🎉 Saved $amount successfully! The balance is stored permanently.';
  }

  @override
  String get insufficientSavingsBalance =>
      'Insufficient savings balance to withdraw!';

  @override
  String withdrawSuccess(Object amount) {
    return 'Successfully withdrew $amount to your active balance!';
  }

  @override
  String get depositTitle => 'Deposit to Savings';

  @override
  String get withdrawTitle => 'Withdraw Savings';

  @override
  String get savingManageDescription =>
      'Manage your savings with permanent storage';

  @override
  String get depositTab => '+ Deposit';

  @override
  String get withdrawTab => '- Withdraw';

  @override
  String get activeBalance => 'Active Balance';

  @override
  String get savingsBalance => 'Savings Balance';

  @override
  String get amountCurrency => 'Amount (Rp)';

  @override
  String get optionalPurpose => 'Purpose / Note (Optional)';

  @override
  String get depositExample => 'Example: Buy a laptop, emergency fund';

  @override
  String get withdrawExample => 'Example: Urgent expense';

  @override
  String get savePermanently => 'Save Permanently';

  @override
  String get withdrawToActive => 'Withdraw to Active Balance';

  @override
  String get billCalendarTitle => 'Bills Calendar';

  @override
  String get addBillTooltip => 'Add bill';

  @override
  String get upcomingBills => 'Upcoming Bills';

  @override
  String get seeAll => 'See all';

  @override
  String get completedBillsFootnote =>
      'Bills marked as completed will be\nremoved from the list.';

  @override
  String noBillsForDate(Object date) {
    return 'No bills on $date';
  }

  @override
  String get noUpcomingBills => 'No upcoming bills';

  @override
  String get filteredBillsHint =>
      'Tap the same date or the button below to see all bills.';

  @override
  String get addBillHint =>
      'Add a new bill using the + button in the top-right corner.';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get overdue => 'OVERDUE';

  @override
  String get pending => 'PENDING';

  @override
  String dueDatePrefix(Object date) {
    return 'Due $date';
  }

  @override
  String get payNow => 'Pay now';

  @override
  String get markBillDoneTitle => 'Mark as completed?';

  @override
  String markBillDoneConfirmation(Object billName, Object amount) {
    return 'Mark \"$billName\" bill (Rp $amount) as completed? It will be removed from the list and its reminders will be canceled.';
  }

  @override
  String get markDone => 'Mark as completed';

  @override
  String overdueDays(int days) {
    return '$days days overdue';
  }

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String daysRemaining(int days) {
    return '$days days left';
  }

  @override
  String get addBillTitle => 'Add Bill';

  @override
  String get billAmount => 'Bill Amount';

  @override
  String get billName => 'Bill Name';

  @override
  String get billNameExample => 'E.g. Home internet, Electricity, Streaming';

  @override
  String get billDueDate => 'Due Date';

  @override
  String get chooseDueDate => 'Choose due date';

  @override
  String get billReminderInfo =>
      'Automatic reminders 7 days and 1 day before the due date.';

  @override
  String get checkInputAndSave => 'Check Input & Save';

  @override
  String get save => 'Save';

  @override
  String get billNameRequired => 'Bill name is required';

  @override
  String get billAmountMustBePositive => 'Amount must be greater than Rp 0';

  @override
  String get billDateRequired => 'Due date is required';

  @override
  String get billReminderChannel => 'Bill Reminders';

  @override
  String get billReminderChannelDescription =>
      'Bill reminders 7 days and 1 day before the due date';

  @override
  String billReminderTitle(Object billName) {
    return 'Bill $billName is due soon';
  }

  @override
  String billReminderBody(Object amount, Object date, Object remaining) {
    return 'Rp $amount is due $date ($remaining)';
  }

  @override
  String get homeInternetBill => 'Home internet';

  @override
  String get electricityBill => 'Electricity';

  @override
  String get streamingBill => 'Streaming';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get searchTransactions => 'Search transactions...';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get allCategories => 'All';

  @override
  String get foodAndDrinks => 'Food & Drinks';

  @override
  String get food => 'Food';

  @override
  String get shopping => 'Shopping';

  @override
  String get transportation => 'Transportation';

  @override
  String get transport => 'Transport';

  @override
  String get transfer => 'Transfer';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get other => 'Other';

  @override
  String get transactionFormIncomplete =>
      'Complete the category and amount first.';

  @override
  String get transactionCategory => 'Category';

  @override
  String get amount => 'Amount';

  @override
  String get transactionDate => 'Transaction date';

  @override
  String get optionalNote => 'Note (optional)';

  @override
  String get transactionEditableNote =>
      'You can edit this data later in the transaction history.';

  @override
  String get selectCategory => 'Choose a category';

  @override
  String get transactionNoteExample => 'Example: lunch money';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get chooseCategory => 'Choose Category';

  @override
  String get date => 'Date';

  @override
  String get type => 'Type';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get noTransactionsInPeriod =>
      'There are no transactions in this period yet.';

  @override
  String get continueButton => 'Continue';

  @override
  String get notifications => 'Notifications';

  @override
  String greeting(Object name) {
    return 'Hello, $name';
  }

  @override
  String get homeGreetingSubtitle => 'Let\'s manage your finances wisely.';

  @override
  String get manualEntry => 'Add Manually';

  @override
  String get payBill => 'Pay Bill';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get balanceCalculation => 'Income − expenses − savings deposits';

  @override
  String get monthlyAiEvaluation => 'This Month\'s Financial Review';

  @override
  String foodSpendingIncrease(int percent) {
    return 'Food spending increased $percent% from last month.';
  }

  @override
  String get aiSummaryHint => 'View AI summary and suggestions';

  @override
  String get lastSevenDays => 'Last 7 Days Summary';

  @override
  String get detail => 'Details';

  @override
  String chartIncome(Object day, Object amount) {
    return '$day: In Rp $amount';
  }

  @override
  String chartExpense(Object amount) {
    return 'Out Rp $amount';
  }

  @override
  String todayAt(Object time) {
    return 'Today · $time';
  }

  @override
  String get aiAnalysisTitle => 'Go Finance AI Analysis';

  @override
  String get aiBasedOnMonth => 'Based on this month\'s expenses';

  @override
  String get smartRecommendation => '💡 Smart Recommendation';

  @override
  String aiRecommendationBody(int percent, int times, Object amount) {
    return 'Food and drink spending is $percent% of this month\'s total expenses. Try limiting delivery orders to $times times a week to save around Rp $amount.';
  }

  @override
  String get viewTransactionDetails => 'View Transaction Details';

  @override
  String get billNotificationTitle => 'Internet Bill Due';

  @override
  String billNotificationDetails(Object date, Object amount) {
    return 'Due on $date for Rp $amount';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String get salaryNotificationTitle => 'Salary Received!';

  @override
  String salaryNotificationDetails(Object amount) {
    return 'Income of Rp $amount was recorded successfully.';
  }

  @override
  String get splashTagline => 'Manage today for a better tomorrow.';

  @override
  String get onboardingHeadline => 'Grow smarter,\nbecome wealthier';

  @override
  String get onboardingSubtitle =>
      'Your journey to better financial\nmanagement starts here!';

  @override
  String get welcomeBack => 'Welcome\nback!';

  @override
  String get loginSubtitle =>
      'Sign in to continue your journey\nwith Go Finance!';

  @override
  String get welcomeNew => 'Welcome!';

  @override
  String get registerSubtitle =>
      'Sign up to start your journey\nwith Go Finance!';

  @override
  String get emailFieldLabel => 'Email:';

  @override
  String get passwordFieldLabel => 'Password:';

  @override
  String get emailHint => 'name@email.com';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get login => 'Sign in';

  @override
  String get register => 'Sign up';

  @override
  String get existingAccountPrompt => 'Already have an account? ';

  @override
  String get noAccountPrompt => 'Don\'t have an account? ';

  @override
  String get passwordRecoveryMessage =>
      'A password recovery link will be sent to your email.';

  @override
  String get emailPasswordRequired => 'Email and password are required!';

  @override
  String get loginSuccess => 'Signed in successfully! Welcome to Go Finance.';

  @override
  String get registerSuccess => 'Account created successfully! Please sign in.';

  @override
  String get checkGithubUpdates => 'Check GitHub Updates';

  @override
  String get checkingGithubUpdates => 'Checking for GitHub updates...';

  @override
  String get checkingGithubUpdatesBanner =>
      'Checking for updates from GitHub...';

  @override
  String get updateAvailable => 'Update Available';

  @override
  String get newUpdateAvailable => 'New Update Available!';

  @override
  String get updateTag => 'UPDATE';

  @override
  String get updateAction => 'Update';

  @override
  String get justNow => 'Just now';

  @override
  String get latestCommitFallback => 'Latest update';

  @override
  String updateCommitByAuthor(Object message, Object author) {
    return '$message ($author)';
  }

  @override
  String get newLabel => 'NEW';

  @override
  String get latestGithubVersion => 'Latest version from GitHub repo';

  @override
  String get changeMessage => 'Change Message:';

  @override
  String get developer => 'Developer';

  @override
  String get githubTeam => 'GitHub Team';

  @override
  String get commit => 'Commit';

  @override
  String get time => 'Time';

  @override
  String get installerInstructions =>
      'When complete, the APK installer will open automatically.';

  @override
  String get apkSizeInfo =>
      'APK size: ~9.4 MB (Direct update without a browser)';

  @override
  String downloadingProgress(int percent) {
    return 'Downloading ($percent%)...';
  }

  @override
  String get directApkUpdate => 'Update directly in the APK (~9.4 MB)';

  @override
  String get browserDownload => 'Open in Browser';

  @override
  String get laterLogin => 'Not Now (Sign In)';

  @override
  String get updateFailed =>
      'Could not open the installer automatically. You can download it in a browser.';

  @override
  String get downloadPreparing => 'Preparing download...';

  @override
  String get downloadConnecting => 'Connecting to GitHub server...';

  @override
  String downloadFailedStatus(Object status) {
    return 'Download failed: status $status';
  }

  @override
  String downloadProgress(Object received, Object total, int percent) {
    return 'Downloading APK: $received MB / $total MB ($percent%)';
  }

  @override
  String get openingInstaller => 'Opening Android package installer...';

  @override
  String get receiptAnalysisTitle => 'Scan Receipt';

  @override
  String get uploadReceiptFile => 'Upload receipt file';

  @override
  String get receiptUploadInstructions => 'Choose a JPG or PNG receipt photo.';

  @override
  String get filePickerUnavailable =>
      'File picker will be available after integration.';

  @override
  String get selectedFile => 'Selected file';

  @override
  String get noFileSelected => 'No file selected';

  @override
  String get startAiAnalysis => 'Start OCR Scan';

  @override
  String get fileProcessingNotice =>
      'The photo is processed on this device and is not uploaded.';

  @override
  String get upload => 'Upload';

  @override
  String get review => 'Review';

  @override
  String get tapToUploadReceipt => 'Tap to Upload Receipt';

  @override
  String get supportedReceiptFormats => 'Supports JPG and PNG';

  @override
  String get maxFileSize => 'Maximum size 10 MB';

  @override
  String get removeFile => 'Remove file';

  @override
  String get receiptPhotoTipTitle => 'Make sure the receipt is clearly visible';

  @override
  String get receiptPhotoTipBody =>
      'and all information is readable for more accurate OCR.';

  @override
  String receiptFileSize(Object size) {
    return 'File · $size MB';
  }

  @override
  String get analysisComplete => 'Analysis complete';

  @override
  String get processingReceipt => 'Processing receipt';

  @override
  String get analysisSimulationComplete =>
      'Scan complete. Review the extracted results.';

  @override
  String get transactionExtractionSimulation =>
      'Reading receipt text on this device...';

  @override
  String get uploadingPhoto => 'Preparing image';

  @override
  String get readingMerchantDate => 'Reading merchant and date';

  @override
  String get calculatingItems => 'Detecting receipt total';

  @override
  String get backToUpload => 'Back to upload page';

  @override
  String get doNotCloseApp => 'Don\'t close the app yet';

  @override
  String get checkAiResults => 'Review Scan Results';

  @override
  String get extractionSuccessful => 'Scan complete';

  @override
  String get checkBeforeSave => 'Review the data before saving.';

  @override
  String get ocrNotIntegrated => 'Sample data; OCR/AI is not connected yet.';

  @override
  String get transactionDraft => 'Transaction Draft';

  @override
  String get editAiResults => 'Review and edit anything that needs correction.';

  @override
  String get merchantName => 'Merchant Name';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get transactionDateLabel => 'Transaction Date';

  @override
  String get tapPencilToEdit => 'Tap the pencil icon to edit the data.';

  @override
  String receiptSource(Object fileName) {
    return 'Source: $fileName';
  }

  @override
  String get confirmAndSave => 'Confirm & Save';

  @override
  String editFieldTooltip(Object label) {
    return 'Edit $label';
  }

  @override
  String receiptTransactionSaved(Object merchant) {
    return 'Transaction $merchant saved successfully.';
  }
}
