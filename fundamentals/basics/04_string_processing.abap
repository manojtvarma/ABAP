****String Processing
DATA: lv_name       TYPE char20,
      lv_username   TYPE char20,
      lv_length     TYPE char5,
      lv_first_name TYPE char20,
      lv_last_name  TYPE char20,
      lv_number     TYPE char10.

lv_name = 'manoj varma'.

***translate
TRANSLATE lv_name TO UPPER CASE.
WRITE / lv_name.

***split
SPLIT lv_name AT space INTO lv_first_name lv_last_name.
WRITE: / lv_first_name,
       / lv_last_name.

***concatenate
CONCATENATE lv_first_name lv_last_name INTO lv_username SEPARATED BY space.
WRITE / lv_username.

***condense
CONDENSE lv_username NO-GAPS.
WRITE / lv_username.

***search
SEARCH lv_username FOR 'manoj'.
IF sy-subrc EQ 0.
  WRITE 'Found'.
ENDIF.

***replace
REPLACE 'manoj' WITH 'sanoj' INTO lv_name.
WRITE lv_name.

***shift
lv_number = 1001.
WRITE / lv_number.

SHIFT lv_number LEFT DELETING LEADING space.
WRITE / lv_number.

**Note: Some In-build string methods
 strlen()
 lines()
 condense()
 to_upper()
 to_lower()
 reverse()
 numofchar()
***