## adevens ltree implementation

This is adevens patched version of postgres ltree.
It's different in using `::` instead of `.` as label separator.
And it allows to have special characters like `{ } ! *` in ltree labels.
You can match those label in ltree queries by escaping these characters:

```SQL
SELECT '!foo::{bar}::baz%'::ltree ~ '\!foo::\{bar\}::baz\%';
```