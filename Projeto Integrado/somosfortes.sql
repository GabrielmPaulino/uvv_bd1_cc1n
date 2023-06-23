/*
|==============================================|
|ALUNOS: Gabriel Manoeli Paulino, Pedro Amorim,|
|Pedro Mello e Ramses Martins. ----------------|
|TURMA: CC1N. ---------------------------------|
|Professor: Abrantes Araújo Silva Filho. ------|
|==============================================|
|-------------- Projeto Integrado -------------|
|==============================================|
	*/

--
-- Esse Banco de Dados foi projetado como parte integrante do Projeto Integrado envolvendo as matérias de Banco de Dados I, UX e WEB. 
-- Se trata de um banco de dados para o banco de talentos da empresa Fortes Engenharia.
--



---
-- Criação das tabelas 
---

---------------------
-- TABELA "grupos" --
---------------------

CREATE TABLE grupos (

   grupo_id        NUMERIC(8)   NOT NULL,
   grupo_nome      VARCHAR(100) NOT NULL,
   descricao_grupo VARCHAR(512) NOT NULL,
   qtd_membros     VARCHAR(5)   NOT NULL
  
);

COMMENT ON TABLE  grupos IS 'nessa tabela se encontra os grupos que os colaboradores podem participar';
COMMENT ON COLUMN grupos.grupo_id IS 'nessa coluna se encontra o id numerico referente a um grupo';
COMMENT ON COLUMN grupos.grupo_nome IS 'nessa coluna se encontra o nome do grupo';
COMMENT ON COLUMN grupos.descricao_grupo IS 'nessa coluna se encontra a descrição do grupo';
COMMENT ON COLUMN grupos.qtd_membros IS 'nessa coluna se encontra a quantidade colaboradores que são membros do grupo';

------------------------------------------------------
-- Definindo a chave primária (PK) da tabela grupos --
------------------------------------------------------

ALTER TABLE grupos 
      ADD CONSTRAINT grupo_id 
      PRIMARY KEY (grupo_id);

-----------------------------------------------------
-- Definindo as Check Constraints da tabela grupos --
-----------------------------------------------------

-- A check constraint a seguir define que a coluna qtd_membros só pode receber valores númericos de 0 a 9 ou NULL.

ALTER TABLE grupos
      ADD CONSTRAINT cc_grupos_qtd_membros
      CHECK (qtd_membros IS NULL OR qtd_membros ~ '^[0-9]+$');

--------------------------
-- TABELA "habilidades" --
--------------------------

CREATE TABLE habilidades (

   habilidade_id        NUMERIC(8)   NOT NULL,
   nome_habilidade      VARCHAR(38)  NOT NULL,
   descricao_habilidade VARCHAR(512),
   tipo                 VARCHAR(100) NOT NULL
              
);

COMMENT ON TABLE  habilidades IS 'nessa tabela se encontram as habilidades (soft skills ou hard skills) dos colaboradores';
COMMENT ON COLUMN habilidades.habilidade_id IS 'nessa coluna se encontra o id numerico referente a habilidade';
COMMENT ON COLUMN habilidades.nome_habilidade IS 'nessa coluna se encontra o nome da habilidade';
COMMENT ON COLUMN habilidades.descricao_habilidade IS 'nessa coluna se encontra a descrição da habilidade';
COMMENT ON COLUMN habilidades.tipo IS 'nessa coluna se encontra o tipo de habilidade';

-----------------------------------------------------------
-- Definindo a chave primária (PK) da tabela habilidades --
-----------------------------------------------------------

ALTER TABLE habilidades 
      ADD CONSTRAINT habilidade_id 
      PRIMARY KEY (habilidade_id);

----------------------------
-- TABELA "colaboradores" --
----------------------------

CREATE TABLE colaboradores (

   cpf       VARCHAR(11)  NOT NULL,
   nome      VARCHAR(100) NOT NULL,
   sobrenome VARCHAR(100) NOT NULL,
   data_nasc DATE         NOT NULL,
   sexo      VARCHAR(1)   NOT NULL
               
);

COMMENT ON TABLE  colaboradores IS 'nessa tabela se encontram informações pessoais dos colaboradores';
COMMENT ON COLUMN colaboradores.cpf IS 'nessa coluna se encontra o atributo cpf do colaborador';
COMMENT ON COLUMN colaboradores.nome IS 'nessa coluna se encontra o nome do colaborador';
COMMENT ON COLUMN colaboradores.sobrenome IS 'nessa coluna se encontra o sobrenome do colaborador';
COMMENT ON COLUMN colaboradores.data_nasc IS 'nessa coluna se encontra a data de nascimento do colaborador';
COMMENT ON COLUMN colaboradores.sexo IS 'nessa coluna se encontra o sexo do colaborador';

