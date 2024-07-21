import 'dart:developer' as devLog;
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> getAllFetchMusicData() async {
    const url = 'https://storage.googleapis.com/uamp/catalog.json';
    try {
      final response = await http.get(Uri.parse(url));
      devLog.log('response --- ${response.body}');
      if (response.statusCode == 200) {
        return response;
      } else {
        final errorMsg = 'Failed to fetch data with status code: ${response.statusCode}';
        devLog.log(errorMsg);
        throw Exception(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Data fetch failed: $e';
      devLog.log(errorMsg);
      throw Exception(errorMsg);
    }
  }
}
