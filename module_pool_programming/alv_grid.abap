***Creating ALV Grid 
***Note:
**1.Create Screen(0100),GUI Status(S100) and GUI Title(T100)
**2.Create Custom Controller(ZMV_ALV_GRID_0100_CC)
**3.Create Trasparent Table(ZMV_TEMPLOYEE) in DDIC and Maintain some records.
***

CONSTANTS:BEGIN OF c_fcode,
            exit TYPE sy-ucomm VALUE 'EXIT',
          END OF c_fcode.
CONSTANTS:BEGIN OF c_screen,
            overview TYPE sy-dynnr VALUE '0100',
          END OF c_screen.
CONSTANTS:BEGIN OF c_save_layout,
             user_defined             TYPE c VALUE 'U',
             global                   TYPE c VALUE 'X',
             user_defined_and_global  TYPE c VALUE 'A',
          END OF c_save_layout.
CONSTANTS:c_structure      TYPE tabname  VALUE 'ZMV_TEMPLOYEE',
          c_container_name TYPE scrfname VALUE 'ZMV_ALV_GRID_0100_CC'.

DATA: ref_custom_container TYPE REF TO cl_gui_custom_container,
      ref_grid             TYPE REF TO cl_gui_alv_grid.

DATA: gt_employee TYPE zmv_t_temployee,
      ok_code     TYPE sy-ucomm.

START-OF-SELECTION.
  CALL SCREEN c_screen-overview.

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

  IF ref_custom_container IS INITIAL.
    CREATE OBJECT ref_custom_container
      EXPORTING
        container_name              = c_container_name
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    CHECK sy-subrc EQ 0.
  ENDIF.

  PERFORM grid_prepare.

ENDFORM.

FORM grid_prepare.

  DATA:lt_fcat             TYPE lvc_t_fcat,
       lt_toolbar_excludes TYPE ui_functions.

  IF ref_grid IS INITIAL.
    CREATE OBJECT ref_grid
      EXPORTING
        i_parent          = ref_custom_container
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

  PERFORM data_prepare.
  PERFORM grid_display USING lt_toolbar_excludes
                       CHANGING gt_employee
                                lt_fcat.


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

ENDFORM.

FORM data_prepare .
  SELECT * FROM zmv_temployee INTO TABLE gt_employee.
ENDFORM.

FORM grid_display USING lt_toolbar_excludes TYPE ui_functions
                  CHANGING lt_employee TYPE zmv_t_temployee
                           lt_fcat     TYPE lvc_t_fcat.

  DATA: ls_variant TYPE disvariant,
        ls_layout  TYPE lvc_s_layo.

   ls_variant-report = sy-repid.
*  ls_layout-cwidth_opt = abap_true."optimize the column width
*  ls_layout-no_toolbar = abap_true."hide toolbar
*  ls_layout-no_rowmark = abap_true."hide selection button
   ls_layout-sel_mode = 'A'.

  CALL METHOD ref_grid->set_table_for_first_display
    EXPORTING
      is_variant                    = ls_variant
*     i_default                     = abap_true "allow user to save default layout settings
      i_save                        = c_save_layout-user_defined_and_global
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

