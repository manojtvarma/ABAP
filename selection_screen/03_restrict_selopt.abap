DATA:  ls_restrict   TYPE sscr_restrict,
ls_optlist    TYPE sscr_opt_list,
ls_sel_screen TYPE sscr_ass.

ls_optlist-name = 'OBJECTKEY1'.
ls_optlist-options-eq = 'X'.
APPEND ls_optlist TO ls_restrict-opt_list_tab.

ls_sel_screen-kind = 'S'.
ls_sel_screen-name = 'SO_SGNUM'.
ls_sel_screen-sg_main = 'I'.
ls_sel_screen-sg_addy = space.
ls_sel_screen-op_main = 'OBJECTKEY1'.
APPEND ls_sel_screen TO ls_restrict-ass_tab.

CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
EXPORTING
restriction            = ls_restrict
EXCEPTIONS
too_late               = 1
repeated               = 2
selopt_without_options = 3
selopt_without_signs   = 4
invalid_sign           = 5
empty_option_list      = 6
invalid_kind           = 7
repeated_kind_a        = 8
OTHERS                 = 9.
