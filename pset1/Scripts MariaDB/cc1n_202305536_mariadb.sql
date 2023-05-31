/*
|==============================================|
|ALUNO: Gabriel Manoeli Paulino. --------------|
|TURMA: CC1N. ---------------------------------|
|Professor: Abrantes Araújo Silva Filho -------|
|==============================================|
|------------------- PSET 1 -------------------|
|------------------- MariaDB ------------------|
|==============================================|
	*/

--
-- Esse Banco de Dados foi projetado como parte integrante das avaliações bimestrais da matéria de Banco de Dados I.
-- Se trata de um banco de dados para as "Lojas Uvv", uma loja fictícia utilizada apenas para a didática (veja mais no comment do banco -- de dados).
--

DROP USER IF EXISTS 'gabriel_paulino'@'localhost';

CREATE USER 'gabriel_paulino'@'localhost' IDENTIFIED BY 'abc123';

----------------------------------
-- Criando o Banco de Dados uvv --
----------------------------------

DROP DATABASE IF EXISTS uvv;

CREATE DATABASE uvv;

-------------------------------------------------------------------------------
-- Garantindo privilégios do banco de dados uvv ao usuário 'gabriel_paulino' --
-------------------------------------------------------------------------------

GRANT ALL ON uvv.* TO 'gabriel_paulino'@'localhost';

FLUSH PRIVILEGES;

---------------------------------
-- Usar o Banco de Dados "uvv" --
---------------------------------

USE uvv; 

-------------------------------
-- Criando a tabela produtos --
-------------------------------

CREATE TABLE produtos (

   produto_id                NUMERIC(38)   NOT NULL,
   nome                      VARCHAR(255)  NOT NULL,
   preco_unitario            NUMERIC(10,2),
   detalhes                  LONGBLOB,
   imagem                    LONGBLOB,
   imagem_mime_type          VARCHAR(512),
   imagem_arquivo            VARCHAR(512),
   imagem_charset            VARCHAR(512),
   imagem_ultima_atualizacao DATE,
   PRIMARY KEY               (produto_id)

);

-------------------------------------------------
-- Comentando a tabela produtos e suas Colunas --
-------------------------------------------------

ALTER TABLE produtos COMMENT 'Inclui informações sobre os produtos das lojas.';

ALTER TABLE produtos MODIFY COLUMN produto_id NUMERIC(38) COMMENT 'PK da tabela produtos. Identifica cada produto com uma id única.';

ALTER TABLE produtos MODIFY COLUMN nome VARCHAR(255) COMMENT 'Nome do produto.';

ALTER TABLE produtos MODIFY COLUMN preco_unitario NUMERIC(10, 2) COMMENT 'Preço unitário do produto.';

ALTER TABLE produtos MODIFY COLUMN detalhes BLOB COMMENT 'Detalhes sobre o produto. Uma breve descrição.';

ALTER TABLE produtos MODIFY COLUMN imagem BLOB COMMENT 'Imagem do produto.';

ALTER TABLE produtos MODIFY COLUMN imagem_mime_type VARCHAR(512) COMMENT 'Indica o tipo de arquivo e o formato do conteúdo da imagem do produto.';

ALTER TABLE produtos MODIFY COLUMN imagem_arquivo VARCHAR(512) COMMENT 'Arquivo da imagem do produto.';

ALTER TABLE produtos MODIFY COLUMN imagem_charset VARCHAR(512) COMMENT 'Denomina a codificação de caracteres.';

ALTER TABLE produtos MODIFY COLUMN imagem_ultima_atualizacao DATE COMMENT 'Data da última atualização da imagem do produto.';

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
                
   loja_id                 NUMERIC(38)  NOT NULL,
   nome                    VARCHAR(255) NOT NULL,
   endereco_web            VARCHAR(100),
   endereco_fisico         VARCHAR(512),
   latitude                NUMERIC,
   longitude               NUMERIC,
   logo                    LONGBLOB,
   logo_mime_type          VARCHAR(512),
   logo_arquivo            VARCHAR(512),
   logo_charset            VARCHAR(512),
   logo_ultima_atualizacao DATE,
   PRIMARY KEY             (loja_id)

);

