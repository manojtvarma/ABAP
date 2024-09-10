REPORT zapi_access.

PARAMETERS: movie TYPE string.

DATA(lv_url) = 'http://www.omdbapi.com/?apikey=YOUR_API_KEY_HERE&t=' && movie.

"Create HTTP Request
cl_http_client=>create_by_url(
        EXPORTING
          url                =  CONV string( lv_url )
        IMPORTING
          client             = DATA(lo_http_client)
        EXCEPTIONS
          argument_not_found = 1
          plugin_not_active  = 2
          internal_error     = 3
          OTHERS             = 4 ).

"Set Request method
CALL METHOD lo_http_client->request->set_header_field
  EXPORTING
    name  = '~request_method'
    value = 'GET'.
"Set Content Type
CALL METHOD lo_http_client->request->set_header_field
  EXPORTING
    name  = 'Content-Type'
    value = 'application/json; charset=utf-8'.

CALL METHOD lo_http_client->request->set_header_field
  EXPORTING
    name  = 'Accept'
    value = 'application/json, application/json'.

"Send Request
CALL METHOD lo_http_client->send
  EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2.

"Receive the request
CALL METHOD lo_http_client->receive
  EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3.

"Get the statu of the request (Failed or Success )
CALL METHOD lo_http_client->response->get_status
  IMPORTING
    code   = DATA(http_status_code)
    reason = DATA(status_text).

DATA: lv_response TYPE string.

"Read the response
CALL METHOD lo_http_client->response->get_cdata
  RECEIVING
    data = lv_response.

TYPES: BEGIN OF lty_response,
         title    TYPE string,
         released TYPE string,
         plot     TYPE string,
       END OF lty_response.
DATA: ls_response TYPE lty_response.

"Convert the data into required format( Usually deep structure with required fields ).
/ui2/cl_json=>deserialize(
      EXPORTING
        json             =   lv_response  " JSON string
        pretty_name      =  /ui2/cl_json=>pretty_mode-low_case   " Pretty Print property names
      CHANGING
        data             =  ls_response   " Data to serialize
    ).
IF ls_response IS NOT INITIAL.
  WRITE:/ 'Release Date: ' && ls_response-released COLOR 1,
  / 'Plot: ' && ls_response-plot COLOR 3.
ELSE.

  WRITE: 'Sorry, no results'.
ENDIF.