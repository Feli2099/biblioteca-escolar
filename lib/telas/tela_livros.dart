import 'tela_cadastro_livro.dart';
import 'package:flutter/material.dart';

class TelaLivros extends StatelessWidget {
  const TelaLivros({super.key});

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
                          builder: (contextRotaTCL) => const TelaCadastroLivro()
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