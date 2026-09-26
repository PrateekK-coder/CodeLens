import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android physical phone -> computer's localhost
  //
  // IMPORTANT:
  // Replace this IP with your computer's local IP address.
  static const String baseUrl = 'http://192.168.1.7:8000';

  static Future<Map<String, dynamic>> reviewFile({
    required String filePath,
    required String fileName,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/v1/reviews/file',
    );

    final request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
        filename: fileName,
      ),
    );

    final streamedResponse =
        await request.send();

    final response =
        await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
          as Map<String, dynamic>;
    }

    throw Exception(
      'File review failed '
      '(${response.statusCode}): '
      '${response.body}',
    );
  }

Future<Map<String, dynamic>> indexRepository({
  required String githubUrl,
  required String branch,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/v1/repositories/index'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'github_url': githubUrl,
      'branch': branch,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to index repository: ${response.body}',
    );
  }

  return jsonDecode(response.body);
}

static Future<Map<String, dynamic>> semanticReview({
  required String repositoryId,
  required String query,
  int k = 5,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/v1/reviews/semantic'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'repository_id': repositoryId,
      'query': query,
      'k': k,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Semantic review failed: ${response.body}',
    );
  }

  return jsonDecode(response.body);
}


static Future<Map<String, dynamic>> reviewRepository({
  required String githubUrl,
  required String branch,
}) async {
  final response = await http.post(
    Uri.parse(
      '$baseUrl/api/v1/reviews/repository',
    ),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'github_url': githubUrl,
      'branch': branch,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  throw Exception(
    'Repository review failed: ${response.body}',
  );
}


}