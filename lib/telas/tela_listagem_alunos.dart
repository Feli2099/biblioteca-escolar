import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';
import 'tela_edicao_aluno.dart';

class TelaListagemAlunos extends StatefulWidget {
  final List<Aluno> alunos;
  final Future<void> Function(Aluno) onAtualizarAluno;

  const TelaListagemAlunos({
    super.key,
    required this.alunos,
    required this.onAtualizarAluno,
  });

  @override
  State<StatefulWidget> createState() {
    return _TelaListagemAlunosState();
  }
}

class _TelaListagemAlunosState extends State<TelaListagemAlunos> {

  @override
  Widget build(BuildContext contextTelaListagemAlunos) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos Cadastrados'),
      ),
      body: widget.alunos.isEmpty
          ? const Center(
        child: Text(
          'Nenhum aluno cadastrado.',
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.alunos.length,
        itemBuilder: (contextoItem, indice) {
          final aluno = widget.alunos[indice];

          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: Text(
                aluno.nomeCompleto,
              ),
              subtitle: Text(
                'Turma: ${aluno.turma}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final alunoAtualizado =
                  await Navigator.push<Aluno>(
                    context,
                    MaterialPageRoute(
                      builder: (contextTelaEdicaoAluno) {
                        return TelaEdicaoAluno(
                          aluno: aluno,
                        );
                      },
                    ),
                  );

                  if (!context.mounted || alunoAtualizado == null) {
                    return;
                  }

                  try {
                    await widget.onAtualizarAluno(
                      alunoAtualizado,
                    );

                    if (!context.mounted) {
                      return;
                    }

                    setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Aluno atualizado com sucesso!',
                        ),
                      ),
                    );
                  } catch (erro) {
                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Erro ao atualizar o aluno.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}