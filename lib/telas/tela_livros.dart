import 'package:flutter/material.dart';

class TelaLivros extends StatelessWidget {
  const TelaLivros({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros'),
      ),
      body: const Center(
        child: Text('Tela de livros'),
      ),
    );
  }
}