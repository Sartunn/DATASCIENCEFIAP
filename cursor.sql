SET SERVEROUTPUT ON
DECLARE
  CURSOR cursor_sac IS
    SELECT 
      s.nr_sac,
      s.dt_abertura_sac,
      s.hr_abertura_sac,
      s.tp_sac,
      p.cd_produto,
      p.ds_produto,
      p.vl_unitario,
      p.vl_perc_lucro,
      c.nr_cliente,
      c.nm_cliente
    FROM
      mc_sgv_sac s
      JOIN mc_produto p ON s.cd_produto = p.cd_produto
      JOIN mc_cliente c ON s.nr_cliente = c.nr_cliente;

  v_ds_tipo_classificacao_saco varchar2(30);
  v_sg_estado char(2);
  v_nm_estado varchar2(30);
  vl_unitario_lucro_produto number;
  v_icms_perc NUMBER;
  v_valor_icms NUMBER;
BEGIN

  FOR linha IN cursor_sac LOOP

    v_ds_tipo_classificacao_saco := CASE
                                        WHEN linha.tp_sac = 'S' THEN 'SUGESTÃO'
                                        WHEN linha.tp_sac = 'D' THEN 'DÚVIDA'
                                        WHEN linha.tp_sac = 'E' THEN 'ELOGIO'
                                        ELSE 'CLASSIFICAÇÃO INVÁLIDA'
                                      END;

    -- lucro unitário
    vl_unitario_lucro_produto := (linha.vl_perc_lucro / 100) * linha.vl_unitario;

    -- dados do estado
    SELECT e.SG_ESTADO, e.NM_ESTADO into v_sg_estado, v_nm_estado
      FROM mc_end_cli ec
      INNER JOIN MC_LOGRADOURO lo ON lo.CD_LOGRADOURO = ec.CD_LOGRADOURO_CLI
      INNER JOIN MC_BAIRRO ba ON ba.CD_BAIRRO = lo.CD_BAIRRO
      INNER JOIN mc_cidade ci ON ci.cd_cidade = ba.cd_cidade
      INNER JOIN mc_estado e ON ci.sg_estado = e.sg_estado
    WHERE ec.nr_cliente = linha.NR_CLIENTE;

    -- ICMS
    SELECT fun_mc_gera_aliquota_media_icms_estado(v_sg_estado) INTO v_icms_perc FROM dual;
    v_valor_icms := (v_icms_perc / 100) * linha.vl_unitario;

    INSERT INTO mc_sgv_ocorrencia_sac
      (nr_ocorrencia_sac,
       dt_abertura_sac,
       hr_abertura_sac,
       DS_TIPO_CLASSIFICACAO_SAC,
       cd_produto,
       ds_produto,
       VL_UNITARIO_PRODUTO,
       VL_PERC_LUCRO,
       VL_UNITARIO_LUCRO_PRODUTO,
       sg_estado,
       nm_estado,
       nr_cliente,
       nm_cliente,
       vl_icms_produto)
    VALUES
      (linha.nr_sac, linha.dt_abertura_sac,
       linha.hr_abertura_sac, v_ds_tipo_classificacao_saco,
       linha.cd_produto, linha.ds_produto,
       linha.vl_unitario, linha.VL_PERC_LUCRO,
       vl_unitario_lucro_produto,
       v_sg_estado, v_nm_estado,
       linha.nr_cliente,
       linha.nm_cliente,
       v_valor_icms);

    COMMIT;
  END LOOP;
  
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('SEM DADOS PARA PROCESSAMENTO');
   WHEN DUP_VAL_ON_INDEX THEN
     DBMS_OUTPUT.PUT_LINE('REGISTRO JÁ EXISTENTE NA BASE DE DADOS');
    WHEN TOO_MANY_ROWS THEN
     DBMS_OUTPUT.PUT_LINE('MUITOS REGISTROS RETORNADOS QUANDO ERA ESPERADO UM ÚNICO REGISTRO');
      
END;
