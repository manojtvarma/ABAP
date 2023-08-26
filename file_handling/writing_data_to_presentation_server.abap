REPORT zdemo_file_handling_02.

*Write data to file on presentation layer
SELECT * FROM scustom
INTO TABLE @DATA(gt_customer)
UP TO 10 ROWS.

CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
    filename              = 'C:\New folder\customer.txt'    " Name of file
    filetype              = 'ASC'                " File Type (ASC or BIN)
    append                = space                " Writing mode (overwrite, append)
    write_field_separator = abap_true            " Separate Columns by Tabs in Case of ASCII Download
  TABLES
    data_tab              = gt_customer.         " Transfer table

CHECK sy-subrc EQ 0.
