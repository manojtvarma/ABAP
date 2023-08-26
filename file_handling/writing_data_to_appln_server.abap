REPORT zdemo_file_handling_03.

*Write data to file on presentation layer
SELECT * FROM scustom
INTO TABLE @DATA(lt_customer)
UP TO 10 ROWS.

DATA(lv_file_name) = './customer.txt'.

*Open the file
OPEN DATASET lv_file_name
FOR OUTPUT
IN TEXT MODE
ENCODING DEFAULT.

IF sy-subrc EQ 0.
  LOOP AT lt_customer ASSIGNING FIELD-SYMBOL(<lwa_customer>).

    DATA(lv_string) = |{ <lwa_customer>-id },{ <lwa_customer>-name },|
                      && |{ <lwa_customer>-custtype }, { <lwa_customer>-email }|."Concatenate the values into string

    TRANSFER lv_string TO lv_file_name."Transfer data to file

  ENDLOOP.
  CLOSE DATASET lv_file_name."close the file
ENDIF.
