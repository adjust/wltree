[![CI](https://github.com/adjust/wltree/actions/workflows/main.yml/badge.svg)](https://github.com/adjust/wltree/actions/workflows/main.yml)

## adevens ltree implementation
[![Build Status](https://travis-ci.org/adeven/ltree.png?branch=master)](https://travis-ci.org/adeven/ltree)

This is adevens patched version of Postgres ltree module.

Original written by Teodor Sigaev (teodor@sigaev.ru) and Oleg Bartunov (oleg@sai.msu.su)

It's different in using `::` instead of `.` as label separator.
And it allows to have special characters like `{ } ! *` in ltree labels.
You can match those label in ltree queries by escaping these characters:

```SQL
SELECT '!foo::{bar}::baz%'::ltree ~ '\!foo::\{bar\}::baz\%';
```

### Unsupported features

* Full-text queries a.k.a. ltxtquery currently does not support usage of escaped characters.
