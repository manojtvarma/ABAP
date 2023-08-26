REPORT zdemo_adbc_03.

*1. Establish a DB connection
DATA(ref_sql_con) = NEW cl_sql_connection( ).

*2. Instantiate the Statement Object

IF ref_sql_con IS BOUND.
  DATA(ref_sql_stmt) = NEW cl_sql_statement( con_ref = ref_sql_con ).
ENDIF.

*3. Construct SQL Statement and Execute the Native SQL Query by calling appropriate methods
IF ref_sql_stmt IS BOUND.

*  DATA(lv_query) = `SELECT * FROM SCUSTOM WHERE ID = '00000001'`.
  DATA(lv_query) = `SELECT NAME, CITY FROM SCUSTOM WHERE ID = '00000001'`.
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

*  DATA lwa_customer TYPE scustom.
*  TRY.
*      ref_result_set->set_param_struct( struct_ref = REF #( lwa_customer ) ).
*    CATCH cx_parameter_invalid INTO DATA(lref_param_invalid).
*      lv_text = lref_param_invalid->get_text( ).
*  ENDTRY.

  DATA: lv_name TYPE scustom-name,
        lv_city TYPE scustom-city.

  TRY.
      ref_result_set->set_param( data_ref = REF #( lv_name ) ).
    CATCH cx_parameter_invalid INTO DATA(lref_param_invalid).
      lv_text = lref_param_invalid->get_text( ).
  ENDTRY.

  TRY.
      ref_result_set->set_param( data_ref = REF #( lv_city ) ).
    CATCH cx_parameter_invalid INTO lref_param_invalid.
      lv_text = lref_param_invalid->get_text( ).
  ENDTRY.

*5. Retrieve the Results Set
  TRY.
      ref_result_set->next( ).
    CATCH cx_sql_exception INTO lref_sql_error.
      lv_text = lref_sql_error->get_text( ).
  ENDTRY.
*6.Close the Result Set
  ref_result_set->close( ).
ENDIF.

*6.Close Database Connection
IF ref_sql_con IS BOUND.
  TRY.
      ref_sql_con->close( ).
    CATCH cx_sql_exception.
  ENDTRY.
ENDIF.

*7. Display the results.
*cl_demo_output=>display( data = lwa_customer ).
WRITE: / lv_name, lv_city.
