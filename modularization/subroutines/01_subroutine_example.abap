PERFORM increment_count."call subroutine

FORM increment_count.
  DATA lv_count TYPE i.

  lv_count = lv_count + 1.
  WRITE: / 'count=',lv_count.
ENDFORM.