DATA: num1 TYPE i,
      num2 TYPE i.

num1 = 10.
num2 = 20.

***if-else statement
IF num1 > num2.
  WRITE / 'number 1 is greater then number2'.
ELSEIF num1 = num2.
  WRITE / 'number1 is equal to number 2'.
ELSE.
  WRITE / 'number1 is less than number2'.
ENDIF.

***case statement
CASE num1.
  WHEN num1 .
    WRITE / num1.
  WHEN num2.
    WRITE / num1.
  WHEN OTHERS.
    WRITE / 'wrong !!'.
ENDCASE.

***while loop
WHILE num1 <> 0.
  WRITE / num1.
  num1 = num1 - 1.
ENDWHILE.

***do loop
DO 5 TIMES.
  WRITE / 'hello '.
ENDDO.

***continue
DO 5 TIMES.
  IF sy-index = 3.
    CONTINUE.
  ENDIF.
  WRITE / sy-index.
ENDDO.

***check
DO 5 TIMES.
  CHECK sy-index BETWEEN 3 AND 4.
  WRITE / sy-index.
ENDDO.

***exit
DO 5 TIMES.
  IF sy-index = 3.
    EXIT.
  ENDIF.
  WRITE / sy-index.
ENDDO.