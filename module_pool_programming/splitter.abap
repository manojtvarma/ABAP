
cl_dynpro_splitter
 constructor(splitter_name)
 set_sash
 get_guisash

Note:Unselect GLE from Screen Painter to Create Splitter Control
settings-->Screen Painter-->Graphical Layout Editor

steps:
1.create splitter control from screen layout specify 
	splitter_name and its subscreen areas
	splitter orientation and sash
	length and height

2.create spiltter object pass spiltter_name
3.call set_sash method in PBO
4.call get_guisash method in PAI

Code:
DATA ref_splitter TYPE REF TO cl_dynpro_splitter.

IF ref_splitter IS INITIAL.
    CREATE OBJECT ref_splitter
      EXPORTING
        splitter_name = 'SPL_NAME'.
ENDIF.

CALL METHOD ref_splitter->set_sash.
CALL METHOD ref_splitter->get_guisash.
