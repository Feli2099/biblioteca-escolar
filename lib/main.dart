import 'package:flutter/material.dart';
import 'telas/tela_inicial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BibliotecaApp());
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext contextBibliotecaApp) {
    return const MaterialApp(
      title: 'Biblioteca Escolar',
      debugShowCheckedModeBanner: false,
      home: const TelaInicial(),
    );
  }
}