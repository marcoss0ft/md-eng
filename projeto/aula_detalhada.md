# Aula Completa: REST, FastAPI e ORM (Baseado no Commit `badbbe4`)

Peço desculpas pelo erro anterior. Esta aula foi reescrita do zero, analisando exclusivamente o código presente no commit `badbbe4...` para garantir total precisão.

---

## Parte 1: A Teoria

### 1.1. O que é uma API REST?

Uma **API** (Application Programming Interface) é um intermediário que permite que dois sistemas de software comuniquem entre si através de um conjunto de regras.

**REST** (Representational State Transfer) é um estilo de arquitetura, um conjunto de princípios para desenhar estas APIs. As suas regras principais são:

*   **Arquitetura Cliente-Servidor**: O cliente (quem pede os dados) e o servidor (quem os fornece) são sistemas separados.
*   **Stateless (Sem Estado)**: Cada pedido do cliente deve conter toda a informação que o servidor precisa para o entender. O servidor não armazena o "contexto" do cliente entre pedidos.
*   **Interface Uniforme**: A comunicação é padronizada.
    *   **Recursos**: Tudo é um "recurso". No seu projeto, uma `equipe é um recurso, e um `piloto` é outro.
    *   **URIs (Identificadores)**: Cada recurso tem um endereço único. Ex: `/equipes/1` para a equipa com ID 1.
    *   **Métodos HTTP (Verbos)**: Usamos verbos para dizer o que queremos fazer com um recurso. A analogia com SQL é direta:
        *   `GET`: Ler dados (`SELECT`).
        *   `POST`: Criar um novo recurso (`INSERT`).
        *   `PUT` / `PATCH`: Atualizar um recurso (`UPDATE`).
        *   `DELETE`: Apagar um recurso (`DELETE`).
    *   **Representações**: Os recursos são trocados num formato específico, geralmente **JSON**.

### 1.2. O que é o FastAPI?

FastAPI é um **framework web** para Python, especializado em criar APIs REST. Ele fornece uma estrutura e ferramentas para acelerar o desenvolvimento.

*   **Rapidez**: É um dos frameworks Python mais rápidos.
*   **Type Hints (Dicas de Tipo)**: Usa as dicas de tipo do Python (ex: `nome: str`) para:
    *   **Validar dados**: Garante que os dados recebidos estão no formato correto.
    *   **Serializar dados**: Converte objetos Python para JSON e vice-versa.
    *   **Documentar a API**: Cria automaticamente uma documentação interativa (Swagger UI).
*   **Pydantic**: É a biblioteca que o FastAPI usa para a validação e gestão de dados através de classes que herdam de `BaseModel`.
*   **Assíncrono**: Suporta operações `async`/`await`, o que o torna muito eficiente.

### 1.3. O que é um ORM e o SQLAlchemy?

Um **ORM** (Object-Relational Mapper) é uma biblioteca que atua como um tradutor entre o paradigma de programação orientada a objetos (classes, objetos) e o paradigma de bases de dados relacionais (tabelas, linhas).

**SQLAlchemy** é o ORM mais popular em Python. Com ele, em vez de escrever SQL, você manipula objetos Python.

*   Uma tabela (`piloto`) torna-se uma classe (`class Piloto:`).
*   As colunas (`nome`, `pontos`) tornam-se atributos (`self.nome`, `self.pontos`).
*   Uma linha na tabela torna-se uma instância (um objeto) dessa classe.

**Vantagens:**
1.  **Abstração**: Você foca-se na lógica da sua aplicação em Python.
2.  **Segurança**: Previne ataques de injeção de SQL.
3.  **Produtividade**: Reduz código repetitivo.
4.  **Portabilidade**: Facilita a troca do sistema de base de dados.

---

## Parte 2: A Prática no Seu Projeto (Commit `badbbe4`)

Análise ficheiro a ficheiro do seu código exato.

### `src/db.py`

Este ficheiro configura a ligação à base de dados.

```python
import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from urllib.parse import quote_plus

# Carrega variáveis de ambiente do ficheiro .env.
load_dotenv(override=True)

# Lê as credenciais da base de dados a partir das variáveis de ambiente.
DB_SERVER = os.getenv("DB_SERVER")
DB_PORT = os.getenv("DB_PORT")
DB_USER = os.getenv("DB_USERNAME")
DB_PASS = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_DATABASE")

# `quote_plus` escapa caracteres especiais na senha para que a URL de conexão seja válida.
password_escaped = quote_plus(DB_PASS)
# Monta a URL de conexão específica para MySQL com o driver `mysqlconnector`.
DATABASE_URL = f"mysql+mysqlconnector://{DB_USER}:{password_escaped}@{DB_SERVER}:{DB_PORT}/{DB_NAME}"

