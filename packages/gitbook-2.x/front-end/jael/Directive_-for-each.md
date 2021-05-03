To render content for each member of an `Iterable`, use the `for-each` directive:

```html
<ul>
  <li for-each=artists as="artist">
    <a href="/artist/" + artist.id>
      {{ artist.name }}
    </a>
  </li>
</ul>
```

Use an `as` attribute to specify the name each member of the iterable will be scoped as.
If it is not provided, it defaults to `item`:

```html
<ul>
  <li for-each=[1, 2, 3]>
    {{ item }} takes {{ item.bitLength }} bit(s) to store.
  </li>
</ul>
```