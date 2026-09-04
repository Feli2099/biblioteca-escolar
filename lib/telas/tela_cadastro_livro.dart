import 'package:flutter/material.dart';

class TelaCadastroLivro extends StatelessWidget {
  const TelaCadastroLivro({super.key});

  @override
  Widget build(BuildContext contextTelaCadastroLivro) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Livros'),
      ),
      body: Center(
        child: const Text('Cadastrar Livro'),
      ),
    );
  }
}
