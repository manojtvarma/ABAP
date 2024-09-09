*&---------------------------------------------------------------------*
*& Report ZCR_SALES_HEADER_DETAILS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcr_sales_order_items_details2.

DATA lv_vbeln TYPE vbak-vbeln.

SELECT-OPTIONS so_vbeln FOR lv_vbeln.

START-OF-SELECTION.
  SELECT vbeln,
         posnr,
         matnr,
         arktx,
         kwmeng,
         meins,
         netpr,
         netwr,
         waerk,
         pstyv
  FROM vbap
  WHERE vbeln IN @so_vbeln
  INTO TABLE @DATA(lt_sales_order_items).

  WRITE:    TEXT-000,
         14 TEXT-001,"Item
         20 TEXT-002,"Material
         28 TEXT-003,"Description
         61 TEXT-004,"Quantity
         71 TEXT-005, "Base Unit of Measure
         93 TEXT-006, "Net Price
         105 TEXT-007, "Net Value
         117 TEXT-008,"Currency
         129 TEXT-009."Item Category

  LOOP AT lt_sales_order_items ASSIGNING FIELD-SYMBOL(<lwa_sales_order_items>).

    WRITE:  / <lwa_sales_order_items>-vbeln UNDER TEXT-000,
            |{ <lwa_sales_order_items>-posnr  ALPHA = OUT }| UNDER TEXT-001, "Removing Zeros from ItemNumber before display
            |{ <lwa_sales_order_items>-matnr  ALPHA = OUT }| UNDER TEXT-002,
            <lwa_sales_order_items>-arktx UNDER TEXT-003,
            <lwa_sales_order_items>-kwmeng UNDER TEXT-004 LEFT-JUSTIFIED,
            <lwa_sales_order_items>-meins UNDER TEXT-005,
            <lwa_sales_order_items>-netpr UNDER TEXT-006 LEFT-JUSTIFIED,
            <lwa_sales_order_items>-netwr UNDER TEXT-007 LEFT-JUSTIFIED,
            <lwa_sales_order_items>-waerk UNDER TEXT-008,
            <lwa_sales_order_items>-pstyv UNDER TEXT-009.
  ENDLOOP.