-------------------------------------------------------------
-- Definindo a chave primária (PK) da tabela colaboradores --
-------------------------------------------------------------

ALTER TABLE colaboradores 
      ADD CONSTRAINT cpf_id 
      PRIMARY KEY (cpf);

------------------------------------------------------------
-- Definindo as Check Constraints da tabela colaboradores -- 
------------------------------------------------------------

-- A check constraint a seguir define que a coluna cpf só pode receber valores númericos de 0-9.

ALTER TABLE colaboradores
      ADD CONSTRAINT cc_colaboradores_cpf
      CHECK (cpf ~ '^[0-9]+$');

-- A check constraint a seguir define que a coluna sexo só pode receber strings = m, f ou o.

ALTER TABLE colaboradores
      ADD CONSTRAINT CK_colaboradores_sexo
      CHECK (sexo IN ('m', 'f', 'o'));

-- A check constraint a seguir define que a coluna data_nasc só pode receber datas entre 01-01-1900 e a data atual.

ALTER TABLE colaboradores
      ADD CONSTRAINT CK_colaboradores_data_nasc
      CHECK (data_nasc >= '1900-01-01' AND data_nasc <= CURRENT_DATE);

------------------------
-- TABELA "enderecos" --
------------------------

CREATE TABLE enderecos (

   endereco_id NUMERIC(8)   NOT NULL,
   cpf         VARCHAR(11)  NOT NULL,
   cep         NUMERIC(8)   NOT NULL,
   uf          VARCHAR(2)   NOT NULL,
   cidade      VARCHAR(100) NOT NULL,
   bairro      VARCHAR(100) NOT NULL,
   logradouro  VARCHAR(100) NOT NULL,
   numero      VARCHAR(100),
   complemento VARCHAR(100)
                
);

COMMENT ON TABLE  enderecos IS 'endereço dos colaboradores';
COMMENT ON COLUMN enderecos.endereco_id IS 'nessa coluna se encontra o id numerico referente ao endereço do colaborador';
COMMENT ON COLUMN enderecos.cpf IS 'nessa coluna se encontra o atributo cpf do colaborador para o atribuir em seu endereço';
COMMENT ON COLUMN enderecos.cep IS 'nessa coluna se encontra o cep refente ao endereço';
COMMENT ON COLUMN enderecos.uf IS 'nessa coluna se encontra a UF referente ao endereço';
COMMENT ON COLUMN enderecos.cidade IS 'nessa coluna se encontra a cidade referente ao endereço';
COMMENT ON COLUMN enderecos.bairro IS 'nessa coluna se encontra o bairro referente ao endereço';
COMMENT ON COLUMN enderecos.logradouro IS 'nessa coluna se encontra o logradouro referente ao endereço';
COMMENT ON COLUMN enderecos.numero IS 'nessa coluna se encontra o numero do imóvel ou residencia referente ao endereço';
COMMENT ON COLUMN enderecos.complemento IS 'nessa coluna se encontra informações adicionais referente ao endereço';

---------------------------------------------------------
-- Definindo a chave primária (PK) da tabela enderecos --
---------------------------------------------------------

ALTER TABLE enderecos 
      ADD CONSTRAINT cep 
      PRIMARY KEY (endereco_id);


ALTER TABLE enderecos 
      ADD CONSTRAINT colaboradores_enderecos_fk
      FOREIGN KEY (cpf)
      REFERENCES colaboradores (cpf);

---------------------------------
-- TABELA "colaboradores_emails" --
---------------------------------

CREATE TABLE colaboradores_emails (

   email VARCHAR(100) NOT NULL,
   cpf   VARCHAR(11)  NOT NULL
                
);

COMMENT ON TABLE  colaboradores_emails IS 'nessa tabela se encontra o email dos colaboradores';
COMMENT ON COLUMN colaboradores_emails.email IS 'nessa coluna se encontra o email do colaborador';
COMMENT ON COLUMN colaboradores_emails.cpf IS 'nessa coluna se encontra o atributo cpf do colaborador para o atribuir ao seu email';

-----------------------------------------------------------------------------------------------
-- Definindo a chave primária (PK) e a chave estrangeira (FK) da tabela colaboradores_emails --
-----------------------------------------------------------------------------------------------

ALTER TABLE colaboradores_emails  
      ADD CONSTRAINT colaboradores_emails_pk 
      PRIMARY KEY (email);

ALTER TABLE colaboradores_emails
      ADD CONSTRAINT colaboradores_emails_fk
      FOREIGN KEY (cpf)
      REFERENCES colaboradores (cpf);

