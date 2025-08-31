ALTER TABLE usuario
 MODIFY COLUMN nickname VARCHAR(30) UNIQUE;

DROP TABLE IF EXISTS comunidade;
CREATE TABLE IF NOT EXISTS comunidade (
    id_comunidade INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    descricao LONGTEXT,
    data_criacao DATETIME NOT NULL,
    ativo TINYINT NOT NULL
);