REPORT zcr_sales_order_items_details3.

DATA lv_vbeln TYPE vbak-vbeln.

SELECT-OPTIONS so_vbeln FOR lv_vbeln.

START-OF-SELECTION.
  SELECT a~vbeln,
         a~auart,
         a~kunnr,
         a~audat,
         a~netwr,
         a~waerk,
         b~posnr,
         b~matnr,
         b~arktx,
         b~kwmeng,
         b~meins
  FROM vbak AS a
  INNER JOIN vbap AS b
  ON a~vbeln = b~vbeln
  WHERE a~vbeln IN @so_vbeln
  INTO TABLE @DATA(lt_sales_order).

  WRITE:    TEXT-000,"Order
           14 TEXT-001,"Order Type
           26 TEXT-002,"Sold to Party
           41 TEXT-003,"Document Date
           56 TEXT-004,"Net Value
           67 TEXT-005,"Currency
           77 TEXT-006,"Item
           83 TEXT-007,"Material
           93 TEXT-008,"Description
           125 TEXT-009,"Quantity
           135 TEXT-010. "Unit

  LOOP AT lt_sales_order ASSIGNING FIELD-SYMBOL(<lwa_sales_order>).

    WRITE:  / <lwa_sales_order>-vbeln UNDER TEXT-000,
              <lwa_sales_order>-auart UNDER TEXT-001,
              <lwa_sales_order>-kunnr UNDER TEXT-002,
              <lwa_sales_order>-audat UNDER TEXT-003,
              <lwa_sales_order>-netwr UNDER TEXT-004 LEFT-JUSTIFIED,
              <lwa_sales_order>-waerk UNDER TEXT-005,
              |{ <lwa_sales_order>-posnr  ALPHA = OUT }| UNDER TEXT-006, "Removing Zeros from ItemNumber befor display
              | { <lwa_sales_order>-matnr ALPHA = OUT } | UNDER TEXT-007,
              <lwa_sales_order>-arktx UNDER TEXT-008,
              <lwa_sales_order>-kwmeng UNDER TEXT-009 LEFT-JUSTIFIED,
              <lwa_sales_order>-meins UNDER TEXT-010.

  ENDLOOP.