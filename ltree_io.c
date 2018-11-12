/*
 * in/out function for ltree and lquery
 * Teodor Sigaev <teodor@stack.net>
 * contrib/ltree/ltree_io.c
 */
#include "postgres.h"

#include <ctype.h>

#include "ltree.h"
#include "crc32.h"

PG_FUNCTION_INFO_V1(ltree_in);
Datum		ltree_in(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(ltree_out);
Datum		ltree_out(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(lquery_in);
Datum		lquery_in(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(lquery_out);
Datum		lquery_out(PG_FUNCTION_ARGS);


#define UNCHAR ereport(ERROR, \
					   (errcode(ERRCODE_SYNTAX_ERROR), \
						errmsg("syntax error at position %d: '%c'", \
						pos, TOUCHAR(ptr))));


typedef struct
{
	char	   *start;
	int			len;			/* length in bytes */
	int			flag;
	int			wlen;			/* length in characters */
	int			escnum;			/* number of escaped characters */
} nodeitem;

#define LTPRS_WAITNAME	0
#define LTPRS_WAITDELIM 1
#define LTPRS_WAITDELIMEND	2

Datum
ltree_in(PG_FUNCTION_ARGS)
{
	char	   *buf = (char *) PG_GETARG_POINTER(0);
	char	   *ptr;
	nodeitem   *list,
			   *lptr;
	int			num = 0,
				totallen = 0;
	int			state = LTPRS_WAITDELIM;
	ltree	   *result;
	ltree_level *curlevel;
	int			charlen;
	int			pos = 0;

	ptr = buf;
	while (*ptr)
	{
		charlen = pg_mblen(ptr);

		if (charlen == 1)
		{
			if (t_iseq(ptr, NODE_DELIMITER_CHAR))
			{
				if (state == LTPRS_WAITDELIMEND)
				{
					num++;
					state = LTPRS_WAITDELIM;
				}
				else
					state = LTPRS_WAITDELIMEND;
			}
			else
			{
				state = LTPRS_WAITDELIM;
			}
		}

		ptr += charlen;
	}
	num++;

	list = lptr = (nodeitem *) palloc(sizeof(nodeitem) * num);
	ptr = buf;
	state = LTPRS_WAITNAME;
	while (*ptr)
	{
		charlen = pg_mblen(ptr);

		if (state == LTPRS_WAITNAME)
		{
			lptr->start = ptr;
			lptr->wlen = 0;

			/* handle corner case when label starts with a delimiter character */
			state = (charlen == 1 && t_iseq(ptr, NODE_DELIMITER_CHAR)) ?
				LTPRS_WAITDELIMEND : LTPRS_WAITDELIM;
		}
		else if (state == LTPRS_WAITDELIMEND)
		{
			if (charlen == 1 && t_iseq(ptr, NODE_DELIMITER_CHAR))
			{
				lptr->len = ptr - lptr->start - 1;
				lptr->wlen--;
				if (lptr->wlen > 255)
					ereport(ERROR,
							(errcode(ERRCODE_NAME_TOO_LONG),
							 errmsg("name of level is too long"),
							 errdetail("Name length is %d, must "
									   "be < 256, in position %d.",
									   lptr->wlen, pos)));
				if (lptr->wlen == 0)
					ereport(ERROR,
							(errcode(ERRCODE_SYNTAX_ERROR),
							 errmsg("syntax error"),
							 errdetail("Unexpected delimeter in position %d",
									   pos)));

				totallen += MAXALIGN(lptr->len + LEVEL_HDRSIZE);
				lptr++;
				state = LTPRS_WAITNAME;
			}
			else
				state = LTPRS_WAITDELIM;
		}
		else if (state == LTPRS_WAITDELIM)
		{
			if (charlen == 1 && t_iseq(ptr, NODE_DELIMITER_CHAR))
				state = LTPRS_WAITDELIMEND;
		}
		else
			/* internal error */
			elog(ERROR, "internal error in parser");

		ptr += charlen;
		lptr->wlen++;
		pos++;
	}

	if (state == LTPRS_WAITDELIM || state == LTPRS_WAITDELIMEND)
	{
		lptr->len = ptr - lptr->start;
		if (lptr->wlen > 255)
			ereport(ERROR,
					(errcode(ERRCODE_NAME_TOO_LONG),
					 errmsg("name of level is too long"),
					 errdetail("Name length is %d, must "
							   "be < 256, in position %d.",
							   lptr->wlen, pos)));

		totallen += MAXALIGN(lptr->len + LEVEL_HDRSIZE);
		lptr++;
	}
	else if (!(state == LTPRS_WAITNAME && lptr == list))
		ereport(ERROR,
				(errcode(ERRCODE_SYNTAX_ERROR),
				 errmsg("syntax error"),
				 errdetail("Unexpected end of line.")));

	result = (ltree *) palloc0(LTREE_HDRSIZE + totallen);
	SET_VARSIZE(result, LTREE_HDRSIZE + totallen);
	result->numlevel = lptr - list;
	curlevel = LTREE_FIRST(result);
	lptr = list;
	while (lptr - list < result->numlevel)
	{
		curlevel->len = (uint16) lptr->len;
		memcpy(curlevel->name, lptr->start, lptr->len);
		curlevel = LEVEL_NEXT(curlevel);
		lptr++;
	}

	pfree(list);
	PG_RETURN_POINTER(result);
}

Datum
ltree_out(PG_FUNCTION_ARGS)
{
	ltree	   *in = PG_GETARG_LTREE(0);
	char	   *buf,
			   *ptr;
	int			i;
	ltree_level *curlevel;

	ptr = buf = (char *) palloc(VARSIZE(in));
	curlevel = LTREE_FIRST(in);
	for (i = 0; i < in->numlevel; i++)
	{
		if (i != 0)
		{
			*ptr = NODE_DELIMITER_CHAR;
			ptr++;
			*ptr = NODE_DELIMITER_CHAR;
			ptr++;
		}
		memcpy(ptr, curlevel->name, curlevel->len);
		ptr += curlevel->len;
		curlevel = LEVEL_NEXT(curlevel);
	}

	*ptr = '\0';
	PG_FREE_IF_COPY(in, 0);

	PG_RETURN_POINTER(buf);
}

#define LQPRS_WAITLEVEL 0
#define LQPRS_WAITDELIM 1
#define LQPRS_WAITOPEN	2
#define LQPRS_WAITFNUM	3
#define LQPRS_WAITSNUM	4
#define LQPRS_WAITND	5
#define LQPRS_WAITCLOSE 6
#define LQPRS_WAITEND	7
#define LQPRS_WAITVAR	8
#define LQPRS_WAITDELIMEND	9


#define GETVAR(x) ( *((nodeitem**)LQL_FIRST(x)) )
#define ITEMSIZE	MAXALIGN(LQL_HDRSIZE+sizeof(nodeitem*))
#define NEXTLEV(x) ( (lquery_level*)( ((char*)(x)) + ITEMSIZE) )

Datum
lquery_in(PG_FUNCTION_ARGS)
{
	char	   *buf = (char *) PG_GETARG_POINTER(0);
	char	   *ptr;
	int			num = 0,
				totallen = 0,
				numOR = 0;
	int			state = LQPRS_WAITLEVEL;
	lquery	   *result;
	nodeitem   *lptr = NULL;
	lquery_level *cur,
			   *curqlevel,
			   *tmpql;
	lquery_variant *lrptr = NULL;
	bool		hasnot = false;
	bool		wasbad = false;
	bool		escaped_char = false;
	int			charlen;
	int			pos = 0;

	ptr = buf;
	while (*ptr)
	{
		charlen = pg_mblen(ptr);

		if (charlen == 1)
		{
			if (! escaped_char && t_iseq(ptr, NODE_DELIMITER_CHAR))
				if (state == LQPRS_WAITDELIMEND)
				{
					num++;
					state = LQPRS_WAITDELIM;
				}
				else
					state = LQPRS_WAITDELIMEND;
			else if (! escaped_char && t_iseq(ptr, '|'))
			{
				escaped_char = false;
				state = LQPRS_WAITDELIM;
				numOR++;
			}
			else
			{
				escaped_char = t_iseq(ptr, ESCAPE_CHAR) && ! escaped_char;
				state = LQPRS_WAITDELIM;
			}
		}
		else
		{
			escaped_char = false;
			state = LQPRS_WAITDELIM;
		}

		ptr += charlen;
	}

	num++;

	curqlevel = tmpql = (lquery_level *) palloc0(ITEMSIZE * num);
	ptr = buf;
	state = LQPRS_WAITLEVEL;
	escaped_char = false;
	while (*ptr)
	{
		charlen = pg_mblen(ptr);
		if (state == LQPRS_WAITLEVEL)
		{
			if (! escaped_char && charlen == 1 && t_iseq(ptr, '!'))
			{
				GETVAR(curqlevel) = lptr = (nodeitem *) palloc0(sizeof(nodeitem) * (numOR + 1));
				lptr->start = ptr + 1;
				lptr->escnum = 0;
				state = LQPRS_WAITDELIM;
				curqlevel->numvar = 1;
				curqlevel->flag |= LQL_NOT;
				hasnot = true;
			}
			else if (! escaped_char && charlen == 1 && t_iseq(ptr, '*'))
				state = LQPRS_WAITOPEN;
			else
			{
				GETVAR(curqlevel) = lptr = (nodeitem *) palloc0(sizeof(nodeitem) * (numOR + 1));
				lptr->start = ptr;
				lptr->escnum = 0;

				/* handle corner case when label starts with a delimiter character */
				state = (! escaped_char && charlen == 1 && t_iseq(ptr, NODE_DELIMITER_CHAR)) ?
					LQPRS_WAITDELIMEND : LQPRS_WAITDELIM;

				curqlevel->numvar = 1;
				escaped_char = (charlen == 1 && t_iseq(ptr, ESCAPE_CHAR)) && ! escaped_char;
			}
		}
		else if (state == LQPRS_WAITVAR)
		{
			lptr++;
			lptr->start = ptr;
			state = LQPRS_WAITDELIM;
			curqlevel->numvar++;
		}
		else if (state == LQPRS_WAITDELIM)
		{
			if (! escaped_char && charlen == 1 && t_iseq(ptr, '@'))
			{
				if (lptr->start == ptr)
					UNCHAR;
				lptr->flag |= LVAR_INCASE;
				curqlevel->flag |= LVAR_INCASE;
			}
			else if (! escaped_char && charlen == 1 && t_iseq(ptr, '*'))
			{
				if (lptr->start == ptr)
					UNCHAR;
				lptr->flag |= LVAR_ANYEND;
				curqlevel->flag |= LVAR_ANYEND;
			}
			else if (! escaped_char && charlen == 1 && t_iseq(ptr, '%'))
			{
				if (lptr->start == ptr)
					UNCHAR;
				lptr->flag |= LVAR_SUBLEXEME;
				curqlevel->flag |= LVAR_SUBLEXEME;
			}
			else if (! escaped_char && charlen == 1 && t_iseq(ptr, '|'))
			{
				lptr->len = ptr - lptr->start -
					((lptr->flag & LVAR_SUBLEXEME) ? 1 : 0) -
					((lptr->flag & LVAR_INCASE) ? 1 : 0) -
					((lptr->flag & LVAR_ANYEND) ? 1 : 0);
				if (lptr->wlen > 255)
					ereport(ERROR,
							(errcode(ERRCODE_NAME_TOO_LONG),
							 errmsg("name of level is too long"),
							 errdetail("Name length is %d, must "
									   "be < 256, in position %d.",
									   lptr->wlen, pos)));

				state = LQPRS_WAITVAR;
			}
			else if (! escaped_char && charlen == 1 && t_iseq(ptr, NODE_DELIMITER_CHAR))
			{
				if (lptr->start == ptr)
					UNCHAR;
				state = LQPRS_WAITDELIMEND;
			}
			else
			{
				escaped_char = (charlen == 1 && t_iseq(ptr, ESCAPE_CHAR)) && ! escaped_char;
				if (lptr->flag)
					UNCHAR;
			}
		}
		else if (state == LQPRS_WAITDELIMEND)
		{
			if (charlen == 1 && t_iseq(ptr, NODE_DELIMITER_CHAR))
			{
				if (lptr != NULL)
				{
					lptr->len = ptr - lptr->start -
						((lptr->flag & LVAR_SUBLEXEME) ? 1 : 0) -
						((lptr->flag & LVAR_INCASE) ? 1 : 0) -
						((lptr->flag & LVAR_ANYEND) ? 1 : 0) - 1;
					if (lptr->wlen > 255)
						ereport(ERROR,
								(errcode(ERRCODE_NAME_TOO_LONG),
								 errmsg("name of level is too long"),
								 errdetail("Name length is %d, must "
										   "be < 256, in position %d.",
										   lptr->wlen, pos)));
					if (lptr->wlen == 0)
						ereport(ERROR,
								(errcode(ERRCODE_SYNTAX_ERROR),
								 errmsg("syntax error"),
								 errdetail("Unexpected delimeter in position %d",
										   pos)));
				}

				escaped_char = false;
				state = LQPRS_WAITLEVEL;
				curqlevel = NEXTLEV(curqlevel);
			}
			else
				state = LTPRS_WAITDELIM;
		}
		else if (state == LQPRS_WAITOPEN)
		{
			if (charlen == 1 && t_iseq(ptr, '{'))
				state = LQPRS_WAITFNUM;
			else if (charlen == 1 && t_iseq(ptr, NODE_DELIMITER_CHAR))
			{
				lptr = NULL;
				curqlevel->low = 0;
				curqlevel->high = 0xffff;
				state = LQPRS_WAITDELIMEND;
			}
			else
				UNCHAR;
		}
		else if (state == LQPRS_WAITFNUM)
		{
			if (charlen == 1 && t_iseq(ptr, ','))
				state = LQPRS_WAITSNUM;
			else if (t_isdigit(ptr))
			{
				curqlevel->low = atoi(ptr);
				state = LQPRS_WAITND;
			}
			else
				UNCHAR;
		}
		else if (state == LQPRS_WAITSNUM)
		{
			if (t_isdigit(ptr))
			{
				curqlevel->high = atoi(ptr);
				state = LQPRS_WAITCLOSE;
			}
			else if (charlen == 1 && t_iseq(ptr, '}'))
			{
				curqlevel->high = 0xffff;
				state = LQPRS_WAITEND;
			}
			else
				UNCHAR;
		}
		else if (state == LQPRS_WAITCLOSE)
		{
			if (charlen == 1 && t_iseq(ptr, '}'))
				state = LQPRS_WAITEND;
			else if (!t_isdigit(ptr))
				UNCHAR;
		}
		else if (state == LQPRS_WAITND)
		{
			if (charlen == 1 && t_iseq(ptr, '}'))
			{
				curqlevel->high = curqlevel->low;
				state = LQPRS_WAITEND;
			}
			else if (charlen == 1 && t_iseq(ptr, ','))
				state = LQPRS_WAITSNUM;
			else if (!t_isdigit(ptr))
				UNCHAR;
		}
		else if (state == LQPRS_WAITEND)
		{
			if (charlen == 1 && t_iseq(ptr, NODE_DELIMITER_CHAR))
			{
				lptr = NULL;
				state = LQPRS_WAITDELIMEND;
			}
			else
				UNCHAR;
		}
		else
			/* internal error */
			elog(ERROR, "internal error in parser");

		ptr += charlen;
		if (state == LQPRS_WAITDELIM)
			lptr->wlen++;
		if (escaped_char)
			lptr->escnum++;
		pos++;
	}

	if (state == LQPRS_WAITDELIM || state == LQPRS_WAITDELIMEND)
	{
		if (lptr->start == ptr)
			ereport(ERROR,
					(errcode(ERRCODE_SYNTAX_ERROR),
					 errmsg("syntax error"),
					 errdetail("Unexpected end of line.")));

		lptr->len = ptr - lptr->start -
			((lptr->flag & LVAR_SUBLEXEME) ? 1 : 0) -
			((lptr->flag & LVAR_INCASE) ? 1 : 0) -
			((lptr->flag & LVAR_ANYEND) ? 1 : 0);
		if (lptr->len == 0)
			ereport(ERROR,
					(errcode(ERRCODE_SYNTAX_ERROR),
					 errmsg("syntax error"),
					 errdetail("Unexpected end of line.")));

		if (lptr->wlen > 255)
			ereport(ERROR,
					(errcode(ERRCODE_NAME_TOO_LONG),
					 errmsg("name of level is too long"),
					 errdetail("Name length is %d, must "
							   "be < 256, in position %d.",
							   lptr->wlen, pos)));
	}
	else if (state == LQPRS_WAITOPEN)
		curqlevel->high = 0xffff;
	else if (state != LQPRS_WAITEND)
		ereport(ERROR,
				(errcode(ERRCODE_SYNTAX_ERROR),
				 errmsg("syntax error"),
				 errdetail("Unexpected end of line.")));

	curqlevel = tmpql;
	totallen = LQUERY_HDRSIZE;
	while ((char *) curqlevel - (char *) tmpql < num * ITEMSIZE)
	{
		totallen += LQL_HDRSIZE;
		if (curqlevel->numvar)
		{
			lptr = GETVAR(curqlevel);
			while (lptr - GETVAR(curqlevel) < curqlevel->numvar)
			{
				totallen += MAXALIGN(LVAR_HDRSIZE + lptr->len - lptr->escnum);
				lptr++;
			}
		}
		else if (curqlevel->low > curqlevel->high)
			ereport(ERROR,
					(errcode(ERRCODE_SYNTAX_ERROR),
					 errmsg("syntax error"),
					 errdetail("Low limit(%d) is greater than upper(%d).",
							   curqlevel->low, curqlevel->high)));

		curqlevel = NEXTLEV(curqlevel);
	}

	result = (lquery *) palloc0(totallen);
	SET_VARSIZE(result, totallen);
	result->numlevel = num;
	result->firstgood = 0;
	result->flag = 0;
	if (hasnot)
		result->flag |= LQUERY_HASNOT;
	cur = LQUERY_FIRST(result);
	curqlevel = tmpql;
	while ((char *) curqlevel - (char *) tmpql < num * ITEMSIZE)
	{
		memcpy(cur, curqlevel, LQL_HDRSIZE);
		cur->totallen = LQL_HDRSIZE;
		if (curqlevel->numvar)
		{
			lrptr = LQL_FIRST(cur);
			lptr = GETVAR(curqlevel);
			while (lptr - GETVAR(curqlevel) < curqlevel->numvar)
			{
				cur->totallen += MAXALIGN(LVAR_HDRSIZE + lptr->len - lptr->escnum);
				lrptr->len = 0;
				lrptr->flag = lptr->flag;
				lrptr->val = ltree_crc32_sz(lptr->start, lptr->len);
				if (lptr->escnum > 0)
				{
					ptr = lptr->start;
					pos = 0;
					while (ptr < lptr->start + lptr->len)
					{
						charlen = pg_mblen(ptr);

						if (charlen == 1 && t_iseq(ptr, ESCAPE_CHAR))
						{
							if (pos > 0)
							{
								memcpy(lrptr->name + lrptr->len, ptr - pos, pos);
								lrptr->len += pos;
							}
							pos = 0;
						}
						else
							pos += charlen;

						ptr += charlen;
					}

					if (pos > 0)
					{
						memcpy(lrptr->name + lrptr->len, ptr - pos, pos);
						lrptr->len += pos;
					}
				}
				else
				{
					lrptr->len += lptr->len;
					memcpy(lrptr->name, lptr->start, lptr->len);
				}
				lptr++;
				lrptr = LVAR_NEXT(lrptr);
			}
			pfree(GETVAR(curqlevel));
			if (cur->numvar > 1 || cur->flag != 0)
				wasbad = true;
			else if (wasbad == false)
				(result->firstgood)++;
		}
		else
			wasbad = true;
		curqlevel = NEXTLEV(curqlevel);
		cur = LQL_NEXT(cur);
	}

	pfree(tmpql);
	PG_RETURN_POINTER(result);
}

Datum
lquery_out(PG_FUNCTION_ARGS)
{
	lquery	   *in = PG_GETARG_LQUERY(0);
	char	   *buf,
			   *ptr;
	int			i,
				j,
				totallen = 1;
	lquery_level *curqlevel;
	lquery_variant *curtlevel;

	curqlevel = LQUERY_FIRST(in);
	for (i = 0; i < in->numlevel; i++)
	{
		totallen++;
		if (curqlevel->numvar)
			totallen += 1 + (curqlevel->numvar * 4) + curqlevel->totallen;
		else
			totallen += 2 * 11 + 4;
		curqlevel = LQL_NEXT(curqlevel);
	}

	ptr = buf = (char *) palloc(totallen);
	curqlevel = LQUERY_FIRST(in);
	for (i = 0; i < in->numlevel; i++)
	{
		if (i != 0)
		{
			*ptr = NODE_DELIMITER_CHAR;
			ptr++;
			*ptr = NODE_DELIMITER_CHAR;
			ptr++;
		}
		if (curqlevel->numvar)
		{
			if (curqlevel->flag & LQL_NOT)
			{
				*ptr = '!';
				ptr++;
			}
			curtlevel = LQL_FIRST(curqlevel);
			for (j = 0; j < curqlevel->numvar; j++)
			{
				if (j != 0)
				{
					*ptr = '|';
					ptr++;
				}
				memcpy(ptr, curtlevel->name, curtlevel->len);
				ptr += curtlevel->len;
				if ((curtlevel->flag & LVAR_SUBLEXEME))
				{
					*ptr = '%';
					ptr++;
				}
				if ((curtlevel->flag & LVAR_INCASE))
				{
					*ptr = '@';
					ptr++;
				}
				if ((curtlevel->flag & LVAR_ANYEND))
				{
					*ptr = '*';
					ptr++;
				}
				curtlevel = LVAR_NEXT(curtlevel);
			}
		}
		else
		{
			if (curqlevel->low == curqlevel->high)
			{
				sprintf(ptr, "*{%d}", curqlevel->low);
			}
			else if (curqlevel->low == 0)
			{
				if (curqlevel->high == 0xffff)
				{
					*ptr = '*';
					*(ptr + 1) = '\0';
				}
				else
					sprintf(ptr, "*{,%d}", curqlevel->high);
			}
			else if (curqlevel->high == 0xffff)
			{
				sprintf(ptr, "*{%d,}", curqlevel->low);
			}
			else
				sprintf(ptr, "*{%d,%d}", curqlevel->low, curqlevel->high);
			ptr = strchr(ptr, '\0');
		}

		curqlevel = LQL_NEXT(curqlevel);
	}

	*ptr = '\0';
	PG_FREE_IF_COPY(in, 0);

	PG_RETURN_POINTER(buf);
}
