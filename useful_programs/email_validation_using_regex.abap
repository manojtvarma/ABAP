
PARAMETERS p_email TYPE ad_smtpadr.

DATA: ref_regex    TYPE REF TO cl_abap_regex,
      ref_matcher  TYPE REF TO cl_abap_matcher,
      lv_pattern   TYPE string,
      lv_valid.

lv_pattern = '\w+(\.\w+)*@(\w+\.)+(\w{2,4})' .

***create regex object
CREATE OBJECT ref_regex
  EXPORTING
    pattern     = lv_pattern
    ignore_case = abap_true.

TRANSLATE p_email TO LOWER CASE.

***create matcher object
CALL METHOD ref_regex->create_matcher
  EXPORTING
    text    = p_email
  RECEIVING
    matcher = ref_matcher.

***check email is valid or not
CALL METHOD ref_matcher->match
  RECEIVING
    success = lv_valid.

IF lv_valid EQ abap_true.
  WRITE :/ 'Email valid'.
ELSE.
  WRITE :/ 'Email not valid'.
ENDIF.

Note:
[a-zA-Z0-9.]+@[a-zA-Z.]+.[a-zA-Z]{2,4}
