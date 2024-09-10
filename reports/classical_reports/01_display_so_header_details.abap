REPORT zcr_sales_header_details_01.

PARAMETERS: p_vbeln TYPE vbak-vbeln.

TYPES: BEGIN OF ty_sales_order,
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

  WRITE: TEXT-001,"Order Number
         TEXT-002,"Order Type
         TEXT-003,"Sold-To Party
         TEXT-004,"Document Date
         TEXT-005,"Net Value
         TEXT-006."Currency

  WRITE:  / ls_sales_order-vbeln,
            ls_sales_order-auart,
            ls_sales_order-kunnr,
            ls_sales_order-audat,
            ls_sales_order-netwr,
            ls_sales_order-waerk.