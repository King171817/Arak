/// HTTP response wrapper with error handling
/// Provides safe handling of HTTP responses with status code validation
class HttpResponse<T> {
  /// HTTP status code
  final int statusCode;

  /// Response headers
  final Map<String, String> headers;

  /// Response body
  final T? body;

  /// Raw response data if parsing failed
  final String? rawData;

  /// Constructor
  HttpResponse({
    required this.statusCode,
    required this.headers,
    this.body,
    this.rawData,
  });

  /// Check if response is successful (2xx)
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// Check if response is client error (4xx)
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Check if response is server error (5xx)
  bool get isServerError => statusCode >= 500 && statusCode < 600;

  /// Check if response is redirect (3xx)
  bool get isRedirect => statusCode >= 300 && statusCode < 400;

  /// Get error message based on status code
  String getErrorMessage() {
    switch (statusCode) {
      case 400:
        return 'Ø¯Ø±Ø®ÙˆØ§Ø³Øª Ù†Ø§Ù…Ø¹ØªØ¨Ø± Ø§Ø³Øª';
      case 401:
        return 'Ø´Ù…Ø§ Ø§Ø¬Ø§Ø²Ù‡ Ø¯Ø³ØªØ±Ø³ÛŒ Ù†Ø¯Ø§Ø±ÛŒØ¯';
      case 403:
        return 'Ø¯Ø³ØªØ±Ø³ÛŒ Ù…Ù…Ù†ÙˆØ¹ Ø§Ø³Øª';
      case 404:
        return 'Ù…Ù†Ø¨Ø¹ Ù…ÙˆØ±Ø¯ Ù†Ø¸Ø± ÛŒØ§ÙØª Ù†Ø´Ø¯';
      case 409:
        return 'ØªØ¶Ø§Ø¯ Ø¯Ø± Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§';
      case 429:
        return 'Ø¯Ø±Ø®ÙˆØ§Ø³Øªâ€ŒÙ‡Ø§ÛŒ Ø¨Ø³ÛŒØ§Ø± Ø²ÛŒØ§Ø¯ÛŒ. Ù„Ø·ÙØ§Ù‹ Ø¨Ø¹Ø¯Ø§Ù‹ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';
      case 500:
        return 'Ø®Ø·Ø§ÛŒ Ø¯Ø§Ø®Ù„ÛŒ Ø³Ø±ÙˆØ±';
      case 502:
        return 'Ø¯Ø±Ú¯Ø§Ù‡ Ø¨Ø¯ Ø³Ø±ÙˆØ±';
      case 503:
        return 'Ø³Ø±ÙˆÛŒØ³ Ø¯Ø± Ø­Ø§Ù„ Ø­Ø§Ø¶Ø± Ø¯Ø± Ø¯Ø³ØªØ±Ø³ Ù†ÛŒØ³Øª';
      case 504:
        return 'Ø²Ù…Ø§Ù† Ø§Ù†ØªØ¸Ø§Ø± Ø³Ø±ÙˆØ± Ø¨Ù‡ Ù¾Ø§ÛŒØ§Ù† Ø±Ø³ÛŒØ¯';
      default:
        return 'Ø®Ø·Ø§ÛŒ Ù†Ø§Ù…Ø´Ø®Øµ (Ú©Ø¯: $statusCode)';
    }
  }

  @override
  String toString() => 'HttpResponse(statusCode: $statusCode, isSuccess: $isSuccess)';
}

