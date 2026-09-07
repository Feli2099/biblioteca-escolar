import 'tela_cadastro_livro.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

class TelaLivros extends StatefulWidget {
  const TelaLivros({super.key});

  @override
  State<TelaLivros> createState() {
    return _TelaLivroState();
  }
}

class _TelaLivroState extends State<TelaLivros> {
  final List<Livro> _livros = [];

  @override
  Widget build(BuildContext contextTelaLivros) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      contextTelaLivros,
                      MaterialPageRoute(
                          builder: (contextRotaCadastro) {
                            return TelaCadastroLivro(
                              livros: _livros,
                            );
                          },
                      ),
                  );
                },
                child: const Text('Cadastrar Livro'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: () {},
                child: const Text('Listar Livros')
            ),
          ],
        ),
      ),
    );
  }
}