# O "Motor" (Engine) é o ponto central de comunicação do SQLAlchemy com a base de dados.
# `echo=True` faz com que o SQLAlchemy imprima no terminal todo o SQL que ele gera.
engine = create_engine(DATABASE_URL, echo=True, future=True)

# `SessionLocal` é uma "fábrica" que cria objetos de Sessão. Uma Sessão é a sua "conversa"
# com a base de dados para executar queries.
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False, expire_on_commit=False)

# `Base` é uma classe da qual todos os seus modelos de tabela irão herdar.
# É assim que o SQLAlchemy descobre quais classes correspondem a tabelas.
Base = declarative_base()
```

**Conclusão**: Este ficheiro lê as credenciais, prepara a URL de conexão para o MySQL e configura o motor e a fábrica de sessões do SQLAlchemy.

### `src/models.py`

Aqui, a estrutura das tabelas da base de dados é definida como classes Python.

```python
from sqlalchemy import Column, Integer, String, Date, DateTime, Float, ForeignKey, Enum
from sqlalchemy.orm import relationship
from .db import Base
import enum

# Define um Enum padrão do Python.
class StatusPiloto(enum.Enum):
    titular = "titular"
    reserva = "reserva"
    lesionado = "lesionado"
    suspenso = "suspenso"

# Mapeia a tabela "equipe".
class Equipe(Base):
    __tablename__ = "equipe" # Nome da tabela na base de dados.

    # Mapeia as colunas para atributos da classe.
    id_equipe = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100), nullable=False, unique=True)
    fundacao = Column(Date, nullable=True)
    pais = Column(String(50), nullable=True)
    orcamento = Column(Float, nullable=True)

    # Define o relacionamento 1-para-N: Uma equipe tem vários pilotos.
    # `relationship` define a ligação a nível de ORM.
    # `back_populates="equipe"` liga este relacionamento ao da classe Piloto.
    # `cascade="all, delete-orphan"` significa que se uma equipe for apagada, os seus pilotos também serão.
    pilotos = relationship("Piloto", back_populates="equipe", cascade="all, delete-orphan")

# Mapeia a tabela "piloto".
class Piloto(Base):
    __tablename__ = "piloto"

    id_piloto = Column(Integer, primary_key=True, index=True)
    # `ForeignKey` é a restrição a nível de SQL.
    id_equipe = Column(Integer, ForeignKey("equipe.id_equipe"), nullable=False)
    nome = Column(String(100), nullable=False)
    data_nascimento = Column(Date, nullable=False)
    data_contrato = Column(DateTime, nullable=False)
    pontos = Column(Integer, nullable=False, default=0)
    # A coluna `status` na base de dados irá armazenar a string correspondente ao membro do Enum.
    status = Column(Enum(StatusPiloto), nullable=False, default=StatusPiloto.titular)

    # Relacionamento inverso: Um piloto pertence a uma equipe.
    equipe = relationship("Equipe", back_populates="pilotos")
```

**Conclusão**: Este ficheiro é o mapa do seu ORM. Ele diz ao SQLAlchemy como as suas tabelas `equipe` e `piloto` são estruturadas e como se relacionam.

### `src/schemas.py`

Este ficheiro define a "forma" dos dados que a API aceita e retorna, usando Pydantic.

```python
from pydantic import BaseModel, Field
from typing import Optional
from datetime import date, datetime

# IMPORTANTE: O schema importa o Enum diretamente do ficheiro de modelos.
from src.models import StatusPiloto

# --- Esquemas da Equipe ---

# `EquipeCreate`: Define os campos necessários para CRIAR uma equipe.
class EquipeCreate(BaseModel):
    nome: str = Field(..., example="Ferrari")
    fundacao: Optional[date] = Field(None, example="1929-11-01")
    pais: Optional[str] = Field(None, example="Itália")
    orcamento: Optional[float] = Field(None, example=380000000.00)

# `EquipeRead`: Define a estrutura dos dados ao LER uma equipe. Herda de `EquipeCreate` e adiciona o ID.
class EquipeRead(EquipeCreate):
    id_equipe: int

    class Config:
        # `orm_mode = True` permite que o Pydantic crie um schema a partir de um objeto SQLAlchemy.
        orm_mode = True

