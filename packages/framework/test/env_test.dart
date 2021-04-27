import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:test/test.dart';

void main() {
  test('custom value', () => expect(GalileoEnvironment('hey').value, 'hey'));

  test('lowercases', () => expect(GalileoEnvironment('HeY').value, 'hey'));
  test('default to env or development',
      () => expect(GalileoEnvironment().value, (Platform.environment['galileo_ENV'] ?? 'development').toLowerCase()));
  test('isDevelopment', () => expect(GalileoEnvironment('development').isDevelopment, true));
  test('isStaging', () => expect(GalileoEnvironment('staging').isStaging, true));
  test('isDevelopment', () => expect(GalileoEnvironment('production').isProduction, true));
}
