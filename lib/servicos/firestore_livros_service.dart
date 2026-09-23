import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

class FirestoreLivrosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> adicionarLivro(Livro livro) async {
    final isbnNormalizado = _normalizarIsbn(livro.isbn);

    final documento = _firestore.collection('livros').doc(isbnNormalizado);

    return _firestore.runTransaction<bool>((transacao) async {
      final documentoExiste = await transacao.get(documento);

      if (documentoExiste.exists) {
        return false;
      }

      transacao.set(documento, livro.toMap(),
      );

      return true;
    });
  }

  String _normalizarIsbn(String isbn) {
    return isbn.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  }

  Future<List<Livro>> buscarLivros() async {
    final resultado = await _firestore.collection('livros').get();

    return resultado.docs.map((documento) {
      return Livro.fromMap(documento.data());
    }
    ).toList();
  }

  Future<void> excluirLivro(String isbn) async {
    final isbnNormalizado = _normalizarIsbn(isbn);

    await _firestore.collection('livros').doc(isbnNormalizado).delete();
  }
}