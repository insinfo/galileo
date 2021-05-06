import 'dart:collection';

import 'package:source_span/source_span.dart';

abstract class TwigObject {
  final FileSpan span;
  final usages = <SymbolUsage>[];
  String get name;

  TwigObject(this.span);
}

class TwigCustomElement extends TwigObject {
  final String name;
  final attributes = new SplayTreeSet<String>();

  TwigCustomElement(this.name, FileSpan span) : super(span);
}

class TwigVariable extends TwigObject {
  final String name;
  TwigVariable(this.name, FileSpan span) : super(span);
}

class SymbolUsage {
  final SymbolUsageType type;
  final FileSpan span;

  SymbolUsage(this.type, this.span);
}

enum SymbolUsageType { definition, read }
