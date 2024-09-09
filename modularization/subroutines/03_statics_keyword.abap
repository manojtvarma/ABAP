PERFORM increment_count.
PERFORM increment_count.

FORM increment_count.
  STATICS lv_count TYPE i.
  lv_count = lv_count + 1.
  WRITE: / 'count=',lv_count.
ENDFORM.

****Output:
*count= 1 
*count= 2 