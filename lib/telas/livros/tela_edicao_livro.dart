import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

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
  late final TextEditingController _quantidadeController;
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _capaManualBytes;
  bool _removerCapaManual = false;

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

    _quantidadeController = TextEditingController(
      text: widget.livro.quantidadeTotal.toString(),
    );

    if (widget.livro.capaBase64 != null &&
        widget.livro.capaBase64!.isNotEmpty) {
      try {
        _capaManualBytes = base64Decode(
          widget.livro.capaBase64!,
        );
      } catch (erro) {
        _capaManualBytes = null;
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _isbnController.dispose();
    _editoraController.dispose();
    _quantidadeController.dispose();

    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    final imagem = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 900,
      imageQuality: 70,
    );

    if (imagem == null) {
      return;
    }

    final bytes = await imagem.readAsBytes();

    if (bytes.length > 400000) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A imagem selecionada é muito grande.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _capaManualBytes = bytes;
      _removerCapaManual = false;
    });
  }

  void _removerImagemManual() {
    setState(() {
      _capaManualBytes = null;
      _removerCapaManual = true;
    });
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

                const SizedBox(height: 16),

                if (_capaManualBytes != null)
                  Image.memory(
                    _capaManualBytes!,
                    width: 140,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                else if (widget.livro.urlCapa != null &&
                    widget.livro.urlCapa!.isNotEmpty)
                  Image.network(
                    widget.livro.urlCapa!,
                    width: 140,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return const Icon(
                        Icons.menu_book_outlined,
                        size: 60,
                      );
                    },
                  )
                else
                  const Icon(
                    Icons.menu_book_outlined,
                    size: 60,
                  ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: _selecionarImagem,
                  icon: const Icon(Icons.image_outlined),
                  label: Text(
                    _capaManualBytes == null
                        ? 'Selecionar imagem'
                        : 'Trocar imagem',
                  ),
                ),

                if (_capaManualBytes != null) ...[
                  const SizedBox(height: 8),

                  TextButton.icon(
                    onPressed: _removerImagemManual,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text(
                      'Remover capa',
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                TextFormField(
                  controller: _quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade de cópias',
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe a quantidade de cópias';
                    }

                    final quantidade = int.tryParse(valor.trim());

                    if (quantidade == null || quantidade <= 0) {
                      return 'Informe uma quantidade válida';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final capaBase64 = _removerCapaManual
                        ? null
                        : _capaManualBytes != null
                        ? base64Encode(_capaManualBytes!)
                        : widget.livro.capaBase64;

                    final livroAtualizado = Livro(
                      titulo: _tituloController.text.trim(),
                      autor: _autorController.text.trim(),
                      isbn: widget.livro.isbn,
                      editora: _editoraController.text.trim(),
                      urlCapa: widget.livro.urlCapa,
                      capaBase64: capaBase64,
                      quantidadeTotal: int.parse(_quantidadeController.text.trim()),
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