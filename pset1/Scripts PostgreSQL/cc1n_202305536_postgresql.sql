/*
|==============================================|
|ALUNO: Gabriel Manoeli Paulino. --------------|
|TURMA: CC1N. ---------------------------------|
|Professor: Abrantes Araújo Silva Filho -------|
|==============================================|
|------------------- PSET 1 -------------------|
|==============================================|
*/

---
-- Esse Banco de Dados foi projetado como parte integrante das avaliações bimestrais da matéria de Banco de Dados I.
-- Se trata de um banco de dados para as "Lojas Uvv", uma loja fictícia utilizada apenas para a didática (veja mais no comment do banco -- de dados).
---

-------------------------------------------
-- Logando com o superusuário 'postgres' --
-------------------------------------------

\c postgres postgres;

---------------------------------------
-- Criando o usuário gabriel_paulino --
---------------------------------------

---------------------------------------------------------------------------------------------------------------------
-- OBS: O objetivo do script abaixo é verificar se um usuário chamado 'gabriel_paulino' já existe no PostgreSQL.-----
-- Se não existir, a instrução CREATE ROLE é executada para criar um novo usuário.-----------------------------------
-- O novo usuário terá o nome de 'gabriel_paulino' e senha 'abc123'.-------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

DO
$$
 BEGIN
   IF NOT EXISTS (SELECT * FROM pg_user WHERE USENAME = 'gabriel_paulino') THEN
   CREATE ROLE gabriel_paulino WITH ENCRYPTED PASSWORD 'abc123' LOGIN CREATEDB CREATEROLE;
   END IF;
 END
$$
;

------------------------------------
-- Criando o Banco de Dados "uvv" --
------------------------------------

DROP DATABASE IF EXISTS uvv;

CREATE DATABASE uvv WITH

       OWNER             gabriel_paulino
       TEMPLATE          template0
       ENCODING          UTF8
       LC_COLLATE        'pt_BR.UTF-8'
       LC_CTYPE          'pt_BR.UTF-8'
       ALLOW_CONNECTIONS true;

COMMENT ON DATABASE uvv IS
'Banco de dados para as "lojas UVV". Contém dados sobre os clientes, produtos, lojas, estoques, envios e pedidos das lojas UVV.';

-----------------------------------------------------------------
-- Usar o Banco de Dados "uvv" com o usuário "gabriel_paulino" --
-----------------------------------------------------------------

\c "dbname=uvv user=gabriel_paulino password=abc123";

------------------------------------------------------
-- Criando o Schema "lojas" e autorizando o usuário --
------------------------------------------------------

CREATE SCHEMA lojas AUTHORIZATION gabriel_paulino;

---------------------------------------------------------------------------------------------------------------------------
-- Mudando o SEARCH_PATH para que o SCHEMA "lojas" seja o padrão para a sessão atual e para o  usuário "gabriel_paulino" --
---------------------------------------------------------------------------------------------------------------------------

SET SEARCH_PATH TO lojas, "$user", public;

ALTER USER gabriel_paulino
SET SEARCH_PATH TO lojas, "$user", public;

---
-- Tabelas 
---

-------------------------------
-- Criando a tabela produtos --
-------------------------------

CREATE TABLE produtos (

   produto_id                NUMERIC(38)    NOT NULL,
   nome                      VARCHAR(255)   NOT NULL,
   preco_unitario            NUMERIC(10,2),
   detalhes                  BYTEA,
   imagem_mime_type          VARCHAR(512),
   imagem_arquivo            VARCHAR(512),
   imagem                    BYTEA,
   imagem_charset            VARCHAR(512),
   imagem_ultima_atualizacao DATE

);

-------------------------------------------------
-- Comentando a tabela produtos e suas colunas --
-------------------------------------------------

COMMENT ON TABLE produtos IS 'Inclui informações sobre os produtos das lojas.';

COMMENT ON COLUMN produtos.produto_id IS 'PK da tabela produtos. Identifica cada produto com uma id única.';
COMMENT ON COLUMN produtos.nome IS 'Nome do produto.';
COMMENT ON COLUMN produtos.preco_unitario IS 'Preço unitário do produto.';
COMMENT ON COLUMN produtos.detalhes IS 'Detalhes sobre o produto. Uma breve descrição.';
COMMENT ON COLUMN produtos.imagem_mime_type IS 'Indica o tipo de arquivo e o formato do conteúdo da imagem do produto.';
COMMENT ON COLUMN produtos.imagem_arquivo IS 'Arquivo da imagem do produto.';
COMMENT ON COLUMN produtos.imagem IS 'Imagem do produto.';
COMMENT ON COLUMN produtos.imagem_charset IS 'Denomina a codificação de caracteres.';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'Data da última atualização da imagem do produto.';

