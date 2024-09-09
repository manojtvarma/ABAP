****Pass by reference for Using
DATA lv_counter TYPE i.

WRITE : / 'counter before increment:', lv_counter.
PERFORM counter_increment USING  lv_counter.
WRITE : / 'counter after increment:', lv_counter.

FORM counter_increment USING lv_counter TYPE i.
  lv_counter = lv_counter + 1.
ENDFORM.

****Output:
*counter before increment: 0 
*counter after increment:  1
****

****Pass by reference for changing
DATA lv_counter TYPE i.

WRITE : / 'counter before increment:', lv_counter.
PERFORM counter_increment CHANGING  lv_counter.
WRITE : / 'counter after increment:', lv_counter.

FORM counter_increment CHANGING lv_counter TYPE i.
  lv_counter = lv_counter + 1.
ENDFORM.

****Output:
*counter before increment: 0
*counter after increment:  1
****