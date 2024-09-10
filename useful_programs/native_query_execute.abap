1.Create Connection Object
------------------------------
call method cl_sql_connection=>get_connection
exporting
	con_name = cl_sql_connection=>c_default_connection
receiving
	con_ref = ref_sql_connection

-->it will return connection object.

2.Create Statement Object
-----------------------------
create object ref_sql_statement
exporting
	con_ref = ref_sql_connection

3.Execute Query
------------------
call method ref_sql_statement->execute_query 
exporting
	statement = sql_query
  	hold_cursor = abap_true
receiving
	result_set = ref_result_set

-->it will return result in result set object.

4.Result
---------
set_param_table 	set internal table as output parameters
(itab_ref,corresponding_fields)
next_package    	read next set of data records into itab
(upto)
close 		close result set

Note:
ref_sql_connection type ref to cl_sql_connection
ref_sql_statement  type ref to cl_sql_statement
ref_result_set 	   type ref to  cl_sql_result_set


 

