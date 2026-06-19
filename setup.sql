-- ============================================================
-- PROJETO 2: O Nascimento das Civilizações
-- Script: criação de schema + inserção de dados
-- Banco: PostgreSQL
-- Autor: Felipe Allage
-- ============================================================

-- ============================================================
-- SCHEMA
-- ============================================================

CREATE TABLE civilizations (
    id                      SERIAL PRIMARY KEY,
    name                    VARCHAR(100) NOT NULL,
    region                  VARCHAR(100),
    start_year              INTEGER,
    end_year                INTEGER,
    peak_population         INTEGER,
    social_complexity_score NUMERIC(4,1),
    government_type         VARCHAR(100),
    writing_system          BOOLEAN
);

CREATE TABLE geographies (
    id                SERIAL PRIMARY KEY,
    civilization_id   INTEGER REFERENCES civilizations(id),
    latitude          NUMERIC(7,4),
    longitude         NUMERIC(7,4),
    climate_zone      VARCHAR(50),
    near_river        BOOLEAN,
    river_name        VARCHAR(100),
    coastal           BOOLEAN,
    elevation_m       INTEGER
);

CREATE TABLE resources (
    id                SERIAL PRIMARY KEY,
    civilization_id   INTEGER REFERENCES civilizations(id),
    resource_type     VARCHAR(100),
    abundance         VARCHAR(20) CHECK (abundance IN ('alta', 'média', 'baixa')),
    notes             TEXT
);

CREATE TABLE milestones (
    id                SERIAL PRIMARY KEY,
    civilization_id   INTEGER REFERENCES civilizations(id),
    milestone_type    VARCHAR(100),
    year              INTEGER,
    notes             TEXT
);

CREATE TABLE interactions (
    id                SERIAL PRIMARY KEY,
    civ_a_id          INTEGER REFERENCES civilizations(id),
    civ_b_id          INTEGER REFERENCES civilizations(id),
    interaction_type  VARCHAR(50) CHECK (interaction_type IN ('comércio', 'guerra', 'cultural')),
    start_year        INTEGER,
    notes             TEXT
);

-- ============================================================
-- DADOS: civilizations
-- ============================================================

INSERT INTO civilizations (id, name, region, start_year, end_year, peak_population, social_complexity_score, government_type, writing_system) VALUES
(1, 'Suméria',              'Mesopotâmia',          -3500, -2000,  800000,   8.5, 'teocracia',               true),
(2, 'Egito Antigo',         'Vale do Nilo',          -3100,   -30, 5000000,   8.8, 'monarquia divina',        true),
(3, 'Harappá',              'Vale do Indo',          -2600, -1900, 5000000,   7.2, 'oligarquia urbana',       true),
(4, 'China Antiga (Shang)', 'Vale do Rio Amarelo',   -1600, -1046, 3000000,   7.8, 'monarquia',               true),
(5, 'Olmeca',               'Mesoamérica',           -1500,  -400,  350000,   6.5, 'teocracia',               false),
(6, 'Caral',                'Andes Centrais',        -3000, -1800,    3000,   6.0, 'teocracia',               false),
(7, 'Grécia Antiga',        'Mar Mediterrâneo',       -800,  -146, 7000000,   9.0, 'cidade-estado/democracia',true),
(8, 'Roma Antiga',          'Itália Central',         -753,   476,70000000,   9.5, 'república/império',       true);

-- ============================================================
-- DADOS: geographies
-- ============================================================

