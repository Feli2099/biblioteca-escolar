import 'package:flutter/material.dart';

class TelaLivros extends StatelessWidget {
  const TelaLivros({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {},
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