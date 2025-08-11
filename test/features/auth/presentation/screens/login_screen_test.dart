


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myntora_app/features/auth/auth.dart';

void main() {

  testWidgets('Encontrar inputs', (tester) async{
    
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: LoginScreen(),
        ),
      ),
    );

    final email = find.byKey(Key('email'));
    final password = find.byKey(Key('password'));

    expect(email, findsOneWidget);
    expect(password, findsOneWidget);

  });

  testWidgets('Encontrar errores', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(800, 1200)),
        child: LoginScreen(),
      ),
    ),
  );

  final email = find.byKey(const Key('email'));
  final password = find.byKey(const Key('password'));
  
  await tester.enterText(email, '');
  await tester.enterText(password, '');

  await tester.tap(find.byKey(Key('filledButton')));
  await tester.pump();

  expect(find.text('El correo es requerido'), findsOneWidget);
  expect(find.text('La contraseña es requerida'), findsOneWidget);
});
}