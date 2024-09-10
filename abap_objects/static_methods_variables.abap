REPORT zbc401_abap_objects.

TYPE-POOLS icon.

CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    METHODS: set_attributes IMPORTING iv_name      TYPE string
                                      iv_planetype TYPE saplane-planetype,
             display_attributes.

    CLASS-METHODS: display_n_o_airplanes,
                   get_n_o_airplanes RETURNING VALUE(rv_count) TYPE i.

  PRIVATE SECTION.
    CONSTANTS c_pos_1 TYPE i VALUE 30.

    DATA: mv_name      TYPE string,
          mv_planetype TYPE saplane-planetype.

    CLASS-DATA gv_n_o_airplanes TYPE i.

ENDCLASS.

CLASS lcl_airplane IMPLEMENTATION.

  METHOD set_attributes.
    mv_planetype = iv_planetype.
    mv_name = iv_name.
    gv_n_o_airplanes = gv_n_o_airplanes + 1.
  ENDMETHOD.

  METHOD display_attributes.
    WRITE: / icon_ws_plane AS ICON,
           / 'Name of Airplane:'(001), AT c_pos_1 mv_name,
           / 'Type of Airplane:'(002), AT c_pos_1 mv_planetype.
  ENDMETHOD.

  METHOD display_n_o_airplanes.
    WRITE: / 'Number of Airplanes:'(ca1), AT c_pos_1 gv_n_o_airplanes LEFT-JUSTIFIED.
  ENDMETHOD.

  METHOD get_n_o_airplanes.
    rv_count = gv_n_o_airplanes.
  ENDMETHOD.

ENDCLASS.

DATA: go_airplane  TYPE REF TO lcl_airplane,
      gt_airplanes TYPE TABLE OF REF TO lcl_airplane,
      gv_count     TYPE i.

START-OF-SELECTION.

  lcl_airplane=>display_n_o_airplanes( ).

  CREATE OBJECT go_airplane.
  APPEND go_airplane TO gt_airplanes.
  go_airplane->set_attributes( iv_name = 'LH Berlin'
                               iv_planetype = 'A321' ).

  CREATE OBJECT go_airplane.
  APPEND go_airplane TO gt_airplanes.
  go_airplane->set_attributes( iv_name = 'AA New York'
                               iv_planetype = '747-400' ).

  CREATE OBJECT go_airplane.
  APPEND go_airplane TO gt_airplanes.
  go_airplane->set_attributes( iv_name = 'US Hercules'
                               iv_planetype = '747-200F' ).

  SKIP.
  LOOP AT gt_airplanes INTO go_airplane.
    go_airplane->display_attributes( ).
  ENDLOOP.

  SKIP.
  gv_count = lcl_airplane=>get_n_o_airplanes( ).
  WRITE: / 'Number of Airplanes:'(ca1), gv_count.