REPORT zdemo_file_handling_04.

*Reading data from a file of Application Server
DATA(lv_file_name) = './customer.txt'.

*Open the file
OPEN DATASET lv_file_name
FOR INPUT
IN TEXT MODE
ENCODING DEFAULT.

IF sy-subrc EQ 0.
  DATA lv_string TYPE string.

****Reading data from application server
  DO.
    READ DATASET lv_file_name INTO lv_string.
    IF sy-subrc EQ 0.
      WRITE lv_string.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
****
  CLOSE DATASET lv_file_name."close the file
*DELETE DATASET lv_file_name."deletes the file
ENDIF.

