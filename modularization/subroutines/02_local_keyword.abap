DATA lv_count TYPE i.

lv_count = 10.

PERFORM display_count.
WRITE: / 'count=',lv_count.

FORM display_count.
  LOCAL lv_count.
  lv_count = 6.
  WRITE: / 'count=',lv_count.
ENDFORM.

*Output:
*count= 6 
*count= 10 