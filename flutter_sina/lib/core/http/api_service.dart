// Professional API service layer with error handling and retry logic
// Provides a clean interface for all API operations
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../exceptions/app_exception.dart';
import '../http/http_interceptor.dart';
import '../http/http_response.dart';
import '../logging/app_logger.dart';
import '../result/result.dart';

class ApiService {
  /// HTTP client with retry logic
  final RetryableHttpClient _client;

  /// Base URL for API calls
  final String baseUrl;

  /// Default headers for all requests
  final Map<String, String> defaultHeaders;

  /// Constructor
  ApiService({
    required this.baseUrl,
    Map<String, String>? defaultHeaders,
    RetryableHttpClient? client,
  }) :
    _client = client ?? RetryableHttpClient(
      maxRetries: AppConfig.networkMaxRetries,
      retryDelayMs: AppConfig.networkRetryDelayMs,
      requestTimeout: AppConfig.networkRequestTimeout,
    ),
    defaultHeaders = defaultHeaders ?? <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

  /// GET request
  Future<Result<HttpResponse<Map<String, dynamic>>>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final Uri uri = _buildUri(endpoint, queryParams);
      final Map<String, String> requestHeaders = <String, String>{
        ...defaultHeaders,
        ...?headers,
      };

      AppLogger.debug('ApiService', 'GET $uri');

      final http.Response response = await _client.get(uri, headers: requestHeaders);
      return _handleResponse(response);
    } catch (e, stackTrace) {
      final Exception exception = e is Exception ? e : Exception(e.toString());
      AppLogger.error('ApiService', 'GET request failed', exception: exception, stackTrace: stackTrace);
      return Error<HttpResponse<Map<String, dynamic>>>(
        AppException.network('Network request failed: ${exception.toString()}'),
      );
    }
  }

  /// POST request
  Future<Result<HttpResponse<Map<String, dynamic>>>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final Uri uri = _buildUri(endpoint, queryParams);
      final Map<String, String> requestHeaders = <String, String>{
        ...defaultHeaders,
        ...?headers,
      };

      final String? jsonBody = body != null ? jsonEncode(body) : null;

      AppLogger.debug('ApiService', 'POST $uri with body: $jsonBody');

      final http.Response response = await _client.post(
        uri,
        headers: requestHeaders,
        body: jsonBody,
      );

      return _handleResponse(response);
    } catch (e, stackTrace) {
      final Exception exception = e is Exception ? e : Exception(e.toString());
      AppLogger.error('ApiService', 'POST request failed', exception: exception, stackTrace: stackTrace);
      return Error<HttpResponse<Map<String, dynamic>>>(
        AppException.network('Network request failed: ${exception.toString()}'),
      );
    }
  }

  /// PUT request
  Future<Result<HttpResponse<Map<String, dynamic>>>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final Uri uri = _buildUri(endpoint, queryParams);
      final Map<String, String> requestHeaders = <String, String>{
        ...defaultHeaders,
        ...?headers,
      };

      final String? jsonBody = body != null ? jsonEncode(body) : null;

      AppLogger.debug('ApiService', 'PUT $uri with body: $jsonBody');

      final http.Response response = await _client.put(
        uri,
        headers: requestHeaders,
        body: jsonBody,
      );

      return _handleResponse(response);
    } catch (e, stackTrace) {
      final Exception exception = e is Exception ? e : Exception(e.toString());
      AppLogger.error('ApiService', 'PUT request failed', exception: exception, stackTrace: stackTrace);
      return Error<HttpResponse<Map<String, dynamic>>>(
        AppException.network('Network request failed: ${exception.toString()}'),
      );
    }
  }

  /// DELETE request
  Future<Result<HttpResponse<Map<String, dynamic>>>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final Uri uri = _buildUri(endpoint, queryParams);
      final Map<String, String> requestHeaders = <String, String>{
        ...defaultHeaders,
        ...?headers,
      };

      AppLogger.debug('ApiService', 'DELETE $uri');

      final http.Response response = await _client.delete(uri, headers: requestHeaders);
      return _handleResponse(response);
    } catch (e, stackTrace) {
      final Exception exception = e is Exception ? e : Exception(e.toString());
      AppLogger.error('ApiService', 'DELETE request failed', exception: exception, stackTrace: stackTrace);
      return Error<HttpResponse<Map<String, dynamic>>>(
        AppException.network('Network request failed: ${exception.toString()}'),
      );
    }
  }

  /// PATCH request
  Future<Result<HttpResponse<Map<String, dynamic>>>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final Uri uri = _buildUri(endpoint, queryParams);
      final Map<String, String> requestHeaders = <String, String>{
        ...defaultHeaders,
        ...?headers,
      };

      final String? jsonBody = body != null ? jsonEncode(body) : null;

      AppLogger.debug('ApiService', 'PATCH $uri with body: $jsonBody');

      final http.Response response = await _client.patch(
        uri,
        headers: requestHeaders,
        body: jsonBody,
      );

      return _handleResponse(response);
    } catch (e, stackTrace) {
      final Exception exception = e is Exception ? e : Exception(e.toString());
      AppLogger.error('ApiService', 'PATCH request failed', exception: exception, stackTrace: stackTrace);
      return Error<HttpResponse<Map<String, dynamic>>>(
        AppException.network('Network request failed: ${exception.toString()}'),
      );
    }
  }

  /// Build URI from endpoint and query parameters
  Uri _buildUri(String endpoint, Map<String, String>? queryParams) {
    final String url = endpoint.startsWith('http') ? endpoint : '$baseUrl$endpoint';
    final Uri uri = Uri.parse(url);

    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }

    return uri;
  }

  /// Handle HTTP response and convert to Result
  Result<HttpResponse<Map<String, dynamic>>> _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic>? responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>?
          : null;

      final HttpResponse<Map<String, dynamic>> httpResponse = HttpResponse<Map<String, dynamic>>(
        statusCode: response.statusCode,
        headers: response.headers,
        body: responseBody,
        rawData: response.body,
      );

      if (httpResponse.isSuccess) {
        AppLogger.debug('ApiService', 'Request successful: ${response.statusCode}');
        return Success<HttpResponse<Map<String, dynamic>>>(httpResponse);
      } else {
        final String errorMessage = httpResponse.getErrorMessage();
        AppLogger.warning('ApiService', 'Request failed: ${response.statusCode} - $errorMessage');

        final AppException exception = _createExceptionFromResponse(httpResponse);
        return Error<HttpResponse<Map<String, dynamic>>>(exception);
      }
    } catch (e, stackTrace) {
      final Exception exception = e is Exception ? e : Exception(e.toString());
      AppLogger.error('ApiService', 'Failed to parse response', exception: exception, stackTrace: stackTrace);
      return Error<HttpResponse<Map<String, dynamic>>>(
        AppException.unknown('Failed to parse response: ${exception.toString()}'),
      );
    }
  }

  /// Create appropriate exception from HTTP response
  AppException _createExceptionFromResponse(HttpResponse<Map<String, dynamic>> response) {
    if (response.isClientError) {
      return AppException.client(response.getErrorMessage());
    } else if (response.isServerError) {
      return AppException.server(response.getErrorMessage());
    } else {
      return AppException.unknown(response.getErrorMessage());
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}

