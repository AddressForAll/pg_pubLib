
-- -- -- -- -- -- -- --
-- Casts, str_to_something:

CREATE or replace FUNCTION to_integer(str text) RETURNS int as $f$
  SELECT CASE WHEN s='' THEN NULL::int ELSE s::int END
  FROM (SELECT regexp_replace(str, '[^0-9]', '','g')) t(s) 
$f$ LANGUAGE SQL IMMUTABLE;

-- -- -- -- -- -- -- --
-- Array-aggregators:

-- string lib??

CREATE or replace FUNCTION to_hex( p_x bigint[], p_fill_zeros int DEFAULT NULL) RETURNS text[] AS $f$
  SELECT array_agg( CASE WHEN $2>0 THEN lpad(x,p_fill_zeros,'0') ELSE x END )
  FROM (SELECT to_hex(x) x FROM unnest($1) t1(x)) t
$f$ LANGUAGE SQL IMMUTABLE;

CREATE or replace FUNCTION  stragg_prefix(prefix text, s text[], sep text default ',') RETURNS text AS $f$
  SELECT string_agg(x,sep) FROM ( select prefix||(unnest(s)) ) t(x)
$f$ LANGUAGE SQL IMMUTABLE;
