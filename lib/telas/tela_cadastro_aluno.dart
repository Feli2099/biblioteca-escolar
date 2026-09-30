import 'package:flutter/material.dart';
import 'package:biblioteca_escolar/modelos/aluno.dart';

class TelaCadastroAluno extends StatefulWidget {
  final Future<void> Function(Aluno) onCadastrar;

  const TelaCadastroAluno({
    super.key,
    required this.onCadastrar,
  });

  @override
  State<TelaCadastroAluno> createState() {
    return _TelaCadastroAlunoState();
  }
}

class _TelaCadastroAlunoState extends State<TelaCadastroAluno> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController =
  TextEditingController();

  final TextEditingController _turmaController =
  TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _turmaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext contextTelaCadastroAluno) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Aluno'),
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
                  if (valor == null ||
                      valor.trim().isEmpty) {
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
                  if (valor == null ||
                      valor.trim().isEmpty) {
                    return 'Informe a turma';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final aluno = Aluno(
                    nomeCompleto:
                    _nomeController.text.trim(),
                    turma:
                    _turmaController.text.trim(),
                  );

                  try {
                    await widget.onCadastrar(aluno);

                    if (!contextTelaCadastroAluno.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      contextTelaCadastroAluno,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Aluno cadastrado com sucesso!',
                        ),
                      ),
                    );

                    _nomeController.clear();
                    _turmaController.clear();
                  } catch (erro) {
                    if (!contextTelaCadastroAluno.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      contextTelaCadastroAluno,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Erro ao cadastrar o aluno.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}