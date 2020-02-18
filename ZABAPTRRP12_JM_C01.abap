*&---------------------------------------------------------------------*
*&  Include           ZABAPTRRP12_JM_C01
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       CLASS lcl_cadastro DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_cadastro DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_s_saida,
        pernr     TYPE p0001-pernr,
        bukrs     TYPE p0001-bukrs,
        persg     TYPE t501t-ptext,
        persk     TYPE t503t-ptext,
        cname     TYPE zabaptrde10_jm,
        gbdat     TYPE p0002-gbdat,
        idade     TYPE zabaptrde21_jm,
        idade18   TYPE zabaptrde22_jm,
        gesch     TYPE zabaptrde19_jm,
        famst     TYPE zabaptrde20_jm,
        natio     TYPE p0002-natio,
        cpf_nr    TYPE p0465-cpf_nr,
        ident_nr  TYPE p0465-ident_nr,
        filhos    TYPE zabaptrde23_jm,
      END OF ty_s_saida.

*   TYPES para obter campo de RH
    TYPES: BEGIN OF ty_s_saida_persg,
            persg TYPE t501t-persg,
            ptext TYPE t501t-ptext,
           END OF ty_s_saida_persg.

*   TYPES para obter campo de Cargo
    TYPES: BEGIN OF ty_s_saida_persk,
            persk TYPE t503t-persk,
            ptext TYPE t503t-ptext,
           END OF ty_s_saida_persk.

*   TYPES para obter campo de Estado Civil
    TYPES: BEGIN OF ty_s_saida_estcivil,
            famst TYPE t502t-famst,
            ftext TYPE t502t-ftext,
           END OF ty_s_saida_estcivil.

*   Estruturas para obter campo de RH
    DATA: gt_t001 TYPE TABLE OF ty_s_saida_persg.
    DATA: gs_t001 TYPE ty_s_saida_persg.

*   Estruturas para obter campo de Cargo
    DATA: gt_t002 TYPE TABLE OF ty_s_saida_persk.
    DATA: gs_t002 TYPE ty_s_saida_persk.

*   Estruturas para obter campo de Estado Civil
    DATA: gt_t003 TYPE TABLE OF ty_s_saida_estcivil.
    DATA: gs_t003 TYPE ty_s_saida_estcivil.

*   Estrutura final de saída para o ALV
    DATA: mt_dados TYPE TABLE OF ty_s_saida.

*   Variável necessária para criação do ALV
    DATA: mo_alv TYPE REF TO cl_salv_table.

    METHODS:
      constructor,
      processamento,
      exibicao.

ENDCLASS.                    "lcl_cadastro DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_cadastro IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_cadastro IMPLEMENTATION.

  METHOD constructor.

*   Popula uma tabela com o código de rh e descrição
    SELECT persg
           ptext
     FROM t501t

     INTO TABLE gt_t001
      WHERE sprsl EQ sy-langu.

*   Popula uma tabela com o código de cargo e descrição
    SELECT persk
           ptext
     FROM t503t

     INTO TABLE gt_t002
      WHERE sprsl EQ sy-langu.

*   Popula uma tabela com o código de Estado Civil e descrição
    SELECT famst
           ftext
     FROM t502t

     INTO TABLE gt_t003
      WHERE sprsl EQ sy-langu.

  ENDMETHOD.                    "constructor

  METHOD processamento.

*   Macro para banco de dados lógico
*   Limpa a tabela antes de realizar a macro do banco de dados lógico
    CLEAR p0001.
    rp_provide_from_last p0001 space pn-begda pn-endda.

*   Limpa a tabela antes de realizar a macro do banco de dados lógico
    CLEAR p0002.
    rp_provide_from_last p0002 space pn-begda pn-endda.

*   Limpa a tabela antes de realizar a macro do banco de dados lógico
    CLEAR p0465.
    rp_provide_from_last p0465 space pn-begda pn-endda.

    DATA: ls_saida TYPE ty_s_saida.

*   Lê o primeiro registro/linha da tabela populada por código de rh + descrição e envia para uma work-area
    READ TABLE gt_t001 INTO gs_t001 WITH KEY persg = p0001-persg.

*   Lê o primeiro registro/linha da tabela populada por código de cargo + descrição e envia para uma work-area
    READ TABLE gt_t002 INTO gs_t002 WITH KEY persk = p0001-persk.

*   Lê o primeiro registro/linha da tabela populada por código de Estado + descrição e envia para uma work-area
    READ TABLE gt_t003 INTO gs_t003 WITH KEY famst = p0002-famst.
    CLEAR ls_saida.

*   Variável deve receber o valor a ser validado
    gv_trim = p0002-gesch.

    ls_saida-pernr    = p0001-pernr   .
    ls_saida-bukrs    = p0001-bukrs   .
    CONCATENATE p0001-persg '-' gs_t001-ptext INTO ls_saida-persg SEPARATED BY space.
    CONCATENATE p0001-persk '-' gs_t002-ptext INTO ls_saida-persk SEPARATED BY space.
    ls_saida-cname    = p0002-cname   .
    ls_saida-gbdat    = p0002-gbdat   .

*   Realiza o cálculo da idade
    CALL FUNCTION 'ZABAPTRF01_JM'
      EXPORTING
        iv_data_nasc = p0002-gbdat "Data de nascimento
      IMPORTING
        ev_idade     = ls_saida-idade. "Variável de saída

    IF ls_saida-idade >= 18.
      ls_saida-idade18  =  'Sim'.
    ENDIF.

*   Valida valores definidos no domínio
    CALL FUNCTION 'DOMAIN_VALUE_GET'
      EXPORTING
        i_domname  = 'GESCH' "Domínio de dados
        i_domvalue = gv_trim "Variável com o valor
      IMPORTING
        e_ddtext   = gv_texto "Saída processada
      EXCEPTIONS
        not_exist  = 1
        OTHERS     = 2.
    ls_saida-gesch    = gv_texto      .
    ls_saida-famst    = gs_t003-ftext .
    ls_saida-natio    = p0002-natio   .
    ls_saida-cpf_nr   = p0465-cpf_nr  .

    CLEAR p0465.
    rp_provide_from_last p0465 '0002' pn-begda pn-endda. "Infotipo de documentos

    IF p0465-ident_nr IS NOT INITIAL.
      CONCATENATE p0465-ident_nr(2) '.' p0465-ident_nr+2(3) '.' p0465-ident_nr+5(3) '-' p0465-ident_nr+8(1) INTO ls_saida-ident_nr.
    ENDIF.

*   Limpa a tabela antes de realizar a macro do banco de dados lógico
    CLEAR p0021.
    rp_provide_from_last p0021 '2' pn-begda pn-endda. "Infotipo de dependentes

    IF p0021 IS INITIAL.
      ls_saida-filhos = 'não'.
    ELSE.
      ls_saida-filhos = 'sim'.
    ENDIF.

    APPEND ls_saida TO mt_dados. "Grava os dados em uma tabela final e limpa as variáveis na sequência

  ENDMETHOD.                    "processamento

  METHOD exibicao.

*   Criando o relatório ALV, declarando na classe a variáveis mo_alv referenciando cl_salv_table
*   Chama o método que constrói a saída ALV
    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = mo_alv
      CHANGING
        t_table      = mt_dados.

*   Mostra o ALV
    mo_alv->display( ). "Imprime na tela do relatório ALV
  ENDMETHOD.                    "exibicao

ENDCLASS.                    "lcl_cadastro IMPLEMENTATION