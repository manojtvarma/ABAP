REPORT zbdc_prg2_mm01
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

  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
      group               = 'MM01_GRP' "Session Name
*     holddate            = filler8    "Session locked until specified date
      keep                = abap_true  "Indicator to keep processed sessions
      user                = sy-uname
    EXCEPTIONS
      client_invalid      = 1
      destination_invalid = 2
      group_invalid       = 3
      group_is_locked     = 4
      holddate_invalid    = 5
      internal_error      = 6
      queue_error         = 7
      running             = 8
      system_lock_error   = 9
      user_invalid        = 10
      OTHERS              = 11.

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

    CALL FUNCTION 'BDC_INSERT'
      EXPORTING
        tcode            = 'MM01'
      TABLES
        dynprotab        = gt_bdcdata
      EXCEPTIONS
        internal_error   = 1
        not_open         = 2
        queue_error      = 3
        tcode_invalid    = 4
        printing_invalid = 5
        posting_invalid  = 6
        OTHERS           = 7.

  ENDLOOP.

  CALL FUNCTION 'BDC_CLOSE_GROUP'
    EXCEPTIONS
      not_open    = 1
      queue_error = 2
      OTHERS      = 3.

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