-------------------------------------------------------
-- Definindo a chave primária(PK) da tabela produtos --
-------------------------------------------------------

ALTER TABLE produtos 
      ADD CONSTRAINT pk_produtos 
      PRIMARY KEY (produto_id);

-- OBS:  A tabela produtos não tem FK

-----------------------------------------------------
-- Criando as CHECK CONSTRAINTS da tabela PRODUTOS --
-----------------------------------------------------

-- A check constraint a seguir define que a coluna 'preco_unitario' não pode receber dados que sejam menores que 0.

ALTER TABLE produtos
      ADD CONSTRAINT cc_produtos_preco_unitario
      CHECK (preco_unitario >= 0);

----------------------------
-- Criando a tabela lojas --
----------------------------

CREATE TABLE lojas (

   loja_id                 NUMERIC(38)   NOT NULL,
   endereco_web            VARCHAR(100),
   endereco_fisico         VARCHAR(512),
   longitude               NUMERIC,
   latitude                NUMERIC,
   nome                    VARCHAR(255)  NOT NULL,
   logo_mime_type          VARCHAR(512),
   logo_charset            VARCHAR(512),
   logo_ultima_atualizacao DATE,
   logo_arquivo            VARCHAR(512),
   logo                    BYTEA
                
);

----------------------------------------------
-- Comentando a tabela lojas e suas colunas --
----------------------------------------------

COMMENT ON TABLE lojas IS 'Inclui todas as informações sobre as lojas.';

COMMENT ON COLUMN lojas.loja_id IS 'PK da tabela lojas. Identifica cada loja com uma id única.';
COMMENT ON COLUMN lojas.endereco_web IS 'Endereço Web da loja.';
COMMENT ON COLUMN lojas.endereco_fisico IS 'Endereço físico da loja.';
COMMENT ON COLUMN lojas.longitude IS 'Longitude da loja.';
COMMENT ON COLUMN lojas.latitude IS 'Latitude da loja.';
COMMENT ON COLUMN lojas.nome IS 'Nome da loja.';
COMMENT ON COLUMN lojas.logo_mime_type IS 'Indica o tipo de arquivo e o formato do conteúdo da logo da loja.';
COMMENT ON COLUMN lojas.logo_charset IS 'Denomina a codificação de caracteres.';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'Data da última atualização do logo da loja.';
COMMENT ON COLUMN lojas.logo_arquivo IS 'Arquivo do logo.';
COMMENT ON COLUMN lojas.logo IS 'Logo da loja.';

----------------------------------------------------
-- Definindo a chave primária(PK) da tabela lojas --
----------------------------------------------------

ALTER TABLE lojas
      ADD CONSTRAINT pk_lojas
      PRIMARY KEY (loja_id);

-- OBS: A tabela lojas não tem FK

--------------------------------------------------
-- Criando as CHECK CONSTRAINTS da tabela LOJAS --
--------------------------------------------------

-- A check constraint a seguir define que ao menos uma das colunas 'endereco_web' ou 'endereco_fisico' não seja nula.

ALTER TABLE lojas
      ADD CONSTRAINT cc_lojas_endereco
      CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

-------------------------------
-- Criando a tabela estoques --
-------------------------------

CREATE TABLE estoques (

   estoque_id          NUMERIC(38) NOT NULL,
   quantidade          NUMERIC(38) NOT NULL,
   loja_id             NUMERIC(38) NOT NULL,
   produto_id          NUMERIC(38) NOT NULL
  
);

-------------------------------------------------
-- Comentando a tabela estoques e suas colunas --
-------------------------------------------------

COMMENT ON TABLE estoques IS 'Inclui informações sobre o(s) estoque(s) da(s) loja(s).';

