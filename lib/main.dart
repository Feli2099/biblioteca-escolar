import 'package:flutter/material.dart';

void main() {
  runApp(const BibliotecaApp());
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca Escolar',
      debugShowCheckedModeBanner: false,
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext) {
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