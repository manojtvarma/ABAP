CONSTANTS c_tabname TYPE tabname VALUE 'ZMV_TCUSTOMER'.

CONSTANTS:BEGIN OF c_table_type,
            transparent TYPE tabclass VALUE 'TRANSP',
            cluster     TYPE tabclass VALUE 'CLUSTER',
            pooled      TYPE tabclass VALUE 'POOL',
          END OF c_table_type.

CONSTANTS:BEGIN OF c_delivery_class,
            application_table TYPE contflag VALUE 'A',
            customizing_table TYPE contflag VALUE 'C',
          END OF c_delivery_class.

CONSTANTS:BEGIN OF c_maintenance,
            allowed_with_restriction TYPE maintflag VALUE '',
            allowed                  TYPE maintflag VALUE 'X',
            not_allowed              TYPE maintflag VALUE 'N',
          END OF c_maintenance.

CONSTANTS:BEGIN OF c_data_class,
            master_data              TYPE tabart VALUE 'APPL0',
            transaction_data         TYPE tabart VALUE 'APPL1',
            organization_customizing TYPE tabart VALUE 'APPL2',
          END OF c_data_class.

CONSTANTS:BEGIN OF c_size_category,
            tables_less_than_500k TYPE tabkat  VALUE '0',
            tables_less_than_2mb  TYPE tabkat  VALUE '1',
            tables_less_than_7mb  TYPE tabkat  VALUE '2',
          END OF c_size_category.

CONSTANTS:BEGIN OF c_buffering,
            not_allowed              TYPE bufallow VALUE 'N',
            allowed_but_switched_off TYPE bufallow VALUE 'A',
            activated                TYPE bufallow VALUE 'X',
          END OF c_buffering.

CONSTANTS:BEGIN OF c_buffering_type,
            single_record_buffered TYPE pufferung VALUE 'P',
            generic_area_buffered  TYPE pufferung VALUE 'G',
            fully_buffered         TYPE pufferung VALUE 'X',
          END OF c_buffering_type.

DATA:ls_table_header  TYPE dd02v,
     ls_tech_settings TYPE dd09v,
     lt_fields        TYPE TABLE OF dd03p,
     lwa_field        TYPE dd03p,
     ls_tadir         TYPE tadir.

***Table Header
ls_table_header-tabname = c_tabname.
ls_table_header-tabclass = c_table_type-transparent.
ls_table_header-ddtext = text-001.
ls_table_header-ddlanguage = sy-langu.

***delivery and maintenance
ls_table_header-contflag = c_delivery_class-application_table.
ls_table_header-mainflag = c_maintenance-allowed_with_restriction.
***
***attributes
ls_table_header-as4user = sy-uname.
ls_table_header-as4date = sy-datum.
ls_table_header-masterlang = sy-langu.
***
ls_table_header-clidep = abap_true."client specific
*****


***technical settings
ls_tech_settings-tabname = c_tabname.
ls_tech_settings-tabart = c_data_class-transaction_data.
ls_tech_settings-tabkat = c_size_category-tables_less_than_500k.
ls_tech_settings-bufallow = c_buffering-activated.
ls_tech_settings-pufferung = c_buffering_type-fully_buffered.
*****

***Fields
lwa_field-tabname = c_tabname.
lwa_field-fieldname = 'MANDT'.
lwa_field-keyflag = abap_true.
lwa_field-notnull = abap_true.
lwa_field-rollname = 'MANDT'.
lwa_field-ddlanguage = sy-langu.
lwa_field-position = 1.

APPEND lwa_field TO lt_fields.

CLEAR lwa_field.
lwa_field-tabname = c_tabname.
lwa_field-fieldname = 'CUSNM'.
lwa_field-keyflag = abap_true.
lwa_field-notnull = abap_true.
lwa_field-rollname = 'ZMV_CUSNM'.
lwa_field-ddlanguage = sy-langu.
lwa_field-position = 2.

APPEND lwa_field TO lt_fields.
*****

****To create table
CALL FUNCTION 'DDIF_TABL_PUT'
  EXPORTING
    name              = c_tabname
    dd02v_wa          = ls_table_header
    dd09l_wa          = ls_tech_settings
  TABLES
    dd03p_tab         = lt_fields
  EXCEPTIONS
    tabl_not_found    = 1
    name_inconsistent = 2
    tabl_inconsistent = 3
    put_failure       = 4
    put_refused       = 5
    OTHERS            = 6.
****
****specify the package
CALL FUNCTION 'TR_TADIR_INTERFACE'
  EXPORTING
    wi_test_modus       = abap_false
    wi_tadir_pgmid      = 'R3TR'
    wi_tadir_object     = 'TABL'
    wi_tadir_obj_name   = 'ZMV_TCUSTOMER'
    wi_tadir_devclass   = '$TMP'
    wi_tadir_masterlang = sy-langu.
****
****To activate table
CALL FUNCTION 'DDIF_TABL_ACTIVATE'
  EXPORTING
    name        = c_tabname
  EXCEPTIONS
    not_found   = 1
    put_failure = 2
    OTHERS      = 3.
****

IF sy-subrc EQ 0.
  MESSAGE text-002 TYPE 'S'.
ELSE.
  MESSAGE text-003 TYPE 'E'.
ENDIF.

****Note:
**text-001:Customer
**text-002:Table Created
**text-003:Table Not Created
****