INSERT INTO geographies (civilization_id, latitude, longitude, climate_zone, near_river, river_name, coastal, elevation_m) VALUES
(1, 32.5000,  45.8000, 'árido',            true,  'Tigre e Eufrates', false,  34),
(2, 26.8000,  30.8000, 'árido',            true,  'Nilo',             false,  75),
(3, 27.3000,  68.1000, 'árido',            true,  'Indo',             false,  40),
(4, 34.8000, 114.3000, 'temperado',        true,  'Rio Amarelo',      false, 120),
(5, 18.0000, -95.0000, 'tropical',         true,  'Coatzacoalcos',    true,   50),
(6,-10.9000, -77.8000, 'árido costeiro',   true,  'Supe',             true,  350),
(7, 38.0000,  23.7000, 'mediterrâneo',     false, NULL,               true,  300),
(8, 41.9000,  12.5000, 'mediterrâneo',     true,  'Tibre',            true,   21);

-- ============================================================
-- DADOS: resources
-- ============================================================

INSERT INTO resources (civilization_id, resource_type, abundance, notes) VALUES
(1, 'agricultura', 'alta',   'Irrigação entre Tigre e Eufrates — cevada e trigo'),
(1, 'argila',      'alta',   'Principal material de construção e escrita (tábuas cuneiformes)'),
(1, 'pesca',       'média',  'Rios abundantes em peixes'),
(2, 'agricultura', 'alta',   'Inundação anual do Nilo depositava sedimentos férteis'),
(2, 'pedra',       'alta',   'Calcário e granito para construção monumental'),
(2, 'pesca',       'alta',   'Rio Nilo e Delta'),
(3, 'agricultura', 'alta',   'Planície aluvial do Indo — trigo e cevada'),
(3, 'mineração',   'média',  'Cobre e estanho para bronze'),
(3, 'comércio',    'alta',   'Rede comercial com Mesopotâmia e Golfo Pérsico'),
(4, 'agricultura', 'alta',   'Loess fértil do Rio Amarelo — painço e arroz'),
(4, 'seda',        'média',  'Sericultura já presente no período Shang'),
(4, 'bronze',      'alta',   'Produção avançada de bronze para rituais e guerra'),
(5, 'agricultura', 'média',  'Milho e mandioca em ambiente tropical'),
(5, 'borracha',    'alta',   'Látex de árvores nativas'),
(5, 'pesca',       'alta',   'Costa do Golfo do México'),
(6, 'agricultura', 'média',  'Algodão e abóbora — irrigação artificial no deserto costeiro'),
(6, 'pesca',       'alta',   'Costa do Pacífico — principal fonte de proteína'),
(6, 'comércio',    'média',  'Rede andina de intercâmbio'),
(7, 'comércio',    'alta',   'Controle das rotas marítimas do Mediterrâneo'),
(7, 'agricultura', 'média',  'Oliveiras, uvas e cereais'),
(7, 'mineração',   'média',  'Prata e mármore'),
(8, 'agricultura', 'alta',   'Solo vulcânico fértil na Itália Central'),
(8, 'comércio',    'alta',   'Controle do Mediterrâneo e rotas terrestres'),
(8, 'mineração',   'alta',   'Ferro, chumbo e ouro em províncias conquistadas');

-- ============================================================
-- DADOS: milestones
-- ============================================================

