Use an `include` tag to copy in the contents of another template into the current one.
The path, specified with a `src` attribute, will be resolved relative to the path of the current file.

This set-up:

```html
<!-- components/todo.jl -->
<div class="list-item">
  <div class="title">{{ todo.title }}</div>
</div>

<!-- todo_list.jl -->
<div class="list">
  <div for-each=todos as="todo">
    <include src="components/todo.jl" />
  </div>
</div>
```

Will be renderered as:

```html
<div class="list">
  <div>
    <div class="list-item">
      <div class="title">Clean your room</div>
    </div>
  </div>
  <div>
    <div class="list-item">
      <div class="title">Do the dishes</div>
    </div>
  </div>
</div>
```
