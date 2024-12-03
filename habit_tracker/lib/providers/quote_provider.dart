import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteProvider {
  static const String zenQuotesUrl = 'https://zenquotes.io/api/random';
  static const String fallbackQuotesUrl = 'https://quotes.rest/qod?language=en';

  Future<String> fetchRandomQuote() async {
    try {
      // 1차 시도: Zen Quotes API
      final response = await http.get(
        Uri.parse(zenQuotesUrl),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[0]['q']; // Zen Quotes에서 랜덤 문구 가져오기
      } else {
        throw Exception('Failed to load Zen Quotes');
      }
    } catch (e) {
      // 2차 시도: 대체 API (They Said So Quotes)
      return await _fetchFallbackQuote();
    }
  }

  Future<String> _fetchFallbackQuote() async {
    try {
      final response = await http.get(
        Uri.parse(fallbackQuotesUrl),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['contents']['quotes'][0]['quote']; // 대체 API에서 문구 가져오기
      } else {
        throw Exception('Failed to load fallback quote');
      }
    } catch (e) {
      return 'Stay positive and keep going!'; // 기본 문구 반환
    }
  }
}
