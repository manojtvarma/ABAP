CLASS lcl_counter DEFINITION.
    PUBLIC SECTION.
      METHODS: constructor,
               count_get EXPORTING e_count TYPE i,
               count_increment.
    PRIVATE SECTION.
      DATA mv_count TYPE i.
  ENDCLASS.
  CLASS lcl_counter IMPLEMENTATION.
    METHOD constructor.
      mv_count = 10.
    ENDMETHOD.
  
    METHOD count_get.
      e_count = mv_count.
    ENDMETHOD.
  
    METHOD count_increment.
      mv_count = mv_count + 1.
    ENDMETHOD.
  ENDCLASS.
  
  START-OF-SELECTION.
    DATA: lv_counter   TYPE i,
          lref_counter TYPE REF TO lcl_counter.
  
  ****Creating Object
    CREATE OBJECT lref_counter.
  
  ****Calling Instance Methods
    CALL METHOD lref_counter->count_increment.
    CALL METHOD lref_counter->count_get
    IMPORTING
      e_count = lv_counter.
  
    WRITE lv_counter.
  
  