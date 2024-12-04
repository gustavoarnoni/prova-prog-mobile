import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conversor_de_moedas/screens/formulario_screen.dart';

void main() {
  testWidgets('Testa o valor do campo de texto no FormulárioScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FormularioScreen(),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), '100');

    expect(find.text('100'), findsOneWidget);
  });
}