# `EquipeUpdate`: Define os campos que podem ser ATUALIZADOS. Todos são opcionais.
class EquipeUpdate(BaseModel):
    nome: Optional[str] = None
    fundacao: Optional[date] = None
    pais: Optional[str] = None
    orcamento: Optional[float] = None


# --- Esquemas do Piloto ---

# `PilotoCreate`: Define os campos para CRIAR um piloto.
class PilotoCreate(BaseModel):
    id_equipe: int = Field(..., example=1)
    nome: str = Field(..., example="Charles Leclerc")
    data_nascimento: date = Field(..., example="1997-10-16")
    data_contrato: datetime = Field(..., example="2024-03-01T09:00:00")
    pontos: Optional[int] = Field(0, example=0)
    # O campo `status` espera um objeto do tipo `StatusPiloto`.
    status: Optional[StatusPiloto] = Field(StatusPiloto.titular)

# `PilotoRead`: Define a estrutura ao LER um piloto.
class PilotoRead(PilotoCreate):
    id_piloto: int

    class Config:
        orm_mode = True

# `PilotoUpdate`: Define os campos para ATUALIZAR um piloto.
class PilotoUpdate(BaseModel):
    id_equipe: Optional[int] = None
    nome: Optional[str] = None
    data_nascimento: Optional[date] = None
    data_contrato: Optional[datetime] = None
    pontos: Optional[int] = None
    status: Optional[StatusPiloto] = None
```

**Conclusão e Causa do Erro**: Este ficheiro define os "contratos" de dados da sua API. Crucialmente, **não há nenhum validador (`@validator`) neste código**. O schema `PilotoRead` espera que o campo `status` seja um membro do `Enum` `StatusPiloto`. No entanto, o SQLAlchemy, ao ler da base de dados, devolve uma `string` (ex: `"titular"`). Quando o Pydantic tenta criar o `PilotoRead` a partir do objeto do modelo, ele encontra uma `string` onde esperava um `Enum`, causando o `ValidationError` que você observou. A sua estrutura de código está correta, mas esta incompatibilidade entre o que o ORM retorna (string) e o que o schema de leitura espera (Enum) é a fonte do problema.

### `src/crud.py`

Este ficheiro isola a lógica de interação com a base de dados (Create, Read, Update, Delete).

```python
from sqlalchemy.orm import Session
from . import models, schemas
from typing import List, Optional

def create_equipe(db: Session, equipe_in: schemas.EquipeCreate) -> models.Equipe:
    # Converte o schema Pydantic para um dicionário e cria um objeto do modelo SQLAlchemy.
    equipe = models.Equipe(**equipe_in.dict())
    db.add(equipe)  # Adiciona à sessão (prepara o INSERT).
    db.commit()     # Confirma a transação (executa o INSERT).
    db.refresh(equipe) # Atualiza o objeto com dados da BD (como o ID gerado).
    return equipe

def get_equipe(db: Session, equipe_id: int) -> Optional[models.Equipe]:
    # Equivalente a: SELECT * FROM equipe WHERE id_equipe = ? LIMIT 1;
    return db.query(models.Equipe).filter(models.Equipe.id_equipe == equipe_id).first()

def list_equipes(db: Session, skip: int = 0, limit: int = 100) -> List[models.Equipe]:
    # Equivalente a: SELECT * FROM equipe OFFSET ? LIMIT ?;
    return db.query(models.Equipe).offset(skip).limit(limit).all()

def update_equipe(db: Session, db_equipe: models.Equipe, equipe_in: schemas.EquipeUpdate) -> models.Equipe:
    # Itera sobre os dados enviados e atualiza os atributos do objeto existente.
    for k, v in equipe_in.dict(exclude_unset=True).items():
        setattr(db_equipe, k, v)
    db.add(db_equipe)
    db.commit()
    db.refresh(db_equipe)
    return db_equipe

# ... (As funções para piloto seguem exatamente a mesma lógica) ...
```

**Conclusão**: Esta é a sua camada de acesso a dados, que traduz as necessidades da sua API em operações de sessão do SQLAlchemy.

### `src/routers/equipes.py` e `src/routers/pilotos.py`

Estes ficheiros definem os endpoints da API.

```python
# Em src/routers/pilotos.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, models
from ..deps import get_db # Função de dependência para obter a sessão da BD.

router = APIRouter(prefix="/pilotos", tags=["pilotos"])

