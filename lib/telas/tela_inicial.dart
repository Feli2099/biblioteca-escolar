import 'package:flutter/material.dart';
import 'livros/tela_livros.dart';
import 'alunos/tela_alunos.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:biblioteca_escolar/servicos/firestore_livros_service.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';
import 'package:biblioteca_escolar/servicos/firestore_alunos_service.dart';
import 'package:biblioteca_escolar/modelos/emprestimo.dart';
import 'package:biblioteca_escolar/servicos/firestore_emprestimos_service.dart';
import 'package:biblioteca_escolar/telas/emprestimos/tela_emprestimos.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() {
    return _TelaInicialState();
  }
}

class _TelaInicialState extends State<TelaInicial> {
  final List<Livro> _livros = [];
  final List<Aluno> _alunos = [];
  final List<Emprestimo> _emprestimos = [];

  bool _carregandoLivros = true;
  String? _erroCarregamentoLivros;

  final FirestoreLivrosService _firestoreLivrosService = FirestoreLivrosService();
  final FirestoreAlunosService _firestoreAlunosService = FirestoreAlunosService();
  final FirestoreEmprestimosService _firestoreEmprestimosService = FirestoreEmprestimosService();

  Future<bool> _adicionarLivro(Livro livro) async {
    final cadastrado = await _firestoreLivrosService.adicionarLivro(livro);

    if (!cadastrado) {
      return false;
    }

    try {
      await _carregarLivros();
    } catch (erro) {
      if (mounted) {
        setState(() {
          _livros.add(livro);
        });
      }
    }

    return true;
  }

  Future<bool> _excluirLivro(String isbn) async {
    final possuiEmprestimoAtivo =
    await _firestoreEmprestimosService
        .livroPossuiEmprestimoAtivo(isbn);

    if (possuiEmprestimoAtivo) {
      return false;
    }

    await _firestoreLivrosService.excluirLivro(isbn);

    if (!mounted) {
      return true;
    }

    setState(() {
      _livros.removeWhere(
            (livro) =>
        _normalizarIsbn(livro.isbn) ==
            _normalizarIsbn(isbn),
      );
    });

    return true;
  }

  Future<void> _atualizarLivro(Livro livroAtualizado) async {
    await _firestoreLivrosService.atualizarLivro(livroAtualizado);

    await _firestoreEmprestimosService.atualizarTituloLivroEmprestimosAtivos(livroAtualizado.isbn, livroAtualizado.titulo);

    if (!mounted) {
      return;
    }

    final indice = _livros.indexWhere(
      (livro) => _normalizarIsbn(livro.isbn) == _normalizarIsbn(livroAtualizado.isbn),
    );

    if (indice == -1) {
      return;
    }

    setState(() {
      _livros[indice] = livroAtualizado;
    });
  }

  String _normalizarIsbn(String isbn) {
    return isbn.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  }

  @override
  void initState() {
    super.initState();

    _carregarLivrosInicial();
  }

  Future<void> _carregarLivros() async {
    final livrosSalvos = await _firestoreLivrosService.buscarLivros();

    if (!mounted) {
      return;
    }

    setState(() {
      _livros.clear();
      _livros.addAll(livrosSalvos);
    });
  }

