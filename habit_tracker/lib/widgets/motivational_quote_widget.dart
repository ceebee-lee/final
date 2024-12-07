import 'package:flutter/material.dart';
import '../providers/quote_provider.dart';

class MotivationalQuoteWidget extends StatefulWidget {
  const MotivationalQuoteWidget({super.key}); // const 생성자 추가

  @override
  State<MotivationalQuoteWidget> createState() =>
      _MotivationalQuoteWidgetState();
}

class _MotivationalQuoteWidgetState extends State<MotivationalQuoteWidget> {
  String? _quote;

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    final quoteProvider = QuoteProvider();
    final quote = await quoteProvider.fetchRandomQuote();
    setState(() {
      _quote = quote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _quote == null
          ? const CircularProgressIndicator()
          : Text(
              _quote!,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}
