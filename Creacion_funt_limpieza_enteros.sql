CREATE OR REPLACE FUNCTION keepcoding.clean_integer(integer INT64) RETURNS INT64 AS(
  IFNULL(integer, -999999)
  );

