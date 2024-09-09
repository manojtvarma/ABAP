REPORT zcr_sales_order_items_details.

PARAMETERS: p_vbeln TYPE vbak-vbeln.

START-OF-SELECTION.
  SELECT posnr,
         matnr,
         arktx,
         kwmeng,
         meins,
         netpr,
         netwr,
         waerk,
         pstyv
  FROM vbap
  WHERE vbeln = @p_vbeln
  INTO TABLE @DATA(lt_sales_order_items).

  WRITE:    TEXT-001,"Item
         6  TEXT-002,"Material
         16 TEXT-003,"Description
*Adding extra 30 space because it contains description value upto 40char
         49 TEXT-004,"Quantity
         59 TEXT-005,"Base Unit of Measure
         81 TEXT-006,"Net Price
         92 TEXT-007,"Net Value
         102 TEXT-008,"Currency
         112 TEXT-009."Item Category

  LOOP AT lt_sales_order_items ASSIGNING FIELD-SYMBOL(<lwa_sales_order_items>).

    WRITE:  / |{ <lwa_sales_order_items>-posnr  ALPHA = OUT }| UNDER TEXT-001, "Removing Zeros from ItemNumber befor display
              | { <lwa_sales_order_items>-matnr ALPHA = OUT } | UNDER TEXT-002,
              <lwa_sales_order_items>-arktx UNDER TEXT-003,
              <lwa_sales_order_items>-kwmeng UNDER TEXT-004 LEFT-JUSTIFIED,
              <lwa_sales_order_items>-meins UNDER TEXT-005,
              <lwa_sales_order_items>-netpr UNDER TEXT-006 LEFT-JUSTIFIED,
              <lwa_sales_order_items>-netwr UNDER TEXT-007 LEFT-JUSTIFIED,
              <lwa_sales_order_items>-waerk UNDER TEXT-008,
              <lwa_sales_order_items>-pstyv UNDER TEXT-009.
  ENDLOOP.