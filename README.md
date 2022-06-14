# LocalStack: o poder da AWS direto da sua máquina
## O que você vai ver nesse artigo
1. AWS services: APIGateway, Lambda, DynamoDB
1. LocalStack Community
1. NodeJs
1. Docker Compose
1. Terraform

## O que vamos fazer
### Definição da nossa POC (Proof of Concept)

![Diagrama do nosso Projeto: Um ApiGateway que recebe requisições que são tratadas por dois Lambdas, um para métodos GET e outro para métodos POST; uma fila SQS onde as mensagens são gravadas e capturadas por outro Lambda que as persiste em um banco de dados DynamoDB.](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/d07uy81jr2ojhqrzmt49.png)

O objetivo desse artigo é exemplificar o uso da LocalStack e o que é necessário para rodar um projeto simples. Para além do que usamos aqui, a ferramenta possui inúmeros outros recursos, bem como outros serviços ofertados pela AWS, que não abordarei.

Nossa POC é portanto muito simples. Trata-se de uma solução que envolve um APIGateway que recebe requisições para busca, listagem e criação de mensagens de vilões famosos. As requests de criação são tratadas por um Lambda criado com NodeJs que grava essas mensagens em uma fila SQS que por sua vez tem um gatilho para que outro Lambda recupere essa frase e a persista em um banco DynamoDB. Na parte de listagem e detalhamento da mensagem, usamos outro Lambda que busca a mensagem da base de dados e retorna para o usuário.

Toda a configuração da aplicação foi feita usando o Terraform com arquivos de configuração bastante simples de entender.

