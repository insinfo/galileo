# Custom Elements
HTML is good for its purpose, because each element (ex. `div`, `a`, `ul`),
has its own purpose, and when invoked, reproduces specific functionality.

The goal of proposals like Web Components, and frameworks like
React, Vue, and Angular, is to let developers create custom components
that encapsulate data and can be called to reproduce specific output.

Jael also supports defining elements; in fact, they are analogous
to defining functions in Dart code.

The benefit of defining custom elements in Jael as opposed to in
a client-side framework is that they build directly to standard HTML,
and require no additional features in an end-user's browser.

## Defining Elements
To define your own element, simply use the `<element>` tag:

```html
<element name="todo-item">
    <input type="checkbox" checked=todo.completed disabled>
    {{ todo.text }}
</element>
```

The best practice is to define elements in their own file, so that
they can be imported into the scope using an
[<include src=".." />](Directive:-include.md) tag:

```html
<extend src="layout.jl">
    <block name="content">
        <include src="todo-item.jl" />
        <todo-item for-each=todos @todo=item />
    </block>
</extend>
```

## Passing Data
You might have noticed that in the earlier example, some attributes of
the `todo-item` were prefixed with an arroba (`@`), while others were not.
There is, of course, a reason for this.

When rendering a custom element, attributes with the `@` are injected
into the custom element's scope. This is analogous to passing arguments
to a function.

Attributes without the `@` are passed to the root of the created element.
Thus, you can pass attributes like `class` and `style` to custom elements,
and therefore apply visual effects, etc.

Directives like `if` and `for-each` also work with custom elements,
of course.

## Specifying a Tag Name
By default, custom elements are replaced with a `div`. There may
be times you wish to override this, for example, to render a `todo-item`
as an `a` element.

Use the special `as` attribute to facilitate this:

```html
<todo-item as="a" for-each=todos @todo=item />
```

## Emitting without a Tag Name
There may be times when you need to emit the contents of an element,
*without* a container element. In such a case, pass `as=false`, and
the contents will be rendered in the current context, rather than
in a new element.
