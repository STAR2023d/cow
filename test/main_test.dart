import 'package:cow/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('main.dart keeps its entry point and root widget', () {
    // If main() or CowApp is ever removed, this file stops compiling.
    expect(app.main, isNotNull);
    expect(const app.CowApp(), isNotNull);
  });
}
