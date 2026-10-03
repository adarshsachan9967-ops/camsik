import 'package:flutter_test/flutter_test.dart';
import 'package:casmik_partner_app/app.dart';

void main() {
  testWidgets('CamsikPartnerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CamsikPartnerApp());
    expect(find.byType(CamsikPartnerApp), findsOneWidget);
  });
}
