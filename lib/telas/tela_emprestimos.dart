import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:biblioteca_escolar/modelos/emprestimo.dart';
import 'package:biblioteca_escolar/telas/tela_cadastro_emprestimo.dart';
import 'package:biblioteca_escolar/telas/tela_listagem_emprestimos.dart';

class TelaEmprestimos extends StatefulWidget {
  final List<Aluno> alunos;
  final List<Livro> livros;
  final List<Emprestimo> emprestimos;

  final Future<Emprestimo?> Function(Emprestimo)
  onAdicionarEmprestimo;

  final Future<void> Function(String)
  onRegistrarDevolucao;

  const TelaEmprestimos({
    super.key,
    required this.alunos,
    required this.livros,
    required this.emprestimos,
    required this.onAdicionarEmprestimo,
    required this.onRegistrarDevolucao,
  });

  @override
  State<TelaEmprestimos> createState() {
    return _TelaEmprestimosState();
  }
}

class _TelaEmprestimosState
    extends State<TelaEmprestimos> {

  @override
  Widget build(BuildContext contextTelaEmprestimos) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empréstimos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  contextTelaEmprestimos,
                  MaterialPageRoute(
                    builder: (contextTelaCadastroEmprestimo) {
                      return TelaCadastroEmprestimo(
                        alunos: widget.alunos,
                        livros: widget.livros,
                        onCadastrar:
                        widget.onAdicionarEmprestimo,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Registrar Empréstimo',
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  contextTelaEmprestimos,
                  MaterialPageRoute(
                    builder: (contextTelaListagemEmprestimos) {
                      return TelaListagemEmprestimos(
                        emprestimos: widget.emprestimos,
                        onRegistrarDevolucao:
                        widget.onRegistrarDevolucao,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Listar Empréstimos',
              ),
            ),
          ],
        ),
      ),
    );
  }
}