----------------------------------------------
-- Comentando a tabela lojas e suas colunas --
----------------------------------------------

ALTER TABLE lojas COMMENT 'Inclui todas as informações sobre as lojas.';

ALTER TABLE lojas MODIFY COLUMN loja_id NUMERIC(38) COMMENT 'PK da tabela lojas. Identifica cada loja com uma id única.';

ALTER TABLE lojas MODIFY COLUMN nome VARCHAR(255) COMMENT 'Nome da loja.';

ALTER TABLE lojas MODIFY COLUMN endereco_web VARCHAR(100) COMMENT 'Endereço Web da loja.';

ALTER TABLE lojas MODIFY COLUMN endereco_fisico VARCHAR(512) COMMENT 'Endereço físico da loja.';

ALTER TABLE lojas MODIFY COLUMN latitude NUMERIC COMMENT 'Latitude da loja.';

ALTER TABLE lojas MODIFY COLUMN longitude NUMERIC COMMENT 'Longitude da loja.';

ALTER TABLE lojas MODIFY COLUMN logo BLOB COMMENT 'Logo da loja.';

ALTER TABLE lojas MODIFY COLUMN logo_mime_type VARCHAR(512) COMMENT 'Indica o tipo de arquivo e o formato do conteúdo da logo da loja.';

ALTER TABLE lojas MODIFY COLUMN logo_arquivo VARCHAR(512) COMMENT 'Arquivo do logo.';

ALTER TABLE lojas MODIFY COLUMN logo_charset VARCHAR(512) COMMENT 'Denomina a codificação de caracteres.';

ALTER TABLE lojas MODIFY COLUMN logo_ultima_atualizacao DATE COMMENT 'Data da última atualização do logo da loja.';

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

   estoque_id  NUMERIC(38) NOT NULL,
   loja_id     NUMERIC(38) NOT NULL,
   produto_id  NUMERIC(38) NOT NULL,
   quantidade  NUMERIC(38) NOT NULL,
   PRIMARY KEY (estoque_id)

);

-------------------------------------------------
-- Comentando a tabela estoques e suas colunas --
-------------------------------------------------

ALTER TABLE estoques COMMENT 'Inclui informações sobre o(s) estoque(s) da(s) loja(s).';

ALTER TABLE estoques MODIFY COLUMN estoque_id NUMERIC(38) COMMENT 'PK da tabela estoques. Identifica cada estoque com uma id única.';

ALTER TABLE estoques MODIFY COLUMN loja_id NUMERIC(38) COMMENT 'PK da tabela lojas e FK da tabela estoques. Identifica cada loja com uma id única.';

ALTER TABLE estoques MODIFY COLUMN produto_id NUMERIC(38) COMMENT 'PK da tabela produtos. Identifica cada produto com uma id única.';

ALTER TABLE estoques MODIFY COLUMN quantidade NUMERIC(38) COMMENT 'Quantidade de cada produto no estoque.';

-------------------------------------------------------------
-- Definindo as Chaves Estrangeiras(FK) da tabela estoques --
-------------------------------------------------------------

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

   cliente_id  NUMERIC(38)  NOT NULL,
   email       VARCHAR(255) NOT NULL,
   nome        VARCHAR(255) NOT NULL,
   telefone1   VARCHAR(20),
   telefone2   VARCHAR(20),
   telefone3   VARCHAR(20),
   PRIMARY KEY (cliente_id)

);

-------------------------------------------------
-- Comentando a tabela clientes e suas colunas --
-------------------------------------------------

ALTER TABLE clientes COMMENT 'Inclui todas as informações pessoais dos clientes.';