### Repositório
Todo esse projeto e os códigos completos estão disponíveis no seguinte [repositório](https://github.com/leandrostl/localstack-terraform-tutorial). Este texto contém alguns
pedaços de códigos que podem não estar completos.

## *TL;DR*

Para quem quer um passo-a-passo rápido de como verificar e executar essa POC, continue nessa sessão. Se você prefere uma explicação bastante minuciosa das decisões e formas para alcançar o resultado do projeto, pule para a sessão seguinte.

### Preparando o ambiente:

1. Clone o projeto do [repositório](https://github.com/leandrostl/LocalStack-terraform-tutorial);
2. Instale o Docker a partir da [documentação](https://docs.docker.com/engine/install/ubuntu/);
3. Instale o docker-compose:
   1. `sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
   2. `sudo chmod +x /usr/local/bin/docker-compose`
4. Instale o Python seguindo a [documentação oficial](https://python.org.br/instalacao-linux/);
5. Instale o AWS CLI: [página oficial](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html);
6. Instale o Localstack: `sudo python3 -m pip install localstack`
7. Instale o awscli-local: `pip install awscli-local`
8. Siga a [orientação oficial](https://www.terraform.io/downloads) para instalar o Terraform;
9. NodeJs:
   1.  NVM: [repositório oficial](https://github.com/nvm-sh/nvm#install--update-script)
   2.  NodeJs: [comando descrito no repositório](https://github.com/nvm-sh/nvm#usage)

### Rodando a aplicação:

1. No diretório raiz execute o comando: `docker-compose up -d`
2. No diretório terraform execute: 
   1. `terraform init`
   2. `terraform apply --auto-approve`
3. Para testar:
   1. Instale a extensão [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) para o VSCode;
   2. Abra o arquivo `test.http`
   3. Altere a variável `API_ID` para o id informado na saída do terraform;
   4. Clique em send request para envio da request de POST;
   5. Verifique os serviços e logs da sua aplicação em https://app.localstack.cloud/;
   6. Verifique, após alguns segundos, se a frase está salva na base de dados, enviando a request de GET com o seu vilão favorito.

### Matando a aplicação:

1. Use o comando `terraform destroy --auto-approve` a partir do diretório terraform para remover os serviços AWS
2. Do diretório raiz, utilize o comando `docker-compose down -v` para apagar todos os recursos criados através do docker-compose.

## Versão estendida: tudo o que você precisa para criar a sua própria POC

Na sessão anterior, fizemos um passo-a-passo rápido para rodar a aplicação. Nessa sessão vamos ir mais a fundo, e explicar tudo o que for necessário para a criação da sua própria POC, do zero.
### Configurando o ambiente
Estou usando uma máquina rodando Ubuntu 20.04.3 LTS. Tudo o que for feito aqui também é possível usando uma máquina Windows ou Mac. Porém, os métodos para instalação mudam.

#### Docker
Vamos começar instalando o Docker. Segui precisamente a documentação da página oficial para instalação no Ubuntu. Você pode verificar a versão instalada no seu ambiente com o comando `docker -v`. Para mim, ele retorna:  `Docker version 20.10.12, build e91ed57.`
#### Docker Compose
Docker Compose foi um pouco mais complicado para instalar. A página do Docker aponta para uma versão muito antiga do *compose*. Preferi entrar no [repositório do github](https://github.com/docker/compose/releases) para verificar e alterar o endereço no comando fornecido na página do Docker. Desta forma, executei os seguintes comandos:
1. `sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
2. `sudo chmod +x /usr/local/bin/docker-compose`

Agora, a versão que tenho do docker-compose instalada é:

```bash
    leandro@leandro-desktop ~> docker-compose -v
    Docker Compose version v2.2.3
```

#### Python
A *LocalStack* usa o compilador Python. Assim precisei instalá-lo, além do gerenciador de pacotes. Segui a [documentação oficial](https://python.org.br/instalacao-linux/). Instalei as seguintes versões:
```bash
   leandro@leandro-desktop:~$ python3 --version
   Python 3.8.10
   leandro@leandro-desktop:~$ pip --version
   pip 20.0.2 from /usr/lib/python3/dist-packages/pip (python 3.8)
```

#### AWS CLI
Para rodar comandos no terminal para acesso aos dados de serviços da AWS, mesmo que na LocalStack, é necessário usar o *AWS CLI*. Para sua instalação, eu segui o passo a passo informado na [página oficial](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). Verificando a versão, obtive:

```bash
leandro@leandro-desktop ~> aws --version
aws-cli/2.4.11 Python/3.8.8 Linux/5.4.0-94-generic exe/x86_64.ubuntu.20 prompt/off
```

#### LocalStack
Para instalar o LocalStack eu tentei seguir o repositório oficial que dizia que não deveria ser instalado usando *sudo*, mas não funcionou. Instalei com o seguinte comando:
```bash
   sudo python3 -m pip install localstack
```
e a versão que tenho instalada é:
```bash
leandro@leandro-desktop:~$ LocalStack --version
0.13.3.1
```
Também instalei o awscli-local com o comando `pip install awscli-local`. 

#### Terraform
O Terraform é uma ferramenta de código de infraestrutura ou *infrastructure as a code*. É open source e mantido pela HashCorp. Para instalar, segui a [orientação oficial](https://www.terraform.io/downloads). Após instalado, testei a versão para:

```bash
leandro@leandro-desktop:~$ terraform -v
Terraform v1.1.3
on linux_amd64
```

#### NodeJs
A escolha de *NodeJs* para esse tutorial foi bastante concorrida com *Python*. Mas pesou o conhecimento e a reutilização do *JavaScript* em front-end. Aqui vai uma [análise bem interessante](https://dashbird.io/blog/most-efficient-lambda-language/) sobre as possíveis linguagens para desenvolvimento para *AWS Lambdas*.

Para instalar o Node no meu ambiente eu optei por usar o [NVM, gerenciador de versão do NodeJs](https://nodejs.org/en/download/package-manager/#nvm). Esse gerenciador pode ser baixado do [repositório oficial](https://github.com/nvm-sh/nvm#install--update-script). Após instalado o NVM, basta seguir o [comando descrito no repositório](https://github.com/nvm-sh/nvm#usage).

Com isso a versão do Node na minha máquina ficou:
```bash
leandro@leandro-desktop:~$ node -v
v16.13.2
leandro@leandro-desktop:~$ npm -v
8.1.2
```

### AWS Cloud
Escolhi abordar os seguintes serviços da AWS:
* [API Gateway](https://docs.aws.amazon.com/cli/latest/reference/apigateway/index.html): Permite criar endpoints e associá-los a um back-end.
* [Cloudwatch](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudwatch/index.html?highlight=cloudwatch): Permite monitorar a aplicação com alarmes e logs.
* [Lambda](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/index.html): Permite executar uma função sem a necessidade de provisionar ou gerenciar um servidor.
* [DynamoDB](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/index.html): Banco de dados não relacional, *NoSQL*, da AWS.
* [SQS - Simple Queue Service](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/index.html): Como o nome bem informa, é um serviço de filas de mensagens.

As escolhas são baseadas em necessidades pessoais e naquilo que a LocalStack oferece gratuitamente.

### LocalStack
Para iniciar nosso projeto, é necessário subir a LocalStack em um container com as configurações adequadas para o ele. Para isso usei o docker-compose e criei um script seguindo a [página oficial](https://docs.LocalStack.cloud/get-started/#docker-compose). Além disso, busquei compreender e alterar alguns pontos, conforme a [documentação de configuração](https://docs.LocalStack.cloud/localstack/configuration/). Com isso, meu `docker-compose` ficou assim:

```yaml
version: "3.8"

services:
  localstack:
    # Determino o nome do container principal da aplicação.
    container_name: ${LOCALSTACK_DOCKER_NAME-localstack-terraform-tutorial}
    image: localstack/localstack
    network_mode: bridge
    ports:
      - "127.0.0.1:4566:4566"
      - "127.0.0.1:4571:4571"
    environment:
      # Como eu resolvi trocar o nome do container principal eu preciso informar em uma
      # variável de ambiente.
      - MAIN_CONTAINER_NAME=${LOCALSTACK_DOCKER_NAME-localstack-terraform-tutorial}
      # Informo os serviços da AWS que desejo usar.
      - SERVICES=${SERVICES-dynamodb,lambda,apigateway,sqs,cloudwatch}
      # Diretório para salvar dados localmente.
      - DATA_DIR=${DATA_DIR-tmp/localstack/data}
      # Como nossas funções lambda serão executadas. Nesse caso escolho o padrão
      # rodar as funções dentro de containers para cada uma.
      - LAMBDA_EXECUTOR=${LAMBDA_EXECUTOR-docker}
      # Esse parâmetro diz respeito a como a função será passada para o container. 
      # Se ela será montada no container ou será copiada. Nesse caso, escolhi copiar
      # todo o arquivo zip para dentro do container.
      - LAMBDA_REMOTE_DOCKER=true
    volumes:
      - "${TMPDIR:-/tmp}/localstack:/tmp/localstack"
      - "/var/run/docker.sock:/var/run/docker.sock"

```

Para rodar o docker-compose, utilizei o comando `docker-compose up`, ele vai subir todo o ambiente. Se quiser continuar a usar o mesmo terminal para outras coisas, adicione o `-d` de *detach*. Para finalizar e se desfazer de todo o ambiente, basta rodar o `docker-compose down -v`. O `-v` informa que você também quer que os volumes criados sejam excluídos, liberando todos os recursos do computador.

Uma vez em execução, é possível verificar se está tudo funcionando corretamente através da URL http://localhost:4566/health e do [dashboard](https://app.localstack.cloud/) oferecido pela LocalStack.

### Terraform

Agora vamos prover os serviços e suas configurações através do Terraform, especificando os recursos em arquivos `.tf` que coloquei na pasta `terraform`. 
Seguindo a [documentação da LocalStack](https://docs.localstack.cloud/integrations/terraform/), primeiro declaramos o `provider "aws"`:

```hcl
provider "aws" {

  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = var.default_endpoint
    cloudwatch     = var.default_endpoint
    dynamodb       = var.default_endpoint
    iam            = var.default_endpoint
    lambda         = var.default_endpoint
    sqs            = var.default_endpoint
  }
}
``` 

Observe que é necessário apontar os serviços da AWS para o LocalStack. Aqui, eu preferi criar uma variável `default_endpoint` para manter o endereço:

```hcl
variable "default_endpoint" {
  description = "Endpoint padrão para os serviços AWS local."
  default     = "http://localhost:4566"
  type        = string
}
```
#### API
A declaração da api, o recurso quotes e os métodos são bem fáceis de compreender. E tem duas formas de se fazer isso. A primeira, é declarar blocos para cada api, recurso, integração, método:
```hcl
# Declarando nossa api para acesso de frases e os métodos
resource "aws_api_gateway_rest_api" "quotes" {
  name        = "Quotes"
  description = "Api para consumo e envio de frases para a aplicação."
}

resource "aws_api_gateway_resource" "quotes" {
  rest_api_id = aws_api_gateway_rest_api.quotes.id
  parent_id   = aws_api_gateway_rest_api.quotes.root_resource_id
  path_part   = "quotes"
}

resource "aws_api_gateway_method" "get_quotes" {
  rest_api_id   = aws_api_gateway_rest_api.quotes.id
  resource_id   = aws_api_gateway_resource.quotes.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_quote" {
  rest_api_id   = aws_api_gateway_rest_api.quotes.id
  resource_id   = aws_api_gateway_resource.quotes.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "quote_receiver" {
  rest_api_id             = aws_api_gateway_rest_api.quotes.id
  resource_id             = aws_api_gateway_resource.quotes.id
  http_method             = aws_api_gateway_method.post_quote.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.quote_receiver.invoke_arn
}

resource "aws_api_gateway_deployment" "quotes" {
  rest_api_id = aws_api_gateway_rest_api.quotes.id
  stage_name  = "dev"
}
```
Uma forma mais interessante de fazer isso é usando o [OpenAPI](https://spec.openapis.org/oas/v3.1.0) para declarar nossa api. Com isso, o nosso arquivo `rest-api.tf` fica bem mais simples:

```hcl
resource "aws_api_gateway_rest_api" "quotes" {
  name = "Quotes API"
  body = templatefile("./openapi.json",
    {
      quote_receiver = "${aws_lambda_function.quote_receiver.invoke_arn}",
      quote_recover  = "${aws_lambda_function.quote_recover.invoke_arn}"
    }
  )
}

resource "aws_api_gateway_deployment" "quotes" {
  rest_api_id = aws_api_gateway_rest_api.quotes.id
}

resource "aws_api_gateway_stage" "quotes" {
  deployment_id = aws_api_gateway_deployment.quotes.id
  rest_api_id   = aws_api_gateway_rest_api.quotes.id
  stage_name    = "dev"
}
```
Eu prefiro declarar o OpenApi usando yaml, mas, por alguma razão, o Terraform não aceita yaml na sua definição do body. Por isso, instalei a extensão [openapi-designer](https://marketplace.visualstudio.com/items?itemName=philosowaffle.openapi-designer) que compila os arquivos yaml para um único arquivo json. Minha definição para a API ficou assim:

```yaml
openapi: 3.0.3
info:
  title: Quotes Api
  description: Api para consumo e envio de frases para a aplicação.
  version: "1.0"
paths:
  /quotes:
    post:
      summary: Permite gravar uma nova frase vilanesca!
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/Quote"
      x-amazon-apigateway-auth:
        type: none
      x-amazon-apigateway-integration:
        uri: ${quote_receiver}
        httpMethod: POST
        type: AWS_PROXY
      responses:
        "201":
          description: Frase vilanesca gravada com sucesso!
    get:
      summary: Retorna as frases vilanesca de um vilão.
      parameters:
        - name: author
          in: query
          required: true
          description: O grade vilão por trás das frases.
          schema:
            type: string
      x-amazon-apigateway-auth:
        type: none
      x-amazon-apigateway-integration:
        uri: ${quote_recover}
        httpMethod: POST
        type: AWS_PROXY
      responses:
        "200":
          description: As frases vilanescas para o vilão selecionado.
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "#/components/schemas/Quote"
```

Nossa API, portanto, tem um recurso `quote` que é disponível no path de `/quotes` e permite os métodos `POST` e `GET` sem necessidade de qualquer autorização de acesso.

Como vimos em nosso diagrama, o objetivo do projeto é que as frases enviadas sejam enviadas para uma fila por uma função Lambda e depois recuperada por outra função e gravada no banco de dados. Aqui, já declaramos a integração também com a função lambda. Vale notar:

* Observe que a integração agora é passada como parte do método através da propriedade `x-amazon-apigateway-integration`. O mesmo para a authorization com a propriedade `x-amazon-apigateway-auth`.
* O Terraform trata o arquivo pelo método *templatefile* que troca os valores como `${quote_receiver}` pelo valor passado como parâmetro.
* `integration_http_method` tem que ser do tipo `POST` para integração com Lambda. Ele informa como a api vai interagir com o backend;
* `type` deve ser, no nosso caso, `AWS_PROXY`. Isso permite que a integração chame um recurso da AWS, no nosso caso a Lambda, e passe a request para a Lambda tratar.
* No arquivo yaml acima, observe que falta a parte de `components`, que pode ser encontrada no repositório.

#### Lambdas
Para receber a mensagem da API, declaramos no nosso `lambda.tf`:

```hcl
# Lambdas para processar as frases
data "archive_file" "quote_receiver" {
  type        = "zip"
  output_path = "../lambdas/dist/quote_receiver.zip"
  source_dir  = "../lambdas/quote-receiver/"
}

resource "aws_lambda_function" "quote_receiver" {
  function_name    = "quote_receiver"
  filename         = data.archive_file.quote_receiver.output_path
  source_code_hash = data.archive_file.quote_receiver.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  role             = "fake_role"
  environment {
    variables = {
      SQS_URL = "${resource.aws_sqs_queue.quotes.url}"
    }
  }
}

---
resource "aws_lambda_event_source_mapping" "quotes" {
  event_source_arn = aws_sqs_queue.quotes.arn
  function_name    = aws_lambda_function.quote_persister.arn
}

``` 

Geramos aqui um arquivo que foi criado na execução do terraform a partir da compactação dos dados dentro da pasta `lambdas/quote-receiver`. O arquivo compactado é referenciado na criação da função. O mesmo ocorre para nossas outras funções, de persistência dos dados e de recuperação.

Como é possível notar, temos um mapeamento da função `quote_persister` com a fila `SQS`. Isso nos permite receber eventos com as informações inseridas na fila sempre que forem adicionadas novas mensagens à ela.

Um ponto interessante é que é possível passar variáveis de ambiente para a função, como é visto na passagem da variável `SQS_URL`.
#### Fila SQS

Declarar a fila também é muito simples:
```hcl
resource "aws_sqs_queue" "quotes" {
    name = "Quotes"
}
```

#### DynamoDB

O provisionamento de uma tabela nova no dynamo demanda apenas os campos a seguir:

```hcl
resource "aws_dynamodb_table" "quotes" {
    name = "Quotes"
    hash_key = "author"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
      name = "author"
      type = "S"
    }
}
```

Poderíamos informar os demais atributos, mas apenas `hash_key` é obrigatória.
Esse atributo é equivalente para a AWS ao `partition key`. Caso eu desejasse criar uma `sort key` eu deveria passá-la como 
`range_key` e também informar os dados do atributo. No código exemplo usei `sort key` para me permitir usar frases diferentes
do mesmo autor.

### Código

Temos apenas três funções muito simples escritas usando NodeJs: uma para receber quotes, uma para persistir e outra para recuperar. Os códigos completos estão no repositório, mas 
vale a pena pontuar alguns detalhes:

```javascript
const { DynamoDBClient, BatchWriteItemCommand } = require("@aws-sdk/client-dynamodb");
const { Marshaller } = require("@aws/dynamodb-auto-marshaller");


const client = new DynamoDBClient({ endpoint: `http://${process.env.LOCALSTACK_HOSTNAME}:4566` });
const marshaller = new Marshaller();
exports.save = (quotes) => client.send(new BatchWriteItemCommand({
    RequestItems: {
        "Quotes": quotes
            .map(quote => marshaller.marshallItem(quote))
            .map(item => new Object({ PutRequest: { Item: item } }))
    }
}));

```

- O código para persistência de dados no Dynamo mostra o uso da SDK para JavaScript V3. 
- Diferente da V2, essa versão permite importar apenas módulos que realmente serão necessários para a aplicação, deixando a Lambda muito mais leve. 
- É necessário configurar o endpoint para os serviços da AWS.
- Usei a biblioteca `Marshaller` que é um mapper entre valores nativos JavaScript e AttributeValues do DynamoDB.
- A melhor forma de ver logs da aplicação é pelo [dashboard](https://app.localstack.cloud/) da LocalStack.

### Rodando nossa aplicação

Uma vez que o ambiente está rodando através do docker-compose, podemos entrar na pasta `terraform` e executar o comando `terraform init`. Este comando irá criar uma pasta `.terraform` e outros arquivos no projeto. Quando terminado é a vez do comando `terraform apply --auto-approve` que realmente provisiona todos os recurso que declaramos no nossos arquivos `.tf`. Ao final, o comando irá disponibilizar como retorno a `API_ID`, necessária para testarmos a api em um http client.

Assim que a aplicação subir, podemos testar sua funcionalidade com a collection de requests disponível no arquivo `test.http`. Para rodar os testes nesse arquivo é necessário ter instalada a extensão [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) para o Visual Studio Code. Uma vez instalada, troque o valor da variável @API_ID para aquele retornado pelo terraform e clique em send request. 

Para encerrar nossa aplicação, basta rodar o comando `docker-compose down -v` a partir do diretório raiz do projeto.

## Conclusão
A LocalStack é uma ótima ferramenta para rodar a aplicação em ambiente local, durante o desenvolvimento. Ela elimina a preocupação de
se *sujar* um ambiente compartilhado por mais desenvolvedores ou de se acabar tendo gastos financeiros por uso indevido da AWS, melhorando muito o processo de criação do código. Essas funcionalidades ficam ainda mais
interessantes quando se é um iniciante em Cloud por que não há riscos de se acabar pagando por algo que estava nas entrelinhas.

Um aspecto que não foi abordado mas vale a pena pesquisar são as bibliotecas e integração da LocalStack com testes de integração. É possível rodar testes automatizados sem onerar a cloud.





