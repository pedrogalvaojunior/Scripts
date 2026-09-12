# SQL Server Base de conhecimento

Coleção de scripts T-SQL para estudo, desenvolvimento, administração, monitoramento, performance, segurança e troubleshooting no Microsoft SQL Server.

Este repositório reúne conhecimentos, experimentos, estudos de caso, exemplos práticos e soluções utilizadas ao longo de anos de atuação profissional com SQL Server, abrangendo desde conceitos básicos até cenários avançados encontrados em ambientes corporativos.

---

## Sobre o Projeto

Este projeto foi criado com o objetivo de:

- Preservar conhecimento técnico acumulado ao longo da carreira;
- Compartilhar boas práticas relacionadas ao SQL Server;
- Apoiar estudantes, profissionais e pesquisadores;
- Servir como laboratório para testes e experimentos;
- Documentar soluções para problemas reais de administração e desenvolvimento.

Atualmente o repositório contempla scripts relacionados a:

- Desenvolvimento T-SQL
- Administração de Banco de Dados
- Performance Tuning
- Monitoramento
- Segurança
- Recuperação de Dados
- Troubleshooting
- Novos recursos das versões mais recentes do SQL Server

---

# Índice Navegável

## Desenvolvimento

- #functions
- #views
- #stored-procedures
- #triggers
- #cte
- #merge
- #query-dinamica
- #xml

## Administração

- #backup-e-restore
- #tempdb
- #dbcc
- #jobs-and-steps
- #filegroups
- #servicos
- #instancia-e-servidor

## Performance

- #indices
- #plano-de-execucao
- #query-store
- #buffer-e-cache
- #wait-statistics
- #memoria

## Segurança

- #logins-e-users
- #application-roles
- #permissoes
- #password
- #criptografia

## Monitoramento

- #whoisactive
- #auditoria
- #events
- #estatisticas

## Recuperação e Troubleshooting

- #transaction-log
- #entendendo-o-transaction-log
- #recuperacao-de-dados
- #trace-flags

## Recursos por Versão

- #sql-server-2005
- #sql-server-2008
- #sql-server-2012
- #sql-server-2014
- #sql-server-2016
- #sql-server-2017
- #sql-server-2019
- #sql-server-2022

---

# Destaques

## Performance

Scripts relacionados a:

- Fragmentação de índices;
- Rebuild e Reorganize;
- Query Store;
- Wait Statistics;
- Buffer Pool;
- Plano de Execução;
- Diagnóstico de lentidão.

---

## Administração

Scripts para:

- Gestão de bancos de dados;
- Arquivos de dados e logs;
- TempDB;
- SQL Agent Jobs;
- FileGroups;
- Configurações da instância.

---

## Monitoramento

Ferramentas para:

- Análise de sessões;
- Bloqueios;
- Auditoria;
- Estatísticas de utilização;
- Monitoramento de ambiente.

---

## Recovery

Scripts envolvendo:

- Transaction Log;
- Recuperação de dados;
- Bancos SUSPECT;
- Controle e análise de VLFs;
- Diagnóstico de recuperação.

---

# Estrutura das Categorias

## Functions

Funções escalares, table-valued functions e exemplos de utilização.

## Views

Criação e utilização de views para abstração e reaproveitamento de consultas.

## Stored Procedures

Procedimentos armazenados para automação e encapsulamento de regras de negócio.

## Triggers

Exemplos de auditoria, validação e automação através de gatilhos.

## CTE

Expressões de tabela comuns utilizadas para consultas recursivas e organização de código.

## Backup e Restore

Scripts para backup, restore e validação de estratégias de recuperação.

## Índices

Análises de seletividade, fragmentação, manutenção e tuning.

## Query Store

Monitoramento de consultas, regressões de desempenho e troubleshooting.

## Transaction Log

Estudos e exemplos relacionados ao funcionamento interno do log de transações.

## Wait Statistics

Identificação de gargalos e análise de tempo de espera.

## WhoIsActive

Monitoramento de sessões, processos e consultas em execução.

---

# Compatibilidade

O acervo contém exemplos compatíveis com:

- SQL Server 2005
- SQL Server 2008
- SQL Server 2012
- SQL Server 2014
- SQL Server 2016
- SQL Server 2017
- SQL Server 2019
- SQL Server 2022

Alguns scripts utilizam recursos específicos de determinadas versões.

---

# Recomendações de Uso

Antes de executar qualquer script:

1. Leia e compreenda seu funcionamento.
2. Execute inicialmente em ambiente de homologação.
3. Verifique compatibilidade com sua versão do SQL Server.
4. Revise permissões necessárias.
5. Evite utilização direta em produção sem validação prévia.

---

# Público-Alvo

Este material pode ser útil para:

- Estudantes de Banco de Dados;
- Desenvolvedores T-SQL;
- Administradores de Banco de Dados (DBAs);
- Analistas de Dados;
- Professores e pesquisadores;
- Profissionais que trabalham com SQL Server.

---

# Autor

**Pedro Antonio Galvão Junior**

- Especialista em SQL Server
- Professor Universitário
- Pesquisador
- Desenvolvedor e DBA

---

# Contribuições

Sugestões de melhoria, correções e novos exemplos são sempre bem-vindos.

---

# Licença

Este projeto está disponível para fins de estudo e compartilhamento de conhecimento.
