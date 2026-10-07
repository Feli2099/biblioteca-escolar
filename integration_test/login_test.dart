import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:biblioteca_escolar/main.dart' as app;
import 'package:biblioteca_escolar/telas/autenticacao/tela_login.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'deve realizar login com usuário válido',
        (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await FirebaseAuth.instance.signOut();
      await tester.pumpAndSettle();

      expect(
        find.byType(TelaLogin),
        findsOneWidget,
      );

      final campos = find.byType(TextField);

      await tester.enterText(
        campos.at(0),
        'teste@biblioteca.com',
      );

      await tester.enterText(
        campos.at(1),
        'teste123456',
      );

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Entrar',
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(
        FirebaseAuth.instance.currentUser,
        isNotNull,
      );

      expect(
        FirebaseAuth.instance.currentUser!.email,
        'teste@biblioteca.com',
      );

      expect(
        find.byType(TelaLogin),
        findsNothing,
      );
    },
  );
}