-- Gerado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   em:        2024-03-17 16:23:05 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

--removendo tabelas do banco de dados
DROP TABLE sgv_preco_produtos;
DROP TABLE sgv_item_pedido;
DROP TABLE sgv_estoque;
DROP TABLE sgv_pedido;

DROP TABLE sgv_aval_video;
DROP TABLE sgv_ponto_avaliacao;
DROP TABLE sgv_video_visu;
DROP TABLE sgv_video_prod;

DROP TABLE sgv_pessoa_pj;
DROP TABLE sgv_pes_fisi;
DROP TABLE sgv_sac;

DROP TABLE sgv_produtos;
DROP TABLE sgv_clientes;

DROP TABLE sgv_cd_categ_prod;
DROP TABLE sgv_funcionarios;




CREATE TABLE sgv_aval_video (
    id_avaliacao   NUMBER(15) NOT NULL,
    avaliacao      NUMBER(5) NOT NULL,
    data_avaliacao DATE NOT NULL,
    cd_cliente     NUMBER(10) NOT NULL,
    id_video       NUMBER(15) NOT NULL
);

ALTER TABLE sgv_aval_video ADD constraint ck_sgv_aval_video_1 
    CHECK (avaliacao BETWEEN 1 AND 5)
;
ALTER TABLE sgv_aval_video ADD CONSTRAINT pk_sgv_aval_video PRIMARY KEY ( id_avaliacao );

CREATE TABLE sgv_cd_categ_prod (
    cd_categ   NUMBER(15) NOT NULL,
    desc_categ VARCHAR2(100) NOT NULL,
    status     CHAR(1) NOT NULL,
    dt_inicio  DATE NOT NULL,
    dt_termino DATE
);

COMMENT ON COLUMN sgv_cd_categ_prod.status IS
    'Aqui a o status deve ser representado por A ou I';

ALTER TABLE sgv_cd_categ_prod ADD CONSTRAINT pk_sgv_cod_categ_prod PRIMARY KEY ( cd_categ );

ALTER TABLE sgv_cd_categ_prod ADD CONSTRAINT un_sgv_cd_categ_prod UNIQUE ( desc_categ );

CREATE TABLE sgv_clientes (
    cd_cliente  NUMBER(10) NOT NULL,
    cl_nome     VARCHAR2(50 BYTE) NOT NULL,
    cl_email    VARCHAR2(50 BYTE) NOT NULL,
    cl_telefone NUMBER(9),
    cl_endereco VARCHAR2(50) NOT NULL,
    tx_login    VARCHAR2(60) NOT NULL,
    tx_senha    VARCHAR2(20) NOT NULL,
    st_status   CHAR(1) NOT NULL,
    qt_estrelas NUMBER(2)
);

ALTER TABLE sgv_clientes
    ADD CONSTRAINT sgv_clientes_ck_1 CHECK ( st_status IN ( 'A', 'I' ) );

ALTER TABLE sgv_clientes ADD CONSTRAINT pk_sgv_clientes PRIMARY KEY ( cd_cliente );

ALTER TABLE sgv_clientes ADD CONSTRAINT un_sgv_clientes UNIQUE ( tx_login,
                                                                 cl_email );

CREATE TABLE sgv_estoque (
    id_estoque_item  NUMBER(10) NOT NULL,
    cd_produto       NUMBER(15) NOT NULL,
    quant_disponivel NUMBER(5) NOT NULL
);

COMMENT ON COLUMN sgv_estoque.id_estoque_item IS
    'identificador único do item no estoque';

ALTER TABLE sgv_estoque ADD CONSTRAINT sgv_estoque_pk PRIMARY KEY ( id_estoque_item );

CREATE TABLE sgv_funcionarios (
    cd_funcionario  NUMBER(10) NOT NULL,
    cpf_func        VARCHAR2(15 CHAR) NOT NULL,
    nm_departamento VARCHAR2(50) NOT NULL,
    fc_nome         VARCHAR2(50) NOT NULL,
    dt_nasc         VARCHAR2(20 CHAR) NOT NULL,
    num_telefone    VARCHAR2(20 CHAR) NOT NULL,
    email_func      VARCHAR2(50 CHAR) NOT NULL,
    cargo           VARCHAR2(20 CHAR) NOT NULL,
    nm_depto        VARCHAR2(20 CHAR) NOT NULL
);

