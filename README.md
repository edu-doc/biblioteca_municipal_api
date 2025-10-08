# Biblioteca Municipal API

![Logo of the project](https://github.com/edu-doc/biblioteca_municipal_api/blob/main/logo.jpg)

> API RESTful para o sistema de gerenciamento da Biblioteca Municipal Ney Pontes de Mossoró/RN.

Este projeto resolve o Desafio Nº 0003/2025 da Prefeitura de Mossoró, modernizando a gestão da biblioteca através de uma API robusta desenvolvida em Ruby on Rails para ser consumida por um frontend em React.

---

## Funcionalidades Implementadas

Todas as funcionalidades obrigatórias e as sugestões de bônus foram implementadas com foco em segurança, eficiência e experiência do usuário.

### 🔒 Autenticação e Segurança do Bibliotecário
* **Autenticação JWT:** Uso de token de autenticação (JSON Web Token pattern) para todas as rotas restritas.
* **Primeiro Acesso Forçado:** Implementação de uma senha provisória e obrigação de troca de senha no primeiro acesso, garantindo segurança desde o cadastro.
* **Recuperação de Senha por API:** Fluxo de recuperação de senha customizado para APIs, utilizando Devise para o envio de e-mail com token.

### 👤 Gestão de Usuários e Senha de Empréstimo
* **Cadastro Completo:** Registro de usuários com nome, CPF, telefone e e-mail. O campo CPF é validado e único.
* **Geração Automática de Senha:** Geração de uma senha de empréstimo aleatória e automática para cada novo usuário, enviada imediatamente por e-mail.

### 📚 Sistema de Empréstimos Avançado
* **Cálculo de Prazo Otimizado:** A data limite de devolução é calculada em **15 dias úteis** a partir da data do empréstimo, excluindo finais de semana, conforme o requisito do desafio.
* **Renovação Self-Service (Bônus):** O usuário pode renovar o empréstimo online (limite de 2 renovações) fornecendo apenas o ID do livro e sua senha de empréstimo (autoatendimento).
* **Controle de Multas (Bônus):** Geração automática de multa de R$ 1,00 por dia de atraso no ato da devolução.
* **Relatórios (Bônus):** Endpoint dedicado para listar todos os livros em atraso.
* **Histórico (Bônus):** Endpoint para consultar o histórico completo de empréstimos de um usuário.

---

## 🏗️ Arquitetura e Qualidade de Código

O projeto foi construído com foco em testes, seguindo os princípios de Desenvolvimento Orientado a Testes (TTD).

### 🧪 Programação Orientada a Testes (POT) e RSpec
A cobertura de código é garantida pelo **RSpec**, com testes abrangentes em três níveis:
* **Testes de Unidade (Models):** Garantindo a lógica de negócio (ex: validação de CPF, geração de senha de empréstimo, cálculo de multas).
* **Testes de Controlador (Controllers):** Verificando as respostas HTTP e o fluxo da API (ex: sucesso na criação de empréstimo, tratamento de erros de autenticação).
* **Testes de Integração (Swagger/Rswag):** Garantindo que a documentação da API esteja sincronizada e funcional, cobrindo todos os endpoints de forma end-to-end.

### 💻 Tecnologias de Qualidade e Segurança
| Aspecto | Tecnologia/Gem | Detalhe |
| :--- | :--- | :--- |
| **Autenticação** | `devise` | Solução padrão da indústria para gerenciar bibliotecários (login, recuperação de senha).
| **Documentação** | `rswag-api`, `rswag-ui` | Geração automática da documentação OpenAPI/Swagger a partir dos testes de integração, disponibilizando a API documentada em `/api-docs`.
| **Análise Estática** | `rubocop`, `brakeman` | Uso de RuboCop para enforce de estilo de código (Lint) e Brakeman para análise de segurança, integrados ao fluxo de Integração Contínua (CI).
| **Background Jobs** | `solid_queue` | Uso do sistema de filas nativo do Rails para processamento assíncrono (ex: envio de e-mails).

---

## 🛠️ Tecnologias Utilizadas

* **Backend (API):** Ruby on Rails 8.0.2
* **Autenticação:** Devise
* **Testes:** RSpec, FactoryBot, Shoulda Matchers
* **Banco de Dados:** PostgreSQL

# Instalação e Execução

Para executar este projeto localmente, siga os passos abaixo.

## Pré-requisitos
* Ruby (~> 3.x)
* Rails (~> 7.x)
* PostgreSQL

## Backend (API Rails)
* Clone o repositório: `git clone https://github.com/edu-doc/biblioteca_municipal_api.git`
* Instale as dependências (gems): `bundle install`
* Configure o banco de dados e edite o arquivo `.env` com as credenciais do seu banco de dados PostgreSQL.
* Crie, migre e gere o bibliotecario admin: `rails db:create db:migrate db:seed`
* Inicie o servidor Rails: `rails server`

# Diagrama do Banco de Dados

```mermaid
erDiagram
    bibliotecarios {
        int id PK
        varchar nome
        varchar email
        varchar senha
        varchar senha_provisoria
        boolean primario_acesso
        varchar token
        int role
    }
    usuarios {
        int id PK
        varchar nome
        varchar cpf
        varchar telefone
        varchar email
        varchar senha
    }
    categorias {
        int id PK
        varchar nome
    }
    livros {
        int id PK
        varchar titulo
        varchar autor
        book_status status
        text observacoes
        int categoria_id FK
    }
    emprestimos {
        int id PK
        int livro_id FK
        int usuario_id FK
        int bibliotecario_id FK
        timestamp data_emprestimo
        timestamp data_limite_devolucao
        timestamp data_devolucao
        int contador_renovacao
    }
    multas {
        int id PK
        int emprestimo_id FK
        decimal multa
        multa_status status
        timestamp data_pagamento
    }

    categorias ||--o{ livros : "contém"
    livros ||--o{ emprestimos : "é emprestado em"
    usuarios ||--o{ emprestimos : "realiza"
    bibliotecarios ||--o{ emprestimos : "registra"
    emprestimos ||--|| multas : "gera"
