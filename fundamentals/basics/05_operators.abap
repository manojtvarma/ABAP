***Operators

DATA: lv_num1   TYPE i,
      lv_num2   TYPE i,
      lv_result TYPE i.

lv_num1 = 50.
lv_num2 = 30.

WRITE: / 'First Number :',lv_num1.
WRITE: / 'Second Number:',lv_num2.

SKIP.

lv_result = lv_num1 + lv_num2.
WRITE: / 'Addition    :',lv_result.

lv_result = lv_num1 - lv_num2.
WRITE: / 'Subtraction :',lv_result.

lv_result = lv_num1 * lv_num2.
WRITE: / 'Multiplication:',lv_result.

lv_result = lv_num1 / lv_num2.
WRITE: / 'Division    :',lv_result.

****Arithmetic Operation using abap statements.

ADD lv_num1 TO lv_num2.
WRITE:/'Addition   :',lv_num2.

lv_num1 = 50.
lv_num2 = 30.

SUBTRACT lv_num2 FROM lv_num1.
WRITE:/'Subtraction:',lv_num1.

lv_num1 = 50.
lv_num2 = 30.

MULTIPLY lv_num1 BY lv_num2.
WRITE: / 'Multiplication:',lv_num1.

lv_num1 = 50.
lv_num2 = 30.

DIVIDE lv_num1 BY lv_num2.
WRITE: / 'Division  :',lv_result.


***Comparison Operator for all datatype

IF lv_num1 <> lv_num2.
  WRITE / 'number1 is not equals to number2'.
ELSEIF lv_num1 > lv_num2.
  WRITE / 'number1 is greater than number2'.
ELSEIF lv_num1 >= lv_num2.
  WRITE / 'number1 is greater than equals to number2'.
ELSEIF lv_num1 <= lv_num2.
  WRITE / 'number1 is greater than equals to number2'.
ELSEIF lv_num1 = lv_num2.
  WRITE / 'number1 is equals to number2'.
ENDIF.

Note:
EQ-Equal
NE-Not Equal
LT-Less than
GT-Geater than
LE-Less equal
GE-Greater equal

***Comparison Operator for character or string

DATA lv_str TYPE string.

lv_str = 'manoj varma'.
WRITE: /'String:',lv_str.

SKIP.

IF lv_str CO 'manoj'.
  WRITE /'Contains Only:true'.
ELSE.
  WRITE /'Contains Only:false'.
ENDIF.

IF lv_str CA 'var'.
  WRITE /'Contains Any:true'.
ELSE.
  WRITE /'Contains Any:false'.
ENDIF.

IF lv_str CS 'ma'.
  WRITE /'Contains String:true'.
ELSE.
  WRITE /'Contains String:false'.
ENDIF.

IF lv_str CP 'ma*j'.
  WRITE /'Covers Pattern:true'.
ELSE.
  WRITE /'Covers Pattern:false'.
ENDIF.