ALTER TABLE sgv_funcionarios ADD CONSTRAINT pk_sgv_funcionarios PRIMARY KEY ( cd_funcionario );

ALTER TABLE sgv_funcionarios ADD CONSTRAINT un_sgv_depto_cd UNIQUE ( nm_departamento );

ALTER TABLE sgv_funcionarios ADD CONSTRAINT sgv_funcionarios__un UNIQUE ( cpf_func );

CREATE TABLE sgv_item_pedido (
    cd_produto     NUMBER(15) NOT NULL,
    preco_unit     NUMBER NOT NULL,
    id_item_pedido NUMBER(10) NOT NULL,
    nm_pedido      VARCHAR2(50) NOT NULL,
    qt_quantidade  NUMBER(3) NOT NULL
);

ALTER TABLE sgv_item_pedido ADD CONSTRAINT sgv_item_pedido_pk PRIMARY KEY ( id_item_pedido );

CREATE TABLE sgv_pedido (
    nm_pedido     VARCHAR2(50) NOT NULL,
    cd_cliente    NUMBER(10) NOT NULL,
    dt_pedido     DATE NOT NULL,
    status_pedido CHAR(14) NOT NULL,
    quantidade    NUMBER(3) NOT NULL
);

ALTER TABLE sgv_pedido ADD CONSTRAINT sgv_pedido_pk PRIMARY KEY ( nm_pedido );

CREATE TABLE sgv_pes_fisi (
    cd_cliente        NUMBER(10) NOT NULL,
    cd_cpf            VARCHAR2(11) NOT NULL,
    in_genero         VARCHAR2(15 BYTE),
    dt_nascimento     DATE NOT NULL,
    in_sexo_biologico VARCHAR2(1 BYTE) NOT NULL,
    cl_status         CHAR(14) NOT NULL,
    cl_login          VARCHAR2(50 BYTE) NOT NULL,
    cl_senha          VARCHAR2(70 BYTE) NOT NULL,
    qnt_estrelas      NUMBER(2)
);

ALTER TABLE sgv_pes_fisi ADD CONSTRAINT pk_sgv_pessoa_fisica PRIMARY KEY ( cd_cliente );

ALTER TABLE sgv_pes_fisi ADD CONSTRAINT un_sgv_pes_fisi UNIQUE ( cd_cpf );

CREATE TABLE sgv_pessoa_pj (
    cd_cliente   NUMBER(10) NOT NULL,
    nr_cnjp      NUMBER(14),
    tx_atividade VARCHAR2(50 BYTE),
    dt_fundacao  DATE,
    nr_ie        NUMBER(20)
);

ALTER TABLE sgv_pessoa_pj ADD CONSTRAINT pk_sgv_pessoa_pj PRIMARY KEY ( cd_cliente );

CREATE TABLE sgv_ponto_avaliacao (
    cd_cliente      NUMBER(10) NOT NULL,
    id_visualizacao NUMBER(15) NOT NULL,
    qtd_avaliacoes  NUMBER(3) NOT NULL,
    pts_moeda_real  NUMBER(3) NOT NULL
);

ALTER TABLE sgv_ponto_avaliacao ADD CONSTRAINT sgv_ponto_avaliacao_pk PRIMARY KEY ( cd_cliente );

CREATE TABLE sgv_preco_produtos (
    id_preco_produto   NUMBER(10) NOT NULL,
    cd_produto         NUMBER(15) NOT NULL,
    vl_preco_unitario  NUMBER(10, 2) NOT NULL,
    dt_validade_inicio DATE NOT NULL,
    dt_validade_fim    DATE,
    cd_produto1        NUMBER NOT NULL
);

COMMENT ON COLUMN sgv_preco_produtos.dt_validade_inicio IS
    'data inicial de validade do preço para o produto';

COMMENT ON COLUMN sgv_preco_produtos.dt_validade_fim IS
    'data final de validade do preço para o produto';

ALTER TABLE sgv_preco_produtos ADD CONSTRAINT sgv_preco_produtos_pk PRIMARY KEY ( id_preco_produto );

CREATE TABLE sgv_produtos (
    cd_produto         NUMBER(15) NOT NULL,
    desc_produto       VARCHAR2(50) NOT NULL,
    desc_completa_prod VARCHAR2(150) NOT NULL,
    cd_barra           NUMBER(12),
    vl_preco_unitario  NUMBER(10, 2) NOT NULL,
    status_prod        CHAR(1 CHAR) NOT NULL,
    cd_categ           NUMBER(15) NOT NULL
);

