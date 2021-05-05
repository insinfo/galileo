Use a `declare` tag to *create* named variables within a block scope.
This is analogous to a variable declaration in Dart.

This Dart code:
```dart
var one = 1, two = 2, three = null;
```

Becomes this Jael:

```html
<declare one=1 two=2 three>
 // Scoped content...
</declare>
```

Another example (this is actually the test for `declare` functionality):

```html
<div>
 <declare one=1 two=2 three=3>
   <ul>
    <li>{{one}}</li>
    <li>{{two}}</li>
    <li>{{three}}</li>
   </ul>
   <ul>
    <declare three=4>
      <li>{{one}}</li>
      <li>{{two}}</li>
      <li>{{three}}</li>
    </declare>
   </ul>
 </declare>
</div>
```

Which yields:

```html
<div>
  <ul>
    <li>
      1
    </li>
    <li>
      2
    </li>
    <li>
      3
    </li>
  </ul>
  <ul>
    <li>
      1
    </li>
    <li>
      2
    </li>
    <li>
      4
    </li>
  </ul>
</div>
```
