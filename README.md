# Conversor de Moedas

Este é um aplicativo de conversão de moedas, desenvolvido em Flutter, que permite aos usuários converter valores entre diferentes moedas utilizando taxas de câmbio em tempo real. O app é ideal para quem precisa de uma ferramenta simples e prática para realizar conversões rápidas durante o dia a dia.

## Funcionalidades

- **Conversão de moedas**: Permite converter valores entre várias moedas (USD, BRL, EUR, etc.).
- **Interface simples e intuitiva**: A interface é fácil de usar, com telas de input e exibição de resultados claros.
- **Cadastro de conversões realizadas**: O app mantém um histórico de conversões, permitindo ao usuário visualizar transações anteriores.
- **Suporte para múltiplas moedas**: A cada nova conversão, o usuário pode escolher a moeda de origem e a moeda de destino.

## Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento para criar interfaces de usuário nativas para Android e iOS.
- **Dart**: Linguagem de programação usada no desenvolvimento do Flutter.
- **JSON-Server**: API fake utilizada para armazenar e recuperar as conversões realizadas.
- **HTTP**: Para comunicação com a API e troca de dados entre o front-end e o back-end.

## Instalação

Para rodar o projeto localmente, siga os passos abaixo:

1. **Clone o repositório**:
    ```bash
    git clone https://github.com/gustavoarnoni/prova-prog-mobile.git
    ```

2. **Navegue até o diretório do projeto**:
    ```bash
    cd conversor_de_moedas
    ```

3. **Instale as dependências**:
    ```bash
    flutter pub get
    ```

4. **Execute o aplicativo**:
    ```bash
    flutter run
    ```

5. **API local (JSON-Server)**: O aplicativo depende de uma API de câmbio. Para rodar a API localmente, instale o `json-server` e inicie o servidor:
    ```bash
    npm install -g json-server
    json-server --watch db.json --port 3000
    ```

6. **Configuração da API**: As informações da API estão configuradas no arquivo `api_service.dart`. A URL padrão para a API é `http://localhost:3000/conversoes`.
