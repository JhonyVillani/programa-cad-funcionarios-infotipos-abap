FUNCTION zabaptrf01_jm.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_DATA_NASC) TYPE  P0002-GBDAT
*"  EXPORTING
*"     REFERENCE(EV_IDADE) TYPE  I
*"----------------------------------------------------------------------

ev_idade(4) = sy-datum(4) - iv_data_nasc(4).
    IF iv_data_nasc+4(2) < sy-datum+4(2).

        ev_idade = ev_idade - 1 .

      elseif iv_data_nasc+4(2) = sy-datum+4(2).

        IF iv_data_nasc+6(2) > sy-datum+6(2).

          ev_idade = ev_idade - 1 .

        ENDIF.

    ENDIF.

ENDFUNCTION.