-------------------------------------------------------------------
-- Definindo as Check Constraints da tabela colaboradores_emails --
-------------------------------------------------------------------

-- A check constraint a seguir define que a coluna email só pode receber uma string no formato de uma email. EX.: exemplo10@gmail.com.

ALTER TABLE colaboradores_emails
      ADD CONSTRAINT cc_colaboradores_emails_email           
      CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

--------------------------------------
-- TABELA "colaboradores_telefones" --
--------------------------------------

CREATE TABLE colaboradores_telefones (

   numero   VARCHAR(9)  NOT NULL,
   ddd      VARCHAR(3)  NOT NULL,
   cod_pais VARCHAR(3)  NOT NULL,
   cpf      VARCHAR(11) NOT NULL
               
);

COMMENT ON TABLE  colaboradores_telefones IS 'nessa tabela se encontram o número de telefone completo do colaborador';
COMMENT ON COLUMN colaboradores_telefones.numero IS 'nessa coluna se encontra o numero de telefone do colaborador';
COMMENT ON COLUMN colaboradores_telefones.ddd IS 'nessa coluna se encontra o código de área do colaborador';
COMMENT ON COLUMN colaboradores_telefones.cod_pais IS 'nessa coluna se encontra o código de telefone do país do telefone do colaborador';
COMMENT ON COLUMN colaboradores_telefones.cpf IS 'nessa coluna se encontra o cpf do colaborador para o atribuir ao seu número';

--------------------------------------------------------------------------------------------------
-- Definindo a chave primária (PK) e a chave estrangeira (FK) da tabela colaboradores_telefones --
--------------------------------------------------------------------------------------------------

ALTER TABLE colaboradores_telefones 
      ADD CONSTRAINT colaboradores_telefones_pk 
      PRIMARY KEY (numero, ddd);

ALTER TABLE colaboradores_telefones
      ADD CONSTRAINT colaboradores_contatos_fk
      FOREIGN KEY (cpf)
      REFERENCES colaboradores (cpf);

----------------------------------------------------------------------
-- Definindo as Check Constraints da tabela colaboradores_telefones --
----------------------------------------------------------------------

-- As check constraints a seguir definem que as colunas numero, ddd e cod_pais só podem receber valores númericos de 0-9.

ALTER TABLE colaboradores_telefones
      ADD CONSTRAINT CK_colaboradores_telefones_numero   CHECK (numero ~ '^[0-9]+$'),
      ADD CONSTRAINT CK_colaboradores_telefones_ddd      CHECK (ddd ~ '^[0-9]+$'),
      ADD CONSTRAINT CK_colaboradores_telefones_cod_pais CHECK (cod_pais ~ '^[0-9]+$');

------------------------
-- TABELA "postagens" --
------------------------

CREATE TABLE postagens (

   post_id    NUMERIC(8)   NOT NULL,
   descricao  VARCHAR(512) NOT NULL,
   titulo     VARCHAR(100) NOT NULL,
   post_data  DATE         NOT NULL,
   expir_data DATE,
   cpf        VARCHAR(11)  NOT NULL
                
);

COMMENT ON TABLE  postagens IS 'aqui se encontra os atributos referentes as postagens';
COMMENT ON COLUMN postagens.post_id IS 'nessa coluna se encontra o id numerico referente a postagem';
COMMENT ON COLUMN postagens.descricao IS 'nessa coluna se encotra a descrição da postagem';
COMMENT ON COLUMN postagens.titulo IS 'nessa coluna se encontra o título da postagem';
COMMENT ON COLUMN postagens.post_data IS 'nessa coluna se encontra a data da postagem';
COMMENT ON COLUMN postagens.expir_data IS 'nessa coluna se encontra a data de expiração da postagem';
COMMENT ON COLUMN postagens.cpf IS 'nessa coluna se encontra o cpf do colaborador para o atribuir a sua postagem';

------------------------------------------------------------------------------------
-- Definindo a chave primária (PK) e a chave estrangeira (FK) da tabela postagens --
------------------------------------------------------------------------------------

ALTER TABLE postagens 
      ADD CONSTRAINT post_id 
      PRIMARY KEY (post_id);

ALTER TABLE postagens 
      ADD CONSTRAINT colaboradores_postagens_fk
      FOREIGN KEY (cpf)
      REFERENCES colaboradores (cpf);

--------------------------------------------------------
-- Definindo as Check Constraints da tabela postagens --
--------------------------------------------------------

-- A check constraint a seguir define que a coluna post_data só pode receber datas entre 01-01-1900 e a data atual.

