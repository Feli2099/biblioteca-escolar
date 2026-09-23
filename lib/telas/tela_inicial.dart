import 'package:flutter/material.dart';
import 'tela_livros.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:biblioteca_escolar/servicos/firestore_livros_service.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() {
    return _TelaInicialState();
  }
}

class _TelaInicialState extends State<TelaInicial> {
  final List<Livro> _livros = [];

  bool _carregandoLivros = true;
  String? _erroCarregamento;

  final FirestoreLivrosService _firestoreLivrosService = FirestoreLivrosService();

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

      print(
        'Livro salvo no Firestore, '
        'mas a lista não pôde ser atualizada: $erro',
      );
    }

    return true;
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
        _erroCarregamento = null;
      });
    }

    try {
      await _carregarLivros();
    } catch (erro) {
      if (!mounted) {
        return;
      }

      setState(() {
        _erroCarregamento = 'Não foi possível carregar os livros.';
      });
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _carregandoLivros = false;
      });
    }
  }

  @override
  Widget build(BuildContext contextTelaInicial) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca Escolar'),
        centerTitle: true,
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

            if (_erroCarregamento != null)
              Column(
                children: [
                  Text(_erroCarregamento!),
                  
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
                        );
                      },
                    ),
                  );
                },
                child: const Text('Livros'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Alunos'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Empréstimos'),
            )
          ],
        ),
      ),
    );
  }
}