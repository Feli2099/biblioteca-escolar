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

  final FirestoreLivrosService _firestoreLivrosService = FirestoreLivrosService();

  Future<bool> _adicionarLivro(Livro livro) async {
    final cadastrado = await _firestoreLivrosService.adicionarLivro(livro);

    if (!cadastrado) {
      return false;
    }

    await _carregarLivros();

    return true;
  }

  @override
  void initState() {
    super.initState();

    _carregarLivros();
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

            ElevatedButton(
              onPressed: () {
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