-- Name: Nur Aisyah Bte Abdul Mutalib
-- Matric: U2110399H
-- Individual Assignment

USE sustainability2022;

-- 1) Table considered: <greenhouse_gas_inventory_data_data> What are the unique [categories]?

SELECT DISTINCT category
FROM greenhouse_gas_inventory_data_data;

-- 2) Tables considered: <greenhouse_gas_inventory_data_data> What is the sum of emission [value] in the [year] 2010 to 2014 for European Union?

SELECT SUM(`value`) AS 'Total Emissions in 2010 to 2014 for EU'
FROM greenhouse_gas_inventory_data_data
WHERE `year` BETWEEN 2010 AND 2014
AND country_or_area = "European Union";

-- 3) Table considered: <greenhouse_gas_inventory_data_data> What are the [year], [category], and [value] for Australia where emission [value] is greater than 530,000?

SELECT `year`, category, `value`
FROM greenhouse_gas_inventory_data_data
WHERE country_or_area = "Australia"
AND `value` > 530000
ORDER BY `year` DESC;

-- 4) Tables considered: <seaice> + <greenhouse_gas_inventory_data_data> For each year (2010 to 2014), display the average [extent] of sea ice, maximum [extent] of sea ice, minimum [extent] of sea ice, and the total amount of emission [value].

# The data type for the extent column is a string (VARCHAR). This affects the min() and max() functions and may possibly allow the min_extent values to be larger than max_values which is not logical. Therefore, there is a need to use the cast() function to convert the values from a string into a integer/ float.

SELECT g.`Year`, AVG(extent) AS avg_extent, MAX(CAST(extent AS FLOAT)) AS max_extent, MIN(CAST(extent AS FLOAT)) AS min_extent, g.total_emission
FROM (
	SELECT greenhouse_gas_inventory_data_data.`Year`, SUM(`value`) AS total_emission
    FROM greenhouse_gas_inventory_data_data
    WHERE `Year` BETWEEN 2010 AND 2014
    GROUP BY `Year`) AS g
LEFT JOIN seaice s
ON s.`Year` = g.`Year`
GROUP BY g.`year`
ORDER BY g.`year`;

-- 5) Tables considered: <seaice> + <globaltemperatures> For each year (2010 to 2014), display the average [extent] of sea ice, maximum [extent] of sea ice, minimum [extent] of sea ice, average [landaveragetemperature], minimum [landaveragetemperature], and maximum [landaveragetemperature].

SELECT s.`Year`, AVG(extent) AS avg_extent, MAX(CAST(extent AS FLOAT)) AS max_extent, MIN(CAST(extent AS FLOAT)) AS min_extent, AVG(t.LandAverageTemperature) AS avgLandTemperature, MIN(CAST(t.LandAverageTemperature AS FLOAT)) AS minLandTemperature, MAX(CAST(t.LandAverageTemperature AS FLOAT)) AS maxLandTemperature
FROM seaice s
INNER JOIN globaltemperatures t
ON s.`Year` = SUBSTRING(t.RecordedDate, 1, 4)
WHERE s.`Year`BETWEEN 2010 and 2014
GROUP BY s.`Year`;

-- 6) Tables considered: <greenhouse_gas_inventory_data_data> + <temperaturechangebycountry> For each year (2010 to 2014), display the sum of emission [value], average temperature change [temperaturechangebycountry.value], minimum temperature change, and maximum temperature change in Australia.

SELECT g.`year`, g.total_emission, AVG(tc.`value`) AS avgTemperatureChange, MIN(CAST(tc.`value`AS FLOAT)) AS minTemperatureChange, MAX(CAST(tc.`value` AS FLOAT)) AS maxTemperatureChange
FROM (
	SELECT greenhouse_gas_inventory_data_data.`Year`, SUM(`value`) AS total_emission
    FROM greenhouse_gas_inventory_data_data
    WHERE `Year` BETWEEN 2010 AND 2014
    GROUP BY `Year`) AS g
INNER JOIN temperaturechangebycountry tc
ON g.`Year` = tc.`Year`
AND tc.`Area` = "Australia"
GROUP BY g.`Year`;

-- 7) Table considered: <mass_balance_data> Display a list of glaciers [name], [investigator], and amount of surveyed on the glacier done by the investigator, when the investigator has conducted more than 11 surveys on the glacier. Sort the output in alphabetic order of [name].

