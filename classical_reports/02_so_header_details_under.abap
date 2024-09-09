REPORT zcr_sales_header_details_02.

PARAMETERS p_vbeln TYPE vbak-vbeln.

TYPES BEGIN OF ty_sales_order,
         vbeln TYPE vbak-vbeln,
         auart TYPE vbak-auart,
         kunnr TYPE vbak-kunnr,
         audat TYPE vbak-audat,
         netwr TYPE vbak-netwr,
         waerk TYPE vbak-waerk,
       END OF ty_sales_order.

DATA ls_sales_order TYPE ty_sales_order.

START-OF-SELECTION.
  SELECT SINGLE vbeln,
                auart,
                kunnr,
                audat,
                netwr,
                waerk
  FROM vbak
  WHERE vbeln = @p_vbeln
  INTO @ls_sales_order.


  WRITE TEXT-001,Order Number
         TEXT-002,Order Type
         TEXT-003,Sold-To Party
         TEXT-004,Document Date
         TEXT-005,Net Value
         TEXT-006.Currency

"To Give Custom Space between the column header
  WRITE    TEXT-001,"Order Number
         14 TEXT-002,"Order Type
         26 TEXT-003,"Sold-To Party
         41 TEXT-004,"Document Date
         56 TEXT-005,"Net Value
         67 TEXT-006."Currency


  WRITE   ls_sales_order-vbeln UNDER TEXT-001,
            ls_sales_order-auart UNDER TEXT-002,
            ls_sales_order-kunnr UNDER TEXT-003,
            ls_sales_order-audat UNDER TEXT-004,
            ls_sales_order-netwr UNDER TEXT-005 LEFT-JUSTIFIED,"Amount field is by default right aligned
            ls_sales_order-waerk UNDER TEXT-006.