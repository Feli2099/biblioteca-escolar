import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/emprestimo.dart';

class TelaListagemEmprestimos extends StatefulWidget {
  final List<Emprestimo> emprestimos;
  final Future<void> Function(String) onRegistrarDevolucao;

  const TelaListagemEmprestimos({
    super.key,
    required this.emprestimos,
    required this.onRegistrarDevolucao,
  });

  @override
  State<TelaListagemEmprestimos> createState() {
    return _TelaListagemEmprestimosState();
  }
}

class _TelaListagemEmprestimosState
    extends State<TelaListagemEmprestimos> {

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  @override
  Widget build(BuildContext contextTelaListagemEmprestimos) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empréstimos'),
      ),
      body: widget.emprestimos.isEmpty
          ? const Center(
        child: Text(
          'Nenhum empréstimo registrado.',
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.emprestimos.length,
        itemBuilder: (contextoItem, indice) {
          final emprestimo =
          widget.emprestimos[indice];

          return Card(
            key: ValueKey(emprestimo.id),
            child: ListTile(
              leading: Icon(
                emprestimo.devolvido
                    ? Icons.check_circle_outline
                    : Icons.menu_book,
              ),
              title: Text(
                emprestimo.livroTitulo,
              ),
              subtitle: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aluno: ${emprestimo.alunoNome}',
                  ),
                  Text(
                    'Empréstimo: '
                        '${_formatarData(emprestimo.dataEmprestimo)}',
                  ),
                  Text(
                    'Devolução prevista: '
                        '${_formatarData(emprestimo.dataDevolucaoPrevista)}',
                  ),
                  Text(
                    emprestimo.devolvido
                        ? 'Status: Devolvido'
                        : 'Status: Emprestado',
                  ),

                  if (emprestimo.dataDevolucaoReal != null)
                    Text(
                      'Devolvido em: '
                          '${_formatarData(emprestimo.dataDevolucaoReal!)}',
                    ),
                ],
              ),
              trailing: emprestimo.devolvido
                  ? null
                  : IconButton(
                icon: const Icon(
                  Icons.assignment_return,
                ),
                tooltip: 'Registrar devolução',
                onPressed: () async {
                  if (emprestimo.id == null) {
                    ScaffoldMessenger.of(
                      contextTelaListagemEmprestimos,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Não foi possível identificar o empréstimo.',
                        ),
                      ),
                    );

                    return;
                  }

                  final confirmar =
                  await showDialog<bool>(
                    context:
                    contextTelaListagemEmprestimos,
                    builder: (contextoDialogo) {
                      return AlertDialog(
                        title: const Text(
                          'Registrar devolução',
                        ),
                        content: Text(
                          'Confirmar devolução de '
                              '"${emprestimo.livroTitulo}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                contextoDialogo,
                                false,
                              );
                            },
                            child: const Text(
                              'Cancelar',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                contextoDialogo,
                                true,
                              );
                            },
                            child: const Text(
                              'Confirmar',
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (!contextTelaListagemEmprestimos
                      .mounted) {
                    return;
                  }

                  if (confirmar != true) {
                    return;
                  }

                  try {
                    await widget
                        .onRegistrarDevolucao(
                      emprestimo.id!,
                    );

                    if (!contextTelaListagemEmprestimos
                        .mounted) {
                      return;
                    }

                    setState(() {});

                    ScaffoldMessenger.of(
                      contextTelaListagemEmprestimos,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Devolução registrada com sucesso!',
                        ),
                      ),
                    );
                  } catch (erro) {
                    if (!contextTelaListagemEmprestimos
                        .mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      contextTelaListagemEmprestimos,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Erro ao registrar a devolução.',
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