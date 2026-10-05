import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() {
    return _TelaLoginState();
  }
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _senhaController =
  TextEditingController();

  bool _carregando = false;
  bool _senhaVisivel = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar(
      BuildContext contextTelaLogin,
      ) async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(
        contextTelaLogin,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Informe o e-mail e a senha.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException {
      if (!contextTelaLogin.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        contextTelaLogin,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'E-mail ou senha inválidos.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext contextTelaLogin) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca Escolar'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.local_library,
                size: 80,
              ),

              const SizedBox(height: 32),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _senhaController,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _senhaVisivel = !_senhaVisivel;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _carregando
                    ? null
                    : () {
                  _entrar(
                    contextTelaLogin,
                  );
                },
                child: Text(
                  _carregando
                      ? 'Entrando...'
                      : 'Entrar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}