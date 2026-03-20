PRAGMA foreign_keys= OFF;
BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS MetaData
(
    element TEXT PRIMARY KEY,
    value   INT,
    notes   TEXT
);
REPLACE INTO MetaData
VALUES ('DB_MAJOR', 3, 'DB major version number');
REPLACE INTO MetaData
VALUES ('DB_MINOR', 1, 'DB minor version number');
REPLACE INTO MetaData
VALUES ('days_per_period', 365, 'count of days in each period');

CREATE TABLE IF NOT EXISTS MetaDataReal
(
    element TEXT PRIMARY KEY,
    value   REAL,
    notes   TEXT
);
REPLACE INTO MetaDataReal
VALUES ('global_discount_rate', 0.03, 'Canadian social discount rate');
REPLACE INTO MetaDataReal
VALUES ('default_loan_rate', 0.03, 'Matching GDR');

CREATE TABLE IF NOT EXISTS SeasonLabel
(
    season TEXT
        PRIMARY KEY,
    notes  TEXT
);
CREATE TABLE IF NOT EXISTS SectorLabel
(
    sector TEXT,
    notes  TEXT,
    PRIMARY KEY (sector)
);
CREATE TABLE IF NOT EXISTS CapacityCredit
(
    region  TEXT,
    period  INTEGER
        REFERENCES TimePeriod (period),
    tech    TEXT,
    vintage INTEGER,
    credit  REAL,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, period, tech, vintage, data_id),
    CHECK (credit >= 0 AND credit <= 1)
);
CREATE TABLE IF NOT EXISTS CapacityFactorProcess
(
    region  TEXT,
    period  INTEGER
        REFERENCES TimePeriod (period),
    season TEXT
        REFERENCES SeasonLabel (season),
    tod     TEXT
        REFERENCES TimeOfDay (tod),
    tech    TEXT,
    vintage INTEGER,
    factor  REAL,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, period, season, tod, tech, vintage, data_id),
    CHECK (factor >= 0 AND factor <= 1)
);
CREATE TABLE IF NOT EXISTS CapacityFactorTech
(
    region TEXT,
    period INTEGER
        REFERENCES TimePeriod (period),
    season TEXT
        REFERENCES SeasonLabel (season),
    tod    TEXT
        REFERENCES TimeOfDay (tod),
    tech   TEXT,
    factor REAL,
    notes  TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, period, season, tod, tech, data_id),
    CHECK (factor >= 0 AND factor <= 1)
);
CREATE TABLE IF NOT EXISTS CapacityToActivity
(
    region TEXT,
    tech   TEXT,
    c2a    REAL,
    notes  TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, tech, data_id)
);
CREATE TABLE IF NOT EXISTS CommodityLabel
(
    commodity TEXT
        PRIMARY KEY,
    notes  TEXT
);
CREATE TABLE IF NOT EXISTS Commodity
(
    name        TEXT,
    flag        TEXT
        REFERENCES CommodityType (label),
    description TEXT,
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (name) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (name, data_id)
);
CREATE TABLE IF NOT EXISTS CommodityType
(
    label       TEXT PRIMARY KEY,
    description TEXT
);
REPLACE INTO CommodityType
VALUES ('s', 'source commodity');
REPLACE INTO CommodityType
VALUES ('a', 'annual commodity');
REPLACE INTO CommodityType
VALUES ('p', 'physical commodity');
REPLACE INTO CommodityType
VALUES ('d', 'demand commodity');
REPLACE INTO CommodityType
VALUES ('e', 'emissions commodity');
REPLACE INTO CommodityType
VALUES ('w', 'waste commodity');
REPLACE INTO CommodityType
VALUES ('wa', 'waste annual commodity');
REPLACE INTO CommodityType
VALUES ('wp', 'waste physical commodity');
CREATE TABLE IF NOT EXISTS ConstructionInput
(
    region      TEXT,
    input_comm   TEXT,
    tech        TEXT,
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    value       REAL,
    units       TEXT,
    notes       TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (input_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, input_comm, tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS CostEmission
(
    region    TEXT,
    period    INTEGER
        REFERENCES TimePeriod (period),
    emis_comm TEXT NOT NULL,
    cost      REAL NOT NULL,
    units     TEXT,
    notes     TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (emis_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, period, emis_comm, data_id)
);
CREATE TABLE IF NOT EXISTS CostFixed
(
    region  TEXT    NOT NULL,
    period  INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    tech    TEXT    NOT NULL,
    vintage INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    cost    REAL,
    units   TEXT,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, period, tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS CostInvest
(
    region  TEXT,
    tech    TEXT,
    vintage INTEGER
        REFERENCES TimePeriod (period),
    cost    REAL,
    units   TEXT,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS CostVariable
(
    region  TEXT    NOT NULL,
    period  INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    tech    TEXT    NOT NULL,
    vintage INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    cost    REAL,
    units   TEXT,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, period, tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS Demand
(
    region    TEXT,
    period    INTEGER
        REFERENCES TimePeriod (period),
    commodity TEXT,
    demand    REAL,
    units     TEXT,
    notes     TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (commodity) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, period, commodity, data_id)
);
CREATE TABLE IF NOT EXISTS DemandSpecificDistribution
(
    region      TEXT,
    period      INTEGER
        REFERENCES TimePeriod (period),
    season TEXT
        REFERENCES SeasonLabel (season),
    tod         TEXT
        REFERENCES TimeOfDay (tod),
    demand_name TEXT,
    dsd         REAL,
    notes       TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (demand_name) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, period, season, tod, demand_name, data_id),
    CHECK (dsd >= 0 AND dsd <= 1)
);
CREATE TABLE IF NOT EXISTS EndOfLifeOutput
(
    region      TEXT,
    tech        TEXT,
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    output_comm   TEXT,
    value       REAL,
    units       TEXT,
    notes       TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (output_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, tech, vintage, output_comm, data_id)
);
CREATE TABLE IF NOT EXISTS Efficiency
(
    region      TEXT,
    input_comm  TEXT,
    tech        TEXT,
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    output_comm TEXT,
    efficiency  REAL,
    notes       TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (input_comm) REFERENCES CommodityLabel (commodity),
    FOREIGN KEY (output_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, input_comm, tech, vintage, output_comm, data_id),
    CHECK (efficiency > 0)
);
CREATE TABLE IF NOT EXISTS EfficiencyVariable
(
    region      TEXT,
    period      INTEGER
        REFERENCES TimePeriod (period),
    season TEXT
        REFERENCES SeasonLabel (season),
    tod         TEXT
        REFERENCES TimeOfDay (tod),
    input_comm  TEXT,
    tech        TEXT,
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    output_comm TEXT,
    efficiency  REAL,
    notes       TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (input_comm) REFERENCES CommodityLabel (commodity),
    FOREIGN KEY (output_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, period, season, tod, input_comm, tech, vintage, output_comm, data_id),
    CHECK (efficiency > 0)
);
CREATE TABLE IF NOT EXISTS EmissionActivity
(
    region      TEXT,
    emis_comm   TEXT,
    input_comm  TEXT,
    tech        TEXT,
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    output_comm TEXT,
    activity    REAL,
    units       TEXT,
    notes       TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (emis_comm) REFERENCES CommodityLabel (commodity),
    FOREIGN KEY (input_comm) REFERENCES CommodityLabel (commodity),
    FOREIGN KEY (output_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, emis_comm, input_comm, tech, vintage, output_comm, data_id)
);
CREATE TABLE IF NOT EXISTS EmissionEmbodied
(
    region      TEXT,
    emis_comm   TEXT,
    tech        TEXT,
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    value       REAL,
    units       TEXT,
    notes       TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (emis_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, emis_comm,  tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS EmissionEndOfLife
(
    region      TEXT,
    emis_comm   TEXT,
    tech        TEXT,
    vintage     INTEGER
        REFERENCES TimePeriod (period),
    value       REAL,
    units       TEXT,
    notes       TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (emis_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, emis_comm,  tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS ExistingCapacity
(
    region   TEXT,
    tech     TEXT,
    vintage  INTEGER
        REFERENCES TimePeriod (period),
    capacity REAL,
    units    TEXT,
    notes    TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS TechGroup
(
    group_name TEXT,
    notes      TEXT,
    data_id TEXT
        REFERENCES DataSet (data_id),
    PRIMARY KEY (group_name, data_id)
);
CREATE TABLE IF NOT EXISTS LoanLifetimeProcess
(
    region   TEXT,
    tech     TEXT,
    vintage  INTEGER
        REFERENCES TimePeriod (period),
    lifetime REAL,
    notes    TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS LoanRate
(
    region  TEXT,
    tech    TEXT,
    vintage INTEGER
        REFERENCES TimePeriod (period),
    rate    REAL,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS LifetimeProcess
(
    region   TEXT,
    tech     TEXT,
    vintage  INTEGER
        REFERENCES TimePeriod (period),
    lifetime REAL,
    notes    TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS LifetimeTech
(
    region   TEXT,
    tech     TEXT,
    lifetime REAL,
    notes    TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, tech, data_id)
);
CREATE TABLE IF NOT EXISTS Operator
(
	operator TEXT PRIMARY KEY,
	notes TEXT
);
REPLACE INTO Operator VALUES('e','equal to');
REPLACE INTO Operator VALUES('le','less than or equal to');
REPLACE INTO Operator VALUES('ge','greater than or equal to');
CREATE TABLE IF NOT EXISTS LimitGrowthCapacity
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitDegrowthCapacity
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitGrowthNewCapacity
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitDegrowthNewCapacity
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitGrowthNewCapacityDelta
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitDegrowthNewCapacityDelta
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitStorageLevelFraction
(
    region   TEXT,
    period   INTEGER
        REFERENCES TimePeriod (period),
    season TEXT
        REFERENCES SeasonLabel (season),
    tod      TEXT
        REFERENCES TimeOfDay (tod),
    tech     TEXT,
    vintage  INTEGER
        REFERENCES TimePeriod (period),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    fraction REAL,
    notes    TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, period, season, tod, tech, vintage, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitActivity
(
    region  TEXT,
    period  INTEGER
        REFERENCES TimePeriod (period),
    tech_or_group   TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    activity REAL,
    units   TEXT,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, period, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitActivityShare
(
    region         TEXT,
    period         INTEGER
        REFERENCES TimePeriod (period),
    sub_group      TEXT,
    super_group    TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    share REAL,
    notes          TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, period, sub_group, super_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitAnnualCapacityFactor
(
    region      TEXT,
    tech        TEXT,
    vintage      INTEGER
        REFERENCES TimePeriod (period),
    output_comm TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    factor      REAL,
    notes       TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (output_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, tech, vintage, output_comm, operator, data_id),
    CHECK (factor >= 0 AND factor <= 1)
);
CREATE TABLE IF NOT EXISTS LimitCapacity
(
    region  TEXT,
    period  INTEGER
        REFERENCES TimePeriod (period),
    tech_or_group   TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    capacity REAL,
    units   TEXT,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, period, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitCapacityShare
(
    region         TEXT,
    period         INTEGER
        REFERENCES TimePeriod (period),
    sub_group      TEXT,
    super_group    TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    share REAL,
    notes          TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, period, sub_group, super_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitNewCapacity
(
    region  TEXT,
    period  INTEGER
        REFERENCES TimePeriod (period),
    tech_or_group   TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    new_cap REAL,
    units   TEXT,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, period, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitNewCapacityShare
(
    region         TEXT,
    period         INTEGER
        REFERENCES TimePeriod (period),
    sub_group      TEXT,
    super_group    TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    share REAL,
    notes          TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, period, sub_group, super_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitResource
(
    region  TEXT,
    tech_or_group   TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    cum_act REAL,
    units   TEXT,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, tech_or_group, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitSeasonalCapacityFactor
(
	region  TEXT,
	period	INTEGER
        REFERENCES TimePeriod (period),
	season TEXT
        REFERENCES SeasonLabel (season),
	tech    TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
	factor	REAL,
	notes	TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (region) REFERENCES Region (region),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
	PRIMARY KEY (region, period, season, tech, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitTechInputSplit
(
    region         TEXT,
    period         INTEGER
        REFERENCES TimePeriod (period),
    input_comm     TEXT,
    tech           TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    proportion REAL,
    notes          TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (input_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, period, input_comm, tech, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitTechInputSplitAnnual
(
    region         TEXT,
    period         INTEGER
        REFERENCES TimePeriod (period),
    input_comm     TEXT,
    tech           TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    proportion REAL,
    notes          TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, period, input_comm, tech, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitTechOutputSplit
(
    region         TEXT,
    period         INTEGER
        REFERENCES TimePeriod (period),
    tech           TEXT,
    output_comm    TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    proportion REAL,
    notes          TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (output_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, period, tech, output_comm, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitTechOutputSplitAnnual
(
    region         TEXT,
    period         INTEGER
        REFERENCES TimePeriod (period),
    tech           TEXT,
    output_comm    TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    proportion REAL,
    notes          TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (output_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, period, tech, output_comm, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LimitEmission
(
    region    TEXT,
    period    INTEGER
        REFERENCES TimePeriod (period),
    emis_comm TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES Operator (operator),
    value     REAL,
    units     TEXT,
    notes     TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (emis_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (region, period, emis_comm, operator, data_id)
);
CREATE TABLE IF NOT EXISTS LinkedTech
(
    primary_region TEXT,
    primary_tech   TEXT,
    emis_comm      TEXT,
    driven_tech    TEXT,
    notes          TEXT,
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (primary_tech, data_id) REFERENCES Technology (tech, data_id),
    FOREIGN KEY (driven_tech, data_id) REFERENCES Technology (tech, data_id),
    FOREIGN KEY (emis_comm) REFERENCES CommodityLabel (commodity),
    PRIMARY KEY (primary_region, primary_tech, emis_comm, data_id)
);
CREATE TABLE IF NOT EXISTS PlanningReserveMargin
(
    region TEXT,
    margin REAL,
    notes TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (region) REFERENCES Region (region),
    PRIMARY KEY (region, data_id)
);
CREATE TABLE IF NOT EXISTS RampDownHourly
(
    region TEXT,
    tech   TEXT,
    rate   REAL,
    notes TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, tech, data_id)
);
CREATE TABLE IF NOT EXISTS RampUpHourly
(
    region TEXT,
    tech   TEXT,
    rate   REAL,
    notes TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, tech, data_id)
);
CREATE TABLE IF NOT EXISTS Region
(
    region TEXT,
    notes  TEXT,
    PRIMARY KEY (region)
);
CREATE TABLE IF NOT EXISTS ReserveCapacityDerate
(
    region  TEXT,
    period  INTEGER
        REFERENCES TimePeriod (period),
    season  TEXT
    	REFERENCES SeasonLabel (season),
    tech    TEXT,
    vintage INTEGER,
    factor  REAL,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, period, season, tech, vintage, data_id),
    CHECK (factor >= 0 AND factor <= 1)
);
CREATE TABLE IF NOT EXISTS TimeSegmentFraction
(   
    period INTEGER
        REFERENCES TimePeriod (period),
    season TEXT
        REFERENCES SeasonLabel (season),
    tod     TEXT
        REFERENCES TimeOfDay (tod),
    segfrac REAL,
    notes   TEXT,
    PRIMARY KEY (period, season, tod),
    CHECK (segfrac >= 0 AND segfrac <= 1)
);
CREATE TABLE IF NOT EXISTS StorageDuration
(
    region   TEXT,
    tech     TEXT,
    duration REAL,
    notes    TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (region, tech, data_id)
);
CREATE TABLE IF NOT EXISTS LifetimeSurvivalCurve
(
    region  TEXT    NOT NULL,
    period  INTEGER NOT NULL,
    tech    TEXT    NOT NULL,
    vintage INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    fraction  REAL,
    notes   TEXT,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (region, period, tech, vintage, data_id)
);
CREATE TABLE IF NOT EXISTS TechnologyType
(
    label       TEXT PRIMARY KEY,
    description TEXT
);
REPLACE INTO TechnologyType
VALUES ('p', 'production technology');
REPLACE INTO TechnologyType
VALUES ('pb', 'baseload production technology');
REPLACE INTO TechnologyType
VALUES ('ps', 'storage production technology');
-- CREATE TABLE IF NOT EXISTS TimeNext
-- (
--     period       INTEGER
--         REFERENCES TimePeriod (period),
--     season TEXT
--        REFERENCES SeasonLabel (season),
--     tod          TEXT
--         REFERENCES TimeOfDay (tod),
--     season_next TEXT
--        REFERENCES SeasonLabel (season),
--     tod_next     TEXT
--         REFERENCES TimeOfDay (tod),
--     notes        TEXT,
--     PRIMARY KEY (period, season, tod, data_id)
-- );
CREATE TABLE IF NOT EXISTS TimeOfDay
(
    sequence INTEGER UNIQUE,
    tod      TEXT
        PRIMARY KEY
);
INSERT INTO TimeOfDay VALUES(0,'H01');
INSERT INTO TimeOfDay VALUES(1,'H02');
INSERT INTO TimeOfDay VALUES(2,'H03');
INSERT INTO TimeOfDay VALUES(3,'H04');
INSERT INTO TimeOfDay VALUES(4,'H05');
INSERT INTO TimeOfDay VALUES(5,'H06');
INSERT INTO TimeOfDay VALUES(6,'H07');
INSERT INTO TimeOfDay VALUES(7,'H08');
INSERT INTO TimeOfDay VALUES(8,'H09');
INSERT INTO TimeOfDay VALUES(9,'H10');
INSERT INTO TimeOfDay VALUES(10,'H11');
INSERT INTO TimeOfDay VALUES(11,'H12');
INSERT INTO TimeOfDay VALUES(12,'H13');
INSERT INTO TimeOfDay VALUES(13,'H14');
INSERT INTO TimeOfDay VALUES(14,'H15');
INSERT INTO TimeOfDay VALUES(15,'H16');
INSERT INTO TimeOfDay VALUES(16,'H17');
INSERT INTO TimeOfDay VALUES(17,'H18');
INSERT INTO TimeOfDay VALUES(18,'H19');
INSERT INTO TimeOfDay VALUES(19,'H20');
INSERT INTO TimeOfDay VALUES(20,'H21');
INSERT INTO TimeOfDay VALUES(21,'H22');
INSERT INTO TimeOfDay VALUES(22,'H23');
INSERT INTO TimeOfDay VALUES(23,'H24');
CREATE TABLE IF NOT EXISTS TimePeriod
(
    sequence INTEGER UNIQUE,
    period   INTEGER
        PRIMARY KEY,
    flag     TEXT
        REFERENCES TimePeriodType (label)
);
REPLACE INTO TimePeriod VALUES (0, 2025, 'f');
REPLACE INTO TimePeriod VALUES (1, 2030, 'f');
REPLACE INTO TimePeriod VALUES (2, 2035, 'f');
REPLACE INTO TimePeriod VALUES (3, 2040, 'f');
REPLACE INTO TimePeriod VALUES (4, 2045, 'f');
REPLACE INTO TimePeriod VALUES (5, 2050, 'f');
CREATE TABLE IF NOT EXISTS TimeSeason
(
    period INTEGER
        REFERENCES TimePeriod (period),
    sequence INTEGER,
    season TEXT
        REFERENCES SeasonLabel (season),
    notes TEXT,
    PRIMARY KEY (period, sequence, season)
);
INSERT INTO SeasonLabel VALUES('D001',NULL);
INSERT INTO SeasonLabel VALUES('D002',NULL);
INSERT INTO SeasonLabel VALUES('D003',NULL);
INSERT INTO SeasonLabel VALUES('D004',NULL);
INSERT INTO SeasonLabel VALUES('D005',NULL);
INSERT INTO SeasonLabel VALUES('D006',NULL);
INSERT INTO SeasonLabel VALUES('D007',NULL);
INSERT INTO SeasonLabel VALUES('D008',NULL);
INSERT INTO SeasonLabel VALUES('D009',NULL);
INSERT INTO SeasonLabel VALUES('D010',NULL);
INSERT INTO SeasonLabel VALUES('D011',NULL);
INSERT INTO SeasonLabel VALUES('D012',NULL);
INSERT INTO SeasonLabel VALUES('D013',NULL);
INSERT INTO SeasonLabel VALUES('D014',NULL);
INSERT INTO SeasonLabel VALUES('D015',NULL);
INSERT INTO SeasonLabel VALUES('D016',NULL);
INSERT INTO SeasonLabel VALUES('D017',NULL);
INSERT INTO SeasonLabel VALUES('D018',NULL);
INSERT INTO SeasonLabel VALUES('D019',NULL);
INSERT INTO SeasonLabel VALUES('D020',NULL);
INSERT INTO SeasonLabel VALUES('D021',NULL);
INSERT INTO SeasonLabel VALUES('D022',NULL);
INSERT INTO SeasonLabel VALUES('D023',NULL);
INSERT INTO SeasonLabel VALUES('D024',NULL);
INSERT INTO SeasonLabel VALUES('D025',NULL);
INSERT INTO SeasonLabel VALUES('D026',NULL);
INSERT INTO SeasonLabel VALUES('D027',NULL);
INSERT INTO SeasonLabel VALUES('D028',NULL);
INSERT INTO SeasonLabel VALUES('D029',NULL);
INSERT INTO SeasonLabel VALUES('D030',NULL);
INSERT INTO SeasonLabel VALUES('D031',NULL);
INSERT INTO SeasonLabel VALUES('D032',NULL);
INSERT INTO SeasonLabel VALUES('D033',NULL);
INSERT INTO SeasonLabel VALUES('D034',NULL);
INSERT INTO SeasonLabel VALUES('D035',NULL);
INSERT INTO SeasonLabel VALUES('D036',NULL);
INSERT INTO SeasonLabel VALUES('D037',NULL);
INSERT INTO SeasonLabel VALUES('D038',NULL);
INSERT INTO SeasonLabel VALUES('D039',NULL);
INSERT INTO SeasonLabel VALUES('D040',NULL);
INSERT INTO SeasonLabel VALUES('D041',NULL);
INSERT INTO SeasonLabel VALUES('D042',NULL);
INSERT INTO SeasonLabel VALUES('D043',NULL);
INSERT INTO SeasonLabel VALUES('D044',NULL);
INSERT INTO SeasonLabel VALUES('D045',NULL);
INSERT INTO SeasonLabel VALUES('D046',NULL);
INSERT INTO SeasonLabel VALUES('D047',NULL);
INSERT INTO SeasonLabel VALUES('D048',NULL);
INSERT INTO SeasonLabel VALUES('D049',NULL);
INSERT INTO SeasonLabel VALUES('D050',NULL);
INSERT INTO SeasonLabel VALUES('D051',NULL);
INSERT INTO SeasonLabel VALUES('D052',NULL);
INSERT INTO SeasonLabel VALUES('D053',NULL);
INSERT INTO SeasonLabel VALUES('D054',NULL);
INSERT INTO SeasonLabel VALUES('D055',NULL);
INSERT INTO SeasonLabel VALUES('D056',NULL);
INSERT INTO SeasonLabel VALUES('D057',NULL);
INSERT INTO SeasonLabel VALUES('D058',NULL);
INSERT INTO SeasonLabel VALUES('D059',NULL);
INSERT INTO SeasonLabel VALUES('D060',NULL);
INSERT INTO SeasonLabel VALUES('D061',NULL);
INSERT INTO SeasonLabel VALUES('D062',NULL);
INSERT INTO SeasonLabel VALUES('D063',NULL);
INSERT INTO SeasonLabel VALUES('D064',NULL);
INSERT INTO SeasonLabel VALUES('D065',NULL);
INSERT INTO SeasonLabel VALUES('D066',NULL);
INSERT INTO SeasonLabel VALUES('D067',NULL);
INSERT INTO SeasonLabel VALUES('D068',NULL);
INSERT INTO SeasonLabel VALUES('D069',NULL);
INSERT INTO SeasonLabel VALUES('D070',NULL);
INSERT INTO SeasonLabel VALUES('D071',NULL);
INSERT INTO SeasonLabel VALUES('D072',NULL);
INSERT INTO SeasonLabel VALUES('D073',NULL);
INSERT INTO SeasonLabel VALUES('D074',NULL);
INSERT INTO SeasonLabel VALUES('D075',NULL);
INSERT INTO SeasonLabel VALUES('D076',NULL);
INSERT INTO SeasonLabel VALUES('D077',NULL);
INSERT INTO SeasonLabel VALUES('D078',NULL);
INSERT INTO SeasonLabel VALUES('D079',NULL);
INSERT INTO SeasonLabel VALUES('D080',NULL);
INSERT INTO SeasonLabel VALUES('D081',NULL);
INSERT INTO SeasonLabel VALUES('D082',NULL);
INSERT INTO SeasonLabel VALUES('D083',NULL);
INSERT INTO SeasonLabel VALUES('D084',NULL);
INSERT INTO SeasonLabel VALUES('D085',NULL);
INSERT INTO SeasonLabel VALUES('D086',NULL);
INSERT INTO SeasonLabel VALUES('D087',NULL);
INSERT INTO SeasonLabel VALUES('D088',NULL);
INSERT INTO SeasonLabel VALUES('D089',NULL);
INSERT INTO SeasonLabel VALUES('D090',NULL);
INSERT INTO SeasonLabel VALUES('D091',NULL);
INSERT INTO SeasonLabel VALUES('D092',NULL);
INSERT INTO SeasonLabel VALUES('D093',NULL);
INSERT INTO SeasonLabel VALUES('D094',NULL);
INSERT INTO SeasonLabel VALUES('D095',NULL);
INSERT INTO SeasonLabel VALUES('D096',NULL);
INSERT INTO SeasonLabel VALUES('D097',NULL);
INSERT INTO SeasonLabel VALUES('D098',NULL);
INSERT INTO SeasonLabel VALUES('D099',NULL);
INSERT INTO SeasonLabel VALUES('D100',NULL);
INSERT INTO SeasonLabel VALUES('D101',NULL);
INSERT INTO SeasonLabel VALUES('D102',NULL);
INSERT INTO SeasonLabel VALUES('D103',NULL);
INSERT INTO SeasonLabel VALUES('D104',NULL);
INSERT INTO SeasonLabel VALUES('D105',NULL);
INSERT INTO SeasonLabel VALUES('D106',NULL);
INSERT INTO SeasonLabel VALUES('D107',NULL);
INSERT INTO SeasonLabel VALUES('D108',NULL);
INSERT INTO SeasonLabel VALUES('D109',NULL);
INSERT INTO SeasonLabel VALUES('D110',NULL);
INSERT INTO SeasonLabel VALUES('D111',NULL);
INSERT INTO SeasonLabel VALUES('D112',NULL);
INSERT INTO SeasonLabel VALUES('D113',NULL);
INSERT INTO SeasonLabel VALUES('D114',NULL);
INSERT INTO SeasonLabel VALUES('D115',NULL);
INSERT INTO SeasonLabel VALUES('D116',NULL);
INSERT INTO SeasonLabel VALUES('D117',NULL);
INSERT INTO SeasonLabel VALUES('D118',NULL);
INSERT INTO SeasonLabel VALUES('D119',NULL);
INSERT INTO SeasonLabel VALUES('D120',NULL);
INSERT INTO SeasonLabel VALUES('D121',NULL);
INSERT INTO SeasonLabel VALUES('D122',NULL);
INSERT INTO SeasonLabel VALUES('D123',NULL);
INSERT INTO SeasonLabel VALUES('D124',NULL);
INSERT INTO SeasonLabel VALUES('D125',NULL);
INSERT INTO SeasonLabel VALUES('D126',NULL);
INSERT INTO SeasonLabel VALUES('D127',NULL);
INSERT INTO SeasonLabel VALUES('D128',NULL);
INSERT INTO SeasonLabel VALUES('D129',NULL);
INSERT INTO SeasonLabel VALUES('D130',NULL);
INSERT INTO SeasonLabel VALUES('D131',NULL);
INSERT INTO SeasonLabel VALUES('D132',NULL);
INSERT INTO SeasonLabel VALUES('D133',NULL);
INSERT INTO SeasonLabel VALUES('D134',NULL);
INSERT INTO SeasonLabel VALUES('D135',NULL);
INSERT INTO SeasonLabel VALUES('D136',NULL);
INSERT INTO SeasonLabel VALUES('D137',NULL);
INSERT INTO SeasonLabel VALUES('D138',NULL);
INSERT INTO SeasonLabel VALUES('D139',NULL);
INSERT INTO SeasonLabel VALUES('D140',NULL);
INSERT INTO SeasonLabel VALUES('D141',NULL);
INSERT INTO SeasonLabel VALUES('D142',NULL);
INSERT INTO SeasonLabel VALUES('D143',NULL);
INSERT INTO SeasonLabel VALUES('D144',NULL);
INSERT INTO SeasonLabel VALUES('D145',NULL);
INSERT INTO SeasonLabel VALUES('D146',NULL);
INSERT INTO SeasonLabel VALUES('D147',NULL);
INSERT INTO SeasonLabel VALUES('D148',NULL);
INSERT INTO SeasonLabel VALUES('D149',NULL);
INSERT INTO SeasonLabel VALUES('D150',NULL);
INSERT INTO SeasonLabel VALUES('D151',NULL);
INSERT INTO SeasonLabel VALUES('D152',NULL);
INSERT INTO SeasonLabel VALUES('D153',NULL);
INSERT INTO SeasonLabel VALUES('D154',NULL);
INSERT INTO SeasonLabel VALUES('D155',NULL);
INSERT INTO SeasonLabel VALUES('D156',NULL);
INSERT INTO SeasonLabel VALUES('D157',NULL);
INSERT INTO SeasonLabel VALUES('D158',NULL);
INSERT INTO SeasonLabel VALUES('D159',NULL);
INSERT INTO SeasonLabel VALUES('D160',NULL);
INSERT INTO SeasonLabel VALUES('D161',NULL);
INSERT INTO SeasonLabel VALUES('D162',NULL);
INSERT INTO SeasonLabel VALUES('D163',NULL);
INSERT INTO SeasonLabel VALUES('D164',NULL);
INSERT INTO SeasonLabel VALUES('D165',NULL);
INSERT INTO SeasonLabel VALUES('D166',NULL);
INSERT INTO SeasonLabel VALUES('D167',NULL);
INSERT INTO SeasonLabel VALUES('D168',NULL);
INSERT INTO SeasonLabel VALUES('D169',NULL);
INSERT INTO SeasonLabel VALUES('D170',NULL);
INSERT INTO SeasonLabel VALUES('D171',NULL);
INSERT INTO SeasonLabel VALUES('D172',NULL);
INSERT INTO SeasonLabel VALUES('D173',NULL);
INSERT INTO SeasonLabel VALUES('D174',NULL);
INSERT INTO SeasonLabel VALUES('D175',NULL);
INSERT INTO SeasonLabel VALUES('D176',NULL);
INSERT INTO SeasonLabel VALUES('D177',NULL);
INSERT INTO SeasonLabel VALUES('D178',NULL);
INSERT INTO SeasonLabel VALUES('D179',NULL);
INSERT INTO SeasonLabel VALUES('D180',NULL);
INSERT INTO SeasonLabel VALUES('D181',NULL);
INSERT INTO SeasonLabel VALUES('D182',NULL);
INSERT INTO SeasonLabel VALUES('D183',NULL);
INSERT INTO SeasonLabel VALUES('D184',NULL);
INSERT INTO SeasonLabel VALUES('D185',NULL);
INSERT INTO SeasonLabel VALUES('D186',NULL);
INSERT INTO SeasonLabel VALUES('D187',NULL);
INSERT INTO SeasonLabel VALUES('D188',NULL);
INSERT INTO SeasonLabel VALUES('D189',NULL);
INSERT INTO SeasonLabel VALUES('D190',NULL);
INSERT INTO SeasonLabel VALUES('D191',NULL);
INSERT INTO SeasonLabel VALUES('D192',NULL);
INSERT INTO SeasonLabel VALUES('D193',NULL);
INSERT INTO SeasonLabel VALUES('D194',NULL);
INSERT INTO SeasonLabel VALUES('D195',NULL);
INSERT INTO SeasonLabel VALUES('D196',NULL);
INSERT INTO SeasonLabel VALUES('D197',NULL);
INSERT INTO SeasonLabel VALUES('D198',NULL);
INSERT INTO SeasonLabel VALUES('D199',NULL);
INSERT INTO SeasonLabel VALUES('D200',NULL);
INSERT INTO SeasonLabel VALUES('D201',NULL);
INSERT INTO SeasonLabel VALUES('D202',NULL);
INSERT INTO SeasonLabel VALUES('D203',NULL);
INSERT INTO SeasonLabel VALUES('D204',NULL);
INSERT INTO SeasonLabel VALUES('D205',NULL);
INSERT INTO SeasonLabel VALUES('D206',NULL);
INSERT INTO SeasonLabel VALUES('D207',NULL);
INSERT INTO SeasonLabel VALUES('D208',NULL);
INSERT INTO SeasonLabel VALUES('D209',NULL);
INSERT INTO SeasonLabel VALUES('D210',NULL);
INSERT INTO SeasonLabel VALUES('D211',NULL);
INSERT INTO SeasonLabel VALUES('D212',NULL);
INSERT INTO SeasonLabel VALUES('D213',NULL);
INSERT INTO SeasonLabel VALUES('D214',NULL);
INSERT INTO SeasonLabel VALUES('D215',NULL);
INSERT INTO SeasonLabel VALUES('D216',NULL);
INSERT INTO SeasonLabel VALUES('D217',NULL);
INSERT INTO SeasonLabel VALUES('D218',NULL);
INSERT INTO SeasonLabel VALUES('D219',NULL);
INSERT INTO SeasonLabel VALUES('D220',NULL);
INSERT INTO SeasonLabel VALUES('D221',NULL);
INSERT INTO SeasonLabel VALUES('D222',NULL);
INSERT INTO SeasonLabel VALUES('D223',NULL);
INSERT INTO SeasonLabel VALUES('D224',NULL);
INSERT INTO SeasonLabel VALUES('D225',NULL);
INSERT INTO SeasonLabel VALUES('D226',NULL);
INSERT INTO SeasonLabel VALUES('D227',NULL);
INSERT INTO SeasonLabel VALUES('D228',NULL);
INSERT INTO SeasonLabel VALUES('D229',NULL);
INSERT INTO SeasonLabel VALUES('D230',NULL);
INSERT INTO SeasonLabel VALUES('D231',NULL);
INSERT INTO SeasonLabel VALUES('D232',NULL);
INSERT INTO SeasonLabel VALUES('D233',NULL);
INSERT INTO SeasonLabel VALUES('D234',NULL);
INSERT INTO SeasonLabel VALUES('D235',NULL);
INSERT INTO SeasonLabel VALUES('D236',NULL);
INSERT INTO SeasonLabel VALUES('D237',NULL);
INSERT INTO SeasonLabel VALUES('D238',NULL);
INSERT INTO SeasonLabel VALUES('D239',NULL);
INSERT INTO SeasonLabel VALUES('D240',NULL);
INSERT INTO SeasonLabel VALUES('D241',NULL);
INSERT INTO SeasonLabel VALUES('D242',NULL);
INSERT INTO SeasonLabel VALUES('D243',NULL);
INSERT INTO SeasonLabel VALUES('D244',NULL);
INSERT INTO SeasonLabel VALUES('D245',NULL);
INSERT INTO SeasonLabel VALUES('D246',NULL);
INSERT INTO SeasonLabel VALUES('D247',NULL);
INSERT INTO SeasonLabel VALUES('D248',NULL);
INSERT INTO SeasonLabel VALUES('D249',NULL);
INSERT INTO SeasonLabel VALUES('D250',NULL);
INSERT INTO SeasonLabel VALUES('D251',NULL);
INSERT INTO SeasonLabel VALUES('D252',NULL);
INSERT INTO SeasonLabel VALUES('D253',NULL);
INSERT INTO SeasonLabel VALUES('D254',NULL);
INSERT INTO SeasonLabel VALUES('D255',NULL);
INSERT INTO SeasonLabel VALUES('D256',NULL);
INSERT INTO SeasonLabel VALUES('D257',NULL);
INSERT INTO SeasonLabel VALUES('D258',NULL);
INSERT INTO SeasonLabel VALUES('D259',NULL);
INSERT INTO SeasonLabel VALUES('D260',NULL);
INSERT INTO SeasonLabel VALUES('D261',NULL);
INSERT INTO SeasonLabel VALUES('D262',NULL);
INSERT INTO SeasonLabel VALUES('D263',NULL);
INSERT INTO SeasonLabel VALUES('D264',NULL);
INSERT INTO SeasonLabel VALUES('D265',NULL);
INSERT INTO SeasonLabel VALUES('D266',NULL);
INSERT INTO SeasonLabel VALUES('D267',NULL);
INSERT INTO SeasonLabel VALUES('D268',NULL);
INSERT INTO SeasonLabel VALUES('D269',NULL);
INSERT INTO SeasonLabel VALUES('D270',NULL);
INSERT INTO SeasonLabel VALUES('D271',NULL);
INSERT INTO SeasonLabel VALUES('D272',NULL);
INSERT INTO SeasonLabel VALUES('D273',NULL);
INSERT INTO SeasonLabel VALUES('D274',NULL);
INSERT INTO SeasonLabel VALUES('D275',NULL);
INSERT INTO SeasonLabel VALUES('D276',NULL);
INSERT INTO SeasonLabel VALUES('D277',NULL);
INSERT INTO SeasonLabel VALUES('D278',NULL);
INSERT INTO SeasonLabel VALUES('D279',NULL);
INSERT INTO SeasonLabel VALUES('D280',NULL);
INSERT INTO SeasonLabel VALUES('D281',NULL);
INSERT INTO SeasonLabel VALUES('D282',NULL);
INSERT INTO SeasonLabel VALUES('D283',NULL);
INSERT INTO SeasonLabel VALUES('D284',NULL);
INSERT INTO SeasonLabel VALUES('D285',NULL);
INSERT INTO SeasonLabel VALUES('D286',NULL);
INSERT INTO SeasonLabel VALUES('D287',NULL);
INSERT INTO SeasonLabel VALUES('D288',NULL);
INSERT INTO SeasonLabel VALUES('D289',NULL);
INSERT INTO SeasonLabel VALUES('D290',NULL);
INSERT INTO SeasonLabel VALUES('D291',NULL);
INSERT INTO SeasonLabel VALUES('D292',NULL);
INSERT INTO SeasonLabel VALUES('D293',NULL);
INSERT INTO SeasonLabel VALUES('D294',NULL);
INSERT INTO SeasonLabel VALUES('D295',NULL);
INSERT INTO SeasonLabel VALUES('D296',NULL);
INSERT INTO SeasonLabel VALUES('D297',NULL);
INSERT INTO SeasonLabel VALUES('D298',NULL);
INSERT INTO SeasonLabel VALUES('D299',NULL);
INSERT INTO SeasonLabel VALUES('D300',NULL);
INSERT INTO SeasonLabel VALUES('D301',NULL);
INSERT INTO SeasonLabel VALUES('D302',NULL);
INSERT INTO SeasonLabel VALUES('D303',NULL);
INSERT INTO SeasonLabel VALUES('D304',NULL);
INSERT INTO SeasonLabel VALUES('D305',NULL);
INSERT INTO SeasonLabel VALUES('D306',NULL);
INSERT INTO SeasonLabel VALUES('D307',NULL);
INSERT INTO SeasonLabel VALUES('D308',NULL);
INSERT INTO SeasonLabel VALUES('D309',NULL);
INSERT INTO SeasonLabel VALUES('D310',NULL);
INSERT INTO SeasonLabel VALUES('D311',NULL);
INSERT INTO SeasonLabel VALUES('D312',NULL);
INSERT INTO SeasonLabel VALUES('D313',NULL);
INSERT INTO SeasonLabel VALUES('D314',NULL);
INSERT INTO SeasonLabel VALUES('D315',NULL);
INSERT INTO SeasonLabel VALUES('D316',NULL);
INSERT INTO SeasonLabel VALUES('D317',NULL);
INSERT INTO SeasonLabel VALUES('D318',NULL);
INSERT INTO SeasonLabel VALUES('D319',NULL);
INSERT INTO SeasonLabel VALUES('D320',NULL);
INSERT INTO SeasonLabel VALUES('D321',NULL);
INSERT INTO SeasonLabel VALUES('D322',NULL);
INSERT INTO SeasonLabel VALUES('D323',NULL);
INSERT INTO SeasonLabel VALUES('D324',NULL);
INSERT INTO SeasonLabel VALUES('D325',NULL);
INSERT INTO SeasonLabel VALUES('D326',NULL);
INSERT INTO SeasonLabel VALUES('D327',NULL);
INSERT INTO SeasonLabel VALUES('D328',NULL);
INSERT INTO SeasonLabel VALUES('D329',NULL);
INSERT INTO SeasonLabel VALUES('D330',NULL);
INSERT INTO SeasonLabel VALUES('D331',NULL);
INSERT INTO SeasonLabel VALUES('D332',NULL);
INSERT INTO SeasonLabel VALUES('D333',NULL);
INSERT INTO SeasonLabel VALUES('D334',NULL);
INSERT INTO SeasonLabel VALUES('D335',NULL);
INSERT INTO SeasonLabel VALUES('D336',NULL);
INSERT INTO SeasonLabel VALUES('D337',NULL);
INSERT INTO SeasonLabel VALUES('D338',NULL);
INSERT INTO SeasonLabel VALUES('D339',NULL);
INSERT INTO SeasonLabel VALUES('D340',NULL);
INSERT INTO SeasonLabel VALUES('D341',NULL);
INSERT INTO SeasonLabel VALUES('D342',NULL);
INSERT INTO SeasonLabel VALUES('D343',NULL);
INSERT INTO SeasonLabel VALUES('D344',NULL);
INSERT INTO SeasonLabel VALUES('D345',NULL);
INSERT INTO SeasonLabel VALUES('D346',NULL);
INSERT INTO SeasonLabel VALUES('D347',NULL);
INSERT INTO SeasonLabel VALUES('D348',NULL);
INSERT INTO SeasonLabel VALUES('D349',NULL);
INSERT INTO SeasonLabel VALUES('D350',NULL);
INSERT INTO SeasonLabel VALUES('D351',NULL);
INSERT INTO SeasonLabel VALUES('D352',NULL);
INSERT INTO SeasonLabel VALUES('D353',NULL);
INSERT INTO SeasonLabel VALUES('D354',NULL);
INSERT INTO SeasonLabel VALUES('D355',NULL);
INSERT INTO SeasonLabel VALUES('D356',NULL);
INSERT INTO SeasonLabel VALUES('D357',NULL);
INSERT INTO SeasonLabel VALUES('D358',NULL);
INSERT INTO SeasonLabel VALUES('D359',NULL);
INSERT INTO SeasonLabel VALUES('D360',NULL);
INSERT INTO SeasonLabel VALUES('D361',NULL);
INSERT INTO SeasonLabel VALUES('D362',NULL);
INSERT INTO SeasonLabel VALUES('D363',NULL);
INSERT INTO SeasonLabel VALUES('D364',NULL);
INSERT INTO SeasonLabel VALUES('D365',NULL);
CREATE TABLE IF NOT EXISTS TimeSeasonSequential
(
    period INTEGER
        REFERENCES TimePeriod (period),
    sequence INTEGER,
    seas_seq TEXT,
    season TEXT
        REFERENCES SeasonLabel (season),
    num_days REAL NOT NULL,
    notes TEXT,
    PRIMARY KEY (period, sequence, seas_seq, season),
    CHECK (num_days > 0)
);
CREATE TABLE IF NOT EXISTS TimePeriodType
(
    label       TEXT PRIMARY KEY,
    description TEXT
);
REPLACE INTO TimePeriodType
VALUES('e', 'existing vintages');
REPLACE INTO TimePeriodType
VALUES('f', 'future');
CREATE TABLE IF NOT EXISTS RPSRequirement
(
    region      TEXT    NOT NULL,
    period      INTEGER NOT NULL
        REFERENCES TimePeriod (period),
    tech_group  TEXT    NOT NULL,
    requirement REAL    NOT NULL,
    data_source TEXT,
    dq_cred INTEGER
        REFERENCES DataQualityCredibility (dq_cred),
    dq_geog INTEGER
        REFERENCES DataQualityGeography (dq_geog),
    dq_struc INTEGER
        REFERENCES DataQualityStructure (dq_struc),
    dq_tech INTEGER
        REFERENCES DataQualityTechnology (dq_tech),
    dq_time INTEGER
        REFERENCES DataQualityTime (dq_time),
    data_id TEXT
        REFERENCES DataSet (data_id),
    notes       TEXT,
    FOREIGN KEY (data_source) REFERENCES DataSourceLabel (source_id),
    FOREIGN KEY (region) REFERENCES Region (region),
    FOREIGN KEY (tech_group, data_id) REFERENCES TechGroup (group_name, data_id),
    PRIMARY KEY (region, data_id)
);
CREATE TABLE IF NOT EXISTS TechGroupMember
(
    group_name TEXT,
    tech       TEXT,
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    FOREIGN KEY (group_name, data_id) REFERENCES TechGroup (group_name, data_id),
    PRIMARY KEY (group_name, tech, data_id)
);
CREATE TABLE IF NOT EXISTS SeasonLabel
(
    tech TEXT
        PRIMARY KEY,
    notes  TEXT
);
CREATE TABLE IF NOT EXISTS TechnologyLabel
(
    tech TEXT
        PRIMARY KEY,
    notes  TEXT
);
CREATE TABLE IF NOT EXISTS Technology
(
    tech         TEXT    NOT NULL,
    flag         TEXT    NOT NULL,
    sector       TEXT
        REFERENCES SectorLabel (sector),
    category     TEXT,
    sub_category TEXT,
    unlim_cap    INTEGER NOT NULL DEFAULT 0,
    annual       INTEGER NOT NULL DEFAULT 0,
    reserve      INTEGER NOT NULL DEFAULT 0,
    curtail      INTEGER NOT NULL DEFAULT 0,
    retire       INTEGER NOT NULL DEFAULT 0,
    flex         INTEGER NOT NULL DEFAULT 0,
    exchange     INTEGER NOT NULL DEFAULT 0,
    seas_stor    INTEGER NOT NULL DEFAULT 0,
    description  TEXT,
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (flag) REFERENCES TechnologyType (label),
    FOREIGN KEY (tech) REFERENCES TechnologyLabel (tech),
    PRIMARY KEY (tech, data_id)
);
CREATE TABLE IF NOT EXISTS DataSourceLabel
(
    source_id TEXT
        PRIMARY KEY,
    notes  TEXT
);
CREATE TABLE IF NOT EXISTS DataSource
(
    source_id TEXT,
    source TEXT,
    notes TEXT,
    data_id TEXT
        REFERENCES DataSet (data_id),
    FOREIGN KEY (source_id) REFERENCES DataSourceLabel (source_id),
    PRIMARY KEY (source_id, data_id)
);
CREATE TABLE IF NOT EXISTS DataQualityCredibility
(
    dq_cred INTEGER PRIMARY KEY,
    description TEXT
);
REPLACE INTO DataQualityCredibility VALUES (1,'Excellent - A trustworthy source backed by strong analysis or direct measurements.');
REPLACE INTO DataQualityCredibility VALUES (2,'Good - Trustworthy source. Partly based on assumptions or imperfect analysis.');
REPLACE INTO DataQualityCredibility VALUES (3,'Acceptable - Acceptable source. May rely on many assumptions, shallow analysis, or rough measurement.');
REPLACE INTO DataQualityCredibility VALUES (4,'Lacking - Questionable or unverified source. Poorly measured or weak analysis.');
REPLACE INTO DataQualityCredibility VALUES (5,'Unacceptable - No or untrustworthy source. Unsupported assumption.');
CREATE TABLE IF NOT EXISTS DataQualityGeography
(
    dq_geog INTEGER PRIMARY KEY,
    description TEXT
);
REPLACE INTO DataQualityGeography VALUES (1,'Excellent - From this region and at the correct aggregation level or a directly-applicable generic value.');
REPLACE INTO DataQualityGeography VALUES (2,'Good - From an analogous region or the modelled region at incorrect aggregation level.');
REPLACE INTO DataQualityGeography VALUES (3,'Acceptable - From a relevant but non-analogous region or highly aggregated.');
REPLACE INTO DataQualityGeography VALUES (4,'Lacking - From a non-analogous region with limited relevance or a generic global value.');
REPLACE INTO DataQualityGeography VALUES (5,'Unacceptable - From a region that is highly dissimilar to the modelled region, or from an unknown region.');
CREATE TABLE IF NOT EXISTS DataQualityStructure
(
    dq_struc INTEGER PRIMARY KEY,
    description TEXT
);
REPLACE INTO DataQualityStructure VALUES (1,'Excellent - Excellent representation of the system, as good or better than other models.');
REPLACE INTO DataQualityStructure VALUES (2,'Good - Well modelled, in line with what others are doing.');
REPLACE INTO DataQualityStructure VALUES (3,'Acceptable - Room for improved representation but works for now.');
REPLACE INTO DataQualityStructure VALUES (4,'Lacking - Poorly represented, overly simplified.');
REPLACE INTO DataQualityStructure VALUES (5,'Unacceptable - Placeholder or dummy representation. Essentially not represented.');
CREATE TABLE IF NOT EXISTS DataQualityTechnology
(
    dq_tech INTEGER PRIMARY KEY,
    description TEXT
);
REPLACE INTO DataQualityTechnology VALUES (1,'Excellent - For the modelled technology as represented. Directly applicable.');
REPLACE INTO DataQualityTechnology VALUES (2,'Good - For the same general technology but not perfectly representative.');
REPLACE INTO DataQualityTechnology VALUES (3,'Acceptable - For an analogous technology. Possibly a subset or general class. Roughly applicable.');
REPLACE INTO DataQualityTechnology VALUES (4,'Lacking - Loosely representative. A niche subset or overbroad general class of the technology.');
REPLACE INTO DataQualityTechnology VALUES (5,'Unacceptable - For a dissimilar or unknown technology. Unknown or poor applicability.');
CREATE TABLE IF NOT EXISTS DataQualityTime
(
    dq_time INTEGER PRIMARY KEY,
    description TEXT
);
REPLACE INTO DataQualityTime VALUES (1,'Excellent - From or directly applicable to the modelled time.');
REPLACE INTO DataQualityTime VALUES (2,'Good - From a different but similar time or only slightly out of date. Still highly relevant.');
REPLACE INTO DataQualityTime VALUES (3,'Acceptable - From a somewhat similar time or several years out of date but still relevant.');
REPLACE INTO DataQualityTime VALUES (4,'Lacking - From a time with different conditions or significantly out of date. Questionable relevance.');
REPLACE INTO DataQualityTime VALUES (5,'Unacceptable - From an irrelevant time or badly out of date.');
CREATE TABLE IF NOT EXISTS DataSet
(
    data_id TEXT PRIMARY KEY,
    label TEXT,
    version TEXT,
    description TEXT,
    status TEXT,
    author TEXT,
    date TEXT,
    parent_id TEXT
        REFERENCES DataSet (data_id),
    changelog TEXT,
    notes TEXT
);

COMMIT;
PRAGMA FOREIGN_KEYS = 1;