COMMENT ON COLUMN estoques.estoque_id IS 'PK da tabela estoques. Identifica cada estoque com uma id única.';
COMMENT ON COLUMN estoques.produto_id IS 'PK da tabela produtos e FK da tabela estoques. Identifica cada produto com uma id única.';
COMMENT ON COLUMN estoques.quantidade IS 'Quantidade de cada produto no estoque.';
COMMENT ON COLUMN estoques.loja_id IS 'PK da tabela lojas e FK da tabela estoques. Identifica cada loja com uma id única.';
COMMENT ON COLUMN estoques.produto_id IS 'PK da tabela produtos. Identifica cada produto com uma id única.';

------------------------------------------------------------------------------------
-- Definindo a Chave Primária(PK) e as Chaves Estrangeiras(FK) da tabela estoques --
------------------------------------------------------------------------------------

ALTER TABLE estoques
      ADD CONSTRAINT pk_estoques
      PRIMARY KEY (estoque_id);

ALTER TABLE estoques
      ADD CONSTRAINT fk_lojas_estoques
      FOREIGN KEY (loja_id)
      REFERENCES lojas (loja_id);

ALTER TABLE estoques
      ADD CONSTRAINT fk_produtos_estoques
      FOREIGN KEY (produto_id)
      REFERENCES produtos (produto_id);

-----------------------------------------------------
-- Criando as CHECK CONSTRAINTS da tabela ESTOQUES --
-----------------------------------------------------

-- A check constraint a seguir define que a coluna quantidade não pode receber dados que sejam menores ou igual a zero.

ALTER TABLE estoques 
      ADD CONSTRAINT cc_estoques_quantidade
      CHECK (quantidade > 0);

-------------------------------
-- Criando a tabela clientes --
-------------------------------

CREATE TABLE clientes (

   cliente_id NUMERIC(38)  NOT NULL,
   email      VARCHAR(255) NOT NULL,
   nome       VARCHAR(255) NOT NULL,
   telefone1  VARCHAR(20),
   telefone2  VARCHAR(20),
   telefone3  VARCHAR(20)
                
);

-------------------------------------------------
-- Comentando a tabela clientes e suas colunas --
-------------------------------------------------

COMMENT ON TABLE clientes IS 'Inclui todas as informações pessoais dos clientes.';

COMMENT ON COLUMN clientes.cliente_id IS 'Pk da tabela clientes, identifica cada cliente com um id único.';
COMMENT ON COLUMN clientes.email IS 'email do cliente.';
COMMENT ON COLUMN clientes.telefone1 IS 'Primeiro número de telefone do cliente.';
COMMENT ON COLUMN clientes.telefone2 IS 'Segundo número de telefone do cliente.';
COMMENT ON COLUMN clientes.nome IS 'nome do cliente, assim como está no RG.';
COMMENT ON COLUMN clientes.telefone3 IS 'Terceiro número de telefone do cliente.';

-------------------------------------------------------
-- Definindo a Chave Primária(PK) da tabela clientes --
-------------------------------------------------------

ALTER TABLE clientes
      ADD CONSTRAINT pk_clientes
      PRIMARY KEY (cliente_id);

-- OBS: A tabela clientes não tem FK

-------------------------------------------------------
-- Definindo as CHECK CONSTRAINTS da tabela clientes --
-------------------------------------------------------

-- As check constraints a seguir definem respectivamente que a coluna email só pode receber dados no formato de email (ex.: gmanoelipaulino@gmail.com), a coluna telefone1, telefone2 e telefone 3 só podem receber dados no formato de telefone brasileiro (ex.: 28999546578).

ALTER TABLE clientes
      ADD CONSTRAINT cc_clientes_email            CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
      ADD CONSTRAINT cc_clientes_telefone1_digits CHECK (telefone1 ~ '^[0-9]+$'),
      ADD CONSTRAINT cc_clientes_telefone1_format CHECK (telefone1 ~ '^\d{10,11}$'),
      ADD CONSTRAINT cc_clientes_telefone2_digits CHECK (telefone2 ~ '^[0-9]+$'),
      ADD CONSTRAINT cc_clientes_telefone2_format CHECK (telefone2 ~ '^\d{10,11}$'),
      ADD CONSTRAINT cc_clientes_telefone3_digits CHECK (telefone3 ~ '^[0-9]+$'),
      ADD CONSTRAINT cc_clientes_telefone3_format CHECK (telefone3 ~ '^\d{10,11}$');

-----------------------------
-- Criando a tabela envios --
-----------------------------

