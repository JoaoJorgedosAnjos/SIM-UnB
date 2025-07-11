# Projeto de Banco de Dados: Sistema de Interesse de Matrícula (UnB)

Este projeto é uma aplicação de backend desenvolvida como parte da disciplina de Banco de Dados. O objetivo é criar um sistema que permita aos alunos da Universidade de Brasília (UnB) manifestarem interesse prévio em disciplinas, ajudando a gestão acadêmica a prever a demanda e os alunos a planejarem melhor seus semestres.

## Problema Resolvido

O sistema busca mitigar a ansiedade e a incerteza do período de matrícula, fornecendo uma plataforma onde a demanda por turmas pode ser visualizada antes do início do processo oficial. Isso permite que alunos, professores e coordenadores tomem decisões mais informadas.

## Tecnologias Utilizadas

* **Linguagem:** Go (Golang)
* **Banco de Dados:** PostgreSQL
* **Roteador HTTP:** [Chi](https://github.com/go-chi/chi)
* **Driver PostgreSQL:** [pgx](https://github.com/jackc/pgx)
* **Documentação da API:** Swagger (OpenAPI)
* **Frontend (Planejado):** Next.js

## Estrutura do Backend

O projeto segue uma arquitetura em camadas para garantir a separação de responsabilidades e a manutenibilidade do código.

```
/seu-projeto-unb/
├── /cmd
│   └── /api
│       └── main.go       # PONTO DE ENTRADA. Inicia o servidor e conecta as camadas.
│
├── /internal             # Onde o código principal do nosso projeto vai morar.
│   ├── /domain           # Nossos modelos/structs principais (Aluno, Curso, etc.).
│   ├── /handler          # Camada que lida com requisições e respostas HTTP.
│   ├── /repository       # Camada que executa todo o código SQL e interage com o BD.
│   └── /service          # Camada que orquestra a lógica de negócio.
│
├── go.mod                # Arquivo que gerencia as dependências do projeto.
├── go.sum                # Checksum das dependências.
└── .env.example          # Exemplo de arquivo para variáveis de ambiente (senha do banco).
```

## Como Executar o Projeto (Setup)

Siga os passos abaixo para configurar e executar o ambiente de desenvolvimento.

### 1. Pré-requisitos

* [Go](https://go.dev/doc/install) (versão 1.18 ou superior)
* [PostgreSQL](https://www.postgresql.org/download/) (versão 14 ou superior)
* [Git](https://git-scm.com/downloads)

### 2. Banco de Dados

Este projeto utiliza um "Script Mestre" para criar e popular o banco de dados do zero.

1.  Certifique-se de que seu servidor PostgreSQL está rodando.
2.  Use o "Script Mestre" (`master_script.sql`) que preparamos. Execute o script inteiro usando seu cliente de banco de dados preferido (DBeaver, DataGrip, `psql`).
3.  O script cuidará de criar o banco `unb_database`, todas as tabelas, e inserir todos os dados de teste.

### 3. Backend (API em Go)

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/](https://github.com/)<seu-usuario-github>/seu-projeto-unb.git
    cd seu-projeto-unb
    ```

2.  **Instale as dependências:**
    ```bash
    go mod tidy
    ```

3.  **Execute o servidor:**
    ```bash
    go run ./cmd/api/main.go
    ```

4.  Você verá a mensagem `Servidor escutando na porta :8080`. Para testar, acesse `http://localhost:8080` no seu navegador e você verá a mensagem "API do Projeto UnB no ar!".

## Endpoints da API

Esta seção será preenchida à medida que desenvolvermos os endpoints. A documentação completa e interativa estará disponível via Swagger na rota `/swagger`.