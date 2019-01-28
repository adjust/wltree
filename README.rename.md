## General info
Because the extension name was conflicting with upstream's contrib module, a decision was made to rename adjust's ltree extension to wltree ('w' for wide-character support).

This rename includes:
- Rename of .so file
- Rename of extension
- Extension version is shifted to 2.0

The above mention changes are achieved through the following:

.so file name is changed via Makefile update. Source files keep their original names.
For consistency reasons, regression test file was also renamed (and updated to reflect extension name change).

Extension rename is a result of filename changes as well as .control file update (+ some cosmetics).

## Update procedure
Update procedure should be performed as follows:
1. Install dummy extension using the following SQL command:
CREATE EXTENSION wltree VERSION "dummy";
This will:
i. Check if ltree is isntalled and bail out if it isn't
ii. If ltree exists, drop all objects from extension (this doesn't drop objects, only the dependencies)
iii. Drop extension ltree;

2. Once dummy is created successfully one should run update script:
ALTER EXTENSION wltree UPDATE TO "2.0";
This will:
i. Much like unpackaged update, this will create dependencies for objects released on previous step
ii. Run CREATE OR REPLACE FUNCTION for all related functions redefining source file (so that it uses wltree.so instead of ltree.so)

This last step is safe in production (from locking point of view) since function signature doesn't change thus there are no locks.


## Precautions

There've been a few cases where above information was not enough to deal with consequences of the rename. Those will be listed below and will be expanded as the time goes (or hopefully, not)


### postgres_fdw

Keep in mind that `postgres_fdw` depends on extension names to determine a set of functions and operators it can push down to the source server. This means that when upgrading from `ltree` to `wltree` one needs to run `ALTER SERVER` command on all instances using updated database as a foreign server. For further info check the documentation for `ALTER SERVER`.

### Binary mismatch

Sometimes one will run into a situation when after a minor upgrade a set of binaries and other extension files for unupgraded `adjust/ltree`  were replaces with `contrib/ltree`. This leads to a weird situation: pg_catalog thinks it is dealing with `adjust/ltree`, whereas all functions are actually from `contrib/ltree`. As a result a normal upgrade path would not work, because it performs an explicit check if `select nlevel('a.b')=2` which is true for `contrib/ltree` binaries.

This can be fixed by dropping the extension and creating a proper one, but this can be difficult, because dropping an extenion will cascade on the `ltree` data type and thus on the tables having that data type.

If one is lucky and the said table is a foreign table then as a solution one should do as follows:

```SQL
begin;
-- for all tables with `ltree` columns
alter foreign table myforeigntable alter myltreecol type to text;

drop extension ltree;

create extension wltree;

alter server myserver options (set extensions 'wltree, ....');

commit;
```

To check if the upgrade worked properly do as follows:

```sql
explain (verbose) select * from myforeigntable where myltreecol = 'whatever';
```

If the `remote sql` has the qual from original query, then everything is working properly.
