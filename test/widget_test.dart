import 'package:flutter_test/flutter_test.dart';

import 'package:enfermeria_pro/main.dart';

void main() {
  testWidgets('Carga inicial de la app Enfermería Pro', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EnfermeriaProApp());

    // Se verifica que la pantalla de inicio cargue el texto de bienvenida.
    expect(find.text('Enfermería Pro'), findsOneWidget);
    expect(find.text('¿Qué deseas repasar hoy?'), findsOneWidget);
  });
}
