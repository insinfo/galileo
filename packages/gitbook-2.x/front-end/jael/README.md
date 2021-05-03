**Jael** is a simple, yet powerful, server-side HTML templating engine for Dart.
Although it can be used in any application, it comes with first-class support for the
[Angel](https://angel-dart.github.io) framework.

Though its syntax is but a superset of HTML, it supports features such as:
* **Custom elements**
* Loops
* Conditionals
* Template inheritance
* Block scoping
* `switch` syntax
* Interpolation of any Dart expression

### Small Example

```html
<!-- layout.jl -->
<html>
    <head>
        <title>{{ title }} - My App</title>
    </head>
    <body>
        <block name="content"></block>
        <div class="footer">
          <!-- Footer content... -->
        </div>
    </body>
</html>

<!-- user-info.jl -->
<element name="user-info">
    <img src=user.avatar ?? "http://example.com/img/default-avatar">
    Hello, {{ user.name }}!
</element>

<!-- hello.jl -->
<extend src="layout.jl">
  <include src="user-info.jl" />
  <block name="content">
    <user-info @user=getCurrentlyAuthenticatedUserSomehow() />
  </block>
</extend>
```

The typical flow of a full-stack Dart application is to develop two separate apps:
  * The server
  * The client, an entire SPA

However, the truth is, many projects will never reach great scale, or are not extensive Web applications, and thus do not need the added complexity of an SPA. In such a case, creating an SPA will consume much excess time.

Jael allows developers to create a frontend for their application without having to worry about push state, increased development time, or having to find complex ways to achieve "server-side rendering."

Rather than forcing you to learn an entire DSL, Jael's syntax is one you already know - HTML. All directives take the form of HTML elements, and are applied either by the preprocessor or at runtime. Jael's AST is simple to patch, so it is relatively straightforward to patch it to add new features.

Jael can easily be used in any application with the following two packages:
  * `package:jael`
  * `package:jael_preprocessor`

However, [Angel](https://angel-dart.github.io) users only need install `package:angel_jael` to include
templating in their server-side applications. One of Angel's goals is to make Web development faster, and having
a tool like Jael at its disposal only brings that goal even closer to fruition.
