import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

class FirestoreLivrosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarLivro(Livro livro) async {
    await _firestore.collection('livros').add(livro.toMap());
  }

  Future<List<Livro>> buscarLivros() async {
    final resultado = await _firestore.collection('livros').get();

    return resultado.docs.map((documento) {
      return Livro.fromMap(documento.data());
    }
    ).toList();
  }
}