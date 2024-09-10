DATA:lt_scarr TYPE TABLE OF scarr,
     lt_spfli TYPE TABLE OF spfli.

DATA:BEGIN OF ls_result,
       carrid   TYPE scarr-carrid,
       carrname TYPE scarr-carrname,
       connid   TYPE spfli-connid,
       cityfrom TYPE spfli-cityfrom,
       cityto   TYPE spfli-cityto,
     END OF ls_result.

DATA lt_result LIKE TABLE OF ls_result.

FIELD-SYMBOLS: <lwa_result> LIKE ls_result,
               <lwa_spfli>  TYPE spfli,
               <lwa_scarr>  TYPE scarr.

SELECT * FROM scarr INTO TABLE lt_scarr
WHERE carrid = 'LH'.

WRITE: 'Airline Code','Airline Name'.
NEW-LINE.

LOOP AT lt_scarr ASSIGNING <lwa_scarr>.
  NEW-LINE.
  WRITE: <lwa_scarr>-carrid,
         <lwa_scarr>-carrname.
ENDLOOP.
ULINE.

SELECT * FROM spfli INTO TABLE lt_spfli
WHERE carrid = 'LH'.

WRITE: 'Airline Code','Flight Connection Number','Departure city','Arrival city'.
NEW-LINE.

LOOP AT lt_spfli ASSIGNING <lwa_spfli>.
  NEW-LINE.
  WRITE: <lwa_spfli>-carrid,
         <lwa_spfli>-connid,
         <lwa_spfli>-cityfrom,
         <lwa_spfli>-cityto.
ENDLOOP.
ULINE.

****Cross Join
SELECT a~carrid,a~carrname,s~connid,s~cityfrom,s~cityto
FROM scarr AS a CROSS JOIN spfli AS s
INTO TABLE @lt_result.

****Inner Join
****we can use inner join or only join
*SELECT a~carrid a~carrname s~connid s~cityfrom s~cityto
*INTO TABLE lt_result
*FROM scarr AS a INNER JOIN spfli AS s
*ON a~carrid = s~carrid
*WHERE a~carrid = 'LH'.

****Left Join
****we can use left join or left outer join
*SELECT a~carrid a~carrname s~connid s~cityfrom s~cityto
*INTO TABLE lt_result
*FROM scarr AS a LEFT JOIN spfli AS s
*ON a~carrid = s~carrid
*AND s~carrid = 'LH'
*ORDER BY s~carrid.

****Right Join
*SELECT a~carrid,a~carrname,s~connid,s~cityfrom,s~cityto
*FROM scarr AS a RIGHT JOIN spfli AS s
*ON a~carrid = s~carrid
*AND s~carrid = 'LH'
*ORDER BY s~carrid
*INTO TABLE @lt_result.

WRITE: 'Airline Code','Airline Name','Flight Connection Number','Departure city','Arrival city'.
NEW-LINE.

LOOP AT lt_result ASSIGNING <lwa_result>.
  NEW-LINE.
  WRITE: <lwa_result>-carrid,
         <lwa_result>-carrname,
         <lwa_result>-connid,
         <lwa_result>-cityfrom,
         <lwa_result>-cityto.
ENDLOOP.
ULINE.