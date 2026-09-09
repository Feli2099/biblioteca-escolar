import 'tela_cadastro_livro.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';
import 'tela_listagem_livros.dart';

class TelaLivros extends StatefulWidget {
  final List<Livro> livros;
  final bool Function(Livro) onAdicionarLivro;

  const TelaLivros({
    super.key,
    required this.livros,
    required this.onAdicionarLivro,
  });

  @override
  State<TelaLivros> createState() {
    return _TelaLivroState();
  }
}

class _TelaLivroState extends State<TelaLivros> {
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
                          onCadastrar: widget.onAdicionarLivro,
                        );
                      },
                    ),
                  );
                },
                child: const Text('Cadastrar Livro'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    contextTelaLivros,
                    MaterialPageRoute(
                      builder: (contextRotaListagem) {
                        return TelaListagemLivros(
                          livros: widget.livros
                        );
                      },
                    ),
                  );
                },
                child: const Text('Listar Livros'),
            ),
          ],
        ),
      ),
    );
  }
}