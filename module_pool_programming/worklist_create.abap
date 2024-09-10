***Create worklist 

CONSTANTS:BEGIN OF c_fcode,
            search      TYPE sy-ucomm VALUE 'SRCH',
            search_more TYPE sy-ucomm VALUE 'SRCH_MORE',
	    exit        TYPE sy-ucomm VALUE 'EXIT',
          END OF c_fcode.

CONSTANTS c_structure   TYPE tabname  VALUE 'ZMV_TEMPLOYEE'.

CLASS lcl_event_handler DEFINITION DEFERRED.

DATA: ok_code TYPE sy-ucomm,
      fcode   TYPE sy-ucomm.

DATA: ref_docking_container TYPE REF TO cl_gui_docking_container,
      ref_worklist          TYPE REF TO cl_gui_alv_grid,
      lcl_event_handler     TYPE REF TO lcl_event_handler.

DATA: gt_employee      TYPE zmv_t_temployee,
      gt_selected_rows TYPE lvc_t_row.

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_toolbar 	FOR EVENT toolbar 	OF cl_gui_alv_grid
      IMPORTING e_object 
		e_interactive,
      on_user_command 	FOR EVENT user_command 	OF cl_gui_alv_grid
      IMPORTING e_ucomm.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_toolbar.
    DATA lwa_button TYPE stb_button.

    CLEAR lwa_button.
    lwa_button-butn_type = space.
    lwa_button-function = c_fcode-search.
    lwa_button-icon = icon_search.
    lwa_button-quickinfo = TEXT-001.
    lwa_button-text = space.
    INSERT lwa_button INTO e_object->mt_toolbar INDEX 1.

    CLEAR lwa_button.
    lwa_button-butn_type = space.
    lwa_button-function = c_fcode-search_more.
    lwa_button-icon = icon_search_next.
    lwa_button-quickinfo = TEXT-002.
    lwa_button-text = space.
    INSERT lwa_button INTO e_object->mt_toolbar INDEX 2.

    CLEAR lwa_button.
    lwa_button-butn_type = 3.
    INSERT lwa_button INTO e_object->mt_toolbar INDEX 3.

  ENDMETHOD.

  METHOD on_user_command.
    REFRESH gt_selected_rows.
    CALL METHOD ref_worklist->get_selected_rows
      IMPORTING
        et_index_rows = gt_selected_rows.

    CALL METHOD cl_gui_cfw=>set_new_ok_code
      EXPORTING
        new_code = e_ucomm.

  ENDMETHOD.
ENDCLASS.

MODULE status_set OUTPUT.
  PERFORM status_set.
ENDMODULE.

FORM status_set .
  SET PF-STATUS 'S100'.
ENDFORM.

MODULE title_set OUTPUT.
  PERFORM title_set.
ENDMODULE.

FORM title_set .
  SET TITLEBAR 'T100'.
ENDFORM.

MODULE controls_display OUTPUT.
  PERFORM controls_display.
ENDMODULE.

FORM controls_display.

  IF ref_docking_container IS INITIAL.
    CREATE OBJECT ref_docking_container
      EXPORTING
        repid                       = sy-repid
        side                        = cl_gui_docking_container=>dock_at_left
        extension                   = 300
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
  ENDIF.

  PERFORM worklist_prepare.

ENDFORM.

FORM worklist_prepare.

  DATA:lt_fcat             TYPE lvc_t_fcat,
       lt_toolbar_excludes TYPE ui_functions.

  IF ref_worklist IS INITIAL.
    CREATE OBJECT ref_worklist
      EXPORTING
        i_parent          = ref_docking_container
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
  ENDIF.

  PERFORM field_catalog_prepare USING    c_structure
                                CHANGING lt_fcat.

  PERFORM toolbar_buttons_exclude CHANGING lt_toolbar_excludes.
  PERFORM control_event_register.
  PERFORM data_prepare.
  PERFORM worklist_display USING lt_toolbar_excludes
                       	   CHANGING gt_employee
                           	    lt_fcat.

  CALL METHOD ref_worklist->set_toolbar_interactive.

ENDFORM.

FORM field_catalog_prepare  USING    lv_structure
                            CHANGING lt_fcat TYPE lvc_t_fcat.

  FIELD-SYMBOLS <lwa_fcat> TYPE lvc_s_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = lv_structure
    CHANGING
      ct_fieldcat            = lt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT lt_fcat ASSIGNING <lwa_fcat>.
    CASE <lwa_fcat>-fieldname.
      WHEN 'EMPID'.
        <lwa_fcat>-hotspot = abap_true.
    ENDCASE.
  ENDLOOP.

ENDFORM.

FORM toolbar_buttons_exclude  CHANGING lt_toolbar_excludes TYPE ui_functions.

  APPEND cl_gui_alv_grid=>mc_fc_detail  TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_print   TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_views   TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_graph   TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_info    TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_subtot  TO lt_toolbar_excludes.

  APPEND cl_gui_alv_grid=>mc_fc_sum     TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_minimum TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_maximum TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_average TO lt_toolbar_excludes.

***for worklist
  APPEND cl_gui_alv_grid=>mc_fc_filter   TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_sort_asc TO lt_toolbar_excludes.
  APPEND cl_gui_alv_grid=>mc_fc_sort_dsc TO lt_toolbar_excludes.
***
ENDFORM.

FORM control_event_register.
  IF lcl_event_handler IS INITIAL.
    CREATE OBJECT lcl_event_handler.
  ENDIF.
  SET HANDLER: lcl_event_handler->on_toolbar       FOR ref_worklist,
               lcl_event_handler->on_user_command  FOR ref_worklist.
ENDFORM.

FORM data_prepare .
  SELECT * FROM zmv_temployee INTO TABLE gt_employee.
ENDFORM.

FORM worklist_display USING lt_toolbar_excludes TYPE ui_functions
                  CHANGING lt_employee TYPE zmv_t_temployee
                           lt_fcat     TYPE lvc_t_fcat.

  DATA: ls_variant TYPE disvariant,
        ls_layout  TYPE lvc_s_layo.


  ls_variant-report = sy-repid.
  ls_layout-sel_mode = 'A'.

  CALL METHOD ref_worklist->set_table_for_first_display
    EXPORTING
      is_variant                    = ls_variant
      i_default                     = abap_true
      i_save                        = 'A'
      is_layout                     = ls_layout
      it_toolbar_excluding          = lt_toolbar_excludes
    CHANGING
      it_outtab                     = gt_employee
      it_fieldcatalog               = lt_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

ENDFORM.

MODULE exit_processing INPUT.
  PERFORM exit_processing.
ENDMODULE.

FORM exit_processing .
  IF ok_code EQ c_fcode-exit.
    SET SCREEN 0.
    LEAVE PROGRAM.
  ENDIF.
ENDFORM.

***Note:
**text-001:Search
**text-002:Search More
***