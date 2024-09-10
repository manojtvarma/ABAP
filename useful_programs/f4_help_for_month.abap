***F4 Help for month

PARAMETERS p_month TYPE kmonth.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_month.

  CALL FUNCTION 'POPUP_TO_SELECT_MONTH'
    EXPORTING
      actual_month               = sy-datum(6)
    IMPORTING
      selected_month             = p_month
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      month_not_found            = 3
      OTHERS                     = 4.

***
**Note: In actual_month we are passing month and year.
