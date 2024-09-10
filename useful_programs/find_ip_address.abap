DATA  lv_ip_address TYPE string.

*lv_ip_address = cl_gui_frontend_services=>get_ip_address( ).

CALL METHOD cl_gui_frontend_services=>get_ip_address
  RECEIVING
    ip_address           = lv_ip_address
  EXCEPTIONS
    cntl_error           = 1
    error_no_gui         = 2
    not_supported_by_gui = 3
    OTHERS               = 4.

WRITE: 'IP Address:',lv_ip_address.
