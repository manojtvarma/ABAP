DATA: lt_flight TYPE STANDARD TABLE OF sflight,
      lv_json   TYPE string.

DATA lref_data TYPE REF TO data.
FIELD-SYMBOLS <lt_flight> TYPE table.

SELECT * FROM sflight INTO TABLE lt_flight
UP TO 5 ROWS.

****ABAP object to JSON
CALL METHOD /ui2/cl_json=>serialize
  EXPORTING
    data   = lt_flight
  RECEIVING
    r_json = lv_json.
****
CHECK sy-subrc IS INITIAL.

REFRESH lt_flight.

****JSON to ABAP objects

*CALL METHOD /ui2/cl_json=>generate
*  EXPORTING
*    json    = lv_json
*  RECEIVING
*    rr_data = lref_data.
*
*ASSIGN lref_data->* TO <lt_flight>.

CALL METHOD /ui2/cl_json=>deserialize
  EXPORTING
    json              = lv_json
  CHANGING
    data             = lt_flight.
****
CHECK sy-subrc IS INITIAL.