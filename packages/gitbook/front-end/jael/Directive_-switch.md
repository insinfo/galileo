Jael's `switch` directive is similar to a Dart `switch` statement. It takes a `value` as input, and evaluates an infinite number of `case` tags, only evaluating the first whose value matches the one in question. A `default` tag can be provided as a fallback.

```html
<switch value=account.isDisabled>
  <case value=true>
    Good riddance!
  </case>
  <case value=false>
    You are in good standing.
  </case>
  <default>
    Weird...
  </default>
</switch>
```
