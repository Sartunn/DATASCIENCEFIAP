-- Comando SQL item a
SELECT 
    c.cd_categoria,
    c.ds_categoria,
    p.cd_produto,
    p.ds_produto,
    p.vl_unitario,
    p.tp_embalagem,
    p.vl_perc_lucro
FROM 
    mc_categoria_prod c
LEFT JOIN 
    mc_produto p ON c.cd_categoria = p.cd_categoria
ORDER BY 
    c.ds_categoria ASC,
    p.ds_produto ASC;
    
-- Comando SQL item b
SELECT 
    c.nr_cliente,
    c.nm_cliente,
    c.ds_email,
    c.nr_telefone,
    c.nm_login,
    cf.dt_nascimento,
    TO_CHAR(cf.dt_nascimento, 'D') AS dia_semana_nascimento,
    (TRUNC(MONTHS_BETWEEN(SYSDATE, cf.dt_nascimento)) / 12) AS anos_vida,
    cf.fl_sexo_biologico,
    cf.nr_cpf
FROM 
    mc_cliente c
INNER JOIN 
    mc_cli_fisica cf ON c.nr_cliente = cf.nr_cliente;
    
-- Comando SQL item c
SELECT 
    v.cd_produto,
    p.ds_produto,
    v.dt_visualizacao,
    v.nr_hora_visualizacao
FROM 
    mc_sgv_visualizacao_video v
INNER JOIN 
    mc_produto p ON v.cd_produto = p.cd_produto
ORDER BY 
    v.dt_visualizacao DESC,
    v.nr_hora_visualizacao DESC;



