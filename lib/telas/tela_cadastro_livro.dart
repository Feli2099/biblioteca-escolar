import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

class TelaCadastroLivro extends StatefulWidget {
  const TelaCadastroLivro({super.key});

  @override
  State<TelaCadastroLivro> createState() {
    return _TelaCadastroLivro();
  }
}

class _TelaCadastroLivro extends State<TelaCadastroLivro> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _editoraController = TextEditingController();

  @override
  Widget build(BuildContext contextTelaCadastroLivro) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Livros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _autorController,
              decoration: const InputDecoration(
                labelText: 'Autor',
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _isbnController,
              decoration: const InputDecoration(
                labelText: 'ISBN',
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _editoraController,
              decoration: const InputDecoration(
                labelText: 'Editora',
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
                onPressed: () {
                  final titulo = _tituloController.text;
                  final autor = _autorController.text;
                  final isbn = _isbnController.text;
                  final editora = _editoraController.text;

                  final livro = Livro(
                      titulo: titulo,
                      autor: autor,
                      isbn: isbn,
                      editora: editora
                  );

                  print('Título: ${livro.titulo}');
                  print('Autor: ${livro.autor}');
                  print('ISBN: ${livro.isbn}');
                  print('Editora: ${livro.editora}');
                },
                child: const Text("Cadastrar"),
            ),
          ],
        ),
      )
    );
  }
}