SELECT `name`, investigator, COUNT(investigator) AS surveyedAmt
FROM mass_balance_data m
GROUP BY `name`, investigator
HAVING COUNT(investigator) > 11
ORDER BY `name`;

-- 8) Table considered: <temperaturechangebycountry> For each year (2010 to 2014), display a list of [area], [year], average [value] of temperature change of the ASEAN countries (see https://asean.org/about-asean/member-states/for the list of member states). Include the overall average of temperature change of all the ASEAN countries of each year.

# Singapore's values were found to be 0. This affects the avgValueChange as the avg() function does not ignore 0 values. Therefore, it is necessary to change Singapore's values to NULL instead so that it'll be excluded from the average.

UPDATE temperaturechangebycountry
SET `value` = NULL
WHERE `value` = "";

(SELECT `area`, `year`, AVG(`value`) AS avgValueChange
FROM temperaturechangebycountry
WHERE `area` IN ("Brunei Darussalam", "Cambodia", "Indonesia", "Lao People\'s Democratic Republic", "Malaysia", "Myanmar", "Philippines", "Singapore", "Thailand", "Vietnam")
AND year BETWEEN 2010 AND 2014
GROUP BY `area` , `year`
ORDER BY `area` , `year`)
UNION
(SELECT 'ASEAN' AS `area`, `year`, AVG(avgValueChange)
FROM
(SELECT `area`, `year`, AVG(`value`) AS avgValueChange
FROM temperaturechangebycountry
WHERE `area` IN ("Brunei Darussalam", "Cambodia", "Indonesia", "Lao People\'s Democratic Republic", "Malaysia", "Myanmar", "Philippines", "Singapore", "Thailand", "Vietnam")
AND `year` BETWEEN 2010 AND 2014
GROUP BY `area` , `year`
ORDER BY `area` , `year`) AS ASEAN_average
GROUP BY `year`)
ORDER BY `year` , `area`;

-- 9) Table considered: <greenhouse_gas_inventory_data_data> Display a list of [country_or_area], [category], and overall average emission [value] per category, when the country’s emission [value] for the category of the [year] is less than the country’s overall average emission [value] for the category.

CREATE VIEW g1
AS
SELECT country_or_area, category, AVG(`value`) AS cat_overallAvgValue
FROM greenhouse_gas_inventory_data_data
GROUP BY country_or_area, category;

CREATE VIEW g2
AS
SELECT country_or_area, category, `year`, AVG(`value`) AS cat_yearValue
FROM greenhouse_gas_inventory_data_data
GROUP BY country_or_area, category, `year`;

SELECT g1.country_or_area, g1.category, cat_overallAvgValue, `year`, cat_yearValue
FROM g1, g2
WHERE g1.category = g2.category
AND g1.country_or_area = g2.country_or_area
AND g2.cat_yearValue < g1.cat_overallAvgValue
ORDER BY g1.category, g1.country_or_area, `year` DESC;

-- 10) Tables considered: <temperaturechangebycountry> +<seaice> + <elevation_change_data> For each year (2008 to 2017), display the average [value] of temperature change in “United States of America”, the year’s average [extent] of [seaice.extent] sea ice, and the corresponding average [value] of [temperaturechangebycountry.elevation_change_unc] glacier elevation change surveyed by “Martina Barandun Robert McNabb” in the same year.

CREATE VIEW tcc
AS
SELECT `Year`, AVG(`Value`) AS avgValue
FROM temperaturechangebycountry
WHERE `Year` BETWEEN 2008 AND 2017
AND `Area` = "United States of America"
GROUP BY `Year`;

CREATE VIEW s
AS
SELECT `Year`, AVG(extent) AS avgExtent
FROM seaice
WHERE `Year` BETWEEN 2008 AND 2017
GROUP BY `Year`;

CREATE VIEW e
AS
SELECT SUBSTRING(Survey_Date, 1, 4) AS `Year`, AVG(elevation_change_unc) AS avgElevationChange
FROM elevation_change_data
WHERE SUBSTRING(Survey_Date, 1, 4) BETWEEN 2008 AND 2017
AND Investigator = "Martina Barandun Robert McNabb"
GROUP BY `Year`
ORDER BY `Year`;

SELECT tcc.`Year`, avgValue, avgExtent, avgElevationChange
FROM tcc, s, e
WHERE tcc.`year` = s.`year`
AND tcc.`year` = e.`year`;
