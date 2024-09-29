# Sistema de Pedidos e Pagamentos

Este projeto implementa um sistema de pedidos e pagamentos utilizando uma modelagem de dados relacional, com base no arquivo `init.sql`. A modelagem é projetada para gerenciar categorias de produtos, clientes, pedidos, itens de pedidos e pagamentos. A solução utiliza o Amazon RDS com engine PostgreSQL, aproveitando seus recursos de escalabilidade, segurança e conformidade com ACID.

## Índice

1. [Modelagem de Dados](#modelagem-de-dados)
2. [Justificativa para Utilizar o Amazon RDS com Engine PostgreSQL](#justificativa-para-utilizar-o-amazon-rds-com-engine-postgresql)
3. [Conclusão](#conclusão)

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

### Suporte a JSON e Dados Não Estruturados

- O PostgreSQL oferece suporte nativo a tipos de dados JSON e JSONB, permitindo armazenar e consultar dados semi-estruturados, útil para informações adicionais sobre produtos, clientes ou pedidos.

### Segurança e Conformidade

- O Amazon RDS oferece criptografia de dados em repouso e em trânsito, backups automáticos e snapshots, além de suporte a controle de acesso baseado em funções (RBAC).
- Facilita a conformidade com regulamentações como GDPR e HIPAA, essenciais para sistemas que lidam com dados sensíveis de clientes.

### Alta Disponibilidade e Recuperação de Desastres

- O Amazon RDS oferece suporte a Multi-AZ (Multi-Availability Zone), garantindo alta disponibilidade e failover automático em caso de falha de hardware ou interrupção de serviço.
- Backups automáticos e snapshots manuais permitem a recuperação de dados em caso de falhas.

### Facilidade de Gerenciamento

- O Amazon RDS gerencia automaticamente tarefas administrativas, como atualizações de software, backups, monitoramento e escalabilidade, reduzindo a carga operacional da equipe.

### Comunidade e Suporte

- O PostgreSQL tem uma comunidade ativa e vasta documentação, facilitando a resolução de problemas e a implementação de novas funcionalidades.
- O suporte da AWS para o RDS garante que qualquer problema crítico seja resolvido rapidamente.

## Conclusão

A modelagem de dados proposta é adequada para um sistema de pedidos e pagamentos, com relacionamentos bem definidos entre produtos, categorias, clientes, pedidos e pagamentos. A escolha do Amazon RDS com engine PostgreSQL é justificada pela escalabilidade, desempenho, segurança, conformidade com ACID, suporte a dados não estruturados e facilidade de gerenciamento, tornando-o uma solução robusta e confiável para esse tipo de aplicação.