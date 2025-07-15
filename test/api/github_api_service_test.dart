import 'package:flutter_test/flutter_test.dart';
import 'package:github_profile_viewer/data/api/github_api_service.dart';
import 'package:github_profile_viewer/utils/exceptions.dart';

void main() {
  group('API Tests', () {
    test('Check if API returns valid JSON', () async {
      final githubApiService = GithubApiService()..onInit();

      // final response = 

      // print('Status Code: ${response.statusCode}');
      // print('Response Body: ${response}');

      expect(await githubApiService.getUser("-deep"), throwsA(isA<UserNotFoundException>()), reason: 'Expected HTTP 404 NOT FOUND');

      // try {
      //   final decoded = json.decode(response.body);
      //   expect(decoded, isA<Map<String, dynamic>>(), reason: 'Expected a JSON object');
      // } catch (e) {
      //   print('❌ Response is not valid JSON: ${response.body}');
      //   fail('Response is not valid JSON');
      // }
    });
  });
}
