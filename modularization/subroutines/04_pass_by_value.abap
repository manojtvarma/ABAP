****Pass by value for using
DATA lv_counter TYPE i.

WRITE : / 'counter before increment:', lv_counter.
PERFORM counter_increment USING  lv_counter.
WRITE : / 'counter after increment:', lv_counter.

FORM counter_increment USING VALUE(lv_counter) TYPE i.
  lv_counter = lv_counter + 1.
ENDFORM.

****Output:
*counter before increment: 0
*counter after increment:  0
****


****Pass by value for changing
DATA lv_counter TYPE i.

WRITE : / 'counter before increment:', lv_counter.
PERFORM counter_increment CHANGING  lv_counter.
WRITE : / 'counter after increment:', lv_counter.

FORM counter_increment CHANGING VALUE(lv_counter) TYPE i.
  lv_counter = lv_counter + 1.
ENDFORM.

****Output:
*counter before increment: 0
*counter after increment:  1
****