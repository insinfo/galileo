Similar to `*ngIf` in Angular, Jael supports a simple `if` directive. Use `if` to only an element if a certain condition is `true`:

```html
<i if=user.locale == 'en'>
  Hello, {{ user.name }}!
</i>
<i if=user.locale == 'jp'>
  こんにちは, {{ user.name }}!
</i>
```
