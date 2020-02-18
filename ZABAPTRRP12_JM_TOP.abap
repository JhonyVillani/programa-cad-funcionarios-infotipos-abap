*&---------------------------------------------------------------------*
*&  Include           ZABAPTRRP12_JM_TOP
*&---------------------------------------------------------------------*

NODES: peras.

TABLES: pa0001,
        pernr.

INFOTYPES: 0001,
           0002,
           0465,
           0006,
           0021.

DATA: gv_texto LIKE dd07v-ddtext, "Tipo do campo na função domain_value_get
      gv_trim  LIKE dd07v-domvalue_l.