/* contrib/wltree/wltree--dummy.sql */

/*
 * xxx This version is used to upgrade from version with different name only xxx
 * To upgrade from a version with extension name ltree do:
 * CREATE EXTENSION wltree VERSION "dummy";
 * ALTER EXTENSION wltree UPDATE to "2.0";
 */


-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION ltree" to load this file. \quit

/*
 * Bail out if ltree is not installed
 */

DO
$do$
begin
	if not exists(select 1 from pg_extension where extname = 'ltree') then
		raise exception 'Extension ltree is not installed, there is no need for "dummy" wltree';
	end if;

	if (select nlevel(ltree'1.2') = 1) then
		raise exception 'Installed ltree is the one from contrib module and conflicts with wltree';
	end if;
end
$do$;

ALTER EXTENSION ltree DROP type ltree;
ALTER EXTENSION ltree DROP function ltree_in(cstring);
ALTER EXTENSION ltree DROP function ltree_out(ltree);
ALTER EXTENSION ltree DROP function ltree_cmp(ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_lt(ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_le(ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_eq(ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_ge(ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_gt(ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_ne(ltree,ltree);
ALTER EXTENSION ltree DROP operator >(ltree,ltree);
ALTER EXTENSION ltree DROP operator >=(ltree,ltree);
ALTER EXTENSION ltree DROP operator <(ltree,ltree);
ALTER EXTENSION ltree DROP operator <=(ltree,ltree);
ALTER EXTENSION ltree DROP operator <>(ltree,ltree);
ALTER EXTENSION ltree DROP operator =(ltree,ltree);
ALTER EXTENSION ltree DROP function subltree(ltree,integer,integer);
ALTER EXTENSION ltree DROP function subpath(ltree,integer,integer);
ALTER EXTENSION ltree DROP function subpath(ltree,integer);
ALTER EXTENSION ltree DROP function index(ltree,ltree);
ALTER EXTENSION ltree DROP function index(ltree,ltree,integer);
ALTER EXTENSION ltree DROP function nlevel(ltree);
ALTER EXTENSION ltree DROP function ltree2text(ltree);
ALTER EXTENSION ltree DROP function text2ltree(text);
ALTER EXTENSION ltree DROP function lca(ltree[]);
ALTER EXTENSION ltree DROP function lca(ltree,ltree);
ALTER EXTENSION ltree DROP function lca(ltree,ltree,ltree);
ALTER EXTENSION ltree DROP function lca(ltree,ltree,ltree,ltree);
ALTER EXTENSION ltree DROP function lca(ltree,ltree,ltree,ltree,ltree);
ALTER EXTENSION ltree DROP function lca(ltree,ltree,ltree,ltree,ltree,ltree);
ALTER EXTENSION ltree DROP function lca(ltree,ltree,ltree,ltree,ltree,ltree,ltree);
ALTER EXTENSION ltree DROP function lca(ltree,ltree,ltree,ltree,ltree,ltree,ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_isparent(ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_risparent(ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_addltree(ltree,ltree);
ALTER EXTENSION ltree DROP function ltree_addtext(ltree,text);
ALTER EXTENSION ltree DROP function ltree_textadd(text,ltree);
ALTER EXTENSION ltree DROP function ltreeparentsel(internal,oid,internal,integer);
ALTER EXTENSION ltree DROP operator <@(ltree,ltree);
ALTER EXTENSION ltree DROP operator @>(ltree,ltree);
ALTER EXTENSION ltree DROP operator ^<@(ltree,ltree);
ALTER EXTENSION ltree DROP operator ^@>(ltree,ltree);
ALTER EXTENSION ltree DROP operator ||(ltree,ltree);
ALTER EXTENSION ltree DROP operator ||(ltree,text);
ALTER EXTENSION ltree DROP operator ||(text,ltree);
ALTER EXTENSION ltree DROP operator family ltree_ops using btree;
ALTER EXTENSION ltree DROP operator class ltree_ops using btree;
ALTER EXTENSION ltree DROP type lquery;
ALTER EXTENSION ltree DROP function lquery_in(cstring);
ALTER EXTENSION ltree DROP function lquery_out(lquery);
ALTER EXTENSION ltree DROP function ltq_regex(ltree,lquery);
ALTER EXTENSION ltree DROP function ltq_rregex(lquery,ltree);
ALTER EXTENSION ltree DROP operator ~(lquery,ltree);
ALTER EXTENSION ltree DROP operator ~(ltree,lquery);
ALTER EXTENSION ltree DROP operator ^~(lquery,ltree);
ALTER EXTENSION ltree DROP operator ^~(ltree,lquery);
ALTER EXTENSION ltree DROP function lt_q_regex(ltree,lquery[]);
ALTER EXTENSION ltree DROP function lt_q_rregex(lquery[],ltree);
ALTER EXTENSION ltree DROP operator ?(lquery[],ltree);
ALTER EXTENSION ltree DROP operator ?(ltree,lquery[]);
ALTER EXTENSION ltree DROP operator ^?(lquery[],ltree);
ALTER EXTENSION ltree DROP operator ^?(ltree,lquery[]);
ALTER EXTENSION ltree DROP type ltxtquery;
ALTER EXTENSION ltree DROP function ltxtq_in(cstring);
ALTER EXTENSION ltree DROP function ltxtq_out(ltxtquery);
ALTER EXTENSION ltree DROP function ltxtq_exec(ltree,ltxtquery);
ALTER EXTENSION ltree DROP function ltxtq_rexec(ltxtquery,ltree);
ALTER EXTENSION ltree DROP operator @(ltxtquery,ltree);
ALTER EXTENSION ltree DROP operator @(ltree,ltxtquery);
ALTER EXTENSION ltree DROP operator ^@(ltxtquery,ltree);
ALTER EXTENSION ltree DROP operator ^@(ltree,ltxtquery);
ALTER EXTENSION ltree DROP type ltree_gist;
ALTER EXTENSION ltree DROP function ltree_gist_in(cstring);
ALTER EXTENSION ltree DROP function ltree_gist_out(ltree_gist);
ALTER EXTENSION ltree DROP function ltree_consistent(internal,internal,smallint,oid,internal);
ALTER EXTENSION ltree DROP function ltree_compress(internal);
ALTER EXTENSION ltree DROP function ltree_decompress(internal);
ALTER EXTENSION ltree DROP function ltree_penalty(internal,internal,internal);
ALTER EXTENSION ltree DROP function ltree_picksplit(internal,internal);
ALTER EXTENSION ltree DROP function ltree_union(internal,internal);
ALTER EXTENSION ltree DROP function ltree_same(internal,internal,internal);
ALTER EXTENSION ltree DROP operator family gist_ltree_ops using gist;
ALTER EXTENSION ltree DROP operator class gist_ltree_ops using gist;
ALTER EXTENSION ltree DROP function _ltree_isparent(ltree[],ltree);
ALTER EXTENSION ltree DROP function _ltree_r_isparent(ltree,ltree[]);
ALTER EXTENSION ltree DROP function _ltree_risparent(ltree[],ltree);
ALTER EXTENSION ltree DROP function _ltree_r_risparent(ltree,ltree[]);
ALTER EXTENSION ltree DROP function _ltq_regex(ltree[],lquery);
ALTER EXTENSION ltree DROP function _ltq_rregex(lquery,ltree[]);
ALTER EXTENSION ltree DROP function _lt_q_regex(ltree[],lquery[]);
ALTER EXTENSION ltree DROP function _lt_q_rregex(lquery[],ltree[]);
ALTER EXTENSION ltree DROP function _ltxtq_exec(ltree[],ltxtquery);
ALTER EXTENSION ltree DROP function _ltxtq_rexec(ltxtquery,ltree[]);
ALTER EXTENSION ltree DROP operator <@(ltree,ltree[]);
ALTER EXTENSION ltree DROP operator @>(ltree[],ltree);
ALTER EXTENSION ltree DROP operator @>(ltree,ltree[]);
ALTER EXTENSION ltree DROP operator <@(ltree[],ltree);
ALTER EXTENSION ltree DROP operator ~(lquery,ltree[]);
ALTER EXTENSION ltree DROP operator ~(ltree[],lquery);
ALTER EXTENSION ltree DROP operator ?(lquery[],ltree[]);
ALTER EXTENSION ltree DROP operator ?(ltree[],lquery[]);
ALTER EXTENSION ltree DROP operator @(ltxtquery,ltree[]);
ALTER EXTENSION ltree DROP operator @(ltree[],ltxtquery);
ALTER EXTENSION ltree DROP operator ^<@(ltree,ltree[]);
ALTER EXTENSION ltree DROP operator ^@>(ltree[],ltree);
ALTER EXTENSION ltree DROP operator ^@>(ltree,ltree[]);
ALTER EXTENSION ltree DROP operator ^<@(ltree[],ltree);
ALTER EXTENSION ltree DROP operator ^~(lquery,ltree[]);
ALTER EXTENSION ltree DROP operator ^~(ltree[],lquery);
ALTER EXTENSION ltree DROP operator ^?(lquery[],ltree[]);
ALTER EXTENSION ltree DROP operator ^?(ltree[],lquery[]);
ALTER EXTENSION ltree DROP operator ^@(ltxtquery,ltree[]);
ALTER EXTENSION ltree DROP operator ^@(ltree[],ltxtquery);
ALTER EXTENSION ltree DROP function _ltree_extract_isparent(ltree[],ltree);
ALTER EXTENSION ltree DROP operator ?@>(ltree[],ltree);
ALTER EXTENSION ltree DROP function _ltree_extract_risparent(ltree[],ltree);
ALTER EXTENSION ltree DROP operator ?<@(ltree[],ltree);
ALTER EXTENSION ltree DROP function _ltq_extract_regex(ltree[],lquery);
ALTER EXTENSION ltree DROP operator ?~(ltree[],lquery);
ALTER EXTENSION ltree DROP function _ltxtq_extract_exec(ltree[],ltxtquery);
ALTER EXTENSION ltree DROP operator ?@(ltree[],ltxtquery);
ALTER EXTENSION ltree DROP function _ltree_consistent(internal,internal,smallint,oid,internal);
ALTER EXTENSION ltree DROP function _ltree_compress(internal);
ALTER EXTENSION ltree DROP function _ltree_penalty(internal,internal,internal);
ALTER EXTENSION ltree DROP function _ltree_picksplit(internal,internal);
ALTER EXTENSION ltree DROP function _ltree_union(internal,internal);
ALTER EXTENSION ltree DROP function _ltree_same(internal,internal,internal);
ALTER EXTENSION ltree DROP operator family gist__ltree_ops using gist;
ALTER EXTENSION ltree DROP operator class gist__ltree_ops using gist;

DROP EXTENSION ltree;
