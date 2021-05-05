* [Interpolation](#interpolation)
* [Attributes](#attributes)
  * [Attribute Values](#attribute-values)
  * [Quoted Attribute Names](#quoted-attribute-names)
  * [Unescaped Attributes](#unescaped-attributes)

Jael syntax is a superset of HTML. The following is valid both in HTML and Jael:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Title</title>
  </head>
  <body>
    <h1>Hello!</h1>
  </body>
</html>
```

However, Jael adds two major changes.

## Interpolation
Firstly, text blocks can contain *interpolations*, which are merely Dart expression contained in double curly braces (`{{ }}`). The value within the braces, once evaluated will be HTML escaped, to prevent XSS. To achieve unescaped output, append a hyphen (`-`) to the first brace (`{{- }}`).

```html
<div>
  {{ user.name }}
</div>

<!-- Do not HTML escape this: -->
<div>
  {{- raw.data.will.not.be('escaped') }}
</div>
```

## Attributes
Secondly, whereas in HTML, the values of attributes can only be strings, Jael allows for their values to be any Dart expression:

```html
<img src=profile.avatar ?? "http://example.com/img/avatars/default.png">
<a class=['btn', 'ban-default', 'btn-lg']>Link</a>
<p style={'color': 'red'}></p>
```

### Attribute Values
Values are handled as such:
* Maps: Serialized as though they were `style` attributes.
* Iterables: Joined by a space, like `class` attributes.
* Anything else: `toString()` is invoked.

### Quoted Attribute Names
In case the name of your attribute is not a valid Dart identifier, you can wrap it with quotes, and it will still be processed as per normal:

```html
<button "(click)"="myEventHandler($event)" />
```

### Unescaped Attributes
These will also be HTML escaped; however, you can replace `=` with `!=` to print unescaped text:

```html
<img src!="<SCARY XSS STRING BEWARE!!!>" />
```
