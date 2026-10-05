import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:biblioteca_escolar/modelos/emprestimo.dart';

class TelaCadastroEmprestimo extends StatefulWidget {
  final List<Aluno> alunos;
  final List<Livro> livros;

  final Future<Emprestimo?> Function(Emprestimo)
  onCadastrar;

  const TelaCadastroEmprestimo({
    super.key,
    required this.alunos,
    required this.livros,
    required this.onCadastrar,
  });

  @override
  State<TelaCadastroEmprestimo> createState() {
    return _TelaCadastroEmprestimoState();
  }
}

class _TelaCadastroEmprestimoState
    extends State<TelaCadastroEmprestimo> {
  Aluno? _alunoSelecionado;
  Livro? _livroSelecionado;
  DateTime? _dataDevolucaoPrevista;

  @override
  Widget build(BuildContext contextTelaCadastroEmprestimo) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Empréstimo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Aluno>(
              value: _alunoSelecionado,
              decoration: const InputDecoration(
                labelText: 'Aluno',
              ),
              items: widget.alunos.map((aluno) {
                return DropdownMenuItem<Aluno>(
                  value: aluno,
                  child: Text(
                    '${aluno.nomeCompleto} - ${aluno.turma}',
                  ),
                );
              }).toList(),
              onChanged: (aluno) {
                setState(() {
                  _alunoSelecionado = aluno;
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<Livro>(
              value: _livroSelecionado,
              decoration: const InputDecoration(
                labelText: 'Livro',
              ),
              items: widget.livros.map((livro) {
                return DropdownMenuItem<Livro>(
                  value: livro,
                  child: Text(
                    livro.titulo,
                  ),
                );
              }).toList(),
              onChanged: (livro) {
                setState(() {
                  _livroSelecionado = livro;
                });
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                final dataSelecionada =
                await showDatePicker(
                  context: contextTelaCadastroEmprestimo,
                  initialDate: DateTime.now()
                      .add(const Duration(days: 7)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now()
                      .add(const Duration(days: 365)),
                );

                if (!contextTelaCadastroEmprestimo.mounted) {
                  return;
                }

                if (dataSelecionada == null) {
                  return;
                }

                setState(() {
                  _dataDevolucaoPrevista =
                      dataSelecionada;
                });
              },
              child: const Text(
                'Selecionar data de devolução',
              ),
            ),

            const SizedBox(height: 12),

            if (_dataDevolucaoPrevista != null)
              Text(
                'Devolução prevista: '
                    '${_dataDevolucaoPrevista!.day.toString().padLeft(2, '0')}/'
                    '${_dataDevolucaoPrevista!.month.toString().padLeft(2, '0')}/'
                    '${_dataDevolucaoPrevista!.year}',
              ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                if (_alunoSelecionado == null ||
                    _livroSelecionado == null ||
                    _dataDevolucaoPrevista == null) {
                  ScaffoldMessenger.of(
                    contextTelaCadastroEmprestimo,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Selecione aluno, livro e data de devolução.',
                      ),
                    ),
                  );

                  return;
                }

                if (_alunoSelecionado!.id == null) {
                  return;
                }

                final emprestimo = Emprestimo(
                  alunoId: _alunoSelecionado!.id!,
                  alunoNome:
                  _alunoSelecionado!.nomeCompleto,
                  livroIsbn:
                  _livroSelecionado!.isbn,
                  livroTitulo:
                  _livroSelecionado!.titulo,
                  dataEmprestimo: DateTime.now(),
                  dataDevolucaoPrevista:
                  _dataDevolucaoPrevista!,
                  devolvido: false,
                );

                try {
                  final emprestimoSalvo =
                  await widget.onCadastrar(
                    emprestimo,
                  );

                  if (!contextTelaCadastroEmprestimo.mounted) {
                    return;
                  }

                  if (emprestimoSalvo == null) {
                    ScaffoldMessenger.of(
                      contextTelaCadastroEmprestimo,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Esse livro já está emprestado.',
                        ),
                      ),
                    );

                    return;
                  }

                  ScaffoldMessenger.of(
                    contextTelaCadastroEmprestimo,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Empréstimo registrado com sucesso!',
                      ),
                    ),
                  );

                  setState(() {
                    _alunoSelecionado = null;
                    _livroSelecionado = null;
                    _dataDevolucaoPrevista = null;
                  });
                } catch (erro) {
                  if (!contextTelaCadastroEmprestimo.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    contextTelaCadastroEmprestimo,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Erro ao registrar o empréstimo.',
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Registrar Empréstimo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}