  Future<void> _carregarLivrosInicial() async {
    if (mounted) {
      setState(() {
        _carregandoLivros = true;
        _erroCarregamentoLivros = null;
      });
    }

    try {
      await _carregarLivros();
    } catch (erro) {
      if (!mounted) {
        return;
      }

      setState(() {
        _erroCarregamentoLivros = 'Não foi possível carregar os livros.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregandoLivros = false;
        });
      }
    }
  }

  Future<void> _carregarAlunos() async {
    final alunosSalvos = await _firestoreAlunosService.buscarAlunos();

    if (!mounted) {
      return;
    }

    setState(() {
      _alunos.clear();
      _alunos.addAll(alunosSalvos);
    });
  }

  Future<void> _adicionarAluno(Aluno aluno) async {
    final alunoSalvo = await _firestoreAlunosService.adicionarAluno(aluno);

    if (!mounted) {
      return;
    }

    setState(() {
      _alunos.add(alunoSalvo);
    });
  }

  Future<void> _atualizarAluno(Aluno alunoAtualizado) async {
    await _firestoreAlunosService.atualizarAluno(alunoAtualizado);

    await _firestoreEmprestimosService.atualizarNomeAlunoEmprestimosAtivos(alunoAtualizado.id!, alunoAtualizado.nomeCompleto);

    if (!mounted) {
      return;
    }

    final indice = _alunos.indexWhere(
          (aluno) => aluno.id == alunoAtualizado.id,
    );

    if (indice == -1) {
      return;
    }

    setState(() {
      _alunos[indice] = alunoAtualizado;
    });
  }

  Future<bool> _excluirAluno(String id) async {
    final possuiEmprestimoAtivo =
    await _firestoreEmprestimosService
        .alunoPossuiEmprestimoAtivo(id);

    if (possuiEmprestimoAtivo) {
      return false;
    }

    await _firestoreAlunosService.excluirAluno(id);

    if (!mounted) {
      return true;
    }

    setState(() {
      _alunos.removeWhere(
            (aluno) => aluno.id == id,
      );
    });

    return true;
  }

  Future<void> _carregarEmprestimos() async {
    final emprestimosSalvos =
    await _firestoreEmprestimosService.buscarEmprestimos();

    if (!mounted) {
      return;
    }

    setState(() {
      _emprestimos.clear();
      _emprestimos.addAll(emprestimosSalvos);
    });
  }

  Future<Emprestimo?> _adicionarEmprestimo(
      Emprestimo emprestimo,
      ) async {
    final emprestimoSalvo =
    await _firestoreEmprestimosService.adicionarEmprestimo(
      emprestimo,
    );

    if (emprestimoSalvo == null) {
      return null;
    }

    if (mounted) {
      setState(() {
        _emprestimos.add(emprestimoSalvo);
      });
    }

    return emprestimoSalvo;
  }

  Future<void> _registrarDevolucao(
      String idEmprestimo,
      ) async {
    await _firestoreEmprestimosService.registrarDevolucao(
      idEmprestimo,
    );

    await _carregarEmprestimos();
  }

  @override
  Widget build(BuildContext contextTelaInicial) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca Escolar'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: contextTelaInicial,
                builder: (contextoDialogo) {
                  return AlertDialog(
                    title: const Text('Sair'),
                    content: const Text(
                      'Deseja sair da sua conta?',
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
                        child: const Text('Sair'),
                      ),
                    ],
                  );
                },
              );

              if (!contextTelaInicial.mounted) {
                return;
              }

              if (confirmar != true) {
                return;
              }

              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_library,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              'Sistema da Biblioteca',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            if (_carregandoLivros)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: CircularProgressIndicator(),
              ),

            if (_erroCarregamentoLivros != null)
              Column(
                children: [
                  Text(_erroCarregamentoLivros!),
                  
                  TextButton(
                      onPressed: _carregarLivrosInicial,
                      child: const Text('Tentar Novamente'),
                  ),

                  const SizedBox(height: 16),
                ],
              ),

            ElevatedButton(
              onPressed: _carregandoLivros
                ? null
                : () {
                  Navigator.push(
                    contextTelaInicial,
                    MaterialPageRoute(
                      builder: (contextoRotaLivros) {
                        return TelaLivros(
                          livros: _livros,
                          onAdicionarLivro: _adicionarLivro,
                          onExcluirLivro: _excluirLivro,
                          onAtualizarLivro: _atualizarLivro,
                        );
                      },
                    ),
                  );
                },
                child: const Text('Livros'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () async {
                try {
                  await _carregarAlunos();

                  if (!contextTelaInicial.mounted) {
                    return;
                  }

                  Navigator.push(
                    contextTelaInicial,
                    MaterialPageRoute(
                      builder: (contextoRotaAlunos) {
                        return TelaAlunos(
                          alunos: _alunos,
                          onAdicionarAluno: _adicionarAluno,
                          onAtualizarAluno: _atualizarAluno,
                          onExcluirAluno: _excluirAluno,
                        );
                      },
                    ),
                  );
                } catch (erro) {
                  if (!contextTelaInicial.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    contextTelaInicial,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Não foi possível carregar os alunos.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Alunos'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: _carregandoLivros
                  ? null
                  : () async {
                try {
                  await _carregarAlunos();
                  await _carregarEmprestimos();

                  if (!contextTelaInicial.mounted) {
                    return;
                  }

                  Navigator.push(
                    contextTelaInicial,
                    MaterialPageRoute(
                      builder: (contextoRotaEmprestimos) {
                        return TelaEmprestimos(
                          alunos: _alunos,
                          livros: _livros,
                          emprestimos: _emprestimos,
                          onAdicionarEmprestimo:
                          _adicionarEmprestimo,
                          onRegistrarDevolucao:
                          _registrarDevolucao,
                        );
                      },
                    ),
                  );
                } catch (erro) {
                  if (!contextTelaInicial.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    contextTelaInicial,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Não foi possível carregar os dados dos empréstimos.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Empréstimos'),
            ),
          ],
        ),
      ),
    );
  }
}