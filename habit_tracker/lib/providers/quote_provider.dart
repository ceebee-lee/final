import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteProvider {
  final String zenQuotesUrl = 'https://zenquotes.io/api/random';

  Future<String> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(zenQuotesUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[0]['q'];
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      return 'Stay positive and keep going!';
    }
  }
}
