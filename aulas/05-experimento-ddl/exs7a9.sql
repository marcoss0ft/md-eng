SELECT * FROM comunidade;

ALTER TABLE comunidade
    ADD COLUMN id_usuario_dono INT NOT NULL DEFAULT 1,
    ADD FOREIGN KEY (id_usuario_dono) REFERENCES usuario(id_usuario);
    
DROP TABLE IF EXISTS usuario_has_comunidade;
CREATE TABLE IF NOT EXISTS usuario_has_comunidade (
    id_usuario INT NOT NULL,
    id_comunidade INT NOT NULL,
    PRIMARY KEY (id_usuario, id_comunidade),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_comunidade) REFERENCES comunidade(id_comunidade)
);