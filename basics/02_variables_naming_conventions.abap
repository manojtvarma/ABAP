*variables: can contains alphabets, numbers, underscore(_), hyphen(-), dollar($) and keywords
*Numeric literals cannot be used as field names

*Valid Variable Names
*Not Recommended* 
DATA _ TYPE i."variable can start with underscore
DATA 1st_manojtvarma/ABAP/alv_idanumber TYPE i. "starting with number is allowed
DATA 1st-number TYPE i. "getting warning "-" character cannot appear in names
DATA add TYPE i."add is keyword
DATA $1 TYPE i.
DATA _test TYPE i.

*Use Meaningful variable names and as a best practise avoid using $, - and keywords in variable names
DATA: lv_first_number TYPE i,
      lv_second_number TYPE i,
      lv_first_name    TYPE i.
      
*Invalid Variable Names
*DATA - TYPE i.
*DATA 123 TYPE i.