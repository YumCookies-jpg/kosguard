import 'package:flutter_test/flutter_test.dart';
import 'package:kosguard/main.dart';

void main() {
  testWidgets('Kosguard opens on the shared inventory', (tester) async {
    await tester.pumpWidget(const KosGuardApp());

    expect(find.text('Inventaris bersama'), findsOneWidget);
    expect(find.text('Laporkan'), findsOneWidget);
    expect(find.text('Data contoh'), findsOneWidget);
  });
}
