import 'dart:io';

import 'package:test/test.dart';
import 'package:build_test/build_test.dart';
import 'package:path/path.dart' as p;

import 'package:galileo_message_builder/galileo_message_builder.dart';

void main() {
  const builder = MessageBuilder();

  group('goldens', () {
    final goldenDir = Directory('test/goldens/');
    for (final item in goldenDir.listSync()) {
      if (!item.path.endsWith('.yaml') || item is! File) continue;
      final file = item as File;
      test(p.basename(file.path), () {
        final yamlContent = file.readAsStringSync();
        final dartFile = File(file.path.substring(0, file.path.length - 4) + 'dart');
        final dartContent = dartFile.readAsStringSync();
        return testBuilder(builder, {'a|${p.basename(file.path)}': yamlContent},
            outputs: {'a|${p.basename(dartFile.path)}': decodedMatches(dartContent)});
      });
    }
  });
}
