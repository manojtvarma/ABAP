REPORT zdemo_alv_ida_02.

*1. Get the ALV Object by passing DB Table Name or DDIC View(CREATE Method)
TRY.
    DATA(lref_alv_ida) = cl_salv_gui_table_ida=>create( iv_table_name = 'SCUSTOM' ).

  CATCH cx_salv_db_connection.
  CATCH cx_salv_db_table_not_supported.
  CATCH cx_salv_ida_contract_violation.
ENDTRY.

*2. Using the above ALV Object, get reference of full screen Mode(FULLSCREEN Method)
IF lref_alv_ida IS BOUND.

*get the reference of field catalog
  DATA(lref_alv_ida_fcat) = lref_alv_ida->field_catalog( ).

  IF lref_alv_ida_fcat IS BOUND.
    TRY.
        lref_alv_ida_fcat->set_field_header_texts( iv_field_name  = 'EMAIL'
                                                   iv_header_text = 'Email' ).

        lref_alv_ida_fcat->disable_sort( iv_field_name = 'ID' ).

        lref_alv_ida_fcat->disable_filter( iv_field_name = 'EMAIL' ).

****Hiding Fields from Display
        lref_alv_ida_fcat->get_all_fields(
          IMPORTING
            ets_field_names = DATA(lt_field_names)
        ).

        IF NOT lt_field_names IS INITIAL.
          DELETE lt_field_names
          WHERE table_line = 'WEBUSER'
             OR table_line = 'POSTBOX'.
        ENDIF.

        lref_alv_ida_fcat->set_available_fields( its_field_names = lt_field_names ).
****
      CATCH cx_salv_ida_unknown_name.
      CATCH cx_salv_call_after_1st_display.
    ENDTRY.
  ENDIF.

*get the reference of field catalog
  DATA(lref_alv_ida_std_functions) = lref_alv_ida->standard_functions( ).

  IF lref_alv_ida_std_functions IS BOUND.
*deactivate aggregate functions button on ALV toolbar
    lref_alv_ida_std_functions->set_aggregation_active( iv_active = abap_false ).
  ENDIF.

  TRY.
      DATA(lref_alv_ida_fullscreen) = lref_alv_ida->fullscreen( ).
    CATCH cx_salv_ida_contract_violation.
  ENDTRY.
ENDIF.

*3. Using the above full screen Mode object, display the content on UI(DISPLAY Method)
IF lref_alv_ida_fullscreen IS BOUND.
  lref_alv_ida_fullscreen->display( ).
ENDIF.