ALTER TABLE clientes MODIFY COLUMN cliente_id NUMERIC(38) COMMENT 'co.';

ALTER TABLE clientes MODIFY COLUMN email VARCHAR(255) COMMENT 'email do cliente.';

ALTER TABLE clientes MODIFY COLUMN nome VARCHAR(255) COMMENT 'nome do cliente, assim como está no RG.';

ALTER TABLE clientes MODIFY COLUMN telefone1 VARCHAR(20) COMMENT 'Primeiro número de telefone do cliente.';

ALTER TABLE clientes MODIFY COLUMN telefone2 VARCHAR(20) COMMENT 'Segundo número de telefone do cliente.';

ALTER TABLE clientes MODIFY COLUMN telefone3 VARCHAR(20) COMMENT 'Terceiro número de telefone do cliente.';

-------------------------------------------------------
-- Definindo as CHECK CONSTRAINTS da tabela clientes --
-------------------------------------------------------

-- As check constraints a seguir definem respectivamente que a coluna email só pode receber dados no formato de email (ex.: gmanoelipaulino@gmail.com), a coluna telefone1, telefone2 e telefone 3 só podem receber dados no formato de telefone brasileiro (ex.: 28999546578).

ALTER TABLE clientes
      ADD CONSTRAINT cc_clientes_email            CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
      ADD CONSTRAINT cc_clientes_telefone1_digits CHECK (telefone1 REGEXP '^[0-9]+$'),
      ADD CONSTRAINT cc_clientes_telefone1_format CHECK (telefone1 REGEXP '^[0-9]{10,11}$'),
      ADD CONSTRAINT cc_clientes_telefone2_digits CHECK (telefone2 REGEXP '^[0-9]+$'),
      ADD CONSTRAINT cc_clientes_telefone2_format CHECK (telefone2 REGEXP '^[0-9]{10,11}$'),
      ADD CONSTRAINT cc_clientes_telefone3_digits CHECK (telefone3 REGEXP '^[0-9]+$'),
      ADD CONSTRAINT cc_clientes_telefone3_format CHECK (telefone3 REGEXP '^[0-9]{10,11}$');

-----------------------------
-- Criando a tabela envios --
-----------------------------

CREATE TABLE envios (

   envio_id         NUMERIC(38) NOT NULL,
   loja_id          NUMERIC(38) NOT NULL,
   cliente_id       NUMERIC(38) NOT NULL,
   endereco_entrega VARCHAR(512) NOT NULL,
   status           VARCHAR(15) NOT NULL,
   PRIMARY KEY      (envio_id)

);

-----------------------------------------------
-- Comentando a tabela envios e suas colunas --
-----------------------------------------------

ALTER TABLE envios COMMENT 'Inclui informações sobre o envio dos produtos.';

ALTER TABLE envios MODIFY COLUMN envio_id NUMERIC(38) COMMENT 'PK da tabela envios. Identifica cada envio com uma id única.';

ALTER TABLE envios MODIFY COLUMN loja_id NUMERIC(38) COMMENT 'PK da tabela lojas e FK da tabela envios. Identifica cada loja com uma id única.';

ALTER TABLE envios MODIFY COLUMN cliente_id NUMERIC(38) COMMENT 'PK da tabela clientes e FK da tabela envios. Identifica cada cliente com uma id única.';

ALTER TABLE envios MODIFY COLUMN endereco_entrega VARCHAR(512) COMMENT 'Endereço de entrega do(s) produto(s).';

ALTER TABLE envios MODIFY COLUMN status VARCHAR(15) COMMENT 'Status do envio do(s) produtos(s).';

-----------------------------------------------------------
-- Definindo as Chaves Estrangeiras(FK) da tabela envios --
-----------------------------------------------------------

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

   pedido_id   NUMERIC(38) NOT NULL,
   data_hora   DATETIME    NOT NULL,
   cliente_id  NUMERIC(38) NOT NULL,
   status      VARCHAR(15) NOT NULL,
   loja_id     NUMERIC(38) NOT NULL,
   PRIMARY KEY (pedido_id)

);

