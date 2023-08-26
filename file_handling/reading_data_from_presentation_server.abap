REPORT zdemo_file_handling_01.

PARAMETERS p_file TYPE localfile.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

*Returns full pathname selected by user
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = p_file.

START-OF-SELECTION.
*Read data from file on presentation layer
  TYPES: BEGIN OF s_customer,
           id       TYPE scustom-id,
           name     TYPE scustom-name,
           custtype TYPE scustom-custtype,
           email    TYPE scustom-email,
           city     TYPE scustom-city,
           country  TYPE scustom-country,
         END OF s_customer.

  DATA: lt_customer TYPE TABLE OF s_customer,
        lv_file_name TYPE string.

  lv_file_name = p_file.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename            = lv_file_name     " Name of file
      filetype            = 'ASC'            " File Type (ASC or BIN)
      has_field_separator = abap_true        " Columns Separated by Tabs in Case of ASCII Upload
      read_by_line        = 'X'              " The file will be written to the internal table line-by-line
    TABLES
      data_tab            = lt_customer.     " Transfer table for file contents


*Display customer data
  cl_demo_output=>display( data = lt_customer ).
