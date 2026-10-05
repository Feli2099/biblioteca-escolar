import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';

class TelaEdicaoAluno extends StatefulWidget {
  final Aluno aluno;

  const TelaEdicaoAluno({
    super.key,
    required this.aluno,
  });

  @override
  State<TelaEdicaoAluno> createState() {
    return _TelaEdicaoAlunoState();
  }
}

class _TelaEdicaoAlunoState extends State<TelaEdicaoAluno> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _turmaController;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(
      text: widget.aluno.nomeCompleto,
    );

    _turmaController = TextEditingController(
      text: widget.aluno.turma,
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _turmaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contextTelaEdicaoAluno) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome completo';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _turmaController,
                decoration: const InputDecoration(
                  labelText: 'Turma',
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe a turma';
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

                  final alunoAtualizado = Aluno(
                    id: widget.aluno.id,
                    nomeCompleto: _nomeController.text.trim(),
                    turma: _turmaController.text.trim(),
                  );

                  Navigator.pop(
                    contextTelaEdicaoAluno,
                    alunoAtualizado,
                  );
                },
                child: const Text('Salvar alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}