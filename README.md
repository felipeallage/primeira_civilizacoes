# O Nascimento das Civilizações
### Uma análise em SQL/PostgreSQL sobre os fatores que determinaram o surgimento das primeiras civilizações humanas

---

## Pergunta central

**Por que as primeiras civilizações surgiram onde surgiram?**

---

## Sobre o projeto

Este é um estudo de caso analítico — não um dashboard genérico.

Cada query foi escrita para responder uma camada específica da pergunta central. A análise avança em blocos progressivos, construindo evidências até uma conclusão fundamentada em dados.

**8 civilizações. 5 tabelas. 15 queries. Uma resposta.**

---

## Stack

- PostgreSQL 16
- pgAdmin 4
- SQL puro — sem frameworks, sem ORMs

---

## Dataset

Dados modelados manualmente para 8 civilizações:

| # | Civilização | Região | Período |
|---|---|---|---|
| 1 | Suméria | Mesopotâmia | -3500 a -2000 |
| 2 | Egito Antigo | Vale do Nilo | -3100 a -30 |
| 3 | Harappá | Vale do Indo | -2600 a -1900 |
| 4 | China Antiga (Shang) | Vale do Rio Amarelo | -1600 a -1046 |
| 5 | Olmeca | Mesoamérica | -1500 a -400 |
| 6 | Caral | Andes Centrais | -3000 a -1800 |
| 7 | Grécia Antiga | Mar Mediterrâneo | -800 a -146 |
| 8 | Roma Antiga | Itália Central | -753 a 476 |

---

## Estrutura do projeto

```
civilizacoes/
│
├── setup.sql                    — schema completo + inserção de dados
│
├── queries/
│   ├── bloco1_geografia.sql     — rios, clima, altitude e litoral
│   ├── bloco2_recursos.sql      — recursos abundantes e complexidade
│   ├── bloco3_velocidade.sql    — marcos históricos e ritmo de desenvolvimento
│   ├── bloco4_interacoes.sql    — conectividade e difusão cultural
│   └── bloco5_consolidado.sql   — visão unificada e score composto
│
└── README.md
```

---

## Schema do banco

```sql
civilizations   — identidade, população, complexidade social, governo
geographies     — coordenadas, clima, rio, litoral, altitude
resources       — tipo de recurso e abundância por civilização
milestones      — marcos históricos com ano e tipo
interactions    — trocas comerciais, guerras e influências culturais
```

**Views criadas:**
- `vw_civilization_overview` — civilizations + geographies consolidados
- `vw_resources_summary` — recursos por civilização com abundância

---

## Conceitos SQL demonstrados

| Conceito | Onde aparece |
|---|---|
| `JOIN` | Blocos 1, 2, 3, 4, 5 |
| `GROUP BY` + agregações | Blocos 1, 2, 3 |
| `CTE` (WITH) | Blocos 2, 3, 4, 5 |
| `CASE WHEN` | Blocos 1, 2, 4, 5 |
| `Window Functions` (RANK, FIRST_VALUE) | Blocos 2, 3, 4, 5 |
| `Subqueries` | Blocos 4, 5 |
| `UNION ALL` | Bloco 4 |
| `Views` | Bloco 5 |
| `STRING_AGG` | Blocos 1, 2 |
| `COALESCE` | Blocos 2, 5 |
| `FILTER (WHERE)` | Blocos 2, 5 |
| `DISTINCT ON` | Blocos 3, 4 |

---

## Estrutura analítica

### Bloco 1 — Geografia como pré-condição
Rios, clima e altitude como fatores determinantes.

**Achado principal:** 7 de 8 civilizações surgiram próximas a rios. Climas áridos produziram maior complexidade que climas tropicais — a escassez forçou organização onde a abundância dispensava.

---

### Bloco 2 — Recursos e complexidade social
Quantidade vs. tipo de recurso.

**Achado principal:** Agricultura foi pré-condição universal — todas as civilizações a tinham, mas não foi diferencial. Mineração, pedra e argila aparecem nas civilizações mais complexas. Comércio foi o grande multiplicador: a Grécia construiu alta complexidade com apenas 1 recurso abundante.

---

### Bloco 3 — Velocidade de desenvolvimento
Marcos históricos, densidade e ritmo.

**Achado principal:** Três perfis distintos — intensidade (Grécia), longevidade (Egito) e aceleração tardia (Roma). Velocidade e complexidade são dimensões independentes.

---

### Bloco 4 — Interações e difusão cultural
Conectividade, tipo de interação e complexidade.

**Achado principal:** Suméria foi o nó central da rede antiga com 5 interações — mas não a mais complexa. Roma absorveu a Grécia e chegou ao score máximo com 3 interações. Qualidade supera quantidade. Comércio cria riqueza; cultura cria complexidade.

---

### Bloco 5 — Visão consolidada
Painel comparativo completo e score composto.

**Achado principal:** Suméria teve o perfil quantitativo mais completo do dataset — mas não o maior score de complexidade. Grécia foi a mais subestimada pelos dados brutos. Roma foi a mais consistente em todas as dimensões. O que escapa aos números — qualidade das ideias e força das instituições — é o que separa o tier elite das demais.

---

## Conclusão

As primeiras civilizações surgiram onde surgiram porque encontraram a combinação certa de três fatores:

**1. Ambiente desafiador mas viável**
Água disponível, mas não abundante. Solo fértil, mas que exigia gestão coletiva. A dificuldade certa criou a pressão certa.

**2. Recursos que viabilizaram construção e registro**
Agricultura para sustentar, mineração e argila para construir e registrar. Civilizações que deixaram marcas físicas e escritas sobreviveram ao tempo e se tornaram mais complexas.

**3. Conexões que transformaram**
Não apenas trocas comerciais, mas absorção cultural. As civilizações que chegaram mais alto foram as que melhor converteram contato externo em desenvolvimento interno.

> Geografia foi o palco. Recursos foram os instrumentos. Conexões foram o catalisador. E a capacidade de organizar tudo isso — em leis, instituições, monumentos e ideias — foi o que separou as civilizações que apenas existiram das que mudaram o mundo.

---

## Como reproduzir

```bash
# 1. Criar o banco no PostgreSQL
createdb civilizacoes

# 2. Rodar o script de setup
psql -d civilizacoes -f setup.sql

# 3. Validar os dados
psql -d civilizacoes -c "
SELECT 'civilizations' AS tabela, COUNT(*) FROM civilizations
UNION ALL SELECT 'geographies', COUNT(*) FROM geographies
UNION ALL SELECT 'resources', COUNT(*) FROM resources
UNION ALL SELECT 'milestones', COUNT(*) FROM milestones
UNION ALL SELECT 'interactions', COUNT(*) FROM interactions;"

# 4. Rodar as queries por bloco
psql -d civilizacoes -f queries/bloco1_geografia.sql
```

---

## Autor

**Felipe Allage**
Analista de dados | Joinville, SC
[LinkedIn](https://linkedin.com/in/felipeallage) · [GitHub](https://github.com/felipeallage)

---

*Projeto 2 de portfólio em Analytics — 2025*
