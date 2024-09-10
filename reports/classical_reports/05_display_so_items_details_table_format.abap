REPORT zcr_sales_order_items_details4.

PARAMETERS: p_vbeln TYPE vbak-vbeln DEFAULT 10000001.

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

  WRITE sy-uline(133).
  NEW-LINE.

  WRITE: sy-vline,    TEXT-001,"Item
         7 sy-vline, TEXT-002,"Material
         17 sy-vline,TEXT-003,"Description
         50 sy-vline,TEXT-004,"Quantity
         60 sy-vline,TEXT-005,"Base Unit of Measure
         82 sy-vline,TEXT-006,"Net Price
         95 sy-vline,TEXT-007,"Net Value
         107 sy-vline,TEXT-008,"Currency
         118 sy-vline,TEXT-009,"Item Category
         133 sy-vline.

  WRITE sy-uline(133).

  LOOP AT lt_sales_order_items ASSIGNING FIELD-SYMBOL(<lwa_sales_order_items>).

    WRITE:  / sy-vline,|{ <lwa_sales_order_items>-posnr  ALPHA = OUT }| UNDER TEXT-001, "Removing Zeros from ItemNumber befor display
              7 sy-vline,| { <lwa_sales_order_items>-matnr ALPHA = OUT } | UNDER TEXT-002,
              17  sy-vline,<lwa_sales_order_items>-arktx UNDER TEXT-003,
              50 sy-vline,<lwa_sales_order_items>-kwmeng UNDER TEXT-004 LEFT-JUSTIFIED,
              60 sy-vline,<lwa_sales_order_items>-meins UNDER TEXT-005,
              82 sy-vline,<lwa_sales_order_items>-netpr UNDER TEXT-006 LEFT-JUSTIFIED,
              95 sy-vline,<lwa_sales_order_items>-netwr UNDER TEXT-007 LEFT-JUSTIFIED,
              107 sy-vline,<lwa_sales_order_items>-waerk UNDER TEXT-008,
              118 sy-vline,<lwa_sales_order_items>-pstyv UNDER TEXT-009,
              133 sy-vline.

    WRITE sy-uline(133).
  ENDLOOP.