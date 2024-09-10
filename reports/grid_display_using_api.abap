
***Display Grid without creating screen

CONSTANTS c_structure       TYPE tabname VALUE 'ZMV_TEMPLOYEE'.
CONSTANTS c_variant_handle  TYPE char4 	 VALUE 'GDWS'.

CONSTANTS:BEGIN OF c_function,
            select_detail   TYPE gui_func VALUE '&ETA',
            print_preview   TYPE gui_func VALUE '&RNT_PREV',
            mail_recipient  TYPE gui_func VALUE '%SL',
            graphics        TYPE gui_func VALUE '&GRAPH',
            export          TYPE gui_func VALUE '%PC',
            word_processing TYPE gui_func VALUE '&AQW',
            microsoft_excel TYPE gui_func VALUE '&VEXCEL',
            information     TYPE gui_func VALUE '&INFO',
            change_layout   TYPE gui_func VALUE '&OL0',
            select_layout   TYPE gui_func VALUE '&OAD',
            save_layout     TYPE gui_func VALUE '&AVE',
          END OF c_function.

DATA: lt_employee          TYPE TABLE OF zmv_temployee,
      lt_fcat              TYPE slis_t_fieldcat_alv,
      lt_function_excludes TYPE slis_t_extab.

DATA: ls_layout            TYPE slis_layout_alv,
      ls_variant           TYPE disvariant,
      lwa_fcat             TYPE slis_fieldcat_alv,
      lwa_function_exclude TYPE slis_extab.

****Field Catalog Prepare
***To create hotspot on field
*lwa_fcat-fieldname = 'EMPID'.
*lwa_fcat-hotspot = abap_true.
*APPEND lwa_fcat TO lt_fcat.
***
***to hide field
*CLEAR lwa_fcat.
*lwa_fcat-fieldname = 'EMPNM'.
*lwa_fcat-no_out = abap_true.
*lwa_fcat-tech = abap_true.
*APPEND lwa_fcat TO lt_fcat.
***
****

****Toolbar Excludes
APPEND c_function-select_detail   TO lt_function_excludes.
APPEND c_function-print_preview   TO lt_function_excludes.
APPEND c_function-mail_recipient  TO lt_function_excludes.
APPEND c_function-graphics        TO lt_function_excludes.
APPEND c_function-export          TO lt_function_excludes.
APPEND c_function-word_processing TO lt_function_excludes.
APPEND c_function-microsoft_excel TO lt_function_excludes.
APPEND c_function-information     TO lt_function_excludes.
*APPEND c_function-change_layout   TO lt_function_excludes.
*APPEND c_function-select_layout   TO lt_function_excludes.
*APPEND c_function-save_layout   TO lt_function_excludes.
****

****Layout
ls_layout-colwidth_optimize = abap_true.
ls_layout-window_titlebar = TEXT-001.
*ls_layout-edit = abap_true.
****

****Variant
*ls_variant-report = sy-repid.
****

****Data Prepare
SELECT * FROM zmv_temployee
INTO TABLE lt_employee.
****

****Grid Display
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = c_structure
    is_layout        = ls_layout
    i_default        = abap_true
    i_save           = 'A'
*    is_variant       = ls_variant
    it_fieldcat      = lt_fcat
    it_excluding     = lt_function_excludes
  TABLES
    t_outtab         = lt_employee
  EXCEPTIONS
    program_error    = 1
    OTHERS           = 2.
****