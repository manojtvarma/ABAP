*Prerequisites for creating AMDP class definition
*1. AMDP class must use interface 'IF_AMDP_MARKER_HDB'
*2. All AMDP method parameters (input/output) must be passed by value
*3. AMDP returning parameter/s must always be internal table

CLASS zcl_customer DEFINITION PUBLIC.

    PUBLIC SECTION.
      INTERFACES if_amdp_marker_hdb.
      TYPES t_customer TYPE TABLE OF scustom.
      CLASS-METHODS get_all_customers EXPORTING VALUE(et_customer) TYPE t_customer. "only pass by value parameter supported for AMDP
  ENDCLASS.
  
  
  CLASS zcl_customer IMPLEMENTATION.
    METHOD get_all_customers BY DATABASE PROCEDURE "Indicates method body contains database specific code
                             FOR HDB "database platform(only HANA supported)
                             LANGUAGE SQLSCRIPT "database procedure lanaguage
                             OPTIONS READ-ONLY "indicates no DML statements are used in business logic
                             USING scustom.
  
      et_customer = SELECT * FROM scustom;
  
    ENDMETHOD.
  ENDCLASS.
  
  Consumption:
  REPORT zdemo_amdp_01.
  
  DATA(ref_customer) =  NEW zcl_customer( ).
  
  ref_customer->get_all_customers(
    IMPORTING
      et_customer = DATA(gt_customer)
  ).
  
  cl_demo_output=>display( data = gt_customer ).