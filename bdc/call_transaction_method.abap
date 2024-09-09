REPORT zbdc_prg1_mm01
       NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPES: BEGIN OF ty_material,
         matnr TYPE matnr, "Material
         mtart TYPE mtart, "Material TYPE
         mbrsh TYPE mbrsh, "Industry Sector
         meins TYPE meins, "Base Unit of Measure
         maktx TYPE maktx, "Material Description
       END OF ty_material.

DATA: gt_material TYPE TABLE OF ty_material,
      gt_bdcdata  TYPE TABLE OF bdcdata,
      gt_messages TYPE TABLE OF bdcmsgcoll.

PARAMETERS p_file TYPE localfile.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = p_file.

AT SELECTION-SCREEN.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename            = CONV string( p_file )
      has_field_separator = abap_true
    TABLES
      data_tab            = gt_material.

  DELETE gt_material INDEX 1."Removing Header Row

  LOOP AT gt_material ASSIGNING FIELD-SYMBOL(<lwa_material>).

    CLEAR gt_bdcdata.

    PERFORM bdc_dynpro USING 'SAPLMGMM'
                             '0060'.

    PERFORM bdc_field  USING 'BDC_CURSOR'
                             'RMMG1-MTART'.

    PERFORM bdc_field  USING 'BDC_OKCODE'
                             '=ENTR'.

    PERFORM bdc_field  USING 'RMMG1-MBRSH'
                             <lwa_material>-mbrsh.

    PERFORM bdc_field  USING 'RMMG1-MTART'
                             <lwa_material>-mtart.

    PERFORM bdc_dynpro USING 'SAPLMGMM'
                             '0070'.

    PERFORM bdc_field  USING 'BDC_CURSOR'
                             'MSICHTAUSW-DYTXT(01)'.

    PERFORM bdc_field  USING 'BDC_OKCODE'
                              '=ENTR'.

    PERFORM bdc_field  USING 'MSICHTAUSW-KZSEL(01)'
                             'X'.

    PERFORM bdc_dynpro USING 'SAPLMGMM'
                              '4004'.

    PERFORM bdc_field  USING 'BDC_OKCODE'
                              '=BU'.

    PERFORM bdc_field  USING 'MAKT-MAKTX'
                             <lwa_material>-maktx.

    PERFORM bdc_field  USING 'BDC_CURSOR'
                             'MARA-EXTWG'.

    PERFORM bdc_field USING 'MARA-MEINS'
                            <lwa_material>-meins.

    PERFORM bdc_field USING 'MARA-MTPOS_MARA'
                            'NORM'.

*Call Transaction
    CALL TRANSACTION 'MM01'
    USING gt_bdcdata
    MODE 'E'
    UPDATE 'S'
    MESSAGES INTO gt_messages.

  ENDLOOP.

*We can use MESSAGE_TEXT_BUILD to prepare message text*

FORM bdc_dynpro USING lv_program
                      lv_dynpro.

  DATA lwa_bdcdata TYPE bdcdata.

  lwa_bdcdata-program  = lv_program.
  lwa_bdcdata-dynpro   = lv_dynpro.
  lwa_bdcdata-dynbegin = 'X'.
  APPEND lwa_bdcdata TO gt_bdcdata.

ENDFORM.

FORM bdc_field USING lv_fnam
                     lv_fval.

  DATA lwa_bdcdata TYPE bdcdata.

  lwa_bdcdata-fnam = lv_fnam.
  lwa_bdcdata-fval = lv_fval.
  APPEND lwa_bdcdata TO gt_bdcdata.

ENDFORM.