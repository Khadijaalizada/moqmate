import 'package:flutter_test/flutter_test.dart';
import 'package:moqmate/core/validators.dart';

void main() {
  group('email', () {
    test('rejects empty and malformed', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('abc'), isNotNull);
      expect(Validators.email('a@b'), isNotNull);
    });
    test('accepts valid', () => expect(Validators.email(' a@b.co '), isNull));
  });
  group('password', () {
    test('too short', () => expect(Validators.password('abc123'), isNotNull));
    test('letters only', () => expect(Validators.password('abcdefgh'), isNotNull));
    test('digits only', () => expect(Validators.password('12345678'), isNotNull));
    test('ok', () => expect(Validators.password('abcd1234'), isNull));
  });
  test('confirmPassword', () {
    final v = Validators.confirmPassword(() => 'abcd1234');
    expect(v('abcd1234'), isNull);
    expect(v('other'), isNotNull);
  });
  test('required', () {
    expect(Validators.required('  ', 'Name'), 'Name is required');
    expect(Validators.required('x'), isNull);
  });
}
