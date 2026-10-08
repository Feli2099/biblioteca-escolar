import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

void main() {
  group('Modelo Livro', () {
    test('toMap deve converter livro para Map corretamente', () {
      final livro = Livro(
        titulo: 'O Hobbit',
        autor: 'J. R. R. Tolkien',
        isbn: '9780000000000',
        editora: 'HarperCollins',
        urlCapa: 'https://exemplo.com/capa.jpg',
        capaBase64: 'imagem-em-base64',
      );

      final map = livro.toMap();

      expect(map['titulo'], 'O Hobbit');
      expect(map['autor'], 'J. R. R. Tolkien');
      expect(map['isbn'], '9780000000000');
      expect(map['editora'], 'HarperCollins');
      expect(
        map['urlCapa'],
        'https://exemplo.com/capa.jpg',
      );
      expect(
        map['capaBase64'],
        'imagem-em-base64',
      );
      expect(map['quantidadeTotal'], 1);
    });

    test('fromMap deve criar Livro corretamente', () {
      final map = {
        'titulo': '1984',
        'autor': 'George Orwell',
        'isbn': '9780451524935',
        'editora': 'Signet',
        'urlCapa': 'https://exemplo.com/1984.jpg',
        'capaBase64': 'imagem-em-base64',
        'quantidadeTotal': 3,
      };

      final livro = Livro.fromMap(map);

      expect(livro.titulo, '1984');
      expect(livro.autor, 'George Orwell');
      expect(livro.isbn, '9780451524935');
      expect(livro.editora, 'Signet');
      expect(
        livro.urlCapa,
        'https://exemplo.com/1984.jpg',
      );
      expect(
        livro.capaBase64,
        'imagem-em-base64',
      );
      expect(livro.quantidadeTotal, 3);
    });

    test('fromMap deve aceitar capa nula', () {
      final map = {
        'titulo': 'Livro sem capa',
        'autor': 'Autor Teste',
        'isbn': '1234567890',
        'editora': '',
        'urlCapa': null,
        'capaBase64': null,
      };

      final livro = Livro.fromMap(map);

      expect(livro.urlCapa, null);
      expect(livro.capaBase64, null);
      expect(livro.editora, '');
    });

    test('fromMap deve usar valores vazios quando campos não existirem', () {
      final livro = Livro.fromMap({});

      expect(livro.titulo, '');
      expect(livro.autor, '');
      expect(livro.isbn, '');
      expect(livro.editora, '');
      expect(livro.urlCapa, null);
      expect(livro.capaBase64, null);
      expect(livro.quantidadeTotal, 1);
    });
  });
}