DROP TABLE IF EXISTS discussao;
CREATE TABLE IF NOT EXISTS discussao(
    id_discussao INT AUTO_INCREMENT PRIMARY KEY,
    id_comunidade INT NOT NULL,
    id_usuario_criador INT NOT NULL,
    titulo VARCHAR(90) NOT NULL,
    data_criacao DATETIME NOT NULL,
    ativa TINYINT NOT NULL,
    FOREIGN KEY (id_comunidade) REFERENCES comunidade(id_comunidade),
    FOREIGN KEY (id_usuario_criador) REFERENCES usuario(id_usuario)
);

DROP TABLE IF EXISTS mensagem;
CREATE TABLE IF NOT EXISTS mensagem (
    id_mensagem INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario_envio INT NOT NULL,
    id_discussao INT NOT NULL,
    texto MEDIUMTEXT NOT NULL,
    data_envio DATETIME NOT NULL,
    oculta TINYINT NOT NULL,
    FOREIGN KEY (id_usuario_envio) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_discussao) REFERENCES discussao(id_discussao)
);