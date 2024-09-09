****Predefined ABAP Types.
*Fixed Length
*Variable Length

****Fixed Length Data Types
*Numeric(I,F,P)
*Character(C,N,D,T)
*Hexadecimal(X)

****Variable Length
*string: sequence of characters with variable length
*xstring: when you need to handle binary data of variable lengths

**********************************************************************
****Numeric
*1.Integers(whole number)
*Used to store whole number values without requiring leading zeros or alphanumeric characters
*Example: counters, numbers of items, time periods
*Default value: 0
*Length: 4-byte
*cl_abap_math=>min_int4 for mininum integer value & cl_abap_math=>max_int4 for max integer value

DATA: lv_counter  TYPE i,
      lv_length   TYPE i,
      lv_duration TYPE i.

lv_counter = '1.2'.

*2.Floating point number
*used for general-purpose floating-point calculations where rounding errors are not critical
*Represents floating-point numbers using a binary format
*Length: 4-byte
*Default value: 0

*3.Packed Number(p)
*used when you need to work with decimal values with a fixed number of decimal places
*Represents decimal numbers using a packed format,(Binary-Coded Decimal(BCD))
*example: amounts, quantities, distance
*Length: 1 to 16 bytes
*Default Length: 8 byte
*Default value: 0
*In realtime scenario we will have currency for amount and unit for quantity & distance(c type)

DATA: lv_price    TYPE p LENGTH 15 DECIMALS 2,
      lv_distance TYPE p LENGTH 9 DECIMALS 4,
      lv_weight   TYPE p LENGTH 8 DECIMALS 4.

lv_price = '845'.
lv_distance = '2.572'.

WRITE: / lv_price, lv_distance. "845,00 2,5720
**since system's settings are configured to use a comma , as the decimal separator instead of a period

**********************************************************************
****Characters

*1.Character(C)
*Used to store text based values like Names,Descriptions, Alphanumeric Codes
*When we assign more char than expected length value will get truncated
*Length: 1-byte
*Defaut Value: '...'
*cl_abap_elemdescr=>type_c_max_length

DATA: lv_customer_name   TYPE c LENGTH 25,
      lv_customer_type   TYPE c, "by default length is 1
      lv_airline_code(3) TYPE c,
      lv_product_code    TYPE c LENGTH 10.

*2.Numeric text field
*numeric characters
*Length: 1-byte
*Defaut Value: '0..0'

DATA: lv_customer_id(8)       TYPE n,
      lv_flight_connection_no TYPE n LENGTH 4,
      lv_agency_number        TYPE n LENGTH 8,
      lv_no_of_sales_office   TYPE n LENGTH 8.

*3.Date field(D)
*Length: 8-byte
*Defaut Value: '00000000'
*default format: YYYYMMDD

DATA: lv_flight_date      TYPE d,
      lv_calculation_date TYPE d.

*4.Time Field(T)
*Length: 6-byte
*Defaut Value: '000000'
*default format: HHMMSS

DATA: lv_departure_time TYPE t,
      lv_arrival_time   TYPE t.
**********************************************************************
****Hexadecimal field(X)
*used for storing and manipulating raw binary data
*Example: binary-coded values, cryptographic keys
*Length: 1-byte
*Defaut Value: X'0..0'

DATA lv_encryption_key TYPE x LENGTH 12.

lv_encryption_key = '1A2B3C4D5E6F'.

*Type Conversion
*Character to Integer: character number can be converted to integer. common exception: CX_SY_CONVERSION_NO_NUMBER
*Decimal to integer: decimal points are ignored and converted into integer
