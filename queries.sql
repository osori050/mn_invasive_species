
--SQL Query x4 – 40 points

-- 1) A SQL query that involves only 1 table.
-- Find the number of terrestrial observations per county and sort them in descending order
SELECT county_name, count(county_name) AS number_of_observations, ST_Union(geom)
FROM terrestrial_invasive_species_observations
GROUP BY county_name
ORDER BY number_of_observations DESC


-- 2) A SQL query that involves 2 or more tables.
-- Find the number of all the invasive species observations per county and sort them in descending order
WITH invasive_species AS
(
SELECT county_name, geom FROM terrestrial_invasive_species_observations
UNION
SELECT county_name, geom FROM aquatic_invasive_species_observations
)
SELECT county_name, count(county_name) AS number_of_observations, ST_Union(geom)
FROM invasive_species
WHERE county_name IS NOT NULL  -- Important to remove the null data so that the query runs
GROUP BY county_name
ORDER BY number_of_observations DESC

-- 3) A SQL query using a subquery or a common table expression
-- Find the land cover classes affected by wildfires and sort them in descending order
WITH burnt AS
(
-- Intersect wildfires with land cover raster and obtain the pixel values
SELECT ST_Value(a.rast, b.geom) AS pixel_value
FROM mn_land_cover a, mn_wildfires b
WHERE ST_Intersects(a.rast, b.geom)
)
SELECT m.pixel_value, COUNT(m.pixel_value) AS number_of_fires, n.land_cover_class
FROM burnt m
-- Join the extracted pixel values to the land cover classes table
JOIN land_cover_classes n ON m.pixel_value = n.pixel_value
GROUP BY m.pixel_value, n.land_cover_class
ORDER BY number_of_fires DESC

-- 4) A spatial SQL query
-- Terrestrial invasive species that colonized after a wildfire. The datasets need to be transformed into a projected coordinate system.
WITH fires AS
(
	-- Find the observations within a 500-meter range from the wildfires
	SELECT fire_id, start_date, ST_Buffer(ST_Transform(geom, 26915), 500) AS buffer
	FROM mn_wildfires
	WHERE start_date IS NOT NULL
)
SELECT t.observation_id, t.observation_date, f.start_date AS fire_date, t.geom, ST_Intersects(ST_Transform(t.geom, 26915), f.buffer) AS in_range
FROM terrestrial_invasive_species_observations t, fires f
WHERE (t.observation_date BETWEEN f.start_date AND (f.start_date + INTERVAL '1 year')) -- Select only the observations that occurred within one year after the fire
	AND ST_Intersects(ST_Transform(t.geom, 26915), f.buffer) = true