COMMENT ON COLUMN sgv_produtos.status_prod IS
    'Aqui o valor devera ser A ou I';

CREATE UNIQUE INDEX sgv_produtos__idx ON
    sgv_produtos (
        desc_produto
    ASC );

ALTER TABLE sgv_produtos
    ADD CONSTRAINT sgv_produtos_ck_1 CHECK ( status_prod IN ( 'A', 'I' ) );

ALTER TABLE sgv_produtos ADD CONSTRAINT pk_sgv_produtos PRIMARY KEY ( cd_produto );

ALTER TABLE sgv_produtos ADD CONSTRAINT un_sgv_produtos UNIQUE ( desc_completa_prod );

CREATE TABLE sgv_sac (
    cd_chamado            NUMBER(10) NOT NULL,
    cd_cliente            NUMBER(10) NOT NULL,
    cd_funcionario        NUMBER(10) NOT NULL,
    cd_produto            NUMBER(15) NOT NULL,
    desc_chamado          VARCHAR2(4000 BYTE) NOT NULL,
    data_hora_abertura    DATE NOT NULL,
    dur_chamado           DATE,
    desc_resposta_func    VARCHAR2(100) NOT NULL,
    ind_tipo_chamado      VARCHAR2(15 BYTE) NOT NULL,
    status_chamado        CHAR(1 CHAR) NOT NULL,
    ind_satisfacao        NUMBER(2),
    data_hora_atendimento DATE,
    cod_categ             NUMBER NOT NULL,
    cd_categ              NUMBER(15) NOT NULL
);

ALTER TABLE sgv_sac
    ADD CONSTRAINT sgv_sac_ck_1 CHECK ( ind_tipo_chamado IN ( 'Sugestão', 'Reclamação' ) );

ALTER TABLE sgv_sac
    ADD CONSTRAINT sgv_sac_ck_2 CHECK ( ind_satisfacao BETWEEN 1 AND 10
                                        OR ind_satisfacao IS NULL );

ALTER TABLE sgv_sac
    ADD CONSTRAINT sgv_sac_ck_3 CHECK ( status_chamado IN ( 'A', 'E', 'C', 'F', 'X' ) );

ALTER TABLE sgv_sac ADD CONSTRAINT pk_sgv_sac PRIMARY KEY ( cd_chamado );

CREATE TABLE sgv_video_prod (
    id_video    NUMBER(15) NOT NULL,
    cd_produto  NUMBER(15) NOT NULL,
    dt_cadastro DATE NOT NULL,
    vd_status   CHAR(1) NOT NULL,
    cd_categ    NUMBER(15) NOT NULL
);

COMMENT ON COLUMN sgv_video_prod.vd_status IS
    'Aqui o v alor deve ser A ou I';

ALTER TABLE sgv_video_prod ADD CONSTRAINT pk_sgv_video_prod PRIMARY KEY ( id_video );

CREATE TABLE sgv_video_visu (
    dt_hora_data_acesso DATE NOT NULL,
    id_visualizacao     NUMBER(15) NOT NULL,
    id_video            NUMBER(15) NOT NULL,
    cd_cliente          NUMBER(10) NOT NULL
);

CREATE UNIQUE INDEX sgv_video_visu__idx ON
    sgv_video_visu (
        cd_cliente
    ASC );

ALTER TABLE sgv_video_visu ADD CONSTRAINT pk_sgv_video_visu PRIMARY KEY ( id_visualizacao );

ALTER TABLE sgv_aval_video
    ADD CONSTRAINT fk_aval_video_clientes FOREIGN KEY ( cd_cliente )
        REFERENCES sgv_clientes ( cd_cliente );

ALTER TABLE sgv_aval_video
    ADD CONSTRAINT fk_aval_video_video_prod FOREIGN KEY ( id_video )
        REFERENCES sgv_video_prod ( id_video );

ALTER TABLE sgv_item_pedido
    ADD CONSTRAINT fk_item_pedido_pedido FOREIGN KEY ( nm_pedido )
        REFERENCES sgv_pedido ( nm_pedido );

ALTER TABLE sgv_item_pedido
    ADD CONSTRAINT fk_item_pedido_produtos FOREIGN KEY ( cd_produto )
        REFERENCES sgv_produtos ( cd_produto );

ALTER TABLE sgv_pedido
    ADD CONSTRAINT fk_pedido_clientes FOREIGN KEY ( cd_cliente )
        REFERENCES sgv_clientes ( cd_cliente );

