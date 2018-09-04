/* contrib/wltree/wltree--dummy--2.0.sql */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION wltree" to load this file. \quit

ALTER EXTENSION wltree ADD type ltree;
ALTER EXTENSION wltree ADD function ltree_in(cstring);
ALTER EXTENSION wltree ADD function ltree_out(ltree);
ALTER EXTENSION wltree ADD function ltree_cmp(ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_lt(ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_le(ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_eq(ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_ge(ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_gt(ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_ne(ltree,ltree);
ALTER EXTENSION wltree ADD operator >(ltree,ltree);
ALTER EXTENSION wltree ADD operator >=(ltree,ltree);
ALTER EXTENSION wltree ADD operator <(ltree,ltree);
ALTER EXTENSION wltree ADD operator <=(ltree,ltree);
ALTER EXTENSION wltree ADD operator <>(ltree,ltree);
ALTER EXTENSION wltree ADD operator =(ltree,ltree);
ALTER EXTENSION wltree ADD function subltree(ltree,integer,integer);
ALTER EXTENSION wltree ADD function subpath(ltree,integer,integer);
ALTER EXTENSION wltree ADD function subpath(ltree,integer);
ALTER EXTENSION wltree ADD function index(ltree,ltree);
ALTER EXTENSION wltree ADD function index(ltree,ltree,integer);
ALTER EXTENSION wltree ADD function nlevel(ltree);
ALTER EXTENSION wltree ADD function ltree2text(ltree);
ALTER EXTENSION wltree ADD function text2ltree(text);
ALTER EXTENSION wltree ADD function lca(ltree[]);
ALTER EXTENSION wltree ADD function lca(ltree,ltree);
ALTER EXTENSION wltree ADD function lca(ltree,ltree,ltree);
ALTER EXTENSION wltree ADD function lca(ltree,ltree,ltree,ltree);
ALTER EXTENSION wltree ADD function lca(ltree,ltree,ltree,ltree,ltree);
ALTER EXTENSION wltree ADD function lca(ltree,ltree,ltree,ltree,ltree,ltree);
ALTER EXTENSION wltree ADD function lca(ltree,ltree,ltree,ltree,ltree,ltree,ltree);
ALTER EXTENSION wltree ADD function lca(ltree,ltree,ltree,ltree,ltree,ltree,ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_isparent(ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_risparent(ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_addltree(ltree,ltree);
ALTER EXTENSION wltree ADD function ltree_addtext(ltree,text);
ALTER EXTENSION wltree ADD function ltree_textadd(text,ltree);
ALTER EXTENSION wltree ADD function ltreeparentsel(internal,oid,internal,integer);
ALTER EXTENSION wltree ADD operator <@(ltree,ltree);
ALTER EXTENSION wltree ADD operator @>(ltree,ltree);
ALTER EXTENSION wltree ADD operator ^<@(ltree,ltree);
ALTER EXTENSION wltree ADD operator ^@>(ltree,ltree);
ALTER EXTENSION wltree ADD operator ||(ltree,ltree);
ALTER EXTENSION wltree ADD operator ||(ltree,text);
ALTER EXTENSION wltree ADD operator ||(text,ltree);
ALTER EXTENSION wltree ADD operator family ltree_ops using btree;
ALTER EXTENSION wltree ADD operator class ltree_ops using btree;
ALTER EXTENSION wltree ADD type lquery;
ALTER EXTENSION wltree ADD function lquery_in(cstring);
ALTER EXTENSION wltree ADD function lquery_out(lquery);
ALTER EXTENSION wltree ADD function ltq_regex(ltree,lquery);
ALTER EXTENSION wltree ADD function ltq_rregex(lquery,ltree);
ALTER EXTENSION wltree ADD operator ~(lquery,ltree);
ALTER EXTENSION wltree ADD operator ~(ltree,lquery);
ALTER EXTENSION wltree ADD operator ^~(lquery,ltree);
ALTER EXTENSION wltree ADD operator ^~(ltree,lquery);
ALTER EXTENSION wltree ADD function lt_q_regex(ltree,lquery[]);
ALTER EXTENSION wltree ADD function lt_q_rregex(lquery[],ltree);
ALTER EXTENSION wltree ADD operator ?(lquery[],ltree);
ALTER EXTENSION wltree ADD operator ?(ltree,lquery[]);
ALTER EXTENSION wltree ADD operator ^?(lquery[],ltree);
ALTER EXTENSION wltree ADD operator ^?(ltree,lquery[]);
ALTER EXTENSION wltree ADD type ltxtquery;
ALTER EXTENSION wltree ADD function ltxtq_in(cstring);
ALTER EXTENSION wltree ADD function ltxtq_out(ltxtquery);
ALTER EXTENSION wltree ADD function ltxtq_exec(ltree,ltxtquery);
ALTER EXTENSION wltree ADD function ltxtq_rexec(ltxtquery,ltree);
ALTER EXTENSION wltree ADD operator @(ltxtquery,ltree);
ALTER EXTENSION wltree ADD operator @(ltree,ltxtquery);
ALTER EXTENSION wltree ADD operator ^@(ltxtquery,ltree);
ALTER EXTENSION wltree ADD operator ^@(ltree,ltxtquery);
ALTER EXTENSION wltree ADD type ltree_gist;
ALTER EXTENSION wltree ADD function ltree_gist_in(cstring);
ALTER EXTENSION wltree ADD function ltree_gist_out(ltree_gist);
ALTER EXTENSION wltree ADD function ltree_consistent(internal,internal,smallint,oid,internal);
ALTER EXTENSION wltree ADD function ltree_compress(internal);
ALTER EXTENSION wltree ADD function ltree_decompress(internal);
ALTER EXTENSION wltree ADD function ltree_penalty(internal,internal,internal);
ALTER EXTENSION wltree ADD function ltree_picksplit(internal,internal);
ALTER EXTENSION wltree ADD function ltree_union(internal,internal);
ALTER EXTENSION wltree ADD function ltree_same(internal,internal,internal);
ALTER EXTENSION wltree ADD operator family gist_ltree_ops using gist;
ALTER EXTENSION wltree ADD operator class gist_ltree_ops using gist;
ALTER EXTENSION wltree ADD function _ltree_isparent(ltree[],ltree);
ALTER EXTENSION wltree ADD function _ltree_r_isparent(ltree,ltree[]);
ALTER EXTENSION wltree ADD function _ltree_risparent(ltree[],ltree);
ALTER EXTENSION wltree ADD function _ltree_r_risparent(ltree,ltree[]);
ALTER EXTENSION wltree ADD function _ltq_regex(ltree[],lquery);
ALTER EXTENSION wltree ADD function _ltq_rregex(lquery,ltree[]);
ALTER EXTENSION wltree ADD function _lt_q_regex(ltree[],lquery[]);
ALTER EXTENSION wltree ADD function _lt_q_rregex(lquery[],ltree[]);
ALTER EXTENSION wltree ADD function _ltxtq_exec(ltree[],ltxtquery);
ALTER EXTENSION wltree ADD function _ltxtq_rexec(ltxtquery,ltree[]);
ALTER EXTENSION wltree ADD operator <@(ltree,ltree[]);
ALTER EXTENSION wltree ADD operator @>(ltree[],ltree);
ALTER EXTENSION wltree ADD operator @>(ltree,ltree[]);
ALTER EXTENSION wltree ADD operator <@(ltree[],ltree);
ALTER EXTENSION wltree ADD operator ~(lquery,ltree[]);
ALTER EXTENSION wltree ADD operator ~(ltree[],lquery);
ALTER EXTENSION wltree ADD operator ?(lquery[],ltree[]);
ALTER EXTENSION wltree ADD operator ?(ltree[],lquery[]);
ALTER EXTENSION wltree ADD operator @(ltxtquery,ltree[]);
ALTER EXTENSION wltree ADD operator @(ltree[],ltxtquery);
ALTER EXTENSION wltree ADD operator ^<@(ltree,ltree[]);
ALTER EXTENSION wltree ADD operator ^@>(ltree[],ltree);
ALTER EXTENSION wltree ADD operator ^@>(ltree,ltree[]);
ALTER EXTENSION wltree ADD operator ^<@(ltree[],ltree);
ALTER EXTENSION wltree ADD operator ^~(lquery,ltree[]);
ALTER EXTENSION wltree ADD operator ^~(ltree[],lquery);
ALTER EXTENSION wltree ADD operator ^?(lquery[],ltree[]);
ALTER EXTENSION wltree ADD operator ^?(ltree[],lquery[]);
ALTER EXTENSION wltree ADD operator ^@(ltxtquery,ltree[]);
ALTER EXTENSION wltree ADD operator ^@(ltree[],ltxtquery);
ALTER EXTENSION wltree ADD function _ltree_extract_isparent(ltree[],ltree);
ALTER EXTENSION wltree ADD operator ?@>(ltree[],ltree);
ALTER EXTENSION wltree ADD function _ltree_extract_risparent(ltree[],ltree);
ALTER EXTENSION wltree ADD operator ?<@(ltree[],ltree);
ALTER EXTENSION wltree ADD function _ltq_extract_regex(ltree[],lquery);
ALTER EXTENSION wltree ADD operator ?~(ltree[],lquery);
ALTER EXTENSION wltree ADD function _ltxtq_extract_exec(ltree[],ltxtquery);
ALTER EXTENSION wltree ADD operator ?@(ltree[],ltxtquery);
ALTER EXTENSION wltree ADD function _ltree_consistent(internal,internal,smallint,oid,internal);
ALTER EXTENSION wltree ADD function _ltree_compress(internal);
ALTER EXTENSION wltree ADD function _ltree_penalty(internal,internal,internal);
ALTER EXTENSION wltree ADD function _ltree_picksplit(internal,internal);
ALTER EXTENSION wltree ADD function _ltree_union(internal,internal);
ALTER EXTENSION wltree ADD function _ltree_same(internal,internal,internal);
ALTER EXTENSION wltree ADD operator family gist__ltree_ops using gist;
ALTER EXTENSION wltree ADD operator class gist__ltree_ops using gist;

CREATE OR REPLACE FUNCTION ltree_in(cstring)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_out(ltree)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

--Compare function for ltree
CREATE OR REPLACE FUNCTION ltree_cmp(ltree,ltree)
RETURNS int4
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_lt(ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_le(ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_eq(ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_ge(ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_gt(ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_ne(ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION subltree(ltree,int4,int4)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION subpath(ltree,int4,int4)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION subpath(ltree,int4)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION index(ltree,ltree)
RETURNS int4
AS 'MODULE_PATHNAME', 'ltree_index'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION index(ltree,ltree,int4)
RETURNS int4
AS 'MODULE_PATHNAME', 'ltree_index'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION nlevel(ltree)
RETURNS int4
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree2text(ltree)
RETURNS text
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION text2ltree(text)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lca(_ltree)
RETURNS ltree
AS 'MODULE_PATHNAME','_lca'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lca(ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lca(ltree,ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lca(ltree,ltree,ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lca(ltree,ltree,ltree,ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lca(ltree,ltree,ltree,ltree,ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lca(ltree,ltree,ltree,ltree,ltree,ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lca(ltree,ltree,ltree,ltree,ltree,ltree,ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_isparent(ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_risparent(ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_addltree(ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_addtext(ltree,text)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_textadd(text,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltreeparentsel(internal, oid, internal, integer)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lquery_in(cstring)
RETURNS lquery
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lquery_out(lquery)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltq_regex(ltree,lquery)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltq_rregex(lquery,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lt_q_regex(ltree,_lquery)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION lt_q_rregex(_lquery,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltxtq_in(cstring)
RETURNS ltxtquery
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltxtq_out(ltxtquery)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltxtq_exec(ltree, ltxtquery)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltxtq_rexec(ltxtquery, ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_gist_in(cstring)
RETURNS ltree_gist
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_gist_out(ltree_gist)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION ltree_consistent(internal,internal,int2,oid,internal)
RETURNS bool as 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION ltree_compress(internal)
RETURNS internal as 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION ltree_decompress(internal)
RETURNS internal as 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION ltree_penalty(internal,internal,internal)
RETURNS internal as 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION ltree_picksplit(internal, internal)
RETURNS internal as 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION ltree_union(internal, internal)
RETURNS int4 as 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION ltree_same(internal, internal, internal)
RETURNS internal as 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION _ltree_isparent(_ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltree_r_isparent(ltree,_ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltree_risparent(_ltree,ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltree_r_risparent(ltree,_ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltq_regex(_ltree,lquery)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltq_rregex(lquery,_ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _lt_q_regex(_ltree,_lquery)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _lt_q_rregex(_lquery,_ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltxtq_exec(_ltree, ltxtquery)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltxtq_rexec(ltxtquery, _ltree)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltree_extract_isparent(_ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltree_extract_risparent(_ltree,ltree)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltq_extract_regex(_ltree,lquery)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltxtq_extract_exec(_ltree,ltxtquery)
RETURNS ltree
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION _ltree_consistent(internal,internal,int2,oid,internal)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION _ltree_compress(internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION _ltree_penalty(internal,internal,internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION _ltree_picksplit(internal, internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION _ltree_union(internal, internal)
RETURNS int4
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION _ltree_same(internal, internal, internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

