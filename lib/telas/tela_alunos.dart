import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';

class TelaAlunos extends StatefulWidget {
  final List<Aluno> alunos;
  final Future<void> Function(Aluno) onAdicionarAluno;

  const TelaAlunos({
    super.key,
    required this.alunos,
    required this.onAdicionarAluno,
  });

  @override
  State<TelaAlunos> createState() {
    return _TelaAlunosState();
  }
}

class _TelaAlunosState extends State<TelaAlunos> {
  @override
  Widget build(BuildContext contextTelaAlunos) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Cadastrar Aluno'),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Listar Alunos'),
            ),
          ],
        ),
      ),
    );
  }
}