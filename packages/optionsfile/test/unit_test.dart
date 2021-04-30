library unittests;

import 'package:options_file/options_file.dart';

import 'dart:io';

import 'package:test/test.dart';

class FileIOExceptionMatcher extends Matcher {
  const FileIOExceptionMatcher();
  Description describe(Description description) =>
      description.add("FileIOException");
  bool matches(item, Map matchState) => item is FileSystemException;
}

class FormatExceptionMatcher extends Matcher {
  const FormatExceptionMatcher();
  Description describe(Description description) =>
      description.add("FormatException");
  bool matches(item, Map matchState) => item is FormatException;
}

void main() {
  test('Should throw exception when file is missing', () {
    expect(() {
      OptionsFile('bob');
    }, throwsA(FileIOExceptionMatcher()));
  });

  test('Should not throw exception when file is present', () {
    OptionsFile('pubspec.yaml');
  });

  test('Should read string value', () {
    final options = OptionsFile('test/options');
    final name = options.getString("name");
    expect("James", name);
  });

  test('Should ignore space around keys', () {
    final options = OptionsFile('test/options');
    var name = options.getString("name1");
    expect("James", name);

    name = options.getString("name2");
    expect("James", name);
  });

  test('Should ignore space around values', () {
    final options = OptionsFile('test/options');
    final name = options.getString("name3");
    expect("James", name);
  });

  test('Should read int value', () {
    final options = OptionsFile('test/options');
    final age = options.getInt("age");
    expect(90, age);
  });

  test('Should throw format exception when reading bad int', () {
    final options = OptionsFile('test/options');
    expect(() {
      final age = options.getInt("name");
    }, throwsA(FormatExceptionMatcher()));
  });

  test('Should ignore comment lines', () {
    final options = OptionsFile('test/options');
    final thing = options.getInt("thing");
    expect(null, thing);
  });

  test('Should use default string value when option is missing', () {
    final options = OptionsFile('test/options');
    final wibble = options.getString("wibble", "default");
    expect("default", wibble);
  });

  test('Should use default int value when option is missing', () {
    final options = OptionsFile('test/options');
    final wibble = options.getInt("wibble", 123);
    expect(123, wibble);
  });

  test(
      'Should use default string value from default file when option is missing',
      () {
    final options = OptionsFile('test/options', 'test/defaultoptions');
    final wibble = options.getString("thing");
    expect("default", wibble);
  });

  test('Should use default int value from default file when option is missing',
      () {
    final options = OptionsFile('test/options', 'test/defaultoptions');
    final wibble = options.getInt("number");
    expect(12, wibble);
  });

  test('Should use default string value when option is missing in both files',
      () {
    final options = OptionsFile('test/options', 'test/defaultoptions');
    final wibble = options.getString("thing2", "xyz");
    expect("xyz", wibble);
  });

  test('Should use default int value when option is missing in both files', () {
    final options = OptionsFile('test/options', 'test/defaultoptions');
    final wibble = options.getInt("number2", 123);
    expect(123, wibble);
  });
}
