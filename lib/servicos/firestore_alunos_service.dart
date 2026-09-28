import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';

class FirestoreAlunosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Aluno> adicionarAluno(Aluno aluno) async {
    final documento = await _firestore.collection('alunos').add(aluno.toMap());

    return Aluno(
      id: documento.id,
      nomeCompleto: aluno.nomeCompleto,
      turma: aluno.turma,
    );
  }

  Future<List<Aluno>> buscarAlunos() async {
    final resultado = await _firestore.collection('alunos').get();

    return resultado.docs.map((documento) {
      return Aluno.fromMap(
        documento.data(),
        documento.id,
      );
    }).toList();
  }

  Future<void> atualizarAluno(Aluno aluno) async {
    if (aluno.id == null) {
      throw Exception('Não é possível atualizar um aluno sem ID.');
    }

    await _firestore.collection('alunos').doc(aluno.id).update(aluno.toMap());
  }

  Future<void> excluirAluno(String id) async {
    await _firestore.collection('alunos').doc(id).delete();
  }
}