CREATE TABLE envios (

   envio_id         NUMERIC(38)  NOT NULL,
   loja_id          NUMERIC(38)  NOT NULL,
   endereco_entrega VARCHAR(512) NOT NULL,
   status           VARCHAR(15)  NOT NULL,
   cliente_id       NUMERIC(38)  NOT NULL
               
);

-----------------------------------------------
-- Comentando a tabela envios e suas colunas --
-----------------------------------------------

COMMENT ON TABLE envios IS 'Inclui informações sobre o envio dos produtos.';

COMMENT ON COLUMN envios.envio_id IS 'PK da tabela envios. Identifica cada envio com uma id única.';
COMMENT ON COLUMN envios.loja_id IS 'PK da tabela lojas e FK da tabela envios. Identifica cada loja com uma id única.';
COMMENT ON COLUMN envios.endereco_entrega IS 'Endereço de entrega do(s) produto(s).';
COMMENT ON COLUMN envios.status IS 'Status do envio do(s) produtos(s).';
COMMENT ON COLUMN envios.cliente_id IS 'PK da tabela clientes e FK da tabela envios. Identifica cada cliente com uma id única.';

----------------------------------------------------------------------------------
-- Definindo a Chave Primária(PK) e as Chaves Estrangeiras(FK) da tabela envios --
----------------------------------------------------------------------------------

ALTER TABLE envios
      ADD CONSTRAINT pk_envios
      PRIMARY KEY (envio_id);

ALTER TABLE envios
      ADD CONSTRAINT fk_lojas_envios
      FOREIGN KEY (loja_id)
      REFERENCES lojas (loja_id);

ALTER TABLE envios
      ADD CONSTRAINT fk_clientes_envios
      FOREIGN KEY (cliente_id)
      REFERENCES clientes (cliente_id);


---------------------------------------------------
-- Criando as CHECK CONSTRAINTS da tabela ENVIOS --
---------------------------------------------------

-- A check constraint a seguir define que a coluna status não pode receber dados que sejam diferentes de 'Criado', 'Enviado', 'Transito'e 'Entregue'.

ALTER TABLE envios
      ADD CONSTRAINT cc_envios_status
      CHECK (status IN ('Criado', 'Enviado', 'Transito', 'Entregue'));

------------------------------
-- Criando a tabela pedidos --
------------------------------

CREATE TABLE pedidos (

    pedido_id  NUMERIC(38) NOT NULL,
    data_hora  TIMESTAMP   NOT NULL,
    cliente_id NUMERIC(38) NOT NULL,
    status     VARCHAR(15) NOT NULL,
    loja_id    NUMERIC(38) NOT NULL
             
);

------------------------------------------------
-- Comentando a tabela pedidos e suas colunas --
------------------------------------------------

COMMENT ON TABLE pedidos IS 'Inclui informações sobre os pedidos dos clientes.';

COMMENT ON COLUMN pedidos.pedido_id IS 'Pk da tabela pedidos, identifica cada pedido com um id único.';
COMMENT ON COLUMN pedidos.data_hora IS 'Inclui a data e a hora do pedido.';
COMMENT ON COLUMN pedidos.cliente_id IS 'Pk da tabela clientes e Fk da tabela pedidos. Identifica cada cliente com uma id única.';
COMMENT ON COLUMN pedidos.status IS 'Indica o status do pedido.';
COMMENT ON COLUMN pedidos.loja_id IS 'PK da tabela lojas e FK da tabela pedidos. Identifica cada loja com um id único.';

-----------------------------------------------------------------------------------
-- Definindo a Chave Primária(PK) e as Chaves Estrangeiras(FK) da tabela pedidos --
-----------------------------------------------------------------------------------

ALTER TABLE pedidos
      ADD CONSTRAINT pk_pedidos
      PRIMARY KEY (pedido_id);

ALTER TABLE pedidos
      ADD CONSTRAINT fk_clientes_pedidos
      FOREIGN KEY (cliente_id)
      REFERENCES clientes (cliente_id);

ALTER TABLE pedidos
      ADD CONSTRAINT fk_lojas_pedidos
      FOREIGN KEY (loja_id)
      REFERENCES lojas (loja_id);

----------------------------------------------------
-- Criando as CHECK CONSTRAINTS da tabela PEDIDOS --
----------------------------------------------------

-- A check constraint a seguir define que a coluna status não pode receber dados diferentes de 'Cancelado', 'Completo', 'Aberto', 'Pago', 'Reembolsado' e 'Enviado'.

