REPORT zdemo_adbc_02.

*1. Establish a DB connection
DATA(ref_sql_con) = NEW cl_sql_connection( ).

*2. Instantiate the Statement Object

IF ref_sql_con IS BOUND.
  DATA(ref_sql_stmt) = NEW cl_sql_statement( con_ref = ref_sql_con ).
ENDIF.

*3. Construct SQL Statement and Execute the Native SQL Query by calling appropriate methods
IF ref_sql_stmt IS BOUND.
*1. DATA(lv_query) = `SELECT * FROM SFLIGHT`.
*2. DATA(lv_query) = `SELECT * FROM SFLIGHT WHERE CARRID = 'AA'`.
*3. DATA(lv_query) = `SELECT CARRID, CONNID, FLDATE, PRICE, CURRENCY FROM SFLIGHT WHERE CARRID = 'AA'`.
*4. Bind the parameter of select query as IN Parameter
  DATA(lv_query) = `SELECT CARRID, CONNID, FLDATE, PRICE, CURRENCY FROM SFLIGHT WHERE CARRID = ? AND CONNID = ?`.
  DATA(lv_carrid) = 'AA'."Airline Code
  DATA(lv_connid) = '0017'."Flight Connection Number

  ref_sql_stmt->set_param( data_ref = REF #( lv_carrid ) ).
  ref_sql_stmt->set_param( data_ref = REF #( lv_connid ) ).

  TRY.
      ref_sql_stmt->execute_query(
        EXPORTING
          statement  = lv_query
        RECEIVING
          result_set = DATA(ref_result_set)
      ).
    CATCH cx_sql_exception INTO DATA(lref_sql_error).
      DATA(lv_text) = lref_sql_error->get_text( ).
  ENDTRY.
ENDIF.

*4. Assign the Target Variable to the Result Set
IF ref_result_set IS BOUND.
*  DATA gt_flight TYPE TABLE OF sflight.
  TYPES: BEGIN OF s_flight,
           carrid   TYPE sflight-carrid,
           connid   TYPE sflight-connid,
           fldate   TYPE sflight-fldate,
           price    TYPE sflight-price,
           currency TYPE sflight-currency,
         END OF s_flight.
  DATA gt_flight TYPE TABLE OF s_flight.

  TRY.
      ref_result_set->set_param_table( itab_ref = REF #( gt_flight ) ).
    CATCH cx_parameter_invalid.
  ENDTRY.

*5. Retrieve the Results Set
  TRY.
    ref_result_set->next_package( ).
    CATCH cx_sql_exception INTO lref_sql_error.
      lv_text = lref_sql_error->get_text( ).
  ENDTRY.
  ref_result_set->close( ).
ENDIF.

*6. Close the Result Set and Database Connection
IF ref_sql_con IS BOUND.
  TRY.
      ref_sql_con->close( ).
    CATCH cx_sql_exception.
  ENDTRY.
ENDIF.

*7. Display the results.
cl_demo_output=>display( data = gt_flight ).
