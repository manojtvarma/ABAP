
CLASS lcl_customer DEFINITION.
    PUBLIC SECTION.
      CONSTANTS num TYPE i VALUE 12.
      EVENTS session_expired.
      METHODS process.
  ENDCLASS.
  
  CLASS lcl_event_handler DEFINITION.
    PUBLIC SECTION.
      METHODS handle_session_expired FOR EVENT session_expired OF lcl_customer.
  ENDCLASS.
  
  CLASS lcl_event_handler IMPLEMENTATION.
    METHOD handle_session_expired.
      WRITE 'Session Has Expired'.
    ENDMETHOD.
  ENDCLASS.
  
  CLASS lcl_customer IMPLEMENTATION.
    METHOD process.
      IF num > 10 .
        RAISE EVENT session_expired.
      ENDIF.
    ENDMETHOD.
  ENDCLASS.
  
  
  START-OF-SELECTION.
  
    DATA: ref_cust TYPE REF TO lcl_customer,
          ref_handler TYPE REF TO lcl_event_handler.
  
    CREATE OBJECT: ref_cust,
                   ref_handler.
  
    SET HANDLER ref_handler->handle_session_expired FOR ref_cust.
  
    ref_cust->process( ).