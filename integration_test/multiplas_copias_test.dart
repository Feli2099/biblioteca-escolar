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

Future<void> preencherEmprestimo({
  required WidgetTester tester,
  required String nomeAluno,
  required String turma,
  required String tituloLivro,
}) async {
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
}

Future<void> limparColecao(String nomeColecao) async {
  final documentos = await FirebaseFirestore.instance
      .collection(nomeColecao)
      .get();

  for (final documento in documentos.docs) {
    await documento.reference.delete();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'deve respeitar a quantidade de cópias disponíveis',
      (tester) async {
        await app.main();
        await tester.pumpAndSettle();

        await FirebaseAuth.instance.signOut();
        await tester.pumpAndSettle();

        final identificador =
            DateTime.now().millisecondsSinceEpoch;

        final nomeAluno =
            'Aluno Cópias $identificador';

        const turma = '7º A';

        final tituloLivro =
            'Livro Cópias $identificador';

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

        const usandoEmulador =
        bool.fromEnvironment('USE_FIREBASE_EMULATOR');

        expect(
          usandoEmulador,
          true,
        );

        await limparColecao('emprestimos');
        await limparColecao('livros');
        await limparColecao('alunos');

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

        await tester.enterText(
          camposLivro.at(4),
          '2',
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

        expect(
          livroSalvo.data()?['quantidadeTotal'],
          2,
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

        await preencherEmprestimo(
          tester: tester,
          nomeAluno: nomeAluno,
          turma: turma,
          tituloLivro: tituloLivro,
        );

        await tester.tap(
          find.widgetWithText(
            ElevatedButton,
            'Registrar Empréstimo',
          ),
        );

        await tester.pumpAndSettle();

        final aposPrimeiroEmprestimo =
        await FirebaseFirestore.instance
            .collection('emprestimos')
            .where(
          'livroIsbn',
          isEqualTo: isbn,
        )
            .get();

        expect(
          aposPrimeiroEmprestimo.docs.length,
          1,
        );

        expect(
          aposPrimeiroEmprestimo.docs.first.data()['devolvido'],
          false,
        );

        await preencherEmprestimo(
          tester: tester,
          nomeAluno: nomeAluno,
          turma: turma,
          tituloLivro: tituloLivro,
        );

        await tester.tap(
          find.widgetWithText(
            ElevatedButton,
            'Registrar Empréstimo',
          ),
        );

        await tester.pumpAndSettle();

        final aposSegundoEmprestimo =
        await FirebaseFirestore.instance
            .collection('emprestimos')
            .where(
          'livroIsbn',
          isEqualTo: isbn,
        )
            .get();

        expect(
          aposSegundoEmprestimo.docs.length,
          2,
        );

        final doisEmprestimosAtivos =
        await FirebaseFirestore.instance
            .collection('emprestimos')
            .where(
          'livroIsbn',
          isEqualTo: isbn,
        )
            .where(
          'devolvido',
          isEqualTo: false,
        )
            .get();

        expect(
          doisEmprestimosAtivos.docs.length,
          2,
        );

        await preencherEmprestimo(
          tester: tester,
          nomeAluno: nomeAluno,
          turma: turma,
          tituloLivro: tituloLivro,
        );

        await tester.tap(
          find.widgetWithText(
            ElevatedButton,
            'Registrar Empréstimo',
          ),
        );

        await tester.pumpAndSettle();

        final aposTentativaTerceiro =
        await FirebaseFirestore.instance
            .collection('emprestimos')
            .where(
          'livroIsbn',
          isEqualTo: isbn,
        )
            .where(
          'devolvido',
          isEqualTo: false,
        )
            .get();

        expect(
          aposTentativaTerceiro.docs.length,
          2,
        );

        await voltar(tester);

        await tester.tap(
          find.widgetWithText(
            ElevatedButton,
            'Listar Empréstimos',
          ),
        );

        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(
          find.text(tituloLivro).first,
          300,
          scrollable: find.byType(Scrollable).last,
        );

        await tester.pumpAndSettle();

        final cardsEmprestimo = find.ancestor(
          of: find.text(tituloLivro),
          matching: find.byType(Card),
        );

        expect(
          cardsEmprestimo,
          findsWidgets,
        );

        final botoesDevolucao = find.descendant(
          of: cardsEmprestimo,
          matching: find.byIcon(
            Icons.assignment_return,
          ),
        );

        expect(
          botoesDevolucao,
          findsWidgets,
        );

        await tester.tap(
          botoesDevolucao.at(0),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(
            TextButton,
            'Confirmar',
          ),
        );

        await tester.pumpAndSettle();

        final aposDevolucao =
        await FirebaseFirestore.instance
            .collection('emprestimos')
            .where(
          'livroIsbn',
          isEqualTo: isbn,
        )
            .where(
          'devolvido',
          isEqualTo: false,
        )
            .get();

        expect(
          aposDevolucao.docs.length,
          1,
        );

        await voltar(tester);

        await tester.tap(
          find.widgetWithText(
            ElevatedButton,
            'Registrar Empréstimo',
          ),
        );

        await tester.pumpAndSettle();

        await preencherEmprestimo(
          tester: tester,
          nomeAluno: nomeAluno,
          turma: turma,
          tituloLivro: tituloLivro,
        );

        await tester.tap(
          find.widgetWithText(
            ElevatedButton,
            'Registrar Empréstimo',
          ),
        );

        await tester.pumpAndSettle();

        final aposNovoEmprestimo =
        await FirebaseFirestore.instance
            .collection('emprestimos')
            .where(
          'livroIsbn',
          isEqualTo: isbn,
        )
            .where(
          'devolvido',
          isEqualTo: false,
        )
            .get();

        expect(
          aposNovoEmprestimo.docs.length,
          2,
        );

        final historicoEmprestimos =
        await FirebaseFirestore.instance
            .collection('emprestimos')
            .where(
          'livroIsbn',
          isEqualTo: isbn,
        )
            .get();

        expect(
          historicoEmprestimos.docs.length,
          3,
        );

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
            'Listar Livros',
          ),
        );

        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(
          find.text(tituloLivro),
          300,
          scrollable: find.byType(Scrollable).last,
        );

        await tester.pumpAndSettle();

        final cardLivro = find.ancestor(
          of: find.text(tituloLivro),
          matching: find.byType(Card),
        );

        expect(
          cardLivro,
          findsOneWidget,
        );

        final botaoExcluirLivro = find.descendant(
          of: cardLivro,
          matching: find.byIcon(
            Icons.delete_outline,
          ),
        );

        expect(
          botaoExcluirLivro,
          findsOneWidget,
        );

        await tester.tap(
          botaoExcluirLivro,
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(
            TextButton,
            'Excluir',
          ),
        );

        await tester.pumpAndSettle();

        final livroAposTentativaExclusao =
        await FirebaseFirestore.instance
            .collection('livros')
            .doc(isbn)
            .get();

        expect(
          livroAposTentativaExclusao.exists,
          true,
        );

        await voltar(tester);
        await voltar(tester);

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
            'Listar Alunos',
          ),
        );

        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(
          find.text(nomeAluno),
          300,
          scrollable: find.byType(Scrollable).last,
        );

        await tester.pumpAndSettle();

        final cardAluno = find.ancestor(
          of: find.text(nomeAluno),
          matching: find.byType(Card),
        );

        expect(
          cardAluno,
          findsOneWidget,
        );

        final botaoExcluirAluno = find.descendant(
          of: cardAluno,
          matching: find.byIcon(
            Icons.delete_outline,
          ),
        );

        expect(
          botaoExcluirAluno,
          findsOneWidget,
        );

        await tester.tap(
          botaoExcluirAluno,
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(
            TextButton,
            'Excluir',
          ),
        );

        await tester.pumpAndSettle();

        final alunoAposTentativaExclusao =
        await FirebaseFirestore.instance
            .collection('alunos')
            .where(
          'nomeCompleto',
          isEqualTo: nomeAluno,
        )
            .get();

        expect(
          alunoAposTentativaExclusao.docs.length,
          1,
        );
      },
  );
}