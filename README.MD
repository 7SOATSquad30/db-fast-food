# Fast Food DB - Infraestrutura RDS PostgreSQL

Este repositório contém a infraestrutura necessária para provisionar um banco de dados **RDS PostgreSQL** na AWS, utilizando **Terraform**. A infraestrutura inclui a criação de uma **VPC**, **Subnets**, **Security Group**, e o armazenamento de credenciais no **AWS Secrets Manager** e parâmetros no **AWS Systems Manager Parameter Store**.

## Estrutura do Projeto

```bash
/rds-postgres-infra
├── main.tf
├── variables.tf
├── outputs.tf
├── secrets.tf
├── parameters.tf

Arquivos:
main.tf: Define os recursos principais, como a VPC, Subnets, Security Group e o banco de dados RDS PostgreSQL.
variables.tf: Contém as variáveis que podem ser configuradas para personalizar a infraestrutura.
outputs.tf: Exibe as saídas importantes, como o endpoint do banco de dados e o ARN do segredo no Secrets Manager.
secrets.tf: Armazena as credenciais do banco de dados no AWS Secrets Manager.
parameters.tf: Armazena parâmetros como IDs de VPC, Subnets e Security Group no AWS Systems Manager Parameter Store.
Pré-requisitos
Terraform: Certifique-se de ter o Terraform instalado. Você pode seguir as instruções de instalação aqui.
AWS CLI: Configure suas credenciais da AWS utilizando o AWS CLI. Instruções aqui.
Variáveis
As seguintes variáveis podem ser configuradas no arquivo variables.tf:

aws_region: Região da AWS onde os recursos serão provisionados (padrão: us-east-1).
vpc_cidr: CIDR block da VPC (padrão: 10.0.0.0/16).
subnet_1_cidr: CIDR block da primeira Subnet (padrão: 10.0.1.0/24).
subnet_2_cidr: CIDR block da segunda Subnet (padrão: 10.0.2.0/24).
db_name: Nome do banco de dados (padrão: mydb).
db_username: Nome de usuário do banco de dados (padrão: admin).
db_password: Senha do banco de dados (sensível).
Como Usar
1. Inicializar o Terraform
Execute o comando abaixo para inicializar o Terraform e baixar os provedores necessários:




terraform init
2. Visualizar o Plano de Execução
Antes de aplicar as mudanças, visualize o plano de execução com o comando:


terraform apply
Se você quiser aplicar as mudanças automaticamente sem confirmação, use a flag -auto-approve:


terraform apply -auto-approve
3. Destruir a Infraestrutura
Se você quiser remover todos os recursos provisionados, execute o comando:


db_endpoint: Endpoint do banco de dados RDS.
db_credentials_secret_arn: ARN do segredo das credenciais do banco de dados no AWS Secrets Manager.
vpc_id: ID da VPC criada.
subnet_1_id: ID da primeira Subnet.
subnet_2_id: ID da segunda Subnet.
security_group_id: ID do Security Group.
Segurança
As credenciais do banco de dados (nome, usuário, senha e endpoint) são armazenadas de forma segura no AWS Secrets Manager.
IDs de VPC, Subnets e Security Group são armazenados no AWS Systems Manager Parameter Store, facilitando a reutilização desses valores em outros recursos.
Considerações Finais
Flexibilidade: Você pode ajustar as variáveis e os recursos conforme necessário para atender às suas necessidades específicas.
Automação: O repositório está configurado para deploy automatizado utilizando GitHub Actions. Certifique-se de proteger as branches principais (main/master) e utilizar pull requests para qualquer alteração.
Contribuições
Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou enviar um pull request.

Licença
Este projeto está licenciado sob a MIT License.

Esse conteúdo pode ser copiado diretamente para o arquivo `README.md` do seu repositório.
```