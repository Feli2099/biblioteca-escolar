import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';
import 'tela_cadastro_aluno.dart';
import 'tela_listagem_alunos.dart';

class TelaAlunos extends StatefulWidget {
  final List<Aluno> alunos;
  final Future<void> Function(Aluno) onAdicionarAluno;
  final Future<void> Function(Aluno) onAtualizarAluno;
  final Future<bool> Function(String) onExcluirAluno;

  const TelaAlunos({
    super.key,
    required this.alunos,
    required this.onAdicionarAluno,
    required this.onAtualizarAluno,
    required this.onExcluirAluno,
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
                Navigator.push(
                  contextTelaAlunos,
                  MaterialPageRoute(
                    builder: (contextTelaCadastroAluno) {
                      return TelaCadastroAluno(
                        onCadastrar: widget.onAdicionarAluno,
                      );
                    },
                  ),
                );
              },
              child: const Text('Cadastrar Aluno'),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  contextTelaAlunos,
                  MaterialPageRoute(
                    builder: (contextTelaListagemAlunos) {
                      return TelaListagemAlunos(
                        alunos: widget.alunos,
                        onAtualizarAluno: widget.onAtualizarAluno,
                        onExcluirAluno: widget.onExcluirAluno,
                      );
                    },
                  ),
                );
              },
              child: const Text('Listar Alunos'),
            ),
          ],
        ),
      ),
    );
  }
}