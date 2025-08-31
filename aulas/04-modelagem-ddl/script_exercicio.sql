DROP DATABASE IF EXISTS megadados;
CREATE DATABASE megadados;
USE megadados;

DROP TABLE IF EXISTS Departamento;
CREATE TABLE Departamento (
  idDepartamento INT NOT NULL,
  nome VARCHAR(80) NOT NULL,
  PRIMARY KEY (idDepartamento)
);
DROP TABLE IF EXISTS Funcionario;
CREATE TABLE Funcionario (
  RG INT NOT NULL,
  nome VARCHAR(80) NOT NULL UNIQUE,
  salario FLOAT NOT NULL DEFAULT 500.0,
  telefone VARCHAR(30),
  idDepartamento INT NOT NULL,
  PRIMARY KEY (RG),
  FOREIGN KEY (idDepartamento)
    REFERENCES Departamento(idDepartamento),
  CHECK (salario >= 0)
);

DROP TABLE IF EXISTS Dependentes;
CREATE TABLE Dependentes (
	RG INT NOT NULL,
    RGFuncionario INT NOT NULL,
    nome VARCHAR(80) NOT NULL UNIQUE,
    PRIMARY KEY (RG),
    FOREIGN KEY (RGFuncionario)
		REFERENCES Funcionario(RG)
);