import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biblioteca_escolar/modelos/emprestimo.dart';

class FirestoreEmprestimosService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<Emprestimo?> adicionarEmprestimo(
      Emprestimo emprestimo,
      ) async {
    final isbnNormalizado =
    _normalizarIsbn(emprestimo.livroIsbn);

    final possuiEmprestimoAtivo =
    await livroPossuiEmprestimoAtivo(
      isbnNormalizado,
    );

    if (possuiEmprestimoAtivo) {
      return null;
    }

    final dados = emprestimo.toMap();

    dados['livroIsbn'] = isbnNormalizado;

    final documento = await _firestore
        .collection('emprestimos')
        .add(dados);

    return Emprestimo(
      id: documento.id,
      alunoId: emprestimo.alunoId,
      alunoNome: emprestimo.alunoNome,
      livroIsbn: isbnNormalizado,
      livroTitulo: emprestimo.livroTitulo,
      dataEmprestimo: emprestimo.dataEmprestimo,
      dataDevolucaoPrevista:
      emprestimo.dataDevolucaoPrevista,
      devolvido: emprestimo.devolvido,
      dataDevolucaoReal:
      emprestimo.dataDevolucaoReal,
    );
  }

  Future<List<Emprestimo>> buscarEmprestimos() async {
    final resultado = await _firestore
        .collection('emprestimos')
        .get();

    return resultado.docs.map((documento) {
      return Emprestimo.fromMap(
        documento.data(),
        documento.id,
      );
    }).toList();
  }

  Future<bool> livroPossuiEmprestimoAtivo(
      String isbn,
      ) async {
    final isbnNormalizado = _normalizarIsbn(isbn);

    final resultado = await _firestore
        .collection('emprestimos')
        .where(
      'livroIsbn',
      isEqualTo: isbnNormalizado,
    )
        .where(
      'devolvido',
      isEqualTo: false,
    )
        .limit(1)
        .get();

    return resultado.docs.isNotEmpty;
  }

  Future<void> registrarDevolucao(
      String idEmprestimo,
      ) async {
    await _firestore
        .collection('emprestimos')
        .doc(idEmprestimo)
        .update({
      'devolvido': true,
      'dataDevolucaoReal':
      Timestamp.fromDate(DateTime.now()),
    });
  }

  String _normalizarIsbn(String isbn) {
    return isbn
        .replaceAll(RegExp(r'[\s-]'), '')
        .toUpperCase();
  }
}