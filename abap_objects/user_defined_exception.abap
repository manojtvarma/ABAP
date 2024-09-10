
CLASS lcl_customer DEFINITION.
    PUBLIC SECTION.
      METHODS:  constructor IMPORTING i_balance TYPE i,
                deposit IMPORTING i_amount TYPE i ,
                withdraw IMPORTING i_amount TYPE i,
                get_balance RETURNING value(return) TYPE i.
    PRIVATE SECTION.
      DATA balance TYPE i.
  ENDCLASS.                    
  
  
  CLASS lcl_customer IMPLEMENTATION.
    METHOD constructor.
      me->balance = i_balance.
    ENDMETHOD.                    
  
    METHOD deposit.
      balance = balance + i_amount.
    ENDMETHOD.                    
  
    METHOD withdraw.
      DATA: msg TYPE string,
            ref_excp TYPE REF TO zcx_insuf_funds_excp.
      IF balance > i_amount.
        balance = balance - i_amount.
      ELSE.
        TRY.
            RAISE EXCEPTION TYPE zcx_insuf_funds_excp EXPORTING message = 'Insufficient Balance In Account'.
          CATCH zcx_insuf_funds_excp INTO ref_excp.
            msg = ref_excp->get_text( ).
        ENDTRY.
        WRITE msg.
      ENDIF.
    ENDMETHOD.                    
  
    METHOD get_balance.
      return = balance.
    ENDMETHOD.                   
  
  ENDCLASS.                    
  
  START-OF-SELECTION.
  
    DATA: balance TYPE i,
          ref_cust TYPE REF TO lcl_customer.
  
    CREATE OBJECT ref_cust
      EXPORTING
        i_balance = 1000.
  
    balance = ref_cust->get_balance( ).
    WRITE: 'Current Balance:',balance.
    NEW-LINE.
  
    CALL METHOD: "ref_cust->deposit EXPORTING i_amount = 5000,
                  ref_cust->withdraw EXPORTING i_amount = 2000.
  
    balance = ref_cust->get_balance( ).
    SKIP.
  
    WRITE: 'Total Balance:',balance.