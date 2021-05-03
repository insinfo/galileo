abstract class Field<T> {
  String renderInput(String name, T initialValue);

  String stringify(String name, T value);

  T parse(String inputValue);
}

class TextField implements Field<String> {
  final String placeholder;

  const TextField({this.placeholder});

  @override
  String parse(String inputValue) => inputValue.toString();

  @override
  String stringify(String name, String value) => value;

  @override
  String renderInput(String name, String initialValue) {
    return '''<input
      name="$name"
      placeholder="${placeholder ?? ''}"
      value="$initialValue"
      type="text">''';
  }
}

class TextAreaField implements Field<String> {
  final String placeholder;

  const TextAreaField({this.placeholder});

  @override
  String parse(String inputValue) => inputValue.toString();

  @override
  String stringify(String name, String value) => value;

  @override
  String renderInput(String name, String initialValue) {
    return '''<textarea
      name="$name"
      placeholder="${placeholder ?? ''}">$initialValue</textarea>''';
  }
}
