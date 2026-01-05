import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/service/config/config_model.dart';

const _defaultTimeoutSeconds = 45;

/// Centralized API client for network communication.
@LazySingleton()
class KonsultaProApi {
  final Config config;
  final http.Client client;

  KonsultaProApi(
    @Named('devConfig') this.config,
  ) : client = http.Client();

  /// Generic request handler with standardized error handling.
  Future<APIResult> _sendRequest(
    Future<http.Response> Function() requestFn, {
    int timeoutSeconds = _defaultTimeoutSeconds,
  }) async {
    try {
      final response =
          await requestFn().timeout(Duration(seconds: timeoutSeconds));
      final body = response.body.isNotEmpty ? response.body : '';
      final status = response.statusCode;

      // if (status == 401) return APIResult.unauthorized();
      if (status == 408) return APIResult.timeout();
      if (status >= 400) return APIResult.error(body, status);

      return APIResult.success(body, status);
    } on SocketException {
      return APIResult.connectionProblem();
    } on TimeoutException {
      return APIResult.timeout();
    } catch (e) {
      return APIResult.error(e.toString(), 0);
    }
  }

  /// Builds the complete API URI.
  Future<Uri> _buildUri(String path,
      {Map<String, dynamic>? queryParams}) async {
    if (!path.startsWith('/')) path = '/$path';

    final storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userID');

    // Only add userId if queryParams is not explicitly empty
    final shouldAddUserId = queryParams == null || queryParams.isNotEmpty;

    final mergedParams = {
      if (shouldAddUserId && userId != null) 'userId': userId,
      ...?queryParams,
    }.map((k, v) => MapEntry(k, v?.toString()));

    final scheme = config.apiUseHttps ? 'https' : 'http';

    // Only include queryParameters if there are actual parameters
    final hasQueryParams = mergedParams.isNotEmpty;

    return Uri(
      scheme: scheme,
      host: config.apiDomain,
      port: config.apiPort,
      path: '${config.apiBasePath}$path',
      queryParameters: hasQueryParams ? mergedParams : null,
    );
  }

  /// Common headers with Bearer token.
  Future<Map<String, String>> _headers() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// -------------------------------
  /// HTTP Methods
  /// -------------------------------

  Future<APIResult> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? customHeaders,
  }) async {
    final headers = {...await _headers(), ...?customHeaders};
    final uri = await _buildUri(path, queryParams: queryParams);

    return _sendRequest(() => client.get(uri, headers: headers));
  }

  Future<APIResult> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? customHeaders,
  }) async {
    final headers = {...await _headers(), ...?customHeaders};
    final uri = await _buildUri(path, queryParams: queryParams);

    return _sendRequest(() => client.post(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        ));
  }

  Future<APIResult> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? customHeaders,
  }) async {
    final headers = {...await _headers(), ...?customHeaders};
    final uri = await _buildUri(path, queryParams: queryParams);

    return _sendRequest(() => client.put(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        ));
  }

  Future<APIResult> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? customHeaders,
  }) async {
    final headers = {...await _headers(), ...?customHeaders};
    final uri = await _buildUri(path, queryParams: queryParams);

    return _sendRequest(() => client.delete(
          uri,
          headers: headers,
        ));
  }

  // for image
  Future<APIResult> postMultipart({
    required String path,
    required List<File> files,
    String fileFieldName = 'file',
    Map<String, String>? fields, // optional form fields
    Map<String, dynamic>? queryParams,
    Map<String, String>? customHeaders,
    int timeoutSeconds = 45,
  }) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'userID');

    // Merge query params with userId
    final mergedQuery = {
      if (userId != null) 'userId': userId,
      ...?queryParams,
    }.map((k, v) => MapEntry(k, v.toString()));

    final uri = Uri(
      scheme: config.apiUseHttps ? 'https' : 'http',
      host: config.apiDomain,
      port: config.apiPort,
      path: '${config.apiBasePath}$path',
      queryParameters: mergedQuery,
    );

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        // Note: Don't set Content-Type manually for multipart, let http package handle it
        ...?customHeaders,
      });

    // Add additional form fields
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Add files
    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final fileName = file.path.split('/').last;
      
      // Verify file exists and is readable
      if (!await file.exists()) {
        throw Exception('File does not exist: ${file.path}');
      }
      
      
      // Determine content type based on file extension
      String? contentType;
      final extension = fileName.toLowerCase().split('.').last;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          contentType = 'image/jpeg';
          break;
        case 'png':
          contentType = 'image/png';
          break;
        case 'pdf':
          contentType = 'application/pdf';
          break;
        default:
          contentType = 'application/octet-stream';
      }
      
      request.files.add(await http.MultipartFile.fromPath(
        fileFieldName,
        file.path,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      ));
    }

    try {
      final streamedResponse =
          await request.send().timeout(Duration(seconds: timeoutSeconds));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 400) {
        return APIResult.error(response.body, response.statusCode);
      }

      return APIResult.success(response.body, response.statusCode);
    } on SocketException {
      return APIResult.connectionProblem();
    } on TimeoutException {
      return APIResult.timeout();
    } catch (e, st) {
      debugPrint('❌ Multipart POST Exception: $e\n$st');
      return APIResult.error(e.toString(), 0);
    }
  }

  /// Closes the HTTP client (good for tests or app exit).
  void dispose() => client.close();
}

/// -------------------------------
/// API Result Model
/// -------------------------------
class APIResult {
  final APIResultType type;
  final String body;
  final int statusCode;
  final Map<String, List<String>> errors;

  APIResult({
    required this.type,
    this.body = '',
    this.statusCode = 0,
    Map<String, List<String>>? errors,
  }) : errors = errors ?? {};

  bool get isSuccess => type == APIResultType.success;

  Map<String, dynamic> get data {
    if (body.isEmpty) return {};
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : {};
    } catch (_) {
      return {};
    }
  }

  String get errorMessage {
    if (errors.isNotEmpty) {
      return errors.entries
          .map((e) => '${e.key}: ${e.value.join(', ')}')
          .join('\n');
    }
    // Try multiple possible error field names
    final message = data['message']?.toString()
        ?? data['error']?.toString()
        ?? data['msg']?.toString()
        ?? data['errors']?.toString()
        ?? 'An unknown error occurred.';
    // Include status code and raw response for debugging
    return '$message (Status: $statusCode, Response: ${data.toString()})';
  }

  factory APIResult.success(String body, int statusCode) => APIResult(
      type: APIResultType.success, body: body, statusCode: statusCode);

  factory APIResult.error(String body, int statusCode) =>
      APIResult(type: APIResultType.error, body: body, statusCode: statusCode);

  factory APIResult.connectionProblem() =>
      APIResult(type: APIResultType.connectionProblem);

  factory APIResult.timeout() => APIResult(type: APIResultType.timeout);

  factory APIResult.unauthorized() =>
      APIResult(type: APIResultType.unauthorized);
}

enum APIResultType {
  success,
  connectionProblem,
  timeout,
  unauthorized,
  error,
}
