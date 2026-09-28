class Aluno {
  final String? id;
  final String nomeCompleto;
  final String turma;

  Aluno({
    this.id,
    required this.nomeCompleto,
    required this.turma,
  });

  Map<String, dynamic> toMap() {
    return {
      'nomeCompleto': nomeCompleto,
      'turma' : turma,
    };
  }

  factory Aluno.fromMap(
    Map<String, dynamic> map,
    String id,
    ) {
    return Aluno(
      id: id,
      nomeCompleto: map['nomeCompleto'] ?? '',
      turma: map['turma'] ?? '',
    );
  }
}