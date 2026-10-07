import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:biblioteca_escolar/main.dart' as app;
import 'package:biblioteca_escolar/modelos/aluno.dart';
import 'package:biblioteca_escolar/modelos/livro.dart';

String gerarIsbn13() {
  final sufixo = (
      DateTime.now().millisecondsSinceEpoch %
          1000000000
  ).toString().padLeft(9, '0');

  final base = '978$sufixo';

  int soma = 0;

  for (int i = 0; i < 12; i++) {
    final digito = int.parse(base[i]);

    soma += digito * (i.isEven ? 1 : 3);
  }

  final digitoVerificador =
      (10 - (soma % 10)) % 10;

  return '$base$digitoVerificador';
}

Future<void> voltar(WidgetTester tester) async {
  await tester.tap(
    find.byType(BackButton),
  );

  await tester.pumpAndSettle();
}

Future<QuerySnapshot<Map<String, dynamic>>> aguardarDocumento({
  required String colecao,
  required String campo,
  required Object valor,
}) async {
  for (int tentativa = 0; tentativa < 20; tentativa++) {
    final resultado = await FirebaseFirestore.instance
        .collection(colecao)
        .where(campo, isEqualTo: valor)
        .get();

    if (resultado.docs.isNotEmpty) {
      return resultado;
    }

    await Future<void>.delayed(
      const Duration(milliseconds: 250),
    );
  }

  throw TestFailure(
    'Documento não encontrado na coleção $colecao.',
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'deve executar o fluxo principal da biblioteca',
        (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await FirebaseAuth.instance.signOut();
      await tester.pumpAndSettle();

      final identificador =
          DateTime.now().millisecondsSinceEpoch;

      final nomeAluno =
          'Aluno Teste $identificador';

      const turma = '7º A';

      final tituloLivro =
          'Livro Teste $identificador';

      const autor = 'Autor Teste';
      const editora = 'Editora Teste';

      final isbn = gerarIsbn13();

      final camposLogin =
      find.byType(TextField);

      await tester.enterText(
        camposLogin.at(0),
        'teste@biblioteca.com',
      );

      await tester.enterText(
        camposLogin.at(1),
        'teste123456',
      );

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Entrar',
        ),
      );

      await tester.pump(
        const Duration(seconds: 2),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Sistema da Biblioteca'),
        findsOneWidget,
      );

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Alunos',
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Cadastrar Aluno',
        ),
      );

      await tester.pumpAndSettle();

      final camposAluno =
      find.byType(TextFormField);

      await tester.enterText(
        camposAluno.at(0),
        nomeAluno,
      );

      await tester.enterText(
        camposAluno.at(1),
        turma,
      );

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Cadastrar',
        ),
      );

      final alunoSalvo = await aguardarDocumento(
        colecao: 'alunos',
        campo: 'nomeCompleto',
        valor: nomeAluno,
      );

      expect(
        alunoSalvo.docs.length,
        1,
      );

      await tester.pumpAndSettle();

      await voltar(tester);
      await voltar(tester);

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Livros',
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Cadastrar Livro',
        ),
      );

      await tester.pumpAndSettle();

      final camposLivro =
      find.byType(TextFormField);

      await tester.enterText(
        camposLivro.at(0),
        tituloLivro,
      );

      await tester.enterText(
        camposLivro.at(1),
        autor,
      );

      await tester.enterText(
        camposLivro.at(2),
        isbn,
      );

      await tester.enterText(
        camposLivro.at(3),
        editora,
      );

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Cadastrar',
        ),
      );

      await tester.pumpAndSettle();

      final livroSalvo =
      await FirebaseFirestore.instance
          .collection('livros')
          .doc(isbn)
          .get();

      expect(
        livroSalvo.exists,
        true,
      );

      await voltar(tester);
      await voltar(tester);

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Empréstimos',
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Registrar Empréstimo',
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byType(
          DropdownButtonFormField<Aluno>,
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find
            .text('$nomeAluno - $turma')
            .last,
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byType(
          DropdownButtonFormField<Livro>,
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text(tituloLivro).last,
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text(
          'Selecionar data de devolução',
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(
          TextButton,
          'OK',
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Registrar Empréstimo',
        ),
      );

      await tester.pumpAndSettle();

      await voltar(tester);

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Listar Empréstimos',
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(tituloLivro),
        findsOneWidget,
      );

      expect(
        find.text('Status: Emprestado'),
        findsOneWidget,
      );

      final cardEmprestimo = find.ancestor(
        of: find.text(tituloLivro),
        matching: find.byType(Card),
      );

      expect(
        cardEmprestimo,
        findsOneWidget,
      );

      final botaoDevolucao = find.descendant(
        of: cardEmprestimo,
        matching: find.byIcon(
          Icons.assignment_return,
        ),
      );

      expect(
        botaoDevolucao,
        findsOneWidget,
      );

      await tester.tap(
        botaoDevolucao,
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(
          TextButton,
          'Confirmar',
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Status: Devolvido'),
        findsOneWidget,
      );

      final emprestimos =
      await FirebaseFirestore.instance
          .collection('emprestimos')
          .where(
        'livroIsbn',
        isEqualTo: isbn,
      )
          .get();

      expect(
        emprestimos.docs.length,
        1,
      );

      final dadosEmprestimo =
      emprestimos.docs.first.data();

      expect(
        dadosEmprestimo['devolvido'],
        true,
      );

      expect(
        dadosEmprestimo['dataDevolucaoReal'],
        isNotNull,
      );
    },
  );
}