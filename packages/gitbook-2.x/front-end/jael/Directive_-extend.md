Jael supports template inheritance by means of `extend` and `block`.

Note the following example:

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

<!-- hello.jl -->
<extend src="layout.jl">
  <block name="content">
    <img src=user.avatar ?? "http://example.com/img/default-avatar">
    Hello, {{ user.name }}!
  </block>
</extend>
```

To extend a layout, instead of the file containing an `<html>` node, create a file with an `<extend>` node. The `src` attribute should point to the correct file. Then, add `<block>` tags that will replace the corresponding `<block>` tags declared in the parent file.