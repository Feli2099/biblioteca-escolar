import 'package:cloud_firestore/cloud_firestore.dart';

class Emprestimo {
  final String? id;

  final String alunoId;
  final String alunoNome;

  final String livroIsbn;
  final String livroTitulo;

  final DateTime dataEmprestimo;
  final DateTime dataDevolucaoPrevista;

  final bool devolvido;
  final DateTime? dataDevolucaoReal;

  Emprestimo({
    this.id,
    required this.alunoId,
    required this.alunoNome,
    required this.livroIsbn,
    required this.livroTitulo,
    required this.dataEmprestimo,
    required this.dataDevolucaoPrevista,
    required this.devolvido,
    this.dataDevolucaoReal,
  });

  Map<String, dynamic> toMap() {
    return {
      'alunoId': alunoId,
      'alunoNome': alunoNome,
      'livroIsbn': livroIsbn,
      'livroTitulo': livroTitulo,
      'dataEmprestimo': Timestamp.fromDate(dataEmprestimo),
      'dataDevolucaoPrevista':
      Timestamp.fromDate(dataDevolucaoPrevista),
      'devolvido': devolvido,
      'dataDevolucaoReal': dataDevolucaoReal != null
          ? Timestamp.fromDate(dataDevolucaoReal!)
          : null,
    };
  }

  factory Emprestimo.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return Emprestimo(
      id: id,
      alunoId: map['alunoId'] ?? '',
      alunoNome: map['alunoNome'] ?? '',
      livroIsbn: map['livroIsbn'] ?? '',
      livroTitulo: map['livroTitulo'] ?? '',
      dataEmprestimo:
      (map['dataEmprestimo'] as Timestamp).toDate(),
      dataDevolucaoPrevista:
      (map['dataDevolucaoPrevista'] as Timestamp).toDate(),
      devolvido: map['devolvido'] ?? false,
      dataDevolucaoReal: map['dataDevolucaoReal'] != null
          ? (map['dataDevolucaoReal'] as Timestamp).toDate()
          : null,
    );
  }
}