------------------------------------------------
-- Comentando a tabela pedidos e suas colunas --
------------------------------------------------

ALTER TABLE pedidos COMMENT 'Inclui informações sobre os pedidos dos clientes.';

ALTER TABLE pedidos MODIFY COLUMN pedido_id NUMERIC(38) COMMENT 'Pk da tabela pedidos, identifica cada pedido com um id único.';

ALTER TABLE pedidos MODIFY COLUMN data_hora TIMESTAMP COMMENT 'Inclui a data e a hora do pedido.';

ALTER TABLE pedidos MODIFY COLUMN cliente_id NUMERIC(38) COMMENT 'Pk da tabela clientes e Fk da tabela pedidos. Identifica cada cliente com uma id única.';

ALTER TABLE pedidos MODIFY COLUMN status VARCHAR(15) COMMENT 'Indica o status do pedido.';

ALTER TABLE pedidos MODIFY COLUMN loja_id NUMERIC(38) COMMENT 'PK da tabela lojas e FK da tabela pedidos. Identifica cada loja com um id único.';

------------------------------------------------------------
-- Definindo as Chaves Estrangeiras(FK) da tabela pedidos --
------------------------------------------------------------

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

-- A funcionalidade do trigger abaixo é garantir que apenas registros com datas e horas futuras sejam inseridos na tabela "pedidos". Caso contrário, um erro é lançado, impedindo a inserção do registro.

DELIMITER $$

CREATE TRIGGER tr_check_data_hora BEFORE INSERT ON pedidos FOR EACH ROW

BEGIN
 IF NEW.data_hora < NOW() THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data e hora devem ser posterior à data e hora atual.';
 END IF;
END$$

DELIMITER ;

------------------------------------
-- Criando a tabela pedidos_itens --
------------------------------------

CREATE TABLE pedidos_itens (

   pedido_id       NUMERIC(38)   NOT NULL,
   produto_id      NUMERIC(38)   NOT NULL,
   numero_da_linha NUMERIC(38)   NOT NULL,
   preco_unitario  NUMERIC(10,2) NOT NULL,
   quantidade      NUMERIC(38)   NOT NULL,
   envio_id        NUMERIC(38),
   PRIMARY KEY     (pedido_id, produto_id)

);

------------------------------------------------------
-- Comentando a tabela pedidos_itens e suas colunas --
------------------------------------------------------

ALTER TABLE pedidos_itens COMMENT 'Inclui informações sobre os pedidos.';

ALTER TABLE pedidos_itens MODIFY COLUMN pedido_id NUMERIC(38) COMMENT 'Parte da PK da tabela pedidos e pedidos_itens. Identifica cada pedido com uma id única. (Primary Key composta)';

ALTER TABLE pedidos_itens MODIFY COLUMN produto_id NUMERIC(38) COMMENT 'Parte da PK da tabela produtos e da tabela pedidos_itens. Identifica cada produto com uma id única. (Primary Key composta).';

ALTER TABLE pedidos_itens MODIFY COLUMN numero_da_linha NUMERIC(38) COMMENT 'Identifica o número da linha do pedido';

ALTER TABLE pedidos_itens MODIFY COLUMN preco_unitario NUMERIC(10, 2) COMMENT 'Preço unitário do produto.';

ALTER TABLE pedidos_itens MODIFY COLUMN quantidade NUMERIC(38) COMMENT 'Quantidade de cada produto no pedido.';

ALTER TABLE pedidos_itens MODIFY COLUMN envio_id NUMERIC(38) COMMENT 'PK da tabela envios e FK da tabela pedidos_itens. Identifica cada envio com uma id única.';

------------------------------------------------------------------
-- Definindo as Chaves Estrangeiras(FK) da tabela pedidos_itens --
------------------------------------------------------------------

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
