## O que você vai ver nesse artigo
1. AWS services: apigateway, lambda, dynamodb
1. Localstack Community
1. NodeJs
1. Docker compose
1. Terraform

## O que vamos fazer
### Repositório
### Diagrama
### **Configurando o ambiente:**
Estou usando uma máquina rodando ubuntu:
```bash
    leandro@leandro-desktop ~> lsb_release -a
    No LSB modules are available.
    Distributor ID:	Ubuntu
    Description:	Ubuntu 20.04.3 LTS
    Release:	20.04
    Codename:	focal
```

#### **Docker**
Vamos começar instalando o docker. Segui precisamente a [documentação](https://docs.docker.com/engine/install/ubuntu/) da página oficial para instalação no ubuntu. A versão que tenho instalada nesse momento é a:

```bash
    leandro@leandro-desktop ~> docker -v
    Docker version 20.10.12, build e91ed57
```
#### **Docker Compose**
Docker compose foi um pouco mais complicado a instalação. A página do docker aponta para um compose numa versão bem antiga. Preferi entrar no [repositório do github](https://github.com/docker/compose/releases) para verificar e alterar o endereço no comando fornecido na página do Docker. Desta forma segui os passos:
1. `sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
1. `sudo chmod +x /usr/local/bin/docker-compose`

Nesse momento a versão que tenho do docker-compose instalada é:

```bash
    leandro@leandro-desktop ~> docker-compose -v
    Docker Compose version v2.2.3
```

#### **Python**
A *localstack* utiliza o python para rodar. Dessa forma precisei instalar o compilador python e o gerenciador de pacotes no meu ambiente. Segui a [documentação oficial](https://python.org.br/instalacao-linux/). Instalei as seguintes versões:
```bash
   leandro@leandro-desktop:~$ python3 --version
   Python 3.8.10
   leandro@leandro-desktop:~$ pip --version
   pip 20.0.2 from /usr/lib/python3/dist-packages/pip (python 3.8)
```


#### **Localstack**
Para instalar o localstack eu tentei seguir o repositório oficial que dizia que não deveria ser instalado usando *sudo*, mas não funcionou. Instalei com o seguinte comando:
```bash
   sudo python3 -m pip install localstack
```
e a versão que tenho instalada é:
```bash
leandro@leandro-desktop:~$ localstack --version
0.13.3.1
```
#### **NodeJs**
A escolha de *NodeJs* para esse tutorial foi bastante concorrida com *Python*. Mas pessou o conhecimento e a reutilização do *JavaScrip* em frontends. Aqui vai uma [análise bem interessante](https://dashbird.io/blog/most-efficient-lambda-language/) sobre as possíveis linguagens para desenvolvimento para *AWS Lambdas*.

Para instalar o Node no meu ambiente eu optei por usar o [NVM, gerenciador de versão do node](https://nodejs.org/en/download/package-manager/#nvm). Esse gerenciador pode ser baixado do [repositório oficial](https://github.com/nvm-sh/nvm#install--update-script). Depois de instalado o NVM, basta seguir o [comando descrito no repositório](https://github.com/nvm-sh/nvm#usage).

Com isso a versão do noje na minha máquina ficou:
```bash
leandro@leandro-desktop:~$ node -v
v16.13.2
leandro@leandro-desktop:~$ npm -v
8.1.2
```

## AWS Cloud

## Localstack
### Docker-compose




