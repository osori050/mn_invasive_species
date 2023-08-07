CREATE TABLE terrestrial_invasive_species_observations
(
    observation_id SERIAL PRIMARY KEY,
    scientific_name VARCHAR,
    category VARCHAR,
    county_name VARCHAR,
    habitat VARCHAR,
    observation_date DATE,
    geom GEOMETRY
);
COMMENT ON COLUMN terrestrial_invasive_species_observations.category IS 'Species grouping';

CREATE TABLE aquatic_invasive_species_observations
(
    observation_id SERIAL PRIMARY KEY,
    scientific_name VARCHAR,
    category VARCHAR,
    county_name VARCHAR,
    habitat VARCHAR,
    observation_date DATE,
    geom GEOMETRY
);
COMMENT ON COLUMN aquatic_invasive_species_observations.category IS 'Species grouping';

CREATE TABLE mn_wildfires
(
    fire_id SERIAL PRIMARY KEY,
    start_date DATE,
    county_name VARCHAR,
    cause VARCHAR,
    geom GEOMETRY
);

CREATE TABLE land_cover_classes
(
    class_id SERIAL PRIMARY KEY,
    pixel_value INTEGER,
    land_cover_class VARCHAR
);