INSERT INTO milestones (civilization_id, milestone_type, year, notes) VALUES
(1, 'urbanização',              -3500, 'Uruk — primeira grande cidade da história com +50.000 habitantes'),
(1, 'escrita',                  -3200, 'Escrita cuneiforme para registros administrativos'),
(1, 'metalurgia',               -3000, 'Bronze a partir de cobre e estanho'),
(1, 'código de leis',           -1754, 'Código de Hamurabi'),
(2, 'unificação política',      -3100, 'Faraó Narmer une Alto e Baixo Egito'),
(2, 'escrita',                  -3000, 'Hieróglifos para registros religiosos e administrativos'),
(2, 'arquitetura monumental',   -2560, 'Grande Pirâmide de Gizé'),
(2, 'calendário',               -2800, 'Calendário solar de 365 dias'),
(3, 'urbanização',              -2600, 'Mohenjo-daro e Harappá — cidades planejadas com esgoto'),
(3, 'escrita',                  -2600, 'Escrita Indus — ainda não decifrada'),
(3, 'padronização',             -2500, 'Pesos e medidas padronizados em toda a rede urbana'),
(4, 'escrita',                  -1200, 'Oracle bones — escrita divinatória em ossos e carapaças'),
(4, 'metalurgia',               -1600, 'Bronzes rituais de alta complexidade técnica'),
(4, 'urbanização',              -1500, 'Anyang — capital do período Shang tardio'),
(5, 'arquitetura monumental',   -1200, 'Cabeças colossais de basalto'),
(5, 'calendário',                -900, 'Sistema calendário de 365 dias'),
(5, 'urbanização',              -1000, 'San Lorenzo — primeiro centro urbano da Mesoamérica'),
(6, 'arquitetura monumental',   -2600, 'Pirâmides de Caral — mais antigas das Américas'),
(6, 'urbanização',              -3000, 'Caral — cidade com ~3000 habitantes sem escrita nem cerâmica'),
(6, 'agricultura especializada',-2800, 'Sistema de irrigação para algodão'),
(7, 'democracia',                -508, 'Reformas de Clístenes em Atenas'),
(7, 'filosofia',                 -585, 'Pré-socráticos — início do pensamento racional ocidental'),
(7, 'arquitetura monumental',    -447, 'Construção do Partenon'),
(7, 'escrita',                   -800, 'Alfabeto grego derivado do fenício'),
(8, 'república',                 -509, 'Fundação da República Romana'),
(8, 'direito',                   -450, 'Lei das XII Tábuas'),
(8, 'arquitetura monumental',     -80, 'Coliseu iniciado sob Vespasiano'),
(8, 'engenharia',                -312, 'Via Ápia — primeira grande estrada pavimentada');

-- ============================================================
-- DADOS: interactions
-- ============================================================

INSERT INTO interactions (civ_a_id, civ_b_id, interaction_type, start_year, notes) VALUES
(1, 2, 'comércio', -3000, 'Evidências de troca de lápis-lazúli e tecidos entre Mesopotâmia e Egito'),
(1, 3, 'comércio', -2500, 'Rota comercial via Golfo Pérsico — metais e têxteis'),
(1, 2, 'guerra',   -1274, 'Batalha de Kadesh entre hititas (aliados da Mesopotâmia) e Egito'),
(2, 7, 'cultural', -800,  'Influência egípcia na escultura e arquitetura grega arcaica'),
(3, 1, 'comércio', -2300, 'Selos Harappá encontrados em Ur — evidência de comércio direto'),
(7, 8, 'cultural', -300,  'Roma absorve cultura grega após conquista da Magna Grécia'),
(7, 8, 'guerra',   -264,  'Primeira Guerra Púnica — Roma vs Cartago (aliada grega)'),
(7, 8, 'cultural', -146,  'Conquista romana da Grécia — helenização de Roma'),
(1, 4, 'cultural', -1500, 'Possível transmissão de técnicas de bronze via rotas da Ásia Central'),
(5, 6, 'cultural', -1000, 'Possível intercâmbio cultural entre Mesoamérica e Andes via rotas costeiras');

-- ============================================================
-- VIEWS ANALÍTICAS
-- ============================================================

-- Vista consolidada principal
CREATE VIEW vw_civilization_overview AS
SELECT
    c.id,
    c.name,
    c.region,
    c.start_year,
    c.end_year,
    c.peak_population,
    c.social_complexity_score,
    c.government_type,
    c.writing_system,
    g.climate_zone,
    g.near_river,
    g.river_name,
    g.coastal,
    g.elevation_m
FROM civilizations c
LEFT JOIN geographies g ON g.civilization_id = c.id;

-- Vista de recursos por civilização
CREATE VIEW vw_resources_summary AS
SELECT
    c.name,
    r.resource_type,
    r.abundance
FROM civilizations c
JOIN resources r ON r.civilization_id = c.id
ORDER BY c.name, r.abundance DESC;
