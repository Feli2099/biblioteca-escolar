import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';
import 'tela_edicao_aluno.dart';

class TelaListagemAlunos extends StatefulWidget {
  final List<Aluno> alunos;
  final Future<void> Function(Aluno) onAtualizarAluno;
  final Future<bool> Function(String) onExcluirAluno;

  const TelaListagemAlunos({
    super.key,
    required this.alunos,
    required this.onAtualizarAluno,
    required this.onExcluirAluno,
  });

  @override
  State<TelaListagemAlunos> createState() {
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                    onPressed: () async {
                      final alunoAtualizado =
                      await Navigator.push<Aluno>(
                        contextTelaListagemAlunos,
                        MaterialPageRoute(
                          builder: (contextTelaEdicaoAluno) {
                            return TelaEdicaoAluno(
                              aluno: aluno,
                            );
                          },
                        ),
                      );

                      if (!contextTelaListagemAlunos.mounted) {
                        return;
                      }

                      if (alunoAtualizado == null) {
                        return;
                      }

                      try {
                        await widget.onAtualizarAluno(
                          alunoAtualizado,
                        );

                        if (!contextTelaListagemAlunos.mounted) {
                          return;
                        }

                        setState(() {});

                        ScaffoldMessenger.of(
                          contextTelaListagemAlunos,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Aluno atualizado com sucesso!',
                            ),
                          ),
                        );
                      } catch (erro) {
                        if (!contextTelaListagemAlunos.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(
                          contextTelaListagemAlunos,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Erro ao atualizar o aluno.',
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    onPressed: () async {
                      if (aluno.id == null) {
                        ScaffoldMessenger.of(
                          contextTelaListagemAlunos,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Não foi possível identificar o aluno.',
                            ),
                          ),
                        );

                        return;
                      }

                      final confirmar = await showDialog<bool>(
                        context: contextTelaListagemAlunos,
                        builder: (contextoDialogo) {
                          return AlertDialog(
                            title: const Text('Excluir aluno'),
                            content: Text(
                              'Deseja excluir "${aluno.nomeCompleto}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    contextoDialogo,
                                    false,
                                  );
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    contextoDialogo,
                                    true,
                                  );
                                },
                                child: const Text('Excluir'),
                              ),
                            ],
                          );
                        },
                      );

                      if (!contextTelaListagemAlunos.mounted) {
                        return;
                      }

                      if (confirmar != true) {
                        return;
                      }

                      try {
                        final excluido = await widget.onExcluirAluno(
                          aluno.id!,
                        );

                        if (!contextTelaListagemAlunos.mounted) {
                          return;
                        }

                        if (!excluido) {
                          ScaffoldMessenger.of(
                            contextTelaListagemAlunos,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Não é possível excluir um aluno com empréstimo ativo.',
                              ),
                            ),
                          );

                          return;
                        }

                        setState(() {});

                        ScaffoldMessenger.of(
                          contextTelaListagemAlunos,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Aluno excluído com sucesso!',
                            ),
                          ),
                        );
                      } catch (erro) {
                        if (!contextTelaListagemAlunos.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(
                          contextTelaListagemAlunos,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Erro ao excluir o aluno.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}