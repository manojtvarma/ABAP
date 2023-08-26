REPORT zdemo_alv_ida_03.

PARAMETERS p_carrid TYPE sbook-carrid.

DATA gv_connid TYPE sbook-connid.
SELECT-OPTIONS so_conid FOR gv_connid.

*1. Get the ALV Object by passing DB Table Name or DDIC View(CREATE Method)
DATA(ref_alv_ida) = cl_salv_gui_table_ida=>create( iv_table_name = 'SBOOK' ).

*2. Using the above ALV Object, get reference of full screen Mode(FULLSCREEN Method)
IF ref_alv_ida IS BOUND.

*Create Object for Range Collector
  DATA(ref_range_collector) = NEW cl_salv_range_tab_collector( ).

*Add Range
  ref_range_collector->add_ranges_for_name(
    EXPORTING
      iv_name   = 'CONNID'
      it_ranges = so_conid[]
  ).
*collect range into select options
  ref_range_collector->get_collected_ranges(
    IMPORTING
      et_named_ranges = DATA(lt_select_options)
  ).

*get reference of condition factory interface
  DATA(ref_alv_ida_condn_factory) = ref_alv_ida->condition_factory( ).

*create the condition based on parameter field
  DATA(ref_alv_ida_condn) = ref_alv_ida_condn_factory->equals( name  = 'CARRID'
                                                               value = p_carrid ).

*set parameter condition
  ref_alv_ida->set_select_options( it_ranges    = lt_select_options
                                   io_condition = ref_alv_ida_condn ).

  DATA(ref_alv_ida_fullscreen) = ref_alv_ida->fullscreen( ).

ENDIF.

*3. Using the above full screen Mode object, display the content on UI(DISPLAY Method)
IF ref_alv_ida_fullscreen IS BOUND.
  ref_alv_ida_fullscreen->display( ).
ENDIF.
