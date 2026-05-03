// Request/Response interceptor for HTTP layer
// Enables centralized request/response handling and error management
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

sealed class HttpEvent {
  const HttpEvent();
}

/// Request interceptor event
class RequestStarted extends HttpEvent {
  final http.BaseRequest request;
  final DateTime timestamp;

  RequestStarted({
    required this.request,
    required this.timestamp,
  });
}

/// Response received event
class ResponseReceived extends HttpEvent {
  final http.BaseResponse response;
  final Duration duration;
  final DateTime timestamp;

  ResponseReceived({
    required this.response,
    required this.duration,
    required this.timestamp,
  });
}

/// Error occurred event
class RequestError extends HttpEvent {
  final String message;
  final Exception exception;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  RequestError({
    required this.message,
    required this.exception,
    this.stackTrace,
    required this.timestamp,
  });
}

/// Retry attempt event
class RequestRetried extends HttpEvent {
  final int attemptNumber;
  final Duration delayBefore;
  final DateTime timestamp;

  RequestRetried({
    required this.attemptNumber,
    required this.delayBefore,
    required this.timestamp,
  });
}

/// Stream controller for HTTP events
class HttpInterceptorService {
  static final HttpInterceptorService _instance = HttpInterceptorService._();

  final StreamController<HttpEvent> _eventController = StreamController<HttpEvent>.broadcast();

  /// Private constructor
  HttpInterceptorService._();

  /// Get singleton instance
  factory HttpInterceptorService() => _instance;

  /// Get event stream
  Stream<HttpEvent> get eventStream => _eventController.stream;

  /// Log request
  void logRequest(http.BaseRequest request) {
    _eventController.add(
      RequestStarted(
        request: request,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Log response
  void logResponse(http.BaseResponse response, Duration duration) {
    _eventController.add(
      ResponseReceived(
        response: response,
        duration: duration,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Log error
  void logError(
    String message,
    Exception exception, {
    StackTrace? stackTrace,
  }) {
    _eventController.add(
      RequestError(
        message: message,
        exception: exception,
        stackTrace: stackTrace,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Log retry attempt
  void logRetry(int attemptNumber, Duration delayBefore) {
    _eventController.add(
      RequestRetried(
        attemptNumber: attemptNumber,
        delayBefore: delayBefore,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Dispose resources
  void dispose() {
    _eventController.close();
  }
}

/// HTTP Client wrapper with retry logic and error handling
class RetryableHttpClient extends http.BaseClient {
  /// Maximum number of retries
  final int maxRetries;

  /// Retry delay in milliseconds
  final int retryDelayMs;

  /// Timeout for requests in seconds
  final int requestTimeout;

  /// Interceptor service
  final HttpInterceptorService interceptor;

  /// Constructor
  RetryableHttpClient({
    this.maxRetries = AppConfig.networkMaxRetries,
    this.retryDelayMs = AppConfig.networkRetryDelayMs,
    this.requestTimeout = AppConfig.networkRequestTimeout,
    HttpInterceptorService? interceptor,
  }) : interceptor = interceptor ?? HttpInterceptorService();

  /// Custom send method with retry logic
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    int attempts = 0;

    while (true) {
      try {
        attempts++;

        // Log request
        interceptor.logRequest(request);

        // Send request with timeout
        final DateTime startTime = DateTime.now();
        final http.StreamedResponse response = await _sendWithTimeout(request);
        final Duration duration = DateTime.now().difference(startTime);

        // Log response
        interceptor.logResponse(response, duration);

        // Check if response is successful or non-retryable error
        if (_isRetryable(response.statusCode) && attempts < maxRetries) {
          final Duration delayBefore = Duration(milliseconds: retryDelayMs * attempts);
          interceptor.logRetry(attempts, delayBefore);

          // Wait before retrying
          await Future<void>.delayed(delayBefore);
          continue;
        }

        return response;
      } on SocketException catch (e) {
        // Network error - retry if possible
        if (attempts < maxRetries) {
          final Duration delayBefore = Duration(milliseconds: retryDelayMs * attempts);
          interceptor.logRetry(attempts, delayBefore);
          await Future<void>.delayed(delayBefore);
          continue;
        }

        interceptor.logError('Network error: $e', e);
        rethrow;
      } catch (e) {
        // Other errors - don't retry
        interceptor.logError('Request failed: $e', Exception(e.toString()));
        rethrow;
      }
    }
  }

  /// Send request with timeout
  Future<http.StreamedResponse> _sendWithTimeout(http.BaseRequest request) async {
    return request.send().timeout(
      Duration(seconds: requestTimeout),
      onTimeout: () => throw TimeoutException('Request timeout after $requestTimeout seconds'),
    );
  }

  /// Check if status code is retryable
  bool _isRetryable(int statusCode) {
    // Retry on 5xx errors and 429 (rate limit)
    return (statusCode >= 500 && statusCode < 600) || statusCode == 429;
  }
}