ALTER TABLE sgv_pes_fisi
    ADD CONSTRAINT fk_pes_fisi_clientes FOREIGN KEY ( cd_cliente )
        REFERENCES sgv_clientes ( cd_cliente );

ALTER TABLE sgv_pessoa_pj
    ADD CONSTRAINT fk_pessoa_pj_clientes FOREIGN KEY ( cd_cliente )
        REFERENCES sgv_clientes ( cd_cliente );

ALTER TABLE sgv_ponto_avaliacao
    ADD CONSTRAINT fk_ponto_avaliacao_clientes FOREIGN KEY ( cd_cliente )
        REFERENCES sgv_clientes ( cd_cliente );

ALTER TABLE sgv_ponto_avaliacao
    ADD CONSTRAINT fk_ponto_avaliacao_video_visu FOREIGN KEY ( id_visualizacao )
        REFERENCES sgv_video_visu ( id_visualizacao );

ALTER TABLE sgv_preco_produtos
    ADD CONSTRAINT fk_preco_produtos_produtos FOREIGN KEY ( cd_produto )
        REFERENCES sgv_produtos ( cd_produto );

ALTER TABLE sgv_produtos
    ADD CONSTRAINT fk_produtos_cd_categ_prod FOREIGN KEY ( cd_categ )
        REFERENCES sgv_cd_categ_prod ( cd_categ );

ALTER TABLE sgv_sac
    ADD CONSTRAINT fk_sac_clientes FOREIGN KEY ( cd_cliente )
        REFERENCES sgv_clientes ( cd_cliente );

ALTER TABLE sgv_sac
    ADD CONSTRAINT fk_sac_funcionarios FOREIGN KEY ( cd_funcionario )
        REFERENCES sgv_funcionarios ( cd_funcionario );

ALTER TABLE sgv_sac
    ADD CONSTRAINT fk_sac_produtos FOREIGN KEY ( cd_produto )
        REFERENCES sgv_produtos ( cd_produto );

ALTER TABLE sgv_video_prod
    ADD CONSTRAINT fk_video_prod_produtos FOREIGN KEY ( cd_produto )
        REFERENCES sgv_produtos ( cd_produto );

ALTER TABLE sgv_video_visu
    ADD CONSTRAINT fk_video_visu_clientes FOREIGN KEY ( cd_cliente )
        REFERENCES sgv_clientes ( cd_cliente );

ALTER TABLE sgv_video_visu
    ADD CONSTRAINT fk_video_visu_video_prod FOREIGN KEY ( id_video )
        REFERENCES sgv_video_prod ( id_video );

ALTER TABLE sgv_estoque
    ADD CONSTRAINT sgv_estoque_sgv_produtos_fk FOREIGN KEY ( cd_produto )
        REFERENCES sgv_produtos ( cd_produto );

CREATE OR REPLACE TRIGGER arc_arc_1_sgv_pes_fisi BEFORE
    INSERT OR UPDATE OF cd_cliente ON sgv_pes_fisi
    FOR EACH ROW
DECLARE
    d NUMBER(10);
BEGIN
    SELECT
        a.cd_cliente
    INTO d
    FROM
        sgv_clientes a
    WHERE
        a.cd_cliente = :new.cd_cliente;

    IF ( d IS NULL ) THEN
        raise_application_error(
                               -20223,
                               'FK FK_PES_FISI_CLIENTES in Table SGV_PES_FISI violates Arc constraint on Table SGV_CLIENTES - discriminator column cd_cliente doesn''t have value cd_cliente'
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_arc_1_sgv_pessoa_pj BEFORE
    INSERT OR UPDATE OF cd_cliente ON sgv_pessoa_pj
    FOR EACH ROW
DECLARE
    d NUMBER(10);
BEGIN
    SELECT
        a.cd_cliente
    INTO d
    FROM
        sgv_clientes a
    WHERE
        a.cd_cliente = :new.cd_cliente;

    IF ( d IS NULL ) THEN
        raise_application_error(
                               -20223,
                               'FK FK_PESSOA_PJ_CLIENTES in Table SGV_PESSOA_PJ violates Arc constraint on Table SGV_CLIENTES - discriminator column cd_cliente doesn''t have value cd_cliente'
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/



-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            15
-- CREATE INDEX                             2
-- ALTER TABLE                             46
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           2
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
