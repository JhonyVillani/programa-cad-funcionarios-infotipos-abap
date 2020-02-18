FUNCTION zabaptrf01_jm.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_DATANASC) TYPE  DATUM
*"  EXPORTING
*"     REFERENCE(EV_IDADE) TYPE  ZABAPTRDE19_MC
*"----------------------------------------------------------------------

  DATA:   lv_diaatual  TYPE char2,
          lv_dianasc   TYPE char2,
          lv_mesatual  TYPE char2,
          lv_mesnasc   TYPE char2,
          lv_anoatual  TYPE i,
          lv_anonasc   TYPE i.

  lv_anoatual = sy-datum(4).                                "20200201
  lv_anonasc  = iv_data_nasc(4).                            "19950814

  lv_mesatual = sy-datum+4(2). "02
  lv_mesnasc  = iv_data_nasc+4(2). "08

  lv_diaatual = sy-datum+6(2). "01
  lv_dianasc  = iv_data_nasc+6(2). "14

  ev_idade = lv_anoatual - lv_anonasc.

  IF lv_mesatual EQ lv_mesnasc.

    IF lv_diaatual < lv_dianasc.

      ev_idade = ev_idade - 1.

    ENDIF.

  ELSE.

    IF lv_mesatual < lv_mesnasc.

      ev_idade = ev_idade - 1.

    ENDIF.

  ENDIF.

ENDFUNCTION.