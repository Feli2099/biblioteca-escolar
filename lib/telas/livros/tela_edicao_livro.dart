import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

class TelaEdicaoLivro extends StatefulWidget {
  final Livro livro;

  const TelaEdicaoLivro({
    super.key,
    required this.livro,
  });

  @override
  State<TelaEdicaoLivro> createState() {
    return _TelaEdicaoLivroState();
  }
}

class _TelaEdicaoLivroState extends State<TelaEdicaoLivro> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloController;
  late final TextEditingController _autorController;
  late final TextEditingController _isbnController;
  late final TextEditingController _editoraController;

  @override
  void initState() {
    super.initState();

    _tituloController = TextEditingController(
      text: widget.livro.titulo,
    );

    _autorController = TextEditingController(
      text: widget.livro.autor,
    );

    _isbnController = TextEditingController(
      text: widget.livro.isbn,
    );

    _editoraController = TextEditingController(
      text: widget.livro.editora,
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _isbnController.dispose();
    _editoraController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext contextTelaEdicao) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Livro'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o título';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _autorController,
                  decoration: const InputDecoration(
                    labelText: 'Autor',
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o autor';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _isbnController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'ISBN',
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _editoraController,
                  decoration: const InputDecoration(
                    labelText: 'Editora',
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final livroAtualizado = Livro(
                      titulo: _tituloController.text.trim(),
                      autor: _autorController.text.trim(),
                      isbn: widget.livro.isbn,
                      editora: _editoraController.text.trim(),
                      urlCapa: widget.livro.urlCapa,
                    );

                    Navigator.pop(
                      contextTelaEdicao,
                      livroAtualizado,
                    );
                  },
                  child: const Text('Salvar alterações'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}