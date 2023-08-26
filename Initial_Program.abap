REPORT zdemo_adbc_01.

*1. Establish a DB connection
DATA(ref_sql_con) = NEW cl_sql_connection( ).

*2. Instantiate the Statement Object
*lref_sql_con->get_dbms( ). "Returns Database Name
*lref_sql_con->get_con_name( )."Returns Connection Name

IF ref_sql_con IS BOUND.
  DATA(ref_sql_stmt) = NEW cl_sql_statement( con_ref = ref_sql_con ).
ENDIF.

*3. Construct SQL Statement and Execute the Native SQL Query by calling appropriate methods
*execute_query
*execute_ddl   : for executing DDL Statements(Create,Drop,Alter)
*execute_update: for executing DML Statements(Insert,Update,Delete)
*execute_procedure: for executing Stored Procedure

IF ref_sql_stmt IS BOUND.
  TRY.
      ref_sql_stmt->execute_query(
        EXPORTING
          statement  = 'SELECT * FROM SCUSTOM'
        RECEIVING
          result_set = DATA(ref_result_set)
      ).
    CATCH cx_sql_exception.
  ENDTRY.
ENDIF.

*4. Assign the Target Variable to the Result Set
IF ref_result_set IS BOUND.
  DATA gt_customer TYPE TABLE OF scustom.

  ref_result_set->set_param_table( itab_ref = REF #( gt_customer ) ).

*5. Retrieve the Results Set
  TRY.
      ref_result_set->next_package( ).
    CATCH cx_sql_exception.
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

*7. Display the results
cl_demo_output=>display( data = gt_customer ).
