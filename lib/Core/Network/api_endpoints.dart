class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://nayem5002.binarybards.online/api/v1';

  // Auth endpoints
  static const String register = '/users/';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';

  // Home endpoints
  static const String homeContent = '/home/content';

  // My List endpoints
  static const String recentlyWatched = '/recently-watched';
  static const String trackProgress = '/recently-watched/track-progress';
  static const String myCollection = '/my-collection';
  static const String bulkRemoveCollection = '/my-collection/bulk';

  // Shorts endpoints
  static const String shorts = '/shorts';
  static String trackShortView(String shortId) => '/shorts/$shortId/view';

  // User & Profile endpoints
  static const String userProfile = '/users/me';
  static const String deleteAccount = '/users/me';
  static const String requestEmailChange = '/users/me/email-change/request';
  static const String confirmEmailChange = '/users/me/email-change/confirm';

  // Auth endpoints
  static const String restoreAccount = '/auth/restore-account';

  // Legal endpoints
  static const String legals = '/legals';
  static String legalBySlug(String slug) => '/legals/$slug';

  // Content Details & Playback endpoints
  static String contentDetails(String contentId) => '/contents/$contentId/details';
  static String playbackUrl(String contentId) => '/contents/$contentId/playback-url';
  static String watchProgress(String contentId) => '/recently-watched/content/$contentId';
  static const String searchContent = '/contents/search';
  static String seasonEpisodes(String seasonId) => '/contents/seasons/$seasonId/episodes';
}