ALTER TABLE pedidos
      ADD CONSTRAINT cc_pedidos_status
      CHECK (status IN ('Cancelado', 'Completo', 'Aberto', 'Pago', 'Reembolsado', 'Enviado'));

-- A check constraint a seguir define que a coluna data_hora só pode receber dados de data e hora à partir de '1900-01-01 00:00:00' e até a data e hora atual, não sendo possível incluir data e hora no futuras.

ALTER TABLE pedidos
      ADD CONSTRAINT cc_pedidos_data_hora
      CHECK (data_hora >= '1900-01-01 00:00:00' AND data_hora <= now());

------------------------------------
-- Criando a tabela pedidos_itens --
------------------------------------

CREATE TABLE pedidos_itens (

   pedido_id       NUMERIC(38)   NOT NULL,
   produto_id      NUMERIC(38)   NOT NULL,
   numero_da_linha NUMERIC(38)   NOT NULL,
   quantidade      NUMERIC(38)   NOT NULL,
   preco_unitario  NUMERIC(10,2) NOT NULL,
   envio_id        NUMERIC(38)
               
);

------------------------------------------------------
-- Comentando a tabela pedidos_itens e suas colunas --
------------------------------------------------------

COMMENT ON TABLE pedidos_itens IS 'Inclui informações sobre os pedidos.';

COMMENT ON COLUMN pedidos_itens.pedido_id IS 'Parte da PK da tabela pedidos e pedidos_itens. Identifica cada pedido com uma id única. (Primary Key composta)';
COMMENT ON COLUMN pedidos_itens.produto_id IS 'Parte da PK da tabela produtos e da tabela pedidos_itens. Identifica cada produto com uma id única. (Primary Key composta).';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 'Determina o número da linha do pedido';
COMMENT ON COLUMN pedidos_itens.quantidade IS 'Quantidade de cada produto no pedido.';
COMMENT ON COLUMN pedidos_itens.preco_unitario IS 'Preço unitário do produto.';
COMMENT ON COLUMN pedidos_itens.envio_id IS 'PK da tabela envios e FK da tabela pedidos_itens. Identifica cada envio com uma id única.';

--------------------------------------------------------------------------------------------
-- Definindo as Chaves Primárias(PK) e as Chaves Estrangeiras(FK) da tabela pedidos_itens --
--------------------------------------------------------------------------------------------

ALTER TABLE pedidos_itens 
      ADD CONSTRAINT pk_pedidos_itens
      PRIMARY KEY (pedido_id, produto_id);

ALTER TABLE pedidos_itens
      ADD CONSTRAINT fk_pedidos_pedidos_itens
      FOREIGN KEY (pedido_id)
      REFERENCES pedidos (pedido_id);

ALTER TABLE pedidos_itens
      ADD CONSTRAINT fk_produtos_pedidos_itens
      FOREIGN KEY (produto_id)
      REFERENCES produtos (produto_id);

ALTER TABLE pedidos_itens
      ADD CONSTRAINT fk_envios_pedidos_itens
      FOREIGN KEY (pedido_id)
      REFERENCES pedidos (pedido_id);

----------------------------------------------------------
-- Criando as CHECK CONSTRAINTS da tabela PEDIDOS_ITENS --
----------------------------------------------------------

-- A check constraint a seguir define que a coluna quantidade não pode receber dados que sejam menores ou iguais a zero. 

ALTER TABLE pedidos_itens
      ADD CONSTRAINT cc_pedidos_itens_quantidade
      CHECK (quantidade > 0);

-- A check constraint a seguir define que a coluna preco_unitario não pode receber dados menores que zero.

ALTER TABLE pedidos_itens
      ADD CONSTRAINT cc_pedidos_itens_preco_unitario
      CHECK (preco_unitario >= 0);

---
-- Tabela para confirmação. Exibe informações sobre as tabelas presentes no banco de dados atualmente conectado. Exibe uma lista detalhada de todas as tabelas, incluindo seus nomes, esquemas, tipos de tabela,   -- tamanhos estimados em disco e proprietários das tabelas além da descrição de cada tabela.
---

DO
 $$
  BEGIN
   RAISE NOTICE 'CONFIRMAÇÃO DAS TABELAS';
  END
 $$
;


\dt+;

---
-- Fim
---
