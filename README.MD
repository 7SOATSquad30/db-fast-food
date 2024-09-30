# Banco de Dados para o Sistema de Pedidos e Pagamentos

Este projeto implementa um sistema de pedidos e pagamentos utilizando uma modelagem de dados relacional. A modelagem é projetada para gerenciar categorias de produtos, clientes, pedidos, itens de pedidos e pagamentos. A solução utiliza o Amazon RDS com engine PostgreSQL, aproveitando seus recursos de escalabilidade, segurança e conformidade com ACID.

## Índice

1. [Modelagem de Dados](#modelagem-de-dados)
2. [Justificativa para Utilizar o Amazon RDS com Engine PostgreSQL](#justificativa-para-utilizar-o-amazon-rds-com-engine-postgresql)
3. [Infraestrutura do RDS com Terraform](#infraestrutura-do-rds-com-terraform)
4. [Conclusão](#conclusão)

## Modelagem de Dados

A modelagem de dados pode ser representada pelo seguinte diagrama de entidades e relacionamentos (ERD):

### Entidades

- **tb_category**:
  - `id`: Identificador único da categoria (chave primária).
  - `name`: Nome da categoria (único).
  - `created_at`: Data de criação.
  - `updated_at`: Data de atualização.
  - `deleted_at`: Data de exclusão lógica.

- **tb_product**:
  - `id`: Identificador único do produto (chave primária).
  - `name`: Nome do produto.
  - `price`: Preço do produto.
  - `description`: Descrição do produto.
  - `img_url`: URL da imagem do produto.
  - `category_id`: Chave estrangeira referenciando a tabela `tb_category`.
  - `created_at`: Data de criação.
  - `updated_at`: Data de atualização.
  - `deleted_at`: Data de exclusão lógica.

- **tb_customer**:
  - `id`: Identificador único do cliente (chave primária).
  - `name`: Nome do cliente.
  - `cpf`: CPF do cliente (único).
  - `email`: Email do cliente.
  - `created_at`: Data de criação.
  - `updated_at`: Data de atualização.
  - `deleted_at`: Data de exclusão lógica.

- **tb_order**:
  - `id`: Identificador único do pedido (chave primária).
  - `status`: Status do pedido (valores: 'DRAFT', 'SUBMITTED', 'PREPARING', 'READY', 'DELIVERED', 'CANCELED').
  - `customer_id`: Chave estrangeira referenciando a tabela `tb_customer`.
  - `created_at`: Data de criação.
  - `updated_at`: Data de atualização.
  - `deleted_at`: Data de exclusão lógica.

- **tb_order_item**:
  - `id`: Identificador único do item do pedido (chave primária).
  - `order_id`: Chave estrangeira referenciando a tabela `tb_order`.
  - `product_id`: Chave estrangeira referenciando a tabela `tb_product`.
  - `quantity`: Quantidade do produto no pedido.
  - `total_price`: Preço total do item (baseado na quantidade e preço do produto).

- **tb_payment**:
  - `id`: Identificador único do pagamento (chave primária).
  - `order_id`: Chave estrangeira referenciando a tabela `tb_order` (único, um pedido tem um pagamento).
  - `amount`: Valor do pagamento.
  - `status`: Status do pagamento (valores: 'NOT_SUBMITTED', 'PROCESSING', 'REJECTED', 'COLLECTED').
  - `created_at`: Data de criação.
  - `updated_at`: Data de atualização.
  - `deleted_at`: Data de exclusão lógica.

### Relacionamentos

- **tb_category** tem um relacionamento de 1:N com **tb_product** (uma categoria pode ter vários produtos).
- **tb_customer** tem um relacionamento de 1:N com **tb_order** (um cliente pode fazer vários pedidos).
- **tb_order** tem um relacionamento de 1:N com **tb_order_item** (um pedido pode ter vários itens).
- **tb_product** tem um relacionamento de 1:N com **tb_order_item** (um produto pode estar em vários itens de pedidos).
- **tb_order** tem um relacionamento de 1:1 com **tb_payment** (um pedido tem um pagamento).

## Justificativa para Utilizar o Amazon RDS com Engine PostgreSQL

### Escalabilidade e Desempenho

- O PostgreSQL é conhecido por sua capacidade de lidar com grandes volumes de dados e consultas complexas.
- O Amazon RDS facilita a escalabilidade vertical (aumento de recursos de CPU, memória e armazenamento) e horizontal (replicação de leitura) sem a necessidade de gerenciar a infraestrutura subjacente.

### Conformidade com ACID

- O PostgreSQL é totalmente compatível com as propriedades ACID (Atomicidade, Consistência, Isolamento e Durabilidade), garantindo a integridade dos dados, especialmente em transações financeiras e de pedidos.

### Segurança e Conformidade

- O Amazon RDS oferece criptografia de dados em repouso e em trânsito, backups automáticos e snapshots.
- Facilita a conformidade com regulamentações como GDPR e HIPAA, essenciais para sistemas que lidam com dados sensíveis de clientes.

### Alta Disponibilidade e Recuperação de Desastres

- O Amazon RDS oferece suporte a Multi-AZ (Multi-Availability Zone), garantindo alta disponibilidade e failover automático em caso de falha de hardware ou interrupção de serviço.
- Backups automáticos e snapshots manuais permitem a recuperação de dados em caso de falhas.

### Facilidade de Gerenciamento

- O Amazon RDS gerencia automaticamente tarefas administrativas, como atualizações de software, backups, monitoramento e escalabilidade, reduzindo a carga operacional da equipe.

### Comunidade e Suporte

- O PostgreSQL tem uma comunidade ativa e vasta documentação, facilitando a resolução de problemas e a implementação de novas funcionalidades.
- O suporte da AWS para o RDS garante que qualquer problema crítico seja resolvido rapidamente.

## Infraestrutura do RDS com Terraform

### Recursos Utilizados

- **`provider "aws"`**: Define o provedor AWS e a região onde os recursos serão criados.
  
- **`terraform { backend "s3" }`**: Configura o backend do Terraform para armazenar o estado do projeto em um bucket S3, garantindo que o estado seja compartilhado e persistente.

- **`data "aws_ssm_parameter"`**: Recupera parâmetros armazenados no AWS Systems Manager (SSM), como IDs de VPC e subnets, para reutilização na configuração da infraestrutura.

- **`resource "aws_security_group"`**: Cria um Security Group para o banco de dados, permitindo o tráfego na porta 5432 (PostgreSQL) e controlando o acesso à instância.

- **`resource "aws_db_subnet_group"`**: Define um grupo de subnets onde o banco de dados será implantado, garantindo que ele esteja em subnets privadas.

- **`resource "aws_db_instance"`**: Cria a instância do banco de dados RDS PostgreSQL, especificando parâmetros como nome do banco, usuário, senha, versão do engine e tamanho da instância.

- **`resource "aws_secretsmanager_secret"`**: Cria um segredo no AWS Secrets Manager para armazenar de forma segura as credenciais do banco de dados.

- **`resource "aws_secretsmanager_secret_version"`**: Armazena as credenciais e o endpoint do banco de dados no Secrets Manager, permitindo acesso seguro às informações sensíveis.

- **`output`**: Define saídas que exibem informações importantes, como o endpoint do banco de dados, o ARN do segredo das credenciais e o ID do Security Group.

### Conclusão




## Conclusão

A modelagem de dados proposta é adequada para um sistema de pedidos e pagamentos, com relacionamentos bem definidos entre produtos, categorias, clientes, pedidos e pagamentos. A escolha do Amazon RDS com engine PostgreSQL é justificada pela escalabilidade, desempenho, segurança, conformidade com ACID, suporte a dados não estruturados e facilidade de gerenciamento, tornando-o uma solução robusta e confiável para esse tipo de aplicação.