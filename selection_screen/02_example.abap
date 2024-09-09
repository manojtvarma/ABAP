REPORT zdemo_selection_screen_02.

DATA gs_flight_book TYPE sbook.

****Defining selection screen as Subscreen
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
  SELECT-OPTIONS so_odate FOR gs_flight_book-order_date."Booking Date

  PARAMETERS p_custyp TYPE sbook-custtype AS LISTBOX VISIBLE LENGTH 20."Customer Type

  SELECTION-SCREEN BEGIN OF BLOCK b1.
    PARAMETERS: p_cusid  TYPE sbook-customid, "Customer
                p_agcyid TYPE sbook-agencynum. "Agency
  SELECTION-SCREEN END OF BLOCK b1.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK b2.
    PARAMETERS: p_cancel TYPE sbook-cancelled AS CHECKBOX, "Show Cancelled Bookings
                p_reserv TYPE sbook-reserved AS CHECKBOX. "Show Reserved Bookings
  SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF SCREEN 1100.
****

****Defining selection screen as Subscreen
SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.
  PARAMETERS p_carid TYPE sbook-carrid."Airline
  SELECT-OPTIONS so_conid FOR gs_flight_book-connid."Airline Connection
  SELECT-OPTIONS so_fldat FOR gs_flight_book-fldate."Flight date

  SELECTION-SCREEN SKIP.

*Search by Booking Class
  SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE ft1."Booking Class
    PARAMETERS: p_ecocls TYPE boolean AS CHECKBOX, "Economy
                p_buscls TYPE boolean AS CHECKBOX, "Business
                p_fstcls TYPE boolean AS CHECKBOX. "First Class
  SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF SCREEN 1200.
****

****Defining Tabstrips on Selection Screens
SELECTION-SCREEN BEGIN OF TABBED BLOCK tb FOR 10 LINES.
  SELECTION-SCREEN TAB (10) tab1 USER-COMMAND general   DEFAULT SCREEN 1100.
  SELECTION-SCREEN TAB (20) tab2 USER-COMMAND flightdet DEFAULT SCREEN 1200.
SELECTION-SCREEN END OF BLOCK tb.

INITIALIZATION.
****Frame Title
  ft1 = 'Search by Booking Class'.

****Set Text to Tab
  tab1 = 'General'.
  tab2 = 'Flight Details'.

****Setting Initial Active Tab
  tb-activetab = 'general'.
  tb-dynnr = 1100.

****Propose Current Date as Booking Date
*  so_odate[] = VALUE #( ( sign = 'I'
*                          option = 'EQ'
*                          low = sy-datum ) ).

  so_odate[] = VALUE #( ( sign = 'I'
                          option = 'EQ'
                          low = '20210827'
                          high = '20211231' ) ).

TOP-OF-PAGE.
  WRITE: / 'Airline',
           'Booking ID',
           'Customer',
           'CustomerType',
           45'Agency',
           55'OrderDate',
           70'Price',
           80'Currency',
           90'BusinessClass'.
  ULINE.

START-OF-SELECTION.

  DATA gv_where TYPE string.

  PERFORM where_clause_prepare CHANGING gv_where.

  SELECT * FROM sbook
  WHERE (gv_where)
  INTO @gs_flight_book.

    WRITE: / gs_flight_book-carrid     UNDER 'Airline'   LEFT-JUSTIFIED,
             gs_flight_book-bookid     UNDER 'Booking ID'   LEFT-JUSTIFIED,
             gs_flight_book-customid   UNDER 'Customer'     LEFT-JUSTIFIED,
             gs_flight_book-custtype   UNDER 'CustomerType' LEFT-JUSTIFIED,
             gs_flight_book-agencynum  UNDER 'Agency'       LEFT-JUSTIFIED,
             gs_flight_book-order_date UNDER 'OrderDate'    LEFT-JUSTIFIED,
             gs_flight_book-forcuram   UNDER 'Price' LEFT-JUSTIFIED,
             gs_flight_book-forcurkey  UNDER 'Currency' LEFT-JUSTIFIED,
             gs_flight_book-class      UNDER 'BusinessClass' LEFT-JUSTIFIED.

  ENDSELECT.


FORM where_clause_prepare CHANGING lv_where.

  DATA: lt_condtab TYPE TABLE OF hrcond,
        lv_where_clause TYPE string.

