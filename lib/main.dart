import 'package:flutter/material.dart';
import 'telas/tela_inicial.dart';

void main() {
  runApp(const BibliotecaApp());
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Biblioteca Escolar',
      debugShowCheckedModeBanner: false,
      home: const TelaInicial(),
    );
  }
}