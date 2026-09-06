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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _isbnController.dispose();
    _editoraController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext contextTelaCadastroLivro) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Livros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),

                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Informe o título';
                  }

                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(
                  labelText: 'Autor',
                ),

                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Informe o autor';
                  }

                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(
                  labelText: 'ISBN',
                ),

                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Informe o ISBN';
                  }

                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _editoraController,
                decoration: const InputDecoration(
                  labelText: 'Editora',
                ),

                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Informe a Editora';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
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
                    }
                  },
                  child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      )
    );
  }
}