****Prepare where clause by considering general selections

  IF NOT so_odate IS INITIAL.
    LOOP AT so_odate .
      APPEND INITIAL LINE TO lt_condtab ASSIGNING FIELD-SYMBOL(<lwa_condtab>).
      <lwa_condtab>-field = 'ORDER_DATE'.
      <lwa_condtab>-opera = so_odate-option.
      <lwa_condtab>-low = so_odate-low.
      <lwa_condtab>-high = so_odate-high.
    ENDLOOP.
    PERFORM selopt_where_clause_prepare USING lt_condtab
                                              'SBOOK'
                                        CHANGING lv_where.
  ENDIF.


  IF NOT p_cusid IS INITIAL.
    IF NOT lv_where IS INITIAL.
      lv_where = |{ lv_where } AND |.
    ENDIF.
    lv_where = |{ lv_where  } customid EQ { cl_abap_dyn_prg=>quote( CONV #( p_cusid ) ) }|.
  ENDIF.

  IF NOT p_agcyid IS INITIAL.
    IF NOT lv_where IS INITIAL.
      lv_where = |{ lv_where } AND |.
    ENDIF.
    lv_where = |{ lv_where  } agencynum EQ { cl_abap_dyn_prg=>quote( CONV #( p_agcyid ) ) }|.
  ENDIF.

  IF NOT p_custyp IS INITIAL.
    IF NOT lv_where IS INITIAL.
      lv_where = |{ lv_where } AND |.
    ENDIF.
    lv_where = |{ lv_where  } custtype EQ { cl_abap_dyn_prg=>quote( p_custyp ) }|.
  ENDIF.

  IF NOT p_cancel IS INITIAL.
    IF NOT lv_where IS INITIAL.
      lv_where = |{ lv_where } AND |.
    ENDIF.
    lv_where = |{ lv_where  } cancelled EQ { cl_abap_dyn_prg=>quote( p_cancel ) }|.
  ENDIF.

  IF NOT p_reserv IS INITIAL.
    IF NOT lv_where IS INITIAL.
      lv_where = |{ lv_where } AND |.
    ENDIF.
    lv_where = |{ lv_where  } reserved EQ { cl_abap_dyn_prg=>quote( p_reserv ) }|.
  ENDIF.
****

****Prepare where clause by considering flight details
  IF NOT p_carid IS INITIAL.
    IF NOT lv_where IS INITIAL.
      lv_where = |{ lv_where } AND |.
    ENDIF.
    lv_where = |{ lv_where  } carrid  EQ { cl_abap_dyn_prg=>quote( p_carid ) }|.
  ENDIF.

*Business Class
  IF NOT p_ecocls IS INITIAL
  OR NOT p_buscls IS INITIAL
  OR NOT p_fstcls IS INITIAL.
    DATA(lv_class) = COND #( WHEN NOT p_ecocls IS INITIAL THEN 'Y'
                             WHEN NOT p_buscls IS INITIAL THEN 'C'
                             ELSE 'F' ).

    IF NOT lv_where IS INITIAL.
      lv_where = |{ lv_where } AND |.
    ENDIF.
    lv_where = |{ lv_where  } class  EQ { cl_abap_dyn_prg=>quote( lv_class ) }|.
  ENDIF.
****

****Airline Connection
  CLEAR: lt_condtab,
         lv_where_clause.

  IF NOT so_conid IS INITIAL.

    LOOP AT so_conid .
      APPEND INITIAL LINE TO lt_condtab ASSIGNING <lwa_condtab>.
      <lwa_condtab>-field = 'CONNID'.
      <lwa_condtab>-opera = so_conid-option.
      <lwa_condtab>-low = so_conid-low.
      <lwa_condtab>-high = so_conid-high.
    ENDLOOP.
    PERFORM selopt_where_clause_prepare USING lt_condtab
                                              'SBOOK'
                                        CHANGING lv_where_clause.

    IF NOT lv_where IS INITIAL.
      lv_where = |{ lv_where } AND |.
    ENDIF.
    lv_where = |{ lv_where } { lv_where_clause }|.
  ENDIF.


****Flight Date
  CLEAR: lt_condtab,
         lv_where_clause.

  IF NOT so_fldat IS INITIAL.
    LOOP AT so_fldat.
      APPEND INITIAL LINE TO lt_condtab ASSIGNING <lwa_condtab>.
      <lwa_condtab>-field = 'FLDATE'.
      <lwa_condtab>-opera = so_fldat-option.
      <lwa_condtab>-low = so_fldat-low.
      <lwa_condtab>-high = so_fldat-high.
    ENDLOOP.
    PERFORM selopt_where_clause_prepare USING lt_condtab
                                              'SBOOK'
                                        CHANGING lv_where_clause.

    IF NOT lv_where IS INITIAL.
      lv_where = |{ lv_where } AND |.
    ENDIF.
    lv_where = |{ lv_where } { lv_where_clause }|.
  ENDIF.

ENDFORM.

FORM selopt_where_clause_prepare USING lt_condtab TYPE table
                                       lv_tabnm
                                 CHANGING lv_where.

  DATA lt_where TYPE TABLE OF string.

  CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
    EXPORTING
      dbtable         = lv_tabnm
    TABLES
      condtab         = lt_condtab
      where_clause    = lt_where
    EXCEPTIONS
      empty_condtab   = 1
      no_db_field     = 2
      unknown_db      = 3
      wrong_condition = 4.

  CALL FUNCTION 'SOTR_SERV_TABLE_TO_STRING'
    IMPORTING
      text     = lv_where
    TABLES
      text_tab = lt_where.

ENDFORM.