ALTER TABLE postagens
      ADD CONSTRAINT CK_postagens_post_data
      CHECK (post_data >= '1900-01-01' AND post_data <= CURRENT_TIMESTAMP);

-- A check constraint a seguir define que a coluna expir_data só pode receber datas >= a data atual.

ALTER TABLE postagens
      ADD CONSTRAINT CK_postagens_expir_data
      CHECK (expir_data >= CURRENT_DATE);

-----------------------------------
-- TABELA "colaboradores_grupos" --
-----------------------------------

CREATE TABLE colaboradores_grupos (

   grupo_id NUMERIC(8)  NOT NULL,
   cpf      VARCHAR(11) NOT NULL
             
);

COMMENT ON TABLE  colaboradores_grupos IS 'nessa tabela se encontra os colaboradores participantes de cada grupo';
COMMENT ON COLUMN colaboradores_grupos.grupo_id IS 'nessa coluna se encontra o id numerico referente a um grupo';
COMMENT ON COLUMN colaboradores_grupos.cpf IS 'nessa coluna se encontra o atributo cpf do colaborador para o atribuir em um grupo';

--------------------------------------------------------------------------------------------------
-- Definindo a chave primária (PK) e as chaves estrangeiras (FK) da tabela colaboradores_grupos --
--------------------------------------------------------------------------------------------------

ALTER TABLE colaboradores_grupos 
      ADD CONSTRAINT colaboradores_grupos_pk 
      PRIMARY KEY (grupo_id);

ALTER TABLE colaboradores_grupos 
      ADD CONSTRAINT grupos_colaboradores_grupos_fk
      FOREIGN KEY (grupo_id)
      REFERENCES grupos (grupo_id);

ALTER TABLE colaboradores_grupos
      ADD CONSTRAINT colaboradores_colaboradores_grupos_fk
      FOREIGN KEY (cpf)
      REFERENCES colaboradores (cpf);

-----------------------
-- TABELA "usuarios" --
-----------------------

CREATE TABLE usuarios (

   login VARCHAR(50)  NOT NULL,
   senha VARCHAR(100) NOT NULL,
   cpf   VARCHAR(11)  NOT NULL
                
);

COMMENT ON TABLE  usuarios IS 'nessa tabela se encontram as informações de login dos usuarios colaboradores';
COMMENT ON COLUMN usuarios.login IS 'nessa coluna se encontra o login do colaborador';
COMMENT ON COLUMN usuarios.senha IS 'nessa coluna se encontra a senha do colaborador';
COMMENT ON COLUMN usuarios.cpf IS 'nessa coluna se encontra o atributo cpf do colaborador para o atribuir ao seu usuário';

-----------------------------------------------------------------------------------
-- Definindo a chave primária (PK) e a chave estrangeira (FK) da tabela usuarios --
-----------------------------------------------------------------------------------

ALTER TABLE usuarios 
      ADD CONSTRAINT login 
      PRIMARY KEY (login, senha);

ALTER TABLE usuarios
      ADD CONSTRAINT colaboradores_usuarios_fk
      FOREIGN KEY (cpf)
      REFERENCES colaboradores (cpf);

----------------------------------------
-- TABELA "colaboradores_habilidades" --
----------------------------------------

CREATE TABLE colaboradores_habilidades (

   habilidade_id NUMERIC(8)  NOT NULL,
   cpf           VARCHAR(11) NOT NULL
                
);

COMMENT ON TABLE  colaboradores_habilidades IS 'nessa tabela se encontram as habilidades de cada colaborador';
COMMENT ON COLUMN colaboradores_habilidades.habilidade_id IS 'nessa coluna se encontra o id numerico referente a habilidade';
COMMENT ON COLUMN colaboradores_habilidades.cpf IS 'nessa coluna se encontra o atributo cpf do colaborador para o atribuir em uma habilidade';

-------------------------------------------------------------------------------------------------------
-- Definindo a chave primária (PK) e as chaves estrangeiras (FK) da tabela colaboradores_habilidades --
-------------------------------------------------------------------------------------------------------

ALTER TABLE colaboradores_habilidades 
      ADD CONSTRAINT colaboradores_habilidades_id 
      PRIMARY KEY (habilidade_id);

ALTER TABLE colaboradores_habilidades
      ADD CONSTRAINT habilidades_colaboradores_habilidades_fk
      FOREIGN KEY (habilidade_id)
      REFERENCES habilidades (habilidade_id);

ALTER TABLE colaboradores_habilidades 
      ADD CONSTRAINT colaboradores_colaboradores_habilidades_fk
      FOREIGN KEY (cpf)
      REFERENCES colaboradores (cpf);
