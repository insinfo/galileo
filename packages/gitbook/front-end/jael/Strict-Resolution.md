# Strict Resolution

Dart is an imperative language, where you have the agency to cast values to other types,
to execute multiple statements, and ultimately create a program by explicitly declaring
every action that should be taken.

HTML, and subseqently, Jael, are declarative markup languages, and thus give you
considerably less control over the flow of data and type information. Functionality
like type checks, which are manageable in Dart, are both unintuitive and verbose in a markup language.

To compensate, Jael can enable or disable what can be referred to as *strict resolution*.
`package:angel_jael` by default disables strict resolution, and
`strictResolution` is available as a parameter to both the
`jael` function in Angel, and the `Render()` constructor in Jael.

Jael's expression parser is **not** the one from `package:analyzer`, so the evaluation
of expressions at runtime is up to the `Renderer` class. When strict resolution is on, all
referenced identifiers **must** be present in the scope, and the only values allowed for
`if`, conditionals, and similar expressions are `bool`.

For example, take the following snippet:

```html
<ul if=user?.name?.isNotEmpty>
  <li>
    Talk to @{{ user.name }}
  </li>
</ul>
```

If strict resolution is **on**:
* If `user` is not in the scope of values passed to the renderer, an error will be thrown.
* If the expression `user?.name?.isNotEmpty` is `null`,
then an error will be thrown.

If strict resolution is **off**:
* If `user` is not in the scope of values, Jael will just substitute it with `null`.
* If `user?.name` is `null`, Jael will substitute the expression with `null`.
* If the expression `user?.name?.isNotEmpty` does not evaluate to `true`
(that is to say, it *can* be `null`!), then the `ul` will simply not be rendered.

Overall, strict resolution should likely be off for most cases, as type checking is not often that important
when writing HTML templates.