@router.post("/", response_model=schemas.PilotoRead, status_code=status.HTTP_201_CREATED)
def create_piloto(piloto_in: schemas.PilotoCreate, db: Session = Depends(get_db)):
    # `piloto_in`: FastAPI valida o corpo da requisição contra `schemas.PilotoCreate`.
    # `db: Session = Depends(get_db)`: Injeção de Dependência. O FastAPI chama `get_db` para obter uma sessão.

    # Lógica de negócio: verifica se a equipe vinculada existe.
    equipe = db.query(models.Equipe).filter(models.Equipe.id_equipe == piloto_in.id_equipe).first()
    if not equipe:
        raise HTTPException(status_code=400, detail="Equipe vinculada não existe")
    
    # Delega a criação para a camada CRUD.
    piloto = crud.create_piloto(db, piloto_in)
    return piloto # FastAPI converte o objeto `models.Piloto` para JSON usando `schemas.PilotoRead`.

@router.get("/", response_model=List[schemas.PilotoRead])
def read_pilotos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    # `skip` e `limit` são parâmetros de query (ex: /pilotos?skip=0&limit=10).
    return crud.list_pilotos(db, skip=skip, limit=limit)

# ... (outros endpoints como read_piloto por ID, update, delete) ...
```

**Conclusão**: Os routers são a camada de controlo. Eles definem os caminhos, validam as entradas com a ajuda do FastAPI/Pydantic, orquestram a lógica de negócio e delegam o acesso à base de dados à camada CRUD.

### `src/main.py`

O ponto de entrada que une a aplicação.

```python
from fastapi import FastAPI
from .db import engine, Base
from .routers import equipes, pilotos

app = FastAPI(title="F1 API (SQLAlchemy)", version="0.1.0")

# Inclui os routers de equipes e pilotos na aplicação principal.
app.include_router(equipes.router)
app.include_router(pilotos.router)

# Define um evento que corre quando a aplicação arranca.
@app.on_event("startup")
def on_startup():
    # `Base.metadata.create_all` verifica os modelos e cria as tabelas na BD se não existirem.
    # É útil para desenvolvimento, mas em produção, usam-se ferramentas de "migration" (como Alembic).
    Base.metadata.create_all(bind=engine)

@app.get("/", tags=["root"])
def root():
    return {"message": "F1 API com SQLAlchemy - OK"}
```

**Conclusão**: `main.py` inicializa o FastAPI, agrega os routers e configura a criação automática das tabelas no arranque.

---

## Parte 3: O Fluxo de uma Requisição (Exemplo: `GET /pilotos/1`)

1.  **Cliente**: Envia uma requisição `GET` para `http://127.0.0.1:8000/pilotos/1`.
2.  **FastAPI (`main.py`)**: Recebe a requisição e encaminha-a para o `pilotos.router`.
3.  **Router (`routers/pilotos.py`)**: O router encontra o endpoint `@router.get("/{piloto_id}", ...)` e chama a função `read_piloto`, passando `piloto_id=1`.
4.  **Injeção de Dependência (`deps.py`)**: O FastAPI chama `get_db()` e injeta uma `Session` da base de dados na função `read_piloto`.
5.  **Lógica do Endpoint**: A função chama `crud.get_piloto(db, piloto_id=1)`.
6.  **Lógica CRUD (`crud.py`)**: A função `get_piloto` executa `db.query(models.Piloto).filter(models.Piloto.id_piloto == 1).first()`.
7.  **SQLAlchemy**: O ORM traduz a chamada para SQL: `SELECT * FROM piloto WHERE id_piloto = 1 LIMIT 1;`. A base de dados retorna a linha correspondente. O SQLAlchemy usa essa linha para criar um objeto `models.Piloto`. O atributo `piloto.status` neste objeto conterá a **string** lida da base de dados (ex: `"titular"`).
8.  **Retorno do Endpoint**: A função `read_piloto` retorna o objeto `models.Piloto`.
9.  **Serialização da Resposta (Pydantic)**: O FastAPI tenta usar o `response_model=schemas.PilotoRead` para converter o objeto `models.Piloto` em JSON.
10. **O ERRO**: O Pydantic vê o objeto `models.Piloto` e tenta preencher o schema `schemas.PilotoRead`. Quando chega ao campo `status`, ele encontra a string `"titular"` no objeto, mas o schema `schemas.PilotoRead` (que herda de `PilotoCreate`) espera um membro do `Enum` `StatusPiloto`. Como `"titular"` não é o mesmo que `StatusPiloto.titular`, ele lança o `ValidationError`.
11. **Finalização**: Após a tentativa (que falha), o `finally` em `get_db` é executado, fechando a sessão com `db.close()`.

Este é o fluxo exato do seu código e a explicação precisa da causa do erro, baseada na versão que você forneceu. Espero que esta análise detalhada e correta seja útil.
