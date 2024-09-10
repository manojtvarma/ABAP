REPORT zdemo_screen_01.

*Selection screens serve as an interface between the program and the user, and allow the amount of data to be read from the database to be limited
*You can use the declarative statements PARAMETERS and SELECT-OPTIONS to generate a standard selection screen (screen 1000) with input fields
*In addition to the standard selection screen,
*you can also use SELECTION-SCREEN BEGIN OF SCREEN to create an additional selection screen and use CALL SELECTION-SCREEN statement to call it

*You can create variants to save selection screen values that you use frequently

***Declaration of Selection Screen Fields Using the PARAMETERS Statement

*The PARAMETERS statement is a declarative language element.
*As in the case of the DATA statement, you can declare parameters with the TYPE or LIKE additions, and the system will then generate input fields on the selection screen.
*You can maintain selection texts by choosing Goto -> Text Elements -> Selection Texts

*The names of PARAMETERS can have a maximum of eight characters

DATA gs_flight TYPE sflight.

*Selections for connections
SELECT-OPTIONS: so_carid FOR gs_flight-carrid,
                so_conid FOR gs_flight-connid.

*Selections for flights
SELECT-OPTIONS so_fldat FOR gs_flight-fldate.

*Output parameter
SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME.
  PARAMETERS: p_all RADIOBUTTON GROUP rbg1,
              p_nat RADIOBUTTON GROUP rbg1 DEFAULT 'X',
              p_int RADIOBUTTON GROUP rbg1.
SELECTION-SCREEN END OF BLOCK b0.

START-OF-SELECTION.
  SELECT * FROM sflight INTO @gs_flight
    WHERE carrid IN @so_carid
    AND connid IN @so_conid
    AND fldate IN @so_fldat.

    WRITE: / gs_flight-carrid,
             gs_flight-connid,
             gs_flight-fldate,
             gs_flight-seatsmax,
             gs_flight-seatsocc.
  ENDSELECT.