import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  static const String _apiKey = String.fromEnvironment(
    'GOOGLE_BOOKS_API_KEY',
  );

  Future<Map<String, dynamic>?> buscarPorIsbn(String isbn) async {
    final isbnLimpo = isbn.replaceAll(
        RegExp(r'[\s-]'),
        '',
    );

    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes'
      '?q=isbn:$isbnLimpo'
      '&key=$_apiKey',
    );

    const int maxTentativas = 3;

    for(int tentativa = 1; tentativa <= maxTentativas; tentativa++) {
      final resposta = await http.get(url);

      print(
        'Tentativa $tentativa de $maxTentativas: ${resposta.statusCode}',
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        print(dados);

        if (dados['totalItems'] == 0) {
          return null;
        }

        final items = dados['items'];

        if (items is! List || items.isEmpty) {
          return null;
        }

        final primeiroItem = items[0];

        if (primeiroItem is! Map<String, dynamic>) {
          return null;
        }

        final volumeInfo = primeiroItem['volumeInfo'];

        if (volumeInfo is! Map<String, dynamic>) {
          return null;
        }

        return volumeInfo;
      }

      final erroTemporario =
          resposta.statusCode == 503 ||
          resposta.statusCode == 429;

      if (erroTemporario && tentativa < maxTentativas) {
        final segundosEspera = tentativa;

        await Future.delayed(
            Duration(seconds: segundosEspera),
        );

        continue;
      }

      print('Erro na Google Books API: ${resposta.statusCode}');
      print('Resposta: ${resposta.body}');

      return null;
    }

    return null;
  }
}