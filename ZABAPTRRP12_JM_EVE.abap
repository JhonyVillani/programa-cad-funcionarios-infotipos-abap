*&---------------------------------------------------------------------*
*&  Include           ZABAPTRRP12_JM_EVE
*&---------------------------------------------------------------------*

DATA:
      go_cadastro TYPE REF TO lcl_cadastro. "Classe local

START-OF-SELECTION.
  CREATE OBJECT go_cadastro.

GET peras.

  go_cadastro->processamento( ).

END-OF-SELECTION.

  go_cadastro->exibicao( ).