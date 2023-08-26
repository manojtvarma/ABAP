DATA: lv_num1   TYPE i VALUE 20,
      lv_num2   TYPE i VALUE 10,
      lv_result TYPE i.

DEFINE calculate.
  lv_result = &1 &2 &3.
END-OF-DEFINITION.

calculate lv_num1 + lv_num2.
calculate lv_num1 - lv_num2.
calculate lv_num1 * lv_num2.
calculate lv_num1 / lv_num2.
