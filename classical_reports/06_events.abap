REPORT zcr_events LINE-COUNT 10(2).

DATA: lv_vbeln TYPE vbak-vbeln,
      lv_audat TYPE vbak-audat.

PARAMETERS p_auart TYPE vbak-auart DEFAULT 'ZKOR'."Document Type

SELECT-OPTIONS: so_vbeln FOR lv_vbeln,"Order Number
                so_audat FOR lv_audat."Document Date

INITIALIZATION.
****When we have to propose calculated default value then we use initialization event
****otherwise provide value at the time of declaration
  so_audat-sign = 'I'.
  so_audat-option = 'BT'.
  so_audat-low = '20200101'. "YYYYMMDD
  so_audat-high = sy-datum.
  APPEND so_audat.

AT SELECTION-SCREEN."It gets triggered on every actions and it used to validate the input
  IF p_auart IS INITIAL.
****Select document type
    MESSAGE e000(zmsg_01).
  ELSE.
    SELECT SINGLE auart
    FROM tvak
    WHERE auart EQ @p_auart
    INTO @DATA(lv_auart).

    IF lv_auart IS INITIAL.
****Document Type &1 is invalid; enter valid document type
      MESSAGE e001(zmsg_01) WITH p_auart.
    ENDIF.
  ENDIF.

*AT SELECTION-SCREEN OUTPUT.
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR {field}.
*AT SELECTION-SCREEN ON HELP-REQUEST FOR {}.
*AT SELECTION-SCREEN ON {Field}.

TOP-OF-PAGE.
  WRITE:   TEXT-000,
           14 TEXT-001,  "Item
           20 TEXT-002,  "Material
           28 TEXT-003,  "Description
           61 TEXT-004,  "Quantity
           71 TEXT-005,  "Base Unit of Measure
           93 TEXT-006,  "Net Price
           105 TEXT-007, "Net Value
           117 TEXT-008, "Currency
           129 TEXT-009. "Item Category

END-OF-PAGE.
  WRITE TEXT-010."End of Page

START-OF-SELECTION."Gets Trigger when we click on Execute
  SELECT vbeln
  FROM vbak
  WHERE vbeln IN @so_vbeln
    AND audat IN @so_audat
    AND auart EQ @p_auart
  INTO TABLE @DATA(lt_sales_order).

  IF NOT lt_sales_order IS INITIAL.
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
     FOR ALL ENTRIES IN @lt_sales_order
     WHERE vbeln EQ @lt_sales_order-vbeln
    INTO TABLE @DATA(lt_sales_order_items).

    CHECK NOT lt_sales_order_items IS INITIAL.
  ENDIF.

  LOOP AT lt_sales_order_items ASSIGNING FIELD-SYMBOL(<lwa_sales_order_items>).

    WRITE:  / <lwa_sales_order_items>-vbeln UNDER TEXT-000,
              |{ <lwa_sales_order_items>-posnr  ALPHA = OUT }| UNDER TEXT-001,
              |{ <lwa_sales_order_items>-matnr  ALPHA = OUT }| UNDER TEXT-002,
              <lwa_sales_order_items>-arktx UNDER TEXT-003,
              <lwa_sales_order_items>-kwmeng UNDER TEXT-004 LEFT-JUSTIFIED,
              <lwa_sales_order_items>-meins UNDER TEXT-005,
              <lwa_sales_order_items>-netpr UNDER TEXT-006 LEFT-JUSTIFIED,
              <lwa_sales_order_items>-netwr UNDER TEXT-007 LEFT-JUSTIFIED,
              <lwa_sales_order_items>-waerk UNDER TEXT-008,
              <lwa_sales_order_items>-pstyv UNDER TEXT-009.
  ENDLOOP.

END-OF-SELECTION.
  WRITE TEXT-011."End of Selection