import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenLibraryService {
  Future<Map<String, dynamic>?> buscarPorIsbn(String isbn) async {
    final isbnLimpo = isbn.replaceAll(
      RegExp(r'[\s-]'),
      '',
    );

    final url = Uri.parse(
      'https://openlibrary.org/isbn/$isbnLimpo.json',
    );

    const int maxTentativas = 3;

    for (int tentativa = 1; tentativa <= maxTentativas; tentativa++) {
      final resposta = await http.get(url);

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (dados is! Map<String, dynamic>) {
          return null;
        }

        return dados;
      }

      if (resposta.statusCode == 404) {
        return null;
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

      print('Erro na Open Library: ${resposta.statusCode}');
      print('Resposta: ${resposta.body}');

      return null;
    }

    return null;
  }

  Future<String?> buscarNomeAutor(String chaveAutor) async {
    final url = Uri.parse('https://openlibrary.org$chaveAutor.json',);

    const int maxTentativas = 3;

    for (int tentativa = 1; tentativa <= maxTentativas; tentativa++) {
      final resposta = await http.get(url);

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (dados is! Map<String, dynamic>) {
          return null;
        }

        final nome = dados['name'];

        if (nome is String && nome.isNotEmpty) {
          return nome;
        }

        return null;
      }

      if (resposta.statusCode == 404) {
        return null;
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

      print('Erro ao buscar autor na Open Library: ${resposta.statusCode}',);

      return null;
    }

    return null;
  }
}