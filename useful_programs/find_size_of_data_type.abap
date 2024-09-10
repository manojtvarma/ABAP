DATA: lv_data        TYPE i,
      ref_type_descr TYPE REF TO cl_abap_typedescr.

START-OF-SELECTION.
  CALL METHOD cl_abap_typedescr=>describe_by_data
    EXPORTING
      p_data      = lv_data
    RECEIVING
      p_descr_ref = ref_type_descr.

  WRITE: / 'Type:', ref_type_descr->type_kind.
  WRITE: / 'Size:', ref_type_descr->length.


***Note:Type Meanning

**Type   Description
**u 	Flat structure
**